#include <QDebug>
#include <QProcess>
#include <iostream>
#include <QDateTime>
#include <QTimer>
#include <shlwapi.h>
#include <windows.h>

//#include "pugixml.hpp"
//#include "pugixml.cpp"

#include "dispatching.h"
#include "myimageprovider.h"
#include "qffmpeg.h"
#include "rtspthread.h"
#include "comm.h"

#include "qcfg.h"

Dispatching::Dispatching(MyImageProvider * imgPro, QObject *parent)
    : QObject(parent)
    , imgProvider(imgPro)
    , ffmpeg(NULL)
    , comm(NULL)
    , m_first_refesh(true)
    , m_pClickTimer(NULL)
{
    //comm = new Comm();
    m_pClickTimer = new QTimer(this);
    connect(m_pClickTimer, SIGNAL(timeout()), this, SLOT(clickTimeout()));

    m_cfg = std::make_shared<QCfg>();

    // TODI: start SoftKeyboard
    QProcess *pprocess = new QProcess(this);
    pprocess->startDetached("osk.exe");
}

Dispatching::~Dispatching()
{
}

void Dispatching::cmpChMap(const std::map<std::string, unsigned int> &data)
{
    std::multimap<int, std::pair<std::string, unsigned int>> cmpResult;
    for (auto item = data.cbegin(); item != data.cend(); ++item) {
        auto old_item = m_old_chs.find(item->first);
        if (old_item == m_old_chs.end()) {
            cmpResult.insert(make_pair(1, *item));
        } else {
            if(item->second != old_item->second)
                cmpResult.insert(make_pair(0, *item));
            m_old_chs.erase(item->first);
        }
    }

    for (auto item = m_old_chs.cbegin(); item != m_old_chs.cend(); ++item) {
        cmpResult.insert(make_pair(-1, *item));
    }

    m_old_chs = data;

    if (cmpResult.size())
        refeshCh(cmpResult);
}

void Dispatching::refeshCh(const std::multimap<int, std::pair<std::string, unsigned int> > &refesh)
{
    if(m_first_refesh) {
        m_first_refesh = false;
        int count = refesh.size();
        int i = 0;
        std::cout << "Ergodic refesh multimap ...... " << refesh.size() << std::endl;
        for (auto item = refesh.cbegin(); item != refesh.cend(); ++item) {
            emit callQmlLoadupCh(item->second.first.c_str(), item->second.second, count, ++i);
        }
    } else {
        for (auto item = refesh.cbegin(); item != refesh.cend(); ++item) {
            emit callQmlRefeshCh(item->second.first.c_str(), item->second.second, item->first);
        }
    }
}

void Dispatching::stop()
{
    if (m_rtsp) {
        m_rtsp->stop();
        m_rtsp->quit();
        m_rtsp->wait();
        delete m_rtsp;
        m_rtsp = nullptr;
    }
}

void Dispatching::SetImage(const QImage &img)
{
    if (img.height() > 0) {
        //imgProvider->setImage(img);
        //imgProvider->setImage(img.scaled(1920, 1080));
        imgProvider->setPixmap(QPixmap::fromImage(img.scaled(1920, 1080)));
        emit callQmlRefeshImg();
    }
}

void Dispatching::convertData(QString data)
{
//    qDebug() << "Convert : " << QDateTime::currentDateTime().toString();
//    std::cout << data;

    pugi::xml_document doc;
    doc.load(data.toLatin1().data());
    pugi::xml_node root = doc.child("RMT");
    if (!root)
        return;

    std::map<std::string, unsigned int> ch_data = {};
    pugi::xml_node ch_node = root.child("CH");
    if (ch_node) {
        auto attr = ch_node.first_attribute();
        while (attr) {
            ch_data[attr.name()] = attr.as_uint();
            attr = attr.next_attribute();
        }
        cmpChMap(ch_data);
    }

    SockCHPack scp;
    SockStatePack ssp;
    pugi::xml_node cur_node = root.child("CUR");
    if (cur_node) {
        scp.pgm = cur_node.attribute("pgm").as_uint();
        scp.pvw = cur_node.attribute("pvw").as_uint();
        scp.pgm_ps = cur_node.attribute("pgm_ps").as_uint();
        scp.pvw_ps = cur_node.attribute("pvw_ps").as_uint();

        if (m_old_scp != scp) {
            QString pgmName = "CH" + QString::number(scp.pgm, 10);
            QString pvwName = "CH" + QString::number(scp.pvw, 10);

            if(scp.pgm_ps > 0 && ch_data[pgmName.toLatin1().data()])
                pgmName += "-" + QString::number(scp.pgm_ps, 10);
            if(scp.pvw_ps > 0 && ch_data[pvwName.toLatin1().data()])
                pvwName += "-" + QString::number(scp.pvw_ps, 10);

            emit callQmlChangeChActivity(pgmName, pvwName);
            m_old_scp = scp;
        }

        ssp.direct_mode = cur_node.attribute("dir_md").as_uint();
        ssp.recode_state = cur_node.attribute("rcd_st").as_uint();
        if (m_old_ssp != ssp) {
            emit callQmlCtrlState("DirectMode", ssp.direct_mode);
            emit callQmlCtrlState("RecodeState", ssp.recode_state);
            m_old_ssp = ssp;
        }
    }
}

void Dispatching::clickTimeout()
{
    m_pClickTimer->stop();
    if (comm)
        comm->SendData(m_pvw_name.toLatin1().data());
    //qDebug() << "Send PVW : " << m_pvw_name;
}

void Dispatching::onQmlStart(QString bkUrl, QString bkImg, bool isImg)
{
    if (!isImg) {
        stop();
        ffmpeg = new QFFmpeg(this);
        connect(ffmpeg, SIGNAL(GetImage(QImage)), this, SLOT(SetImage(QImage)));

        if (ffmpeg->OpenURL(bkUrl.toLatin1().data())) {
            m_rtsp = new RtspThread(this);
            m_rtsp->setFFmpeg(ffmpeg);
            m_rtsp->start();
        }
    }
    m_cfg->saveBkURL(bkUrl, bkImg, isImg);
}

void Dispatching::onQmlStartKepplive(QString ip, QString port)
{
    qDebug() << ip << " : " << port;

    Comm * old_comm = comm;
    comm = new Comm();
    if (comm->ConnectServer(ip.toLatin1().data(), port.toInt()) && comm->RunClient()){
        connect(comm, SIGNAL(recvPack(QString)), this, SLOT(convertData(QString)));
        m_cfg->saveServerInfo(ip, port);
        m_cfg->setCurrentIpPlan(ip);
        qDebug() << "Sock Client Start OK !!";
    } else {
        qDebug() << "Sock Client Start ERROR !!";
    }
    if (old_comm) {
        old_comm->Stop();
    }
}

void Dispatching::onQmlChSwitch(QString name, bool single)
{
    if (!comm)
        return;
    if(single){
        name.replace(0, 2, "PVW");
        m_pvw_name = name;
        m_pClickTimer->start(200);
    } else {
        m_pClickTimer->stop();
        name.replace(0, 2, "PGM");
        comm->SendData(name.toLatin1().data());
        //qDebug() << "Send PGM : " << name;
    }
}

void Dispatching::onQmlSendAction(QString action)
{
    if (!comm)
        return;
    comm->SendData(action.toLatin1().data());
}

void Dispatching::onQmlSaveCHPoint(QString name, int x, int y)
{
    m_cfg->saveCHPoint(name, x, y);
    qDebug() << name << " POINT IS : " << x << " - - - " << y;
}

void Dispatching::onQmlVK()
{
    auto _Is64BitsOS = []() -> bool {
            QString mod = "kernel32";
            QString addr = "GetNativeSystemInfo";
            typedef VOID(WINAPI *LPFN_GetNativeSystemInfo)(LPSYSTEM_INFO lpSystemInfo);
            LPFN_GetNativeSystemInfo fnGetNativeSystemInfo = (LPFN_GetNativeSystemInfo)GetProcAddress(GetModuleHandle(mod.toStdWString().c_str()), addr.toLatin1().data());

            SYSTEM_INFO si = { 0 };
            if (NULL != fnGetNativeSystemInfo) {
                fnGetNativeSystemInfo(&si);
            }
            else {
                GetSystemInfo(&si);
            }

            return (si.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64
                    || si.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_IA64);
    };

    if (_Is64BitsOS()) {
        QString appPath = "Process32to64Host.exe";
        QString operation = "open";
        QString exePath = "C:\\Windows\\System32\\osk.exe";

        TCHAR path[MAX_PATH] = { 0 };
        ::GetModuleFileName(nullptr, path, MAX_PATH);
        ::PathRemoveFileSpec(path);
        ::PathAppend(path, appPath.toStdWString().c_str());
        ::ShellExecute(0, operation.toStdWString().c_str(), path, exePath.toStdWString().c_str(), nullptr, SW_SHOWNORMAL);
    }
    else {
        QString operation = "open";
        QString exePath = "osk.exe";
        ::ShellExecute(0, operation.toStdWString().c_str(), exePath.toStdWString().c_str(), nullptr, nullptr, SW_SHOWNORMAL);
    }
}

void Dispatching::onQmlGetInitData()
{
    QString ip, port;
    QString bkUrl, bkImg;
    bool isImg;
    m_cfg->getServerInfo(ip, port);
    m_cfg->getBkURL(bkUrl, bkImg, isImg);

    emit callQmlSendInitData(ip, port, bkUrl, bkImg, isImg);
}
