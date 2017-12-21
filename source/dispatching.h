#ifndef DISPATCHING_H
#define DISPATCHING_H

#include <QObject>
#include <string>
#include <memory>
//#include <share.h>

class MyImageProvider;
class QFFmpeg;
class Comm;
class QTimer;
class QCfg;

struct SockCHPack
{
public:
    unsigned int pgm;
    unsigned int pvw;
    unsigned int pgm_ps;
    unsigned int pvw_ps;

public:
    inline bool operator !=(const SockCHPack &scp) {
        if (this->pgm != scp.pgm
                || this->pgm_ps != scp.pgm_ps
                || this->pvw != scp.pvw
                || this->pvw_ps != scp.pvw_ps)
            return true;
        return false;
    }
};

struct SockStatePack
{
    unsigned int direct_mode;
    unsigned int recode_state;

    inline bool operator !=(const SockStatePack ssp) {
        if (this->direct_mode != ssp.direct_mode
                || this->recode_state != ssp.recode_state)
            return true;
        return false;
    }
};

class Dispatching : public QObject
{
    Q_OBJECT
public:
    explicit Dispatching(MyImageProvider * imgPro, QObject *parent = nullptr);
    ~Dispatching();

private:
    void cmpChMap(const std::map<std::string, unsigned int> &data);        // Compare Channel map change
    void refeshCh(const std::multimap<int, std::pair<std::string, unsigned int>> & refesh);

signals:
    // * C++ Call Qml *********************************************************
    void callQmlRefeshImg();
    void callQmlLoadupCh(QString name, int chType, int count, int index);
    void callQmlRefeshCh(QString name, int chType, int refType);
    void callQmlChangeChActivity(QString pgmName, QString pvwName);
    void callQmlCtrlState(QString obj, int val);

public slots:
    void stop();
    void SetImage(const QImage & img);
    void convertData(QString data);
    void clickTimeout();

    // * Qml Call C++ *********************************************************
    void onQmlStart(QString url);
    void onQmlStartKepplive(QString ip, QString port);
    void onQmlChSwitch(QString name, bool single);
    void onQmlSendAction(QString action);
    void onQmlSaveCHPoint(QString name, int x, int y);
    void onQmlVK();

private:
    MyImageProvider * imgProvider;
    QFFmpeg * ffmpeg;
    Comm * comm;
    QString m_data;

    std::map<std::string, unsigned int> m_old_chs;
    SockCHPack m_old_scp;
    SockStatePack m_old_ssp;
    bool m_first_refesh;
    QTimer * m_pClickTimer;
    QString m_pvw_name;

    std::shared_ptr<QCfg> m_cfg;
};

#endif // DISPATCHING_H
