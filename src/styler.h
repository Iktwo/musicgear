#ifndef MYITEM_H
#define MYITEM_H

#include <QObject>
#include <QColor>

class Styler : public QObject
{
    Q_OBJECT
    Q_PROPERTY (bool darkTheme READ darkTheme WRITE setDarkTheme NOTIFY darkThemeChanged)

public:
    Styler(QObject* parent = 0);
    bool darkTheme();
    void setDarkTheme(bool darkTheme);

signals:
    void darkThemeChanged();

private:
    bool m_darkTheme;
};


#endif // MYITEM_H
