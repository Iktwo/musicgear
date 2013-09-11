#include <QDebug>
#include "song.h"

Song::Song(QObject *parent)
    : QObject(parent)
{
}

Song::Song(const QString &name, const QString &group, const QString &length,
           const QString &comment, const QString &code, QObject *parent)
    : QObject(parent),
      m_name(name),
      m_group(group),
      m_length(length),
      m_comment(comment),
      m_code(code)
{
}

QString Song::name() const
{
    return m_name;
}

void Song::setName(const QString &name)
{
    if (m_name == name)
        return;

    m_name = name;
    emit nameChanged();
}

QString Song::group() const
{
    return m_group;
}

void Song::setGroup(const QString &group)
{
    if (m_group == group)
        return;

    m_group = group;
    emit groupChanged();
}

QString Song::length() const
{
    return m_length;
}

void Song::setLength(const QString &length)
{
    if (m_length == length)
        return;

    m_length = length;
    emit lengthChanged();
}

QString Song::comment() const
{
    return m_comment;
}

void Song::setComment(const QString &comment)
{
    if (m_comment == comment)
        return;

    m_comment = comment;
    emit commentChanged();
}

QString Song::code() const
{
    return m_code;
}

void Song::setCode(const QString &code)
{
    if (m_code == code)
        return;

    m_code = code;
    emit codeChanged();
}

QString Song::url() const
{
    return m_url;
}

void Song::setUrl(const QString &url)
{
    if (m_url == url)
        return;

    m_url = url;
    emit urlChanged();
}
