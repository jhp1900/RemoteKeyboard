#include <QDebug>
#include <iostream>
#include <QDateTime>
#include <QTimer>

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
    comm = new Comm();
    m_pClickTimer = new QTimer(this);
    connect(m_pClickTimer, SIGNAL(timeout()), this, SLOT(clickTimeout()));

    m_cfg = std::make_shared<QCfg>();
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

void Dispatching::start(QString url)
{
    qDebug() << "Dispatching Start!! - " << url;
    ffmpeg = new QFFmpeg(this);
    connect(ffmpeg, SIGNAL(GetImage(QImage)), this, SLOT(SetImage(QImage)));

    if (ffmpeg->OpenURL(url.toLatin1().data())) {
       RtspThread * rtsp = new RtspThread(this);
       rtsp->setFFmpeg(ffmpeg);
       rtsp->start();
    }
}

void Dispatching::stop()
{
    qDebug() << "Dispatching Stop!!";
}

void Dispatching::SetImage(const QImage &img)
{
    if (img.height() > 0) {
        imgProvider->setImage(img);
        //imgProvider->setImage(img.scaled(1920, 1080));
        //imgProvider->setPixmap(QPixmap::fromImage(img.scaled(1920, 1080)));
        emit callQmlRefeshImg();
    }
}

void Dispatching::startKepplive(QString ip, QString port)
{
    qDebug() << ip << " : " << port;

    if (comm->ConnectServer(ip.toLatin1().data(), port.toInt()) && comm->RunClient()){
        connect(comm, SIGNAL(recvPack(QString)), this, SLOT(convertData(QString)));
        m_cfg->setCurrentIpPlan(ip);
        qDebug() << "Sock Client Start OK !!";
    } else {
        qDebug() << "Sock Client Start ERROR !!";
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
    comm->SendData(m_pvw_name.toLatin1().data());
    //qDebug() << "Send PVW : " << m_pvw_name;
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
