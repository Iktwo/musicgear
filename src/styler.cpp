#include "styler.h"
#include <QSettings>
#include <QDebug>

Styler::Styler(QObject *parent):
    QObject(parent),
    m_darkTheme(true)
{
    QSettings settings;
    settings.beginGroup("ui");
    m_darkTheme = settings.value("DarkTheme", true).toBool();
}

bool Styler::darkTheme()
{
    return m_darkTheme;
}

void Styler::setDarkTheme(bool darkTheme)
{
    if (m_darkTheme == darkTheme)
        return;

    m_darkTheme = darkTheme;
    emit darkThemeChanged();

    QSettings settings;
    settings.beginGroup("ui");
    settings.setValue("DarkTheme", darkTheme);
}
