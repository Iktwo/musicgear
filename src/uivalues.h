#ifndef UIVALUES_H
#define UIVALUES_H

#include <QObject>

class UIValues : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool firstRun READ firstRun WRITE setFirstRun NOTIFY firstRunChanged)
    Q_PROPERTY(bool isTablet READ isTablet NOTIFY isTabletChanged)
public:
    explicit UIValues(QObject *parent = 0);

    Q_INVOKABLE void showMessage(const QString &message);

    bool firstRun() const;
    void setFirstRun(bool firstRun);

    bool isTablet() const;
    void setIsTablet(bool isTablet);

signals:
    void firstRunChanged();
    void isTabletChanged();

private:
    bool m_firstRun;
    bool m_isTablet;
};

#endif // UIVALUES_H
