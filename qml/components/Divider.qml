import QtQuick 2.3
import com.iktwo.components 1.0
import "style.js" as Style

Rectangle {
    property bool horizontal: true

    width: horizontal ? parent.width : Math.max(1, 1 * ScreenValues.dpMultiplier)
    height: horizontal ? Math.max(1, 1 * ScreenValues.dpMultiplier) : parent.height

    color: Style.DIVIDER_DARK
}
