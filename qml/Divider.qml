import QtQuick 2.1
import "style.js" as Style

Rectangle {
    property bool horizontal: true

    width: horizontal ? parent.width : Math.max(1, 1 * dpMultiplier)
    height: horizontal ? Math.max(1, 1 * dpMultiplier) : parent.height

    color: Style.DIVIDER_DARK
}
