#ifndef DISPATCHING_H
#define DISPATCHING_H

#include <QObject>
#include <string>
#include <memory>

class MyImageProvider;
class QFFmpeg;
class Comm;

struct SockPack
{
public:
    unsigned int pgm;
    unsigned int pvw;
    unsigned int pgm_ps;
    unsigned int pvw_ps;

public:
    inline bool operator !=(const SockPack &sp) {
        if (this->pgm != sp.pgm || this->pgm_ps != sp.pgm_ps
                || this->pvw != sp.pvw || this->pvw_ps != sp.pvw_ps)
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
    void cmpChMap(const std::map<std::string, bool> &data);        // Compare Channel map change
    void refeshCh(const std::multimap<int, std::pair<std::string, bool>> & refesh);

signals:
    void callQmlRefeshImg();
    void callQmlLoadupCh(QString name, QString ch_type, int count, int index);
    void callQmlRefeshCh(QString name, QString ch_type, int ref_type);
    void callQmlChangeChActivity(QString pgmName, QString pvwName);

public slots:
    void start(QString url);
    void stop();
    void SetImage(const QImage & img);
    void startKepplive(QString ip, QString port);
    void sendAction(QString act);
    void convertData(std::string data);

private:
    MyImageProvider * imgProvider;
    QFFmpeg * ffmpeg;
    Comm * comm;
    QString m_data;

    std::map<std::string, bool> m_old_chs;
    SockPack m_old_pack;
    bool m_first_refesh;
};

#endif // DISPATCHING_H
