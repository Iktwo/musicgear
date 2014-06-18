#include "downloader.h"

#include <QDebug>
#include <QtNetwork>
#include <QDir>
#include <QFile>

#define COOKIE_CREATOR_URL "http://www.goear.com/listen/"
#define TARGET_URL "http://www.goear.com/"
#define SEARCH_URL "http://www.goear.com/search/"
QString Downloader::DownloadUrl("http://www.goear.com/action/sound/get/");

Downloader::Downloader(QObject *parent) :
    QObject(parent),
    m_downloading(false)
{
    m_netAccess = new QNetworkAccessManager(this);
    connect(m_netAccess, SIGNAL(finished(QNetworkReply*)), SLOT(downloadFinished(QNetworkReply*)));
}

Downloader::~Downloader()
{
    delete m_netAccess;
}

void Downloader::downloadSong(const QString &name, const QString &url)
{
#ifdef Q_OS_ANDROID
    mAdm.downloadFile(url, name.simplified());
#else
    m_songsToDownload.insert(url, name);
    download(url);
    setDownloading(true);
#endif
}

void Downloader::getDownloadLink(const QString &code)
{
//    qDebug() << Q_FUNC_INFO << " - " << code;
//    QString newUrl = url;
//    newUrl.replace(DownloadUrl, COOKIE_CREATOR_URL);

    download(COOKIE_CREATOR_URL + code);
//    setDownloading(true);
}

void Downloader::download(const QString &urlString)
{
    QUrl url(urlString);
    QNetworkRequest request(url);

    if (!mCookies.isEmpty()) {
        QVariant var;
        var.setValue(mCookies);
        request.setHeader(QNetworkRequest::CookieHeader, var);
    }

    request.setRawHeader("User-Agent", " Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0");
    m_nreply = m_netAccess->get(request);
    connect(m_nreply, SIGNAL(downloadProgress(qint64, qint64)), this, SLOT(downloadProgressChanged(qint64, qint64)));
}

void Downloader::search(const QString &term)
{
    // qDebug() << Q_FUNC_INFO << " " + term;
    download(SEARCH_URL + term);
}

void Downloader::downloadFinished(QNetworkReply *reply)
{
    if (reply->url().toString().startsWith(COOKIE_CREATOR_URL)) {
        mCookies = m_netAccess->cookieJar()->cookiesForUrl(reply->url());

        download(reply->url().toString().replace(COOKIE_CREATOR_URL, DownloadUrl));
        reply->deleteLater();
        return;
    }

    if (reply->url().toString().endsWith(".mp3"))
        setDownloading(false);

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

    //    qDebug() << reply->url().toString() << " has been dowloaded";

    QVariant redir = reply->attribute(QNetworkRequest::RedirectionTargetAttribute);

    if (redir.isValid()) {
        QUrl url = redir.toUrl();
        QString name = m_songsToDownload.value(reply->url().toString()).toString();
        m_songsToDownload.remove(reply->url().toString());
        m_songsToDownload.insert(url.toString(), name);

        if (url.toString().endsWith(".mp3")) {
            emit decodedUrl(reply->url().toString().remove(DownloadUrl), url.toString());
            reply->deleteLater();
            return;
        }

        qDebug() << reply->url().toString() << " was redirected to:" << url.toString();

        if (url.isRelative())
            url.setScheme(reply->url().scheme());

        download(url.toString());
        reply->deleteLater();
        return;
    }

    QString mimeType(reply->header(QNetworkRequest::ContentTypeHeader).toString());

    if (mimeType.contains("text/html")) {
        QString songs(reply->readAll());

        int count = songs.count("listen/");

        QString hasMore = "";
        QString searchTerm = "<ol id=\"new_pagination\">";
        QString closingTerm = "</ol>";

        int termBegins = songs.indexOf(searchTerm);
        int termEnds = songs.indexOf(closingTerm, termBegins);

        if (termBegins != -1) {
            hasMore = songs.mid(termBegins + searchTerm.length(), termEnds - termBegins
                                - searchTerm.length());
        }

        QStringList list = hasMore.simplified().split("<li", QString::SkipEmptyParts);

        bool foundMore = false;
        for (int i = 0; i < list.length() - 1; ++i) {
            if (list.at(i).simplified().startsWith("class=\"active\">")) {
                QString number = reply->url().toString().mid(reply->url().toString().lastIndexOf("/") + 1);
                bool isNumber = false;
                int index = number.toInt(&isNumber);
                //                reply->url().toString().mid(reply->url().toString().length() - 1).toInt(isANumber);
                if (isNumber)
                    emit searchHasMoreResults(reply->url().toString().mid(0, reply->url().toString().lastIndexOf("/")) + "/" + QString::number(index + 1));
                else
                    emit searchHasMoreResults(reply->url().toString() + "/" + QString::number(++i));

                foundMore = true;
                break;
            }
        }

        if (!foundMore)
            emit searchHasNoMoreResults();

        searchTerm = "<ol id=\"search_results\">";
        closingTerm = "</ol>";

        termBegins = songs.indexOf(searchTerm);
        termEnds = songs.indexOf(closingTerm, termBegins);

        songs = songs.mid(termBegins + searchTerm.length(),
                          termEnds - termBegins);

        for (int i = 0; i < count; ++i) {
            songs = decodeHtml(songs);

            searchTerm = "listen/";
            closingTerm = "/";

            termBegins = songs.indexOf(searchTerm) + searchTerm.length();
            termEnds = songs.indexOf(closingTerm, termBegins);

            QString code = songs.mid(termBegins, termEnds - termBegins);

            searchTerm = "<span class=\"song\">";
            closingTerm = "</span>";

            termBegins = songs.indexOf(searchTerm) + searchTerm.length();
            termEnds = songs.indexOf(closingTerm, termBegins);

            QString title = songs.mid(termBegins, termEnds - termBegins);

            searchTerm = "<span class=\"group\">";

            termBegins = songs.indexOf(searchTerm) + searchTerm.length();
            termEnds = songs.indexOf(closingTerm, termBegins);

            QString group = songs.mid(termBegins, termEnds - termBegins);

            searchTerm = "<li class=\"length radius_3\">";
            closingTerm = "</li>";

            termBegins = songs.indexOf(searchTerm) + searchTerm.length();
            termEnds = songs.indexOf(closingTerm, termBegins);

            QString length = songs.mid(termBegins, termEnds - termBegins);

            searchTerm = "<li class=\"description\">";

            termBegins = songs.indexOf(searchTerm) + searchTerm.length();
            termEnds = songs.indexOf(closingTerm, termBegins);

            QString comment = songs.mid(termBegins, termEnds - termBegins);

            //            searchTerm = "<p class=\"comment\">";
            //            closingTerm = "</p>";
            //            termBegins = songs.indexOf(searchTerm, listenBegins);
            //            termEnds = songs.indexOf(closingTerm, termBegins);

            //            QString comment = songs.mid(termBegins + searchTerm.length(), termEnds - termBegins
            //                                        - searchTerm.length()).simplified();

//            qDebug() << "Song found " << title << group << length << comment << code;
            emit songFound(title, group, length, comment, code);
            getDownloadLink(code);

            songs = songs.mid(songs.indexOf("<li>", termEnds));
            //            download(DOWNLOAD_URL + code);

            //            songs = songs.mid(listenEnds) + 1;
            //            exit(0);
        }
    } else if (mimeType == "text/xml") {
//        qDebug() << "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
//        qDebug() << "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
//        qDebug() << "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

//        QString link = reply->readAll();

//        int linkBegins = link.indexOf("path=\"") + 6;
//        int linkEnds = link.indexOf("\"", linkBegins);
//        link = link.mid(linkBegins, linkEnds - linkBegins);

//        emit decodedUrl(reply->url().toString().replace(DownloadUrl, ""), link);
    } else if (mimeType == "audio/mpeg") {
        qDebug() << "Writing file";
        QString name(m_songsToDownload.value(reply->url().toString()).toString());
        m_songsToDownload.remove(reply->url().toString());

        name.replace("/", "-");

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

void Downloader::downloadProgressChanged(qint64 bytesReceived, qint64 bytesTotal)
{
    if (bytesTotal == 0 || bytesTotal == -1)
        return;

    float i = bytesReceived / (double)bytesTotal;

    QNetworkReply *net = (QNetworkReply *)sender();
    // qDebug() << "Progress for: "<< net->url().toString() << " " << i;

    emit progressChanged(i, m_songsToDownload.value(net->url().toString()).toString());
}

bool Downloader::isDownloading() const
{
    return m_downloading;
}

void Downloader::setDownloading(bool downloading)
{
    if (m_downloading == downloading)
        return;

    m_downloading = downloading;
    emit downloadingChanged();
}
