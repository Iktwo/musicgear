#include <QQuickView>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlEngine>
#include <QtQml>

#include "virtualkeyboardcontrol.h"
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

    QScopedPointer<QQuickView> view(new QQuickView);

    qmlRegisterSingletonType<Styler>("Styler", 1, 0, "Styler", stylerProvider);
    qRegisterMetaType<QObjectList>("QObjectList");

    MusicStreamer musicStreamer;
    view->rootContext()->setContextProperty("musicStreamer", &musicStreamer);

    view->rootContext()->setContextProperty("Q_OS", "UNKNOWN");

#if defined(Q_OS_ANDROID)
    view->rootContext()->setContextProperty("Q_OS", "ANDROID");
#elif defined(Q_OS_LINUX)
    view->rootContext()->setContextProperty("Q_OS", "LINUX");
#elif defined(Q_OS_WINDOWS)
    view->rootContext()->setContextProperty("Q_OS", "WINDOWS");
#endif

    VirtualKeyboardControl vkc(*app.data(), *view.data());
    view->rootContext()->setContextProperty("vkControl", &vkc);

    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->setSource(QUrl("qrc:/qml/qml/main.qml"));

    view->show();

    return app->exec();
}
