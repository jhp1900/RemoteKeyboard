#include <QDebug>
#include <iostream>
#include <QDateTime>
#include <QTimer>

#include "pugixml.hpp"
#include "pugixml.cpp"

#include "dispatching.h"
#include "myimageprovider.h"
#include "qffmpeg.h"
#include "rtspthread.h"
#include "comm.h"

Dispatching::Dispatching(MyImageProvider * imgPro, QObject *parent)
    : QObject(parent)
    , imgProvider(imgPro)
    , ffmpeg(NULL)
    , comm(NULL)
    , m_first_refesh(true)
    , m_pTimer(NULL)
{
    m_pTimer = new QTimer(this);
    connect(m_pTimer, SIGNAL(timeout()), this, SLOT(handleTimeout()));
}

Dispatching::~Dispatching()
{
}

void Dispatching::cmpChMap(const std::map<std::string, unsigned int> &data)
{
    std::multimap<int, std::pair<std::string, unsigned int>> cmpResult;
    for (auto item = data.cbegin(); item != data.cend(); ++item) {
        if (m_old_chs.find(item->first) == m_old_chs.end()) {
            cmpResult.insert(make_pair(1, *item));
        } else {
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
        //imgProvider->setImage(img);
        imgProvider->setPixmap(QPixmap::fromImage(img.scaled(1920, 1080)));
        emit callQmlRefeshImg();
    }
}

void Dispatching::startKepplive(QString ip, QString port)
{
    //m_data = "456123789";
    qDebug() << ip << " : " << port;
    comm = new Comm(this);
    comm->linkInfo(ip, port);
    connect(comm, SIGNAL(recvPack(std::string)), this, SLOT(convertData(std::string)));
    comm->start();
}

void Dispatching::convertData(std::string data)
{
//    qDebug() << "Convert : " << QDateTime::currentDateTime().toString();
//    std::cout << data;

    pugi::xml_document doc;
    doc.load(data.c_str());
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

void Dispatching::handleTimeout()
{
    m_pTimer->stop();
    comm->sendData(m_pvw_name);
    qDebug() << "Send PVW : " << m_pvw_name;
}

void Dispatching::onQmlChSwitch(QString name, bool single)
{
    if (!comm)
        return;
    if(single){
        name.replace(0, 2, "PVW");
        m_pvw_name = name;
        m_pTimer->start(200);
    } else {
        m_pTimer->stop();
        name.replace(0, 2, "PGM");
        comm->sendData(name);
        qDebug() << "Send PGM : " << name;
    }
}

void Dispatching::onQmlSendAction(QString action)
{
    if (!comm)
        return;
    comm->sendData(action);
}
