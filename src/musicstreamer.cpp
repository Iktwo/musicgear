#include "musicstreamer.h"

#include "downloader.h"
#include "song.h"

#include <QDebug>

MusicStreamer::MusicStreamer(QObject *parent) :
    QAbstractListModel(parent),
    m_searching(false),
    m_serverError(false),
    fetched(0)
{
#if QT_VERSION < 0x050000
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[GroupRole] = "group";
    roles[LengthRole] = "length";
    roles[CommentRole] = "comment";
    roles[CodeRole] = "code";
    roles[UrlRole] = "url";
    setRoleNames(roles);
#endif

    m_downloader = new Downloader(this);

    connect(m_downloader, SIGNAL(songFound(QString, QString, QString, QString, QString)), this,
            SLOT(songFound(QString, QString, QString, QString, QString)));

    connect(m_downloader, SIGNAL(searchEnded()), SLOT(searchEnded()));
    //connect(m_downloader, SIGNAL(serverError()), SLOT(serverErrorOcurred()));
    connect(m_downloader, SIGNAL(decodedUrl(QString,QString)), SLOT(decodedUrl(QString,QString)));
    connect(m_downloader, SIGNAL(searchHasMoreResults(QString)),
            SLOT(lastSearchHasMoreResults(QString)));
    connect(m_downloader, SIGNAL(downloadingChanged()), SLOT(emitDownloadingChanged()));
    connect(m_downloader, SIGNAL(progressChanged(float, QString)), SIGNAL(progressChanged(float, QString)));

    connect(m_downloader, SIGNAL(serverError()), SIGNAL(serverError()));
}

void MusicStreamer::downloadSong(const QString &name, const QString &url)
{
    //setServerError(false);
    m_downloader->downloadSong(name, url);
}

void MusicStreamer::search(const QString &term)
{
    //setServerError(false);
    setSearching(true);

    foreach (QObject *item, m_songs)
        delete item;

    beginRemoveRows(QModelIndex(), 0, rowCount());
    m_songs.clear();
    emit songsChanged();
    endRemoveRows();

    QString searchTerm(term);
    m_downloader->search(searchTerm.replace(" ", "-"));
}

void MusicStreamer::songFound(const QString &title, const QString &group, const QString &length,
                              const QString &comment, const QString &code)
{
    //    qDebug() << "apending " << title;
    // m_downloader->download(QString(Downloader::ImageUrl + hash + extension));
    // m_songs.append(QString(title));

    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_songs.append(new Song(title, group, length, comment, code, this));
    endInsertRows();

    emit songsChanged();
}

QObjectList MusicStreamer::songs()
{
    return m_songs;
}

void MusicStreamer::decodedUrl(const QString &code, const QString &url)
{
    int i = 0;
    foreach (QObject *item, m_songs) {
        Song *song = qobject_cast<Song *>(item);
        if (song->code() == code) {
            song->setUrl(url);
            QModelIndex index = createIndex(i, 0);
            dataChanged(index, index);
            break;
        }
        ++i;
    }
}

QVariant MusicStreamer::data(const QModelIndex & index, int role) const
{
    if (index.row() < 0 || index.row() >= m_songs.count())
        return QVariant();

    Song *song = qobject_cast<Song*>(m_songs[index.row()]);
    if (role == NameRole)
        return song->name();
    else if (role == GroupRole)
        return song->group();
    else if (role == LengthRole)
        return song->length();
    else if (role == CommentRole)
        return song->comment();
    else if (role == CodeRole)
        return song->code();
    else if (role == UrlRole)
        return Downloader::DownloadUrl + song->code();
    return QVariant();
}

int MusicStreamer::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent);
    return m_songs.count();
}

QHash<int, QByteArray> MusicStreamer::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[GroupRole] = "group";
    roles[LengthRole] = "length";
    roles[CommentRole] = "comment";
    roles[CodeRole] = "code";
    roles[UrlRole] = "url";
    return roles;
}

void MusicStreamer::searchEnded()
{
    setSearching(false);
}

bool MusicStreamer::searching()
{
    return m_searching;
}

void MusicStreamer::setSearching(bool searching)
{
    if (m_searching == searching)
        return;

    m_searching = searching;
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
    qDebug() << "more results: " << url;
    m_lastSearchHasMoreResults = url;
}

void MusicStreamer::fetchMore()
{
    //    if (fetched < 3)
    if (!m_lastSearchHasMoreResults.isEmpty() && !m_searching) {
        m_downloader->download(m_lastSearchHasMoreResults);
        setSearching(true);
    }
    //    fetched++;
}

bool MusicStreamer::isDownloading() const
{
    return m_downloader->isDownloading();
}

void MusicStreamer::emitDownloadingChanged()
{
    emit downloadingChanged();
}
