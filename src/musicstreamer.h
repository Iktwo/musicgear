#ifndef DOWNLOADERCOMPONENT_H
#define DOWNLOADERCOMPONENT_H

#include <QAbstractListModel>
#include <QDateTime>
#include <QStringList>

class Downloader;
class MusicStreamer : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QObjectList songs READ songs NOTIFY songsChanged)
    Q_PROPERTY(bool searching READ searching NOTIFY searchingChanged)
    //Q_PROPERTY(bool serverError READ serverError NOTIFY serverErrorChanged)
    Q_PROPERTY(bool downloading READ isDownloading NOTIFY downloadingChanged)
    Q_PROPERTY(int activeConnections READ activeConnections NOTIFY activeConnectionsChanged)
    Q_PROPERTY(bool skipImages READ skipImages WRITE setSkipImages NOTIFY skipImagesChanged)

public:
    enum DownloaderRoles {
        NameRole = Qt::UserRole + 1,
        ArtistRole,
        LengthRole,
        CommentRole,
        KbpsRole,
        CodeRole,
        UrlRole,
        PictureRole,
        HitsRole
    };

    explicit MusicStreamer(QObject *parent = 0);

    Q_INVOKABLE void downloadSong(const QString &name, const QString &url);
    Q_INVOKABLE void search(const QString &term);
    Q_INVOKABLE void fetchMoreResulst();
    Q_INVOKABLE void share(const QString &name, const QString &url);

    QObjectList songs();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    bool searching();
    void setSearching(bool searching);

    //bool serverError();
    //void setServerError(bool serverError);

    bool isDownloading() const;

    int activeConnections() const;
    void setActiveConnections(int activeConnections);

    bool skipImages() const;
    void setSkipImages(bool skipImages);

signals:
    void songsChanged();
    void searchingChanged();
    //void serverErrorChanged();
    void serverError();
    void downloadingChanged();
    void progressChanged(float progress, const QString &name);
    void activeConnectionsChanged();
    void noResults();
    void skipImagesChanged();

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    Downloader *mDownloader;
    QObjectList mSongs;
    QObjectList mTempSongs;
    bool mSearching;
    bool mServerError;
    QString mLastSearchHasMoreResults;
    int fetched;
    bool m_skipImages;

private slots:
    void songFound(const QString &title, const QString &artist, const QString &length,
                   const QString &comment, int kbps, const QString &code,
                   const QString &picture, long long hits);
    void decodedUrl(const QString &code, const QString &url);
    void searchEnded();
    void lastSearchHasMoreResults(const QString &url);
    void lastSearchHasNoMoreResults();
    void emitDownloadingChanged();
};

#endif // DOWNLOADERCOMPONENT_H
