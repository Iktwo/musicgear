#ifndef VIRTUALKEYBOARDCONTROL_H
#define VIRTUALKEYBOARDCONTROL_H

#include <QObject>
#include <QQuickView>
#include <QGuiApplication>

//! VirtualKeyboardControl class.

/*!
VirtualKeyboardControl class provides functions to interact with
the keyboard.
*/

class VirtualKeyboardControl : public QObject
{
    Q_OBJECT
public:
    //! VirtualKeyboardControl constructor.

/*!
VirtualKeyboardControl constructor.

\param app is a reference to QGuiApplication.
\param view is a reference to QQuickView.
\param parent is a pointer to QObject parent.
*/
    explicit VirtualKeyboardControl(QGuiApplication &app,
                                    QQuickView &view, QObject *parent = 0);

    //! Close function to close virtual keyboard.
    Q_INVOKABLE void close();
    
private:
    QGuiApplication *m_app;
    QQuickView *m_view;
};

#endif // VIRTUALKEYBOARDCONTROL_H
