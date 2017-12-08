#include "qcfg.h"
#include "pugixml.cpp"

QCfg::QCfg()
{
    m_path = "qcfg.xml";
    loadCfg();
}

QCfg::~QCfg()
{
    saveCfg();
}

bool QCfg::setCurrentIpPlan(const QString &ip_play)
{
    m_ip_plan = ip_play;
}

bool QCfg::saveCHPoint(const QString &name, int x, int y)
{
    pugi::xml_node plan_node = getCurretIpPlanNode();
    pugi::xml_node ch_node = plan_node.child(name.toStdString().c_str());
    if (!ch_node)
        ch_node = plan_node.append_child(name.toStdString().c_str());

    pugi::xml_attribute attr = ch_node.attribute("x");
    if (!attr)
        attr = ch_node.append_attribute("x");
    attr = x;

    attr = ch_node.attribute("y");
    if (!attr)
        attr = ch_node.append_attribute("y");
    attr = y;

    saveCfg();
}

bool QCfg::loadCfg()
{
    if (m_doc.load_file(m_path.toStdWString().c_str()))
        return true;
    return false;
}

bool QCfg::saveCfg()
{
    return m_doc.save_file(m_path.toStdWString().c_str(), " ", pugi::format_indent | pugi::format_write_bom, pugi::encoding_utf8);
}

pugi::xml_node QCfg::getRoot()
{
    pugi::xml_node root = m_doc.child("Cfg");
    if (!root)
        root = m_doc.append_child("Cfg");
    return root;
}

pugi::xml_node QCfg::getIpPlanNode(const QString &ip)
{
    pugi::xml_node root = getRoot();
    pugi::xml_node node = root.child(ip.toStdString().c_str());
    if (!node)
        node = root.append_child(ip.toStdString().c_str());
    return node;
}

pugi::xml_node QCfg::getCurretIpPlanNode()
{
    return getIpPlanNode(m_ip_plan);
}
