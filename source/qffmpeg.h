#ifndef QFFMPEG_H
#define QFFMPEG_H

#ifndef INT64_C
#define INT64_C
#define UINT64_C
#endif

extern "C"
{
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavfilter/avfilter.h>
#include <libswscale/swscale.h>
#include <libavutil/frame.h>
}

#include <QObject>
#include <QMutex>
#include <QImage>

class QFFmpeg : public QObject
{
    Q_OBJECT
public:
    explicit QFFmpeg(QObject *parent = nullptr);
    ~QFFmpeg();

    bool OpenURL(const char *url);
    void Play();
    bool Stop();

signals:
    void GetImage(const QImage &image);

public slots:

private:
    QMutex mutex;
    AVFormatContext *pAVFormatContext;
    AVCodecContext *pAVCodecContext;
    AVFrame *pAVFrame;
    SwsContext * pSwsContext;
    AVPicture  pAVPicture;
    int videoStreamIndex;
    int width;
    int height;
};

#endif // QFFMPEG_H
