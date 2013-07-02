#include <qglobal.h>

#if QT_VERSION >= 0x050000
#include <QQuickView>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlEngine>
#include <QtQml>
#else
#include <QApplication>
#include <QDeclarativeView>
#include <QDeclarativeContext>
#endif

#include "downloadercomponent.h"
#include "styler.h"

#if QT_VERSION >= 0x050000
static QObject *stylerProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    Styler *example = new Styler();
    return example;
}
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("Iktwo Corp.");
    QCoreApplication::setOrganizationDomain("iktwo.com");
    QCoreApplication::setApplicationName("MusicGear");

#if QT_VERSION >= 0x050000
    QScopedPointer<QGuiApplication> app(new QGuiApplication(argc, argv));

    qmlRegisterSingletonType<Styler>("Styler", 1, 0, "Styler", stylerProvider);

    QScopedPointer<QQuickView> view(new QQuickView);
#else
    QScopedPointer<QApplication> app(new QApplication(argc, argv));

    QScopedPointer<QDeclarativeView> view(new QDeclarativeView);
#endif

    qRegisterMetaType<QObjectList>("QObjectList");

    DownloaderComponent downloaderComponent;

    view->rootContext()->setContextProperty("downloaderComponent", &downloaderComponent);

#if QT_VERSION >= 0x050000
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->setSource(QUrl("qrc:/QtQuick2/qml/QtQuick2/main.qml"));
#else
    Styler styler;
    view->rootContext()->setContextProperty("Styler", &styler);
    view->setResizeMode(QDeclarativeView::SizeRootObjectToView);
    view->setSource(QUrl("qrc:/QtQuick1/qml/QtQuick1/main.qml"));
#endif

    view->show();

    return app->exec();
}
