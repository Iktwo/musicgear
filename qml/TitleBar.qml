import QtQuick 2.1
import QtQuick.Controls 1.1
import "style.js" as Style

Item {
    id: root

    property alias color: container.color
    property alias title: titleLabel.text
    property alias titleFont: titleLabel.font

    objectName: "titleBar"

    width: parent.width
    height: 0.35 * dpi

    anchors.top: parent.top

    Rectangle {
        id: container

        anchors.fill: parent
        color: Style.MENU_TITLE_BACKGROUND_COLOR

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            height: dpi * 0.01

            color: "#005CB8"
        }

        Label {
            id: titleLabel

            anchors {
                left: parent.left; leftMargin: 15
                verticalCenter: parent.verticalCenter
            }

            font {
                weight: Font.Light
            }

            color: Style.TITLE_TEXT_COLOR
        }
    }
}
