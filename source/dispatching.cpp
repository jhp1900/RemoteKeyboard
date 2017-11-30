#include <QDebug>
#include <iostream>

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
{
}

Dispatching::~Dispatching()
{
}

void Dispatching::cmpChMap()
{
   std::multimap<int, std::pair<std::string, bool>> cmpResult;

   for (auto item = m_pack.ch.cbegin(); item != m_pack.ch.cend(); ++item) {
       if (m_old_chs.find(item->first) == m_old_chs.end()) {
           std::pair<std::string, bool> temp = make_pair(item->first, item->second);
           cmpResult.insert(make_pair(1, temp));
       } else {
           m_old_chs.erase(item);
       }
   }

   for (auto item = m_old_chs.cbegin(); item != m_old_chs.cend(); ++item) {
       std::pair<std::string, bool> temp = { item->first, item->second };
       cmpResult.insert(make_pair(-1, temp));
   }
   m_old_chs = m_pack.ch;
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
    //std::cout << "Convert : " << data << std::endl;

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
        cmpChMap();
    }

    pugi::xml_node cur_node = root.child("CUR");
    if (cur_node) {
        m_pack.pgm = cur_node.attribute("pgm").as_uint();
        m_pack.pvw = cur_node.attribute("pvw").as_uint();
        m_pack.pgm_ps = cur_node.attribute("pgm_ps").as_uint();
        m_pack.pvw_ps = cur_node.attribute("pvw_ps").as_uint();
    }
}
