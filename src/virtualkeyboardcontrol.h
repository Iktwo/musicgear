#ifndef VIRTUALKEYBOARDCONTROL_H
#define VIRTUALKEYBOARDCONTROL_H

#include <QObject>
#include <QQuickView>
#include <QGuiApplication>

class VirtualKeyboardControl : public QObject
{
    Q_OBJECT
public:
    explicit VirtualKeyboardControl(QGuiApplication &app,
                                    QQuickView &view, QObject *parent = 0);

    Q_INVOKABLE void close();
    
private:
    QGuiApplication *m_app;
    QQuickView *m_view;
};

#endif // VIRTUALKEYBOARDCONTROL_H
