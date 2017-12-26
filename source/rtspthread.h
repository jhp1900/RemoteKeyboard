#ifndef RTSPTHREAD_H
#define RTSPTHREAD_H

#include <QThread>
#include "qffmpeg.h"

class RtspThread : public QThread
{
    Q_OBJECT
public:
    explicit RtspThread(QObject * parent = 0) : QThread(parent) {}

    void run() { ffmpeg->Play(); }
    void stop() { ffmpeg->Stop(); }
    void setFFmpeg(QFFmpeg *f) { ffmpeg = f; }

private:
    QFFmpeg * ffmpeg;
};

#endif // RTSPTHREAD_H
