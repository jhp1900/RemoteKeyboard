#include <QDebug>
#include <QDateTime>

#include "qffmpeg.h"

QFFmpeg::QFFmpeg(QObject *parent)
    : QObject(parent)
    , pAVFormatContext(NULL)
    , pAVCodecContext(NULL)
    , pAVFrame(NULL)
    , pSwsContext(NULL)
    , videoStreamIndex(-1)
    , width(0)
    , height(0)
{
}

QFFmpeg::~QFFmpeg()
{
    Stop();
}

bool QFFmpeg::OpenURL(const char *url)
{
    /* 初始化 */
    av_register_all();
    avformat_network_init();
    pAVFormatContext = avformat_alloc_context();
    pAVFrame = av_frame_alloc();

    if (avformat_open_input(&pAVFormatContext, url, NULL, NULL) < 0) {
        qDebug() << "打开视频流失败！！！";
        return false;
    }

    if (avformat_find_stream_info(pAVFormatContext, NULL) < 0) {
        qDebug() << "获取视频流信息失败！！！";
        return false;
    }

    videoStreamIndex = -1;
    for (uint i = 0; i < pAVFormatContext->nb_streams; ++i) {
        if (pAVFormatContext->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
            videoStreamIndex = i;
            break;
        }
    }

    if (videoStreamIndex == -1) {
        qDebug() << "获取视频流索引失败！！！";
        return false;
    }

    pAVCodecContext = pAVFormatContext->streams[videoStreamIndex]->codec;

    width = pAVCodecContext->width;
    height = pAVCodecContext->height;
    avpicture_alloc(&pAVPicture, AV_PIX_FMT_RGB24, width, height);

    AVCodec *pAVCodec = avcodec_find_decoder(pAVCodecContext->codec_id);
    pSwsContext = sws_getContext(width, height, AV_PIX_FMT_YUV420P,
                                 width, height, AV_PIX_FMT_RGB24,
                                 SWS_BICUBIC, 0, 0, 0);

    if (avcodec_open2(pAVCodecContext, pAVCodec, NULL) < 0) {
        qDebug() << "打开解码器失败！！！";
        return false;
    }

    qDebug() << "The URL Open Success !!!!";
    return true;
}

void QFFmpeg::Play()
{
    int frameFinished = 0;
    isRun = true;
    AVPacket pAVPacket;
    while (isRun) {
        if (av_read_frame(pAVFormatContext, &pAVPacket) >= 0) {
            if (pAVPacket.stream_index == videoStreamIndex) {
                //qDebug() << "开始解码:" << QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");
                avcodec_decode_video2(pAVCodecContext, pAVFrame, &frameFinished, &pAVPacket);
                if (frameFinished) {
                    mutex.lock();
                    sws_scale(pSwsContext, (const uint8_t *const *)pAVFrame->data, pAVFrame->linesize,
                              0, height, pAVPicture.data, pAVPicture.linesize);
                    QImage image(pAVPicture.data[0], width, height, QImage::Format_RGB888);
                    emit GetImage(image);
                    mutex.unlock();
                }
            }
        }
        av_free_packet(&pAVPacket);
    }
    qDebug() << " ---- Close FFmpeg stream ---- ";
    if (pAVFormatContext)
        avformat_free_context(pAVFormatContext);
    if (pAVFrame)
        av_frame_free(&pAVFrame);
    if (pSwsContext)
        sws_freeContext(pSwsContext);
}

bool QFFmpeg::Stop()
{
    isRun = false;
//    if (pAVFormatContext)
//        avformat_free_context(pAVFormatContext);
//    if (pAVFrame)
//        av_frame_free(&pAVFrame);
//    if (pSwsContext)
//        sws_freeContext(pSwsContext);

    return true;
}
