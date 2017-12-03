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

void Dispatching::cmpChMap(const std::map<std::string, bool> &data)
{
    std::multimap<int, std::pair<std::string, bool>> cmpResult;
//    std::cout << "Ergodic data map ...... " << data.size() << std::endl;
    for (auto item = data.cbegin(); item != data.cend(); ++item) {
//        std::cout << item->first << " : " << item->second;
        if (m_old_chs.find(item->first) == m_old_chs.end()) {
//            std::cout << " no find!" << std::endl;
            cmpResult.insert(make_pair(1, *item));
        } else {
            m_old_chs.erase(item->first);
//            std::cout << " is find! OK!" << std::endl;
        }
    }

//    std::cout << "Ergodic surplus m_old_chs map ...... " << m_old_chs.size() << std::endl;
    for (auto item = m_old_chs.cbegin(); item != m_old_chs.cend(); ++item) {
        cmpResult.insert(make_pair(-1, *item));
//        std::cout << item->first << " : " << item->second << " is surplus!" << std::endl;
    }

//    std::cout << "Ergodic cmpResult multimap ...... " << cmpResult.size() << std::endl;
//    for (auto item = cmpResult.cbegin(); item != cmpResult.cend(); ++item) {
//        std::cout << item->first << " : " << item->second.first << " - " << item->second.second << std::endl;
//    }

//    std::cout << std::endl;
    m_old_chs = data;

    if (cmpResult.size())
        refeshCh(cmpResult);
}

void Dispatching::refeshCh(const std::multimap<int, std::pair<std::string, bool> > &refesh)
{
    if(m_first_refesh) {
        m_first_refesh = false;
        int count = refesh.size();
        int i = 0;
        std::cout << "Ergodic refesh multimap ...... " << refesh.size() << std::endl;
        for (auto item = refesh.cbegin(); item != refesh.cend(); ++item) {
            if(item->second.second)
                emit callQmlLoadupCh(item->second.first.c_str(), "CH-", count, ++i);
            else
                emit callQmlLoadupCh(item->second.first.c_str(), "CH", count, ++i);
        }
    } else {
        for (auto item = refesh.cbegin(); item != refesh.cend(); ++item) {
            if (item->second.second)
                emit callQmlRefeshCh(item->second.first.c_str(), "CH-", item->first);
            else
                emit callQmlRefeshCh(item->second.first.c_str(), "CH", item->first);
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

    std::map<std::string, bool> ch_data = {};
    pugi::xml_node ch_node = root.child("CH");
    if (ch_node) {
        auto attr = ch_node.first_attribute();
        while (attr) {
            ch_data[attr.name()] = attr.as_bool();
            attr = attr.next_attribute();
        }
        cmpChMap(ch_data);
    }

    SockPack sp;
    pugi::xml_node cur_node = root.child("CUR");
    if (cur_node) {
        sp.pgm = cur_node.attribute("pgm").as_uint();
        sp.pvw = cur_node.attribute("pvw").as_uint();
        sp.pgm_ps = cur_node.attribute("pgm_ps").as_uint();
        sp.pvw_ps = cur_node.attribute("pvw_ps").as_uint();

        //qDebug() << "SockInfo: " << sp.pgm << " - " << sp.pvw << " - " << sp.pgm_ps << " - " << sp.pvw_ps;

        if (m_old_pack != sp) {
            QString pgmName = "CH" + QString::number(sp.pgm, 10);
            QString pvwName = "CH" + QString::number(sp.pvw, 10);

            if(sp.pgm_ps > 0 && ch_data[pgmName.toLatin1().data()])
                pgmName += "-" + QString::number(sp.pgm_ps, 10);
            if(sp.pvw_ps > 0 && ch_data[pvwName.toLatin1().data()])
                pvwName += "-" + QString::number(sp.pvw_ps, 10);

            emit callQmlChangeChActivity(pgmName, pvwName);
            m_old_pack = sp;
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
