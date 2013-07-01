#include <QGuiApplication>
#include <QtQuick>

#include "downloadercomponent.h"
#include "styler.h"

static QObject *stylerProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    Styler *example = new Styler();
    return example;
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("Iktwo Corp.");
    QCoreApplication::setOrganizationDomain("iktwo.com");
    QCoreApplication::setApplicationName("MusicGear");

    qRegisterMetaType<QObjectList>("QObjectList");
    qmlRegisterSingletonType<Styler>("Styler", 1, 0, "Styler", stylerProvider);

    QQuickView view;

    DownloaderComponent downloaderComponent;
    QQmlContext *ctxt = view.rootContext();
    ctxt->setContextProperty("downloaderComponent", &downloaderComponent);

    view.setSource(QUrl("qrc:/qml/qml/main.qml"));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();

    return app.exec();
}
