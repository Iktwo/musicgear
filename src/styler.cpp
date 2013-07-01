#include "styler.h"
#include <QDebug>

Styler::Styler(QObject *parent):
    QObject(parent),
    m_darkTheme(true)
{
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
}

int Styler::titleBarHeight()
{
#ifdef Q_OS_BLACKBERRY
    return 92;
#else
    return 122;
#endif
}
