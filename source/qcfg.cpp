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

bool QCfg::saveBkURL(const QString &bkUrl, const QString &bkImg, bool isImg)
{
    pugi::xml_node node = getNode("BkUrl");

    auto attr = node.attribute("bkUrl");
    if (!attr)
        attr = node.append_attribute("bkUrl");
    attr = bkUrl.toStdString().c_str();

    attr = node.attribute("bkImg");
    if (!attr)
        attr = node.append_attribute("bkImg");
    attr = bkImg.toStdString().c_str();

    attr = node.attribute("isImg");
    if (!attr)
        attr = node.append_attribute("isImg");
    attr = isImg;

    saveCfg();
}

bool QCfg::getBkURL(QString &bkUrl, QString &bkImg, bool &isImg)
{
    bool isUpdata = false;
    pugi::xml_node node = getNode("BkUrl");

    auto attr = node.attribute("bkUrl");
    if (!attr) {
        attr = node.append_attribute("bkUrl");
        attr = "";
        isUpdata = true;
    }
    bkUrl = attr.as_string();

    attr = node.attribute("bkImg");
    if (!attr) {
        attr = node.append_attribute("bkImg");
        attr = "";
        isUpdata = true;
    }
    bkImg = attr.as_string();

    attr = node.attribute("isImg");
    if (!attr) {
        attr = node.append_attribute("isImg");
        attr = "";
        isUpdata = true;
    }
    isImg = attr.as_bool();

    if(isUpdata)
        saveCfg();

    return true;
}

bool QCfg::saveServerInfo(const QString &ip, const QString &port)
{
    auto node = getNode("SvIp");
    auto attr = node.attribute("ip");
    if (!attr)
        attr = node.append_attribute("ip");
    attr = ip.toStdString().c_str();

    attr = node.attribute("port");
    if (!attr)
        attr = node.append_attribute("port");
    attr = port.toStdString().c_str();

    saveCfg();
}

bool QCfg::getServerInfo(QString &ip, QString &port)
{
    bool isUpdata = false;
    auto node = getNode("SvIp");
    auto attr = node.attribute("ip");
    if (!attr) {
        attr = node.append_attribute("ip");
        attr = "";
        isUpdata = true;
    }
    ip = attr.as_string();

    attr = node.attribute("port");
    if (!attr) {
        attr = node.append_attribute("port");
        attr = "";
        isUpdata = true;
    }
    port = attr.as_string();

    if (isUpdata)
        saveCfg();

    return true;
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

pugi::xml_node QCfg::getCurretIpPlanNode()
{
    return getNode(m_ip_plan);
}

pugi::xml_node QCfg::getNode(const QString &name)
{
    auto root = getRoot();
    auto node = root.child(name.toStdString().c_str());
    if (!node)
        node = root.append_child(name.toStdString().c_str());
    return node;
}
