import QtQuick 2.0
import "style.js" as Style
import Styler 1.0

Text {
    color: Styler.darkTheme ? Style.TEXT_COLOR_DARK : Style.TEXT_COLOR_LIGHT
}
