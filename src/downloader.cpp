#include "downloader.h"

#include <QDebug>
#include <QtNetwork>
#include <QtXml>
#include <QDir>
#include <QFile>

#define SEARCH_URL "http://www.goear.com/search/"
#define DOWNLOAD_URL "http://www.goear.com/tracker758.php?f="
#define IMGUR_URL "http://imgur.com/r/"

QString Downloader::ImageUrl("http://i.imgur.com/");

Downloader::Downloader(QObject *parent) :
    QObject(parent)
{
    m_netAccess = new QNetworkAccessManager(this);

    connect(m_netAccess, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(downloadFinished(QNetworkReply*)));
}

Downloader::~Downloader()
{
    delete m_netAccess;
}

void Downloader::downloadSong(const QString &name)
{
    qDebug() << "Name " << name;
    // if pages == -1 download until there are two equal hashes
    // else iterate trough *pages*
    /*if (pages == 0)
        return;

    if (pages != -1)
        for (int i = 0; i < pages; ++i) {
            QString url(IMGUR_URL + name + "/page/" + QString::number(i) + ".xml");
            m_getNsfw.insert(url, getNsfw);
            download(QString(IMGUR_URL + name + "/page/" + QString::number(i) + ".xml"));
        }
    else
        qDebug() << "TODO: get 'em all"; /// TODO: download until two sequential hashes are equal*/
}

void Downloader::download(const QString &urlString)
{
    QUrl url(urlString);
    QNetworkRequest request(url);
    m_netAccess->get(request);
}

void Downloader::search(const QString &term)
{
    download(SEARCH_URL + term);
}

void Downloader::downloadFinished(QNetworkReply *reply)
{
    if (reply->url().toString().startsWith(SEARCH_URL))
        emit searchEnded();

    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << Q_FUNC_INFO << " error downloading "
                 << reply->url().toString() << ":" << reply->errorString();

        reply->deleteLater();
        return;
    }

    // qDebug() << reply->url().toString() << " has been dowloaded";

    QVariant redir = reply->attribute(QNetworkRequest::RedirectionTargetAttribute);

    if (redir.isValid()) {
        QUrl url = redir.toUrl();
        qDebug() << reply->url().toString() << " was redirected to:" << url.toString();

        if (url.isRelative()) {
            url.setScheme(reply->url().scheme());
            /// TODO: check why this doesn't work
            //            url.setEncodedHost(reply->url().encodedHost());
        }

        download(url.toString());
        reply->deleteLater();
        return;
    }

    QString mimeType(reply->header(QNetworkRequest::ContentTypeHeader).toString());

    if (mimeType.contains("text/html")) {
        QString songs(reply->readAll());

        int count = songs.count("listen/");

        for (int i = 0; i < count; ++i) {
            songs = decodeHtml(songs);

            QString searchTerm = "<span class=\"songtitleinfo\">";
            QString closingTerm = "</span>";

            int listenBegins = songs.indexOf("listen/");
            int listenEnds = songs.indexOf("/", listenBegins + 7);

            int termBegins = songs.indexOf(searchTerm, listenBegins);
            int termEnds = songs.indexOf(closingTerm, termBegins);

            QString code = songs.mid(listenBegins + 7, listenEnds - listenBegins - 7);

            QString title = songs.mid(termBegins + searchTerm.length(), termEnds - termBegins
                                      - searchTerm.length());

            searchTerm = "<span class=\"groupnameinfo\">";
            termBegins = songs.indexOf(searchTerm, listenBegins);
            termEnds = songs.indexOf(closingTerm, termBegins);


            QString group = songs.mid(termBegins + searchTerm.length(), termEnds - termBegins
                                      - searchTerm.length());

            searchTerm = "<span class=\"length\">";
            termBegins = songs.indexOf(searchTerm, listenBegins);
            termEnds = songs.indexOf(closingTerm, termBegins);

            QString length = songs.mid(termBegins + searchTerm.length(), termEnds - termBegins
                                      - searchTerm.length());

            searchTerm = "<p class=\"comment\">";
            closingTerm = "</p>";
            termBegins = songs.indexOf(searchTerm, listenBegins);
            termEnds = songs.indexOf(closingTerm, termBegins);

            QString comment = songs.mid(termBegins + searchTerm.length(), termEnds - termBegins
                                      - searchTerm.length()).simplified();

            emit songFound(title, group, length, comment, code);
            download(DOWNLOAD_URL + code);

            songs = songs.mid(listenEnds) + 1;
        }
    } else if (mimeType == "text/xml") {
        QString link = reply->readAll();

        int linkBegins = link.indexOf("path=\"") + 6;
        int linkEnds = link.indexOf("\"", linkBegins);
        link = link.mid(linkBegins, linkEnds - linkBegins);

        emit decodedUrl(reply->url().toString().replace(DOWNLOAD_URL, ""), link);
    } else
        qDebug() << reply->url().toString()
                 << " type is:" << mimeType;

    reply->deleteLater();
}

QString Downloader::decodeHtml(const QString &html)
{
    QString decodedHtml(html);

    decodedHtml.replace("&amp;", "&");

    decodedHtml.replace("&aacute;", "á");
    decodedHtml.replace("&eacute;", "é");
    decodedHtml.replace("&iacute;", "í");
    decodedHtml.replace("&oacute;", "ó");
    decodedHtml.replace("&uacute;", "ú");

    decodedHtml.replace("&Aacute;", "Á");
    decodedHtml.replace("&Eacute;", "É");
    decodedHtml.replace("&Iacute;", "Í");
    decodedHtml.replace("&Oacute;", "Ó");
    decodedHtml.replace("&Uacute;", "Ú");

    decodedHtml.replace("&Ntilde;", "Ñ");
    decodedHtml.replace("&ntilde;", "ñ");

    decodedHtml.replace("&Euml;", "Ë");
    decodedHtml.replace("&euml;", "ë");
    decodedHtml.replace("&Uuml;", "Ü");
    decodedHtml.replace("&uuml;", "ü");

    decodedHtml.replace("&Ccedil;", "Ç");
    decodedHtml.replace("&ccedil;", "ç");

    return decodedHtml;
}

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
/*void WMain::searchFinished(QNetworkReply *reply){
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
