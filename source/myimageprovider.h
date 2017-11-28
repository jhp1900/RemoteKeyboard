#ifndef MYIMAGEPROVIDER_H
#define MYIMAGEPROVIDER_H

#include <QQuickImageProvider>
#include <QImage>
#include <QDebug>

class MyImageProvider : public QQuickImageProvider
{
public:
    explicit MyImageProvider(ImageType type, Flags flags = Flags())
        : QQuickImageProvider(type, flags)
    {}

    ~MyImageProvider()
    {}

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize)
    {
        //qDebug() << "image info : " << image.width() << " - " << image.height();
        return image;
    }

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
    {
        //qDebug() << "pixmap info : " << pixmap.width() << " - " << pixmap.height();
        return pixmap;
    }

    void setImage(const QImage &i) { image = i; }

    void setPixmap(const QPixmap &p) { pixmap = p; }

private:
    QImage image;
    QPixmap pixmap;
};

#endif // MYIMAGEPROVIDER_H
