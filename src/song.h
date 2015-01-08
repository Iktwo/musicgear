#ifndef SONG_H
#define SONG_H

#include <QObject>

class Song : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name NOTIFY nameChanged)

    Q_PROPERTY(QString artist READ artist NOTIFY artistChanged)
    Q_PROPERTY(QString length READ length NOTIFY lengthChanged)
    Q_PROPERTY(QString code READ code NOTIFY codeChanged)
    Q_PROPERTY(QString url READ url NOTIFY urlChanged)
    Q_PROPERTY(int kbps READ kbps NOTIFY kbpsChanged)
    Q_PROPERTY(QString picture READ picture NOTIFY pictureChanged)

public:
    Song(QObject *parent = 0);

    Song(const QString &name, const QString &artist, const QString &length,
         int kbps, const QString &code, const QString &picture, QObject *parent = 0);

    QString name() const;
    QString artist() const;
    QString length() const;
    int kbps() const;
    QString code() const;
    QString url() const;

    void setName(const QString &name);
    void setArtist(const QString &artist);
    void setLength(const QString &length);
    void setCode(const QString &code);
    void setUrl(const QString &url);
    void setKbps(int kbps);

    QString picture() const;
    void setPicture(const QString &picture);

signals:
    void nameChanged();
    void artistChanged();
    void lengthChanged();
    void codeChanged();
    void urlChanged();
    void kbpsChanged();
    void pictureChanged();

private:
    QString m_name;
    QString m_artist;
    QString m_length;
    int m_kbps;
    QString m_url;
    QString m_code;
    QString m_picture;
};

#endif // SONG_H
