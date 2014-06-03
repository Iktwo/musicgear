import QtQuick 2.1

Item {
    id: root

    property alias source: image.source
    property double pressedOpacity: 0.5

    signal clicked

    height: parent.objectName === "titleBar" ? parent.height : 80
    width: parent.objectName === "titleBar" ? parent.height : 80

    Rectangle {
        id: container

        anchors.fill: parent
        opacity: mouseArea.pressed ? pressedOpacity : 0
    }

    Image {
        id: image

        anchors {
            fill: parent
            margins: root.height * 0.15
        }

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
