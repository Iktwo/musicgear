#include "virtualkeyboardcontrol.h"

#include <QDebug>

VirtualKeyboardControl::VirtualKeyboardControl(QGuiApplication *app,
                                               QQuickView *view,
                                               QObject *parent) :
    QObject(parent),
    m_app(app),
    m_view(view)
{
}

void VirtualKeyboardControl::close()
{
    qDebug() << "requesting close";
    QEvent event(QEvent::FocusOut);
    m_app->sendEvent(m_view, &event);
}

void VirtualKeyboardControl::open()
{
    qDebug() << "requesting open";
    QEvent event(QEvent::RequestSoftwareInputPanel);
    m_app->sendEvent(m_view, &event);
}
