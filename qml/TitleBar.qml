import QtQuick 2.1
import QtQuick.Controls 1.1
import Styler 1.0
import "style.js" as Style

Item {
    id: root

    property alias color: container.color
    property alias title: titleLabel.text
    property alias titleFont: titleLabel.font

    objectName: "titleBar"

    width: parent.width
    height: 0.40 * dpi

    anchors.top: parent.top

    Rectangle {
        id: container

        anchors.fill: parent
        color: Styler.darkTheme ? Style.MENU_TITLE_BACKGROUND_COLOR_DARK : Style.MENU_TITLE_BACKGROUND_COLOR_LIGHT

        Label {
            id: titleLabel

            anchors {
                left: parent.left; leftMargin: 15
                verticalCenter: parent.verticalCenter
            }

            font {
//                pointSize: 12
                weight: Font.Light
            }

            color: Styler.darkTheme ? Style.TITLE_TEXT_COLOR_DARK : Style.TITLE_TEXT_COLOR_LIGHT
        }

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            height: 2

            color: Styler.darkTheme ? Style.TITLE_BAR_HIGHLIGHTER_DARK : Style.TITLE_BAR_HIGHLIGHTER_LIGHT
        }
    }
}
