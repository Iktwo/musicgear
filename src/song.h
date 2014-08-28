#ifndef SONG_H
#define SONG_H

#include <QObject>

/*!
    \class Song

    \brief The Song class provides information about a song.

    Song class contains the following information about a song: name, group,
    length, comment, code and url.
*/

class Song : public QObject
{
    Q_OBJECT

    /*!
    \brief The name of the song.

    \accessors name(), setName(const QString &name);
    */
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)

    /*!
    \brief The group of the song.

    \accessors group(), setGroup(const QString &group)
    */
    Q_PROPERTY(QString group READ group NOTIFY groupChanged)
    Q_PROPERTY(QString length READ length NOTIFY lengthChanged)
    Q_PROPERTY(QString comment READ comment NOTIFY commentChanged)
    Q_PROPERTY(QString code READ code NOTIFY codeChanged)
    Q_PROPERTY(QString url READ url NOTIFY urlChanged)
    Q_PROPERTY(int kbps READ kbps NOTIFY kbpsChanged)
    Q_PROPERTY(QString picture READ picture NOTIFY pictureChanged)

public:
    Song(QObject *parent = 0);

    Song(const QString &name, const QString &group, const QString &length, const QString &comment,
         int kbps, const QString &code, const QString &picture, QObject *parent = 0);

    /*!
    Return the name of the song.

    \return The name of the song.
    \sa setName(const QString &name);
    */
    QString name() const;
    QString group() const;
    QString length() const;
    QString comment() const;
    int kbps() const;
    QString code() const;
    QString url() const;

    /*!
    Set the name of the song.

    \param name new song's name.
    \sa name();
    */
    void setName(const QString &name);
    void setGroup(const QString &group);
    void setLength(const QString &length);
    void setComment(const QString &comment);
    void setCode(const QString &code);
    void setUrl(const QString &url);
    void setKbps(int kbps);

    QString picture() const;
    void setPicture(const QString &picture);

signals:
    void nameChanged();
    void groupChanged();
    void lengthChanged();
    void commentChanged();
    void codeChanged();
    void urlChanged();
    void kbpsChanged();
    void pictureChanged();

private:
    QString m_name;
    QString m_group;
    QString m_length;
    QString m_comment;
    int m_kbps;
    QString m_url;
    QString m_code;
    QString m_picture;
};

#endif // SONG_H
