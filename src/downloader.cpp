#include "downloader.h"

#include <QDebug>
#include <QtNetwork>
#include <QtXml>
#include <QDir>
#include <QFile>

#define TARGET_URL "http://www.goear.com/"
#define SEARCH_URL "http://www.goear.com/search/"
#define DOWNLOAD_URL "http://www.goear.com/tracker758.php?f="

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

void Downloader::downloadSong(const QString &name, const QString &url)
{
    m_songsToDownload.insert(url, name);
    download(url);
}

void Downloader::download(const QString &urlString)
{
    QUrl url(urlString);
    QNetworkRequest request(url);
    m_netAccess->get(request);
}

void Downloader::search(const QString &term)
{
    qDebug() << Q_FUNC_INFO << " " + term;
    download(SEARCH_URL + term);
}

void Downloader::downloadFinished(QNetworkReply *reply)
{
    if (reply->url().toString().startsWith(SEARCH_URL))
        emit searchEnded();

    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << Q_FUNC_INFO << " error downloading "
                 << reply->url().toString() << ":" << reply->errorString();

        if (reply->errorString().contains("Server Error"))
            emit serverError();

        reply->deleteLater();
        return;
    }

    qDebug() << reply->url().toString() << " has been dowloaded";

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

        QString hasMore = "";
        QString searchTerm = "<a class=\"next\" href=\"";
        QString closingTerm = "\">";

        int termBegins = songs.indexOf(searchTerm);
        int termEnds = songs.indexOf(closingTerm, termBegins);

        if (termBegins != -1) {
            hasMore = songs.mid(termBegins + searchTerm.length(), termEnds - termBegins
                                - searchTerm.length());
        }

        if (!hasMore.isEmpty())
            emit searchHasMoreResults(TARGET_URL + hasMore);

        for (int i = 0; i < count; ++i) {
            songs = decodeHtml(songs);

            searchTerm = "<span class=\"songtitleinfo\">";
            closingTerm = "</span>";

            int listenBegins = songs.indexOf("listen/");
            int listenEnds = songs.indexOf("/", listenBegins + 7);

            termBegins = songs.indexOf(searchTerm, listenBegins);
            termEnds = songs.indexOf(closingTerm, termBegins);

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
    } else if (mimeType == "audio/mpeg") {
        qDebug() << "Writing file";
        QString name(m_songsToDownload.value(reply->url().toString()).toString());

#ifdef Q_OS_BLACKBERRY
        name = "shared/music/" + name;
#endif

#ifdef Q_OS_ANDROID
        QDir musicDir("/sdcard/Music");
        if (!musicDir.exists())
            musicDir.mkdir("/sdcard/Music");

        name = "/sdcard/Music/" + name;
#endif

        bool permission;
        QFile file(name + reply->url().toString().mid(reply->url().toString().lastIndexOf(".")));
        permission = file.open(QIODevice::WriteOnly);

        /// TODO: do this
        if (!permission)
            qDebug() << "TODO: show a dialog to let user know that file can't be writteng to FS";

        qDebug() << "permission for file " << file.fileName() << " " << permission;

        file.write(reply->readAll());
        file.close();
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
