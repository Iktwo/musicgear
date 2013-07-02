#ifndef MYITEM_H
#define MYITEM_H

#include <QObject>
#include <QColor>

class Styler : public QObject
{
    Q_OBJECT
    Q_PROPERTY (bool darkTheme READ darkTheme WRITE setDarkTheme NOTIFY darkThemeChanged)

public:
//    Q_ENUMS (Platform)

//    enum Platform {
//        BlackBerry,
//        Desktop
//    };

    Styler(QObject* parent = 0);
    bool darkTheme();
    void setDarkTheme(bool darkTheme);
    int titleBarHeight();

signals:
    void darkThemeChanged();

private:
    bool m_darkTheme;
};


#endif // MYITEM_H
