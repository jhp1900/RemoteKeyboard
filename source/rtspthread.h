#ifndef RTSPTHREAD_H
#define RTSPTHREAD_H

#include <QThread>
#include "qffmpeg.h"

class RtspThread : public QThread
{
    Q_OBJECT
public:
    explicit RtspThread(QObject * parent = 0)
        : QThread(parent)
        , ffmpeg(NULL)
    {}

    void run() { ffmpeg->Play(); }
    void stop() {
        if (ffmpeg) {
            ffmpeg->Stop();
            delete ffmpeg;
            ffmpeg = NULL;
        }
    }
    void setFFmpeg(QFFmpeg *f) { ffmpeg = f; }

private:
    QFFmpeg * ffmpeg;
};

#endif // RTSPTHREAD_H
