#ifndef DISPATCHING_H
#define DISPATCHING_H

#include <QObject>
#include "myimageprovider.h"
#include "qffmpeg.h"

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

private:
    MyImageProvider * imgProvider;
    QFFmpeg * ffmpeg;
};

#endif // DISPATCHING_H
