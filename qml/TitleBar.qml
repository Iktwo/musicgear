import QtQuick 2.1
import QtQuick.Controls 1.1
import "style.js" as Style

Item {
    id: root

    property alias color: container.color
    property alias title: titleLabel.text
    property alias titleColor: titleLabel.color

    objectName: "titleBar"

    width: parent.width
    height: Math.ceil(dpMultiplier * (musicStreamer.isTablet ? 56 : (isScreenPortrait ? 48 : 40)))

    anchors.top: parent.top

    Rectangle {
        id: container

        anchors.fill: parent
        color: Style.MENU_TITLE_BACKGROUND_COLOR

        Label {
            id: titleLabel

            anchors {
                left: parent.left; leftMargin: 8 * dpMultiplier
                verticalCenter: parent.verticalCenter
            }

            font {
                pixelSize: 18 * dpMultiplier
                weight: Font.Light
            }

            color: Style.TITLE_TEXT_COLOR
        }
    }
}
