import QtQuick 2.0
import "style.js" as Style
import Styler 1.0

Rectangle {
    property bool horizontal: true

    width: horizontal ? parent.width : 2
    height: horizontal ? 2 : parent.height

    color: Styler.darkTheme ? Style.DIVIDER_DARK : Style.DIVIDER_LIGHT
}
