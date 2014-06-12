import QtQuick 2.1
import "style.js" as Style

Rectangle {
    property bool horizontal: true
    property real multiplayer: 0.95

    width: horizontal ? parent.width * multiplayer: dpi * 0.01
    height: horizontal ? dpi * 0.01 : parent.height * multiplayer

    color: Style.DIVIDER_DARK
}
