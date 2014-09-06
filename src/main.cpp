#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
#include <QTranslator>

#include "musicstreamer.h"
#include "uivalues.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("Iktwo Corp.");
    QCoreApplication::setOrganizationDomain("iktwo.com");
    QCoreApplication::setApplicationName("MusicGear");

    QScopedPointer<QGuiApplication> app(new QGuiApplication(argc, argv));

    QStringList translations;
    translations << "es";

    QTranslator translator;

    if (translations.contains(QLocale::system().bcp47Name())) {
        translator.load("translation_" + QLocale::system().bcp47Name(), ":/translations/");
    }

    app->installTranslator(&translator);

    qRegisterMetaType<QObjectList>("QObjectList");

    QQmlApplicationEngine engine;

    MusicStreamer musicStreamer;
    engine.rootContext()->setContextProperty(QStringLiteral("musicStreamer"), &musicStreamer);
    engine.rootContext()->setContextProperty(QStringLiteral("buildDate"), QString(BUILD_DATE));

    UIValues uiValues;
    engine.rootContext()->setContextProperty(QStringLiteral("ui"), &uiValues);

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
