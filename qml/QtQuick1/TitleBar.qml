import QtQuick 1.1
import "style.js" as Style

Item {
    id: root

    property alias title: titleLabel.text
    property alias color: container.color

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

            font.pixelSize: 35
        }
    }
}
