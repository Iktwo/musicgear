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

public:
    enum DownloaderRoles {
        NameRole = Qt::UserRole + 1,
        GroupRole,
        LengthRole,
        CommentRole,
        CodeRole,
        UrlRole
    };

    explicit MusicStreamer(QObject *parent = 0);

    Q_INVOKABLE void downloadSong(const QString &name, const QString &url);
    Q_INVOKABLE void search(const QString &term);
    Q_INVOKABLE void fetchMore();

    QObjectList songs();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    bool searching();
    void setSearching(bool searching);

    //bool serverError();
    //void setServerError(bool serverError);

    bool isDownloading() const;

signals:
    void songsChanged();
    void searchingChanged();
    //void serverErrorChanged();
    void serverError();
    void downloadingChanged();
    void progressChanged(float progress, const QString &name);

#if QT_VERSION >= 0x050000
protected:
    QHash<int, QByteArray> roleNames() const;
#endif

private:
    Downloader *m_downloader;
    QObjectList m_songs;
    bool m_searching;
    bool m_serverError;
    QString m_lastSearchHasMoreResults;
    int fetched;

private slots:
    void songFound(const QString &title, const QString &group, const QString &length,
                   const QString &comment, const QString &code);

    void decodedUrl(const QString &code, const QString &url);
    void searchEnded();
    //void serverErrorOcurred();
    void lastSearchHasMoreResults(const QString &url);
    void emitDownloadingChanged();
    
};

#endif // DOWNLOADERCOMPONENT_H