#include <QDebug>
#include <iostream>
#include <QDateTime>

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
{
}

Dispatching::~Dispatching()
{
}

void Dispatching::cmpChMap(const std::map<std::string, bool> &data)
{
    std::multimap<int, std::pair<std::string, bool>> cmpResult;
    std::cout << "Ergodic data map ...... " << data.size() << std::endl;
    for (auto item = data.cbegin(); item != data.cend(); ++item) {
        std::cout << item->first << " : " << item->second;
        if (m_old_chs.find(item->first) == m_old_chs.end()) {
            std::cout << " no find!" << std::endl;
            cmpResult.insert(make_pair(1, *item));
        } else {
            m_old_chs.erase(item->first);
            std::cout << " is find! OK!" << std::endl;
        }
    }

    std::cout << "Ergodic surplus m_old_chs map ...... " << m_old_chs.size() << std::endl;
    for (auto item = m_old_chs.cbegin(); item != m_old_chs.cend(); ++item) {
        cmpResult.insert(make_pair(-1, *item));
        std::cout << item->first << " : " << item->second << " is surplus!" << std::endl;
    }

//    std::cout << "Ergodic cmpResult multimap ...... " << cmpResult.size() << std::endl;
//    for (auto item = cmpResult.cbegin(); item != cmpResult.cend(); ++item) {
//        std::cout << item->first << " : " << item->second.first << " - " << item->second.second << std::endl;
//    }

    std::cout << std::endl;
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

void Dispatching::sendAction(QString act)
{
    if (!comm)
        return;
    comm->sendData("act.toLatin1().data()");
    qDebug() << "send action";
}

void Dispatching::convertData(std::string data)
{
    qDebug() << "Convert : " << QDateTime::currentDateTime().toString();
    std::cout << data;

    pugi::xml_document doc;
    doc.load(data.c_str());
    pugi::xml_node root = doc.child("RMT");
    if (!root)
        return;

    m_pack.clear();
    pugi::xml_node ch_node = root.child("CH");
    if (ch_node) {
        auto attr = ch_node.first_attribute();
        while (attr) {
            m_pack.ch[attr.name()] = attr.as_bool();
            attr = attr.next_attribute();
        }
        cmpChMap(m_pack.ch);
    }

    pugi::xml_node cur_node = root.child("CUR");
    if (cur_node) {
        m_pack.pgm = cur_node.attribute("pgm").as_uint();
        m_pack.pvw = cur_node.attribute("pvw").as_uint();
        m_pack.pgm_ps = cur_node.attribute("pgm_ps").as_uint();
        m_pack.pvw_ps = cur_node.attribute("pvw_ps").as_uint();
    }
}
