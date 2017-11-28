#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QtQml>

#include "myimageprovider.h"
#include "dispatching.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    MyImageProvider * imgProvider = new MyImageProvider(QQmlImageProviderBase::Pixmap);
    QQmlApplicationEngine engine;
    engine.addImageProvider(QLatin1String("provider"), imgProvider);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    Dispatching * dispatch = new Dispatching(imgProvider);
    engine.rootContext()->setContextProperty("dispatching", dispatch);

    return app.exec();
}
