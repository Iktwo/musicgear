#include "virtualkeyboardcontrol.h"

#include <QDebug>

VirtualKeyboardControl::VirtualKeyboardControl(QGuiApplication &app,
                                               QQuickView &view,
                                               QObject *parent) :
    QObject(parent),
    m_app(&app),
    m_view(&view)
{
}

void VirtualKeyboardControl::close()
{
    QEvent event(QEvent::FocusOut);
    m_app->sendEvent(m_view, &event);
}
