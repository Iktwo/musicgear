import QtQuick 2.2

Item {
    id: root

    property alias source: image.source
    property alias icon: image
    property double pressedOpacity: 0.5

    signal clicked

    height: parent.objectName === "titleBar" ? parent.height : 48 * uiValues.dpMultiplier
    width: parent.objectName === "titleBar" ? parent.height : 48 * uiValues.dpMultiplier

    Rectangle {
        id: container

        anchors.fill: parent
        opacity: mouseArea.pressed && mouseArea.containsMouse ? pressedOpacity : 0
    }

    Image {
        id: image

        anchors.centerIn: parent

        height: 32 * uiValues.dpMultiplier
        width: 32 * uiValues.dpMultiplier

        fillMode: Image.PreserveAspectFit
        antialiasing: true
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        enabled: parent.enabled

        onClicked: root.clicked()
    }
}
