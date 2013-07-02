import QtQuick 1.0
import "style.js" as Style

Text {
    color: Styler.darkTheme ? Style.TEXT_COLOR_DARK : Style.TEXT_COLOR_LIGHT
}
