#ifndef DOWNLOADER_H
#define DOWNLOADER_H

#include <QObject>
#include <QDateTime>
#include <QMap>

class QNetworkReply;
class QNetworkAccessManager;
class Downloader : public QObject
{
    Q_OBJECT
public:
    explicit Downloader(QObject *parent = 0);
    ~Downloader();

    static QString ImageUrl;

public slots:
    void downloadSong(const QString &name, const QString &url);
    void download(const QString &urlString);
    void search(const QString &term);
    void downloadFinished(QNetworkReply *reply);

signals:
    void songFound(const QString &title, const QString &group, const QString &length,
                    const QString &comment, const QString &code);

    void decodedUrl(const QString &code, const QString &url);
    void searchEnded();
    void songDownloaded(const QString &url);
    void serverError();

private:
    QNetworkAccessManager *m_netAccess;
    QMap<QString, QString> m_subdirs;
    QMap<QString, bool> m_getNsfw;
    QVariantMap m_songsToDownload;

private slots:
    QString decodeHtml(const QString &html);
};

#endif // DOWNLOADER_H
