#include <QtGui/QApplication>
#include <QtDeclarative>

#include "musicstreamer.h"
#include "audiocomponent.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(new QApplication(argc, argv));

    QCoreApplication::setOrganizationName("Iktwo Corp.");
    QCoreApplication::setOrganizationDomain("iktwo.com");
    QCoreApplication::setApplicationName("MusicGear");

    QScopedPointer<QDeclarativeView> view(new QDeclarativeView());

    MusicStreamer musicStreamer;
    view->rootContext()->setContextProperty("musicStreamer", &musicStreamer);

    qRegisterMetaType<AudioComponent::PlaybackState>("AudioComponent::PlaybackState");
    qmlRegisterType<AudioComponent>("com.iktwo.components", 1, 0, "AudioComponent");

    view->setSource(QUrl("qrc:/qml/qml/main.qml"));
    view->showFullScreen();

    return app->exec();
}
