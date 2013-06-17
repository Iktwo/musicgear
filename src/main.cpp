#include <QGuiApplication>
#include <QtQuick>

#include "downloadercomponent.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("Iktwo Corp.");
    QCoreApplication::setOrganizationDomain("iktwo.com");
    QCoreApplication::setApplicationName("MusicGear");

    qRegisterMetaType<QObjectList>("QObjectList");

    // qmlRegisterType<DownloaderComponent>("DownloaderComponent", 1, 0, "Downloader");
    QQuickView view;

    DownloaderComponent downloaderComponent;
    QQmlContext *ctxt = view.rootContext();
    ctxt->setContextProperty("songsModel", &downloaderComponent);

    view.setSource(QUrl("qrc:/qml/qml/main.qml"));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();

    return app.exec();
}


/*
 wmain.h

#ifndef WMAIN_H
#define WMAIN_H

#include <QDeclarativeView>
#include <QDeclarativeEngine>
#include <QDeclarativeView>
#include <QDeclarativeContext>
#include <QSettings>
#include <QGraphicsObject>
#include <QNetworkAccessManager>
#include <QNetworkConfigurationManager>
#include <QNetworkReply>
#include <QtXml>

#include "song.h"


class WMain : public QObject
{
    Q_OBJECT
public:
    explicit WMain(QWidget *parent = 0);


public slots:
    void setSearchBusyIndicator(bool busy);
    void search(QString searchTerm);
    void search(QString url, QNetworkAccessManager *netAccessMan);
    void searchFinished(QNetworkReply *reply);

private:
    QDeclarativeView *view;
    QDeclarativeContext *rootContext;
    QSettings *settings;
    QNetworkAccessManager *netAccessManSearch;
    QByteArray *downloadedItem;
};

#endif // WMAIN_H
*/

/*
 wmain.cpp

#include "wmain.h"
#include <QDebug>
#include <QDesktopServices>
#include <QTimer>
#include <QSettings>
#include <QFile>

WMain::WMain(QWidget *parent)
{
//    QSettings *settings= new QSettings(this);
//    settings->beginGroup ("Kall");
//    lastDialedNumber=(settings->value("lastDialedNumber","").toString());
//    settings->endGroup();
//    delete settings;

    view = new QDeclarativeView();

    rootContext = view->rootContext();
    rootContext->setContextProperty("wMain", this);

    view->setAttribute(Qt::WA_OpaquePaintEvent);
    view->setAttribute(Qt::WA_NoSystemBackground);

    // BEGINS LAUNCH DIFFERENT QML FILE FOR DIFFERENT PLATFORMS
#ifdef Q_OS_SYMBIAN
    view->setSource(QUrl("qrc:/qml/Symbian/main.qml"));
#elif defined(Q_WS_MAEMO_5)
    view->setSource(QUrl("qrc:/qml/Maemo/main.qml"));
#elif defined(Q_WS_WIN)
    view->setSource(QUrl("qrc:/qml/Desktop/main.qml"));
    //#elif defined(Q_WS_X11)
    //setSource(QUrl("qrc:/qml/Desktop/main.qml"));
#elif defined(Q_WS_MACX)
    view->setSource(QUrl("qrc:/qml/Desktop/main.qml"));
#else
    view->setSource(QUrl("qrc:/Harmattan/qml/harmattan/main.qml"));
#endif

#ifdef Q_OS_SYMBIAN
    view->showFullScreen();
#elif defined(Q_WS_MAEMO_5)
    view->showFullScreen();
#elif defined(Q_WS_WIN)
    view->show();
    //#elif defined(Q_WS_X11)
    //view.show();
#elif defined(Q_WS_MACX)
    view->show();
#else
    view->showFullScreen();
#endif
    // ENDS LAUNCH DIFFERENT QML FILE FOR DIFFERENT PLATFORMS

    netAccessManSearch = new QNetworkAccessManager(this);
    connect(netAccessManSearch, SIGNAL(finished(QNetworkReply*)), this, SLOT(searchFinished(QNetworkReply*)));
}

void WMain::setSearchBusyIndicator(bool busy){
    QObject* rootObject = view->rootObject();
    QObject* listView = rootObject->findChild<QObject *>("searchPage");
    QVariant returnedValue;
    QMetaObject::invokeMethod(listView, "setBusyIndicator",
                              Q_RETURN_ARG(QVariant, returnedValue),
                              Q_ARG(QVariant, busy));
}

void WMain::search(QString searchTerm){
    search("http://www.goear.com/search/"+searchTerm,netAccessManSearch);
}

void WMain::search(QString url, QNetworkAccessManager *netAccessMan){
    QUrl qUrl(url);
    QNetworkRequest request(qUrl);
    netAccessMan->get(request);
    setSearchBusyIndicator(true);
}

void WMain::searchFinished(QNetworkReply *reply){
    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << "ERROR While searching";
        qDebug() << reply->error();
        reply->deleteLater();
        return;
    }else{
        QVariant redir = reply->attribute(QNetworkRequest::RedirectionTargetAttribute);
        if (redir.isValid()) {
            QUrl url = redir.toUrl();
            qDebug() << "Redirecting:" << url;
            if (url.isRelative()) {
                url.setScheme(reply->url().scheme());
                url.setEncodedHost(reply->url().encodedHost());
            }
            QNetworkRequest req(url);
            netAccessManSearch->get(req);
            reply->deleteLater();
            return;
        }
        //qDebug() << "ContentType:" << reply->header(QNetworkRequest::ContentTypeHeader).toString();
        downloadedItem = new QByteArray (reply->readAll());
        if (reply->header(QNetworkRequest::ContentTypeHeader).toString().contains("text/html")){
            QStringList songNameList;
            QStringList songUrlList;
            QString songs= downloadedItem->data();
            int count=songs.count("listen/");
            for (int var=0;var<count;var++){
                int listenBegins=songs.indexOf("listen/");
                int listenEnds=songs.indexOf("/",listenBegins+7);
                int tittleEnds=songs.indexOf("\"",listenEnds+1);

                QString song = songs.mid(listenEnds+1,tittleEnds-listenEnds-1);
                song = song.replace("-"," ");
                songNameList.append(song);
                songUrlList.append(songs.mid(listenBegins+7,listenEnds-listenBegins-7));
                songs=songs.mid(listenEnds)+1;
            }
            if (songNameList.count()==songUrlList.count()){
                QList<QObject*> searchResultList;
                for (int var = 0; var < songNameList.count(); ++var) {
                    searchResultList.append(new Song(songNameList.at(var),songUrlList.at(var)));
                }
                rootContext->setContextProperty("searchResultsModel", QVariant::fromValue(searchResultList));
            }
        }else if (reply->header(QNetworkRequest::ContentTypeHeader).toString().contains("text/xml")){
            QString link=downloadedItem->data();

            int linkBegins=link.indexOf("path=\"")+6;
            int linkEnds=link.indexOf("\"",linkBegins);
            link=link.mid(linkBegins,linkEnds-linkBegins);

            //download(link,downloadNetAccessMan);

//            music->clearQueue();
//                music->enqueue(link);
//                music->play();
            link.toInt();
        }

        delete downloadedItem;
    }
    setSearchBusyIndicator(false);
}

*/
