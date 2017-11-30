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
    int pgm_ps;
    int pvw_ps;
    std::map<std::string, bool> ch;

public:
    void clear() {
        pgm = pvw = 0;
        pgm_ps = pvw_ps = 0;
        ch.clear();
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

signals:
    void callQmlRefeshImg();

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
    SockPack m_pack;

    std::map<std::string, bool> m_old_chs;
};

#endif // DISPATCHING_H
