#include "uivalues.h"

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#endif

#include <QScreen>
#include <QSettings>
#include <QDebug>
#include <QGuiApplication>

UIValues::UIValues(QObject *parent) :
    QObject(parent),
    m_isTablet(false)
{
    QSettings settings;
    m_firstRun = settings.value("firstRun", true).toBool();

#ifdef Q_OS_ANDROID
    m_isTablet = QAndroidJniObject::callStaticMethod<jboolean>("com/iktwo/musicgear/MusicGear",
                                                               "isTablet", "()Z");
#endif
}

void UIValues::showMessage(const QString &message)
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("com/iktwo/musicgear/MusicGear",
                                              "toast", "(Ljava/lang/String;)V",
                                              QAndroidJniObject::fromString(message).object<jstring>());
#else
    qDebug() << Q_FUNC_INFO << "not implemented yet";
    qDebug() << message;
#endif
}

bool UIValues::firstRun() const
{
    return m_firstRun;
}

void UIValues::setFirstRun(bool firstRun)
{
    if (m_firstRun == firstRun)
        return;

    m_firstRun = firstRun;
    emit firstRunChanged();
}

bool UIValues::isTablet() const
{
    return m_isTablet;
}

void UIValues::setIsTablet(bool isTablet)
{
    if (m_isTablet == isTablet)
        return;

    m_isTablet = isTablet;
    emit isTabletChanged();
}
