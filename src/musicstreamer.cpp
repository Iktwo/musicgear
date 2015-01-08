#include "musicstreamer.h"

#include "downloader.h"
#include "song.h"

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#endif

#include <QSettings>
#include <QDebug>

MusicStreamer::MusicStreamer(QObject *parent) :
    QAbstractListModel(parent),
    mSearching(false),
    mServerError(false),
    fetched(0)
{
    mDownloader = new Downloader(this);

    connect(mDownloader, SIGNAL(songFound(QString, QString, QString, int, QString, QString)),
            SLOT(songFound(QString, QString, QString, int, QString, QString)));
    connect(mDownloader, SIGNAL(searchEnded()), SLOT(searchEnded()));
    connect(mDownloader, SIGNAL(decodedUrl(QString,QString)), SLOT(decodedUrl(QString,QString)));
    connect(mDownloader, SIGNAL(searchHasMoreResults(QString)), SLOT(lastSearchHasMoreResults(QString)));
    connect(mDownloader, SIGNAL(searchHasNoMoreResults()), SLOT(lastSearchHasNoMoreResults()));
    connect(mDownloader, SIGNAL(downloadingChanged()), SLOT(emitDownloadingChanged()));
    connect(mDownloader, SIGNAL(progressChanged(float, QString)), SIGNAL(progressChanged(float, QString)));
    connect(mDownloader, SIGNAL(serverError()), SIGNAL(serverError()));
    connect(mDownloader, SIGNAL(activeConnectionsChanged()), SIGNAL(activeConnectionsChanged()));
    connect(mDownloader, SIGNAL(noResults()), SIGNAL(noResults()));


    QSettings settings;
    m_skipImages = settings.value("skipImages", true).toBool();
}

void MusicStreamer::downloadSong(const QString &name, const QString &url)
{
    //setServerError(false);
    mDownloader->downloadSong(name, url);
}

void MusicStreamer::search(const QString &term)
{
    //setServerError(false);
    setSearching(true);

    foreach (QObject *item, mSongs)
        delete item;

    beginRemoveRows(QModelIndex(), 0, rowCount());
    mSongs.clear();
    emit songsChanged();
    endRemoveRows();

    QString searchTerm(term);
    mDownloader->search(searchTerm.replace(" ", "-"));
}

void MusicStreamer::songFound(const QString &title, const QString &artist, const QString &length,
                              int kbps, const QString &code, const QString &picture)
{
    mTempSongs.append(new Song(title, artist, length, kbps, code, picture, this));
}

QObjectList MusicStreamer::songs()
{
    return mSongs;
}

void MusicStreamer::decodedUrl(const QString &code, const QString &url)
{
    //    qDebug() << Q_FUNC_INFO << " URL: " << url;
    int i = 0;
    foreach (QObject *item, mTempSongs) {
        Song *song = qobject_cast<Song *>(item);
        if (song->code() == code) {
            song->setUrl(url);
            beginInsertRows(QModelIndex(), rowCount(), rowCount());
            mSongs.append(song);
            endInsertRows();
            emit songsChanged();
            mTempSongs.removeAt(i);
            break;
        }
        ++i;
    }
}

QVariant MusicStreamer::data(const QModelIndex & index, int role) const
{
    if (index.row() < 0 || index.row() >= mSongs.count())
        return QVariant();

    Song *song = qobject_cast<Song*>(mSongs[index.row()]);
    if (role == NameRole)
        return song->name();
    else if (role == ArtistRole)
        return song->artist();
    else if (role == LengthRole)
        return song->length();
    else if (role == KbpsRole)
        return song->kbps();
    else if (role == CodeRole)
        return song->code();
    else if (role == UrlRole)
        return song->url();
    else if (role == PictureRole)
        return song->picture();
    return QVariant();
}

int MusicStreamer::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent);
    return mSongs.count();
}

QHash<int, QByteArray> MusicStreamer::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[ArtistRole] = "artist";
    roles[LengthRole] = "length";
    roles[KbpsRole] = "kbps";
    roles[CodeRole] = "code";
    roles[UrlRole] = "url";
    roles[PictureRole] = "picture";
    return roles;
}

bool MusicStreamer::skipImages() const
{
    return m_skipImages;
}

void MusicStreamer::setSkipImages(bool skipImages)
{
    if (m_skipImages == skipImages)
        return;

    m_skipImages = skipImages;

    QSettings settings;
    settings.setValue("skipImages", m_skipImages);

    emit skipImagesChanged();
}

int MusicStreamer::activeConnections() const
{
    return mDownloader->activeConnections();
}

void MusicStreamer::setActiveConnections(int activeConnections)
{
    mDownloader->setActiveConnections(activeConnections);
}

void MusicStreamer::searchEnded()
{
    setSearching(false);
}

bool MusicStreamer::searching()
{
    return mSearching;
}

void MusicStreamer::setSearching(bool searching)
{
    if (mSearching == searching)
        return;

    mSearching = searching;
    emit searchingChanged();
}

/*bool MusicStreamer::serverError()
{
    return m_serverError;
}*/

/*void MusicStreamer::serverErrorOcurred()
{
    setServerError(true);
}*/

/*void MusicStreamer::setServerError(bool serverError)
{
    if (m_serverError == serverError)
        return;

    m_serverError = serverError;
    emit serverErrorChanged();
}*/

void MusicStreamer::lastSearchHasMoreResults(const QString &url)
{
    // qDebug() << "more results: " << url;
    mLastSearchHasMoreResults = url;
}

void MusicStreamer::lastSearchHasNoMoreResults()
{
    mLastSearchHasMoreResults.clear();
}

void MusicStreamer::fetchMoreResulst()
{
    if (!mLastSearchHasMoreResults.isEmpty() && !mSearching) {
        setSearching(true);
        mDownloader->download(mLastSearchHasMoreResults);
    }
}

void MusicStreamer::share(const QString &name, const QString &url)
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("com/iktwo/musicgear/MusicGear",
                                              "share", "(Ljava/lang/String;Ljava/lang/String;)V",
                                              QAndroidJniObject::fromString(name).object<jstring>(),
                                              QAndroidJniObject::fromString(url).object<jstring>());
#else
    qDebug() << Q_FUNC_INFO << " Name:" << name << " Url:" << url;
#endif
}

bool MusicStreamer::isDownloading() const
{
    return mDownloader->isDownloading();
}

void MusicStreamer::emitDownloadingChanged()
{
    emit downloadingChanged();
}
