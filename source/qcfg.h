#ifndef QCFG_H
#define QCFG_H

#include <QString>

#include "pugixml.hpp"

class QCfg
{
public:
    QCfg();
    ~QCfg();

    bool setCurrentIpPlan(const QString &ip_play);
    bool saveCHPoint(const QString &name, int x, int y);
    bool saveBkURL(const QString &bkUrl, const QString &bkImg, bool isImg);
    bool getBkURL(QString &bkUrl, QString &bkImg, bool &isImg);
    bool saveServerInfo(const QString &ip, const QString &port);
    bool getServerInfo(QString &ip, QString &port);

private:
    bool loadCfg();
    bool saveCfg();
    pugi::xml_node getRoot();
    pugi::xml_node getCurretIpPlanNode();
    pugi::xml_node getNode(const QString &name);

private:
    pugi::xml_document m_doc;
    QString m_path;
    QString m_ip_plan;
};

#endif // QCFG_H
