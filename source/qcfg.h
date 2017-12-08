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

private:
    bool loadCfg();
    bool saveCfg();
    pugi::xml_node getRoot();
    pugi::xml_node getIpPlanNode(const QString &ip);
    pugi::xml_node getCurretIpPlanNode();

private:
    pugi::xml_document m_doc;
    QString m_path;
    QString m_ip_plan;
};

#endif // QCFG_H
