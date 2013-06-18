#ifndef DOWNLOADERCOMPONENT_H
#define DOWNLOADERCOMPONENT_H

#include <QAbstractListModel>
#include <QDateTime>
#include <QStringList>

class Downloader;
class DownloaderComponent : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QObjectList songs READ songs NOTIFY songsChanged)
    Q_PROPERTY(bool searching READ searching NOTIFY searchingChanged)
public:
    enum DownloaderRoles {
        NameRole = Qt::UserRole + 1,
        GroupRole,
        LengthRole,
        CommentRole,
        CodeRole,
        UrlRole
    };

    explicit DownloaderComponent(QObject *parent = 0);
    ~DownloaderComponent();

    Q_INVOKABLE void download(const QString &url);
    Q_INVOKABLE void search(const QString &term);

    QObjectList songs();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    bool searching();
    void setSearching(bool searching);
    
signals:
    void songsChanged();
    void searchingChanged();

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    Downloader *m_downloader;
    QObjectList m_songs;
    bool m_searching;

private slots:
    void songFound(const QString &title, const QString &group, const QString &length,
                   const QString &comment, const QString &code);

    void decodedUrl(const QString &code, const QString &url);
    void searchEnded();
    
};

#endif // DOWNLOADERCOMPONENT_H
