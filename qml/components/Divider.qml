import QtQuick 2.3
import "style.js" as Style

Rectangle {
    property bool horizontal: true

    width: horizontal ? parent.width : Math.max(1, 1 * ui.dpMultiplier)
    height: horizontal ? Math.max(1, 1 * ui.dpMultiplier) : parent.height

    color: Style.DIVIDER_DARK
}
