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
    Q_PROPERTY(int dpi READ dpi WRITE setDpi NOTIFY dpiChanged)
    Q_PROPERTY(bool isTablet READ isTablet WRITE setIsTablet NOTIFY isTabletChanged)

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
    Q_INVOKABLE void showMessage(const QString &message);

    QObjectList songs();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    bool searching();
    void setSearching(bool searching);

    //bool serverError();
    //void setServerError(bool serverError);

    bool isDownloading() const;

    int dpi() const;
    void setDpi(int dpi);

    bool isTablet() const;
    void setIsTablet(bool isTablet);

signals:
    void songsChanged();
    void searchingChanged();
    //void serverErrorChanged();
    void serverError();
    void downloadingChanged();
    void progressChanged(float progress, const QString &name);
    void dpiChanged();
    void isTabletChanged();

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    Downloader *mDownloader;
    QObjectList mSongs;
    bool mSearching;
    bool mServerError;
    QString mLastSearchHasMoreResults;
    int fetched;
    int m_dpi;
    bool m_isTablet;

private slots:
    void songFound(const QString &title, const QString &group, const QString &length, const QString &comment, const QString &code);
    void decodedUrl(const QString &code, const QString &url);
    void searchEnded();
    //void serverErrorOcurred();
    void lastSearchHasMoreResults(const QString &url);
    void lastSearchHasNoMoreResults();
    void emitDownloadingChanged();
};

#endif // DOWNLOADERCOMPONENT_H
