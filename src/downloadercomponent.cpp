#include "downloadercomponent.h"

#include "downloader.h"
#include "song.h"

#include <QDebug>

DownloaderComponent::DownloaderComponent(QObject *parent) :
    QAbstractListModel(parent), m_searching(false)
{
    m_downloader = new Downloader();

    connect(m_downloader, SIGNAL(songFound(QString, QString, QString, QString, QString)), this,
            SLOT(songFound(QString, QString, QString, QString, QString)));

    connect(m_downloader, SIGNAL(decodedUrl(QString,QString)), this, SLOT(decodedUrl(QString,QString)));

    connect(m_downloader, SIGNAL(searchEnded()), this, SLOT(searchEnded()));
}

DownloaderComponent::~DownloaderComponent()
{
    delete m_downloader;
}

void DownloaderComponent::download(const QString &url)
{
    // m_songs.clear();
    emit songsChanged();
    m_downloader->downloadSong(url);
}

void DownloaderComponent::search(const QString &term)
{
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

void DownloaderComponent::songFound(const QString &title, const QString &group, const QString &length,
                                    const QString &comment, const QString &code)
{
    // m_downloader->download(QString(Downloader::ImageUrl + hash + extension));
    // m_songs.append(QString(title));
    /// TODO: store in a map to be able to match it? maybe not..
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_songs.append(new Song(title, group, length, comment, code));
    endInsertRows();
    emit songsChanged();
}

QObjectList DownloaderComponent::songs()
{
    return m_songs;
}

void DownloaderComponent::decodedUrl(const QString &code, const QString &url)
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

QVariant DownloaderComponent::data(const QModelIndex & index, int role) const
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
        return song->url();
    return QVariant();
}

int DownloaderComponent::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent);
    return m_songs.count();
}

QHash<int, QByteArray> DownloaderComponent::roleNames() const
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

void DownloaderComponent::searchEnded()
{
    setSearching(false);
}

bool DownloaderComponent::searching()
{
    return m_searching;
}

void DownloaderComponent::setSearching(bool searching)
{
    if (m_searching == searching)
        return;

    m_searching = searching;
    emit searchingChanged();
}
