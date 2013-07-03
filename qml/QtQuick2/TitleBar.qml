import QtQuick 2.0
import Styler 1.0
import "style.js" as Style

Item {
    id: root

    property alias color: container.color
    property alias title: titleLabel.text
    property alias titleFont: titleLabel.font

    objectName: "titleBar"

    width: parent.width
    height: Style.TITLE_BAR_HEIGHT

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
                pointSize: 12
                weight: Font.Light
            }
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
