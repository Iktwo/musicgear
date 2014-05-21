#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>

#include "musicstreamer.h"
#include "styler.h"

static QObject *stylerProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    Styler *styler = new Styler();
    return styler;
}

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("Iktwo Corp.");
    QCoreApplication::setOrganizationDomain("iktwo.com");
    QCoreApplication::setApplicationName("MusicGear");

    QScopedPointer<QGuiApplication> app(new QGuiApplication(argc, argv));

    qmlRegisterSingletonType<Styler>("Styler", 1, 0, "Styler", stylerProvider);
    qRegisterMetaType<QObjectList>("QObjectList");

    QQmlApplicationEngine engine;

    MusicStreamer musicStreamer;
    engine.rootContext()->setContextProperty("musicStreamer", &musicStreamer);

#if defined(Q_OS_ANDROID)
    engine.rootContext()->setContextProperty("Q_OS", "ANDROID");
#elif defined(Q_OS_LINUX)
    engine.rootContext()->setContextProperty("Q_OS", "LINUX");
#elif defined(Q_OS_WINDOWS)
    engine.rootContext()->setContextProperty("Q_OS", "WINDOWS");
#else
    engine.rootContext()->setContextProperty("Q_OS", "UNKNOWN");
#endif

    engine.load(QUrl(QStringLiteral("qrc:/qml/qml/main.qml")));

    return app->exec();
}
