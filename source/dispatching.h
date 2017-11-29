#ifndef DISPATCHING_H
#define DISPATCHING_H

#include <QObject>

class MyImageProvider;
class QFFmpeg;
class Comm;

class Dispatching : public QObject
{
    Q_OBJECT
public:
    explicit Dispatching(MyImageProvider * imgPro, QObject *parent = nullptr);
    ~Dispatching();

signals:
    void callQmlRefeshImg();

public slots:
    void start(QString url);
    void stop();
    void SetImage(const QImage & img);
    void startKepplive(QString ip, QString port);
    void sendAction(QString act);

private:
    MyImageProvider * imgProvider;
    QFFmpeg * ffmpeg;
    Comm * comm;
    QString m_data;
};

#endif // DISPATCHING_H
