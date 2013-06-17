#ifndef SONG_H
#define SONG_H

#include <QObject>

class Song : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(QString group READ group NOTIFY groupChanged)
    Q_PROPERTY(QString length READ length NOTIFY lengthChanged)
    Q_PROPERTY(QString comment READ comment NOTIFY commentChanged)
    Q_PROPERTY(QString code READ code NOTIFY codeChanged)
    Q_PROPERTY(QString url READ url NOTIFY urlChanged)

public:
    Song(QObject *parent = 0);

    Song(const QString &name, const QString &group, const QString &length, const QString &comment,
         const QString &code, QObject *parent = 0);

    QString name() const;
    QString group() const;
    QString length() const;
    QString comment() const;
    QString code() const;
    QString url() const;

    void setName(const QString &name);
    void setGroup(const QString &group);
    void setLength(const QString &length);
    void setComment(const QString &comment);
    void setCode(const QString &code);
    void setUrl(const QString &url);

signals:
    void nameChanged();
    void groupChanged();
    void lengthChanged();
    void commentChanged();
    void codeChanged();
    void urlChanged();

private:
    QString m_name;
    QString m_group;
    QString m_length;
    QString m_comment;
    QString m_code;
    QString m_url;
};

#endif // SONG_H
