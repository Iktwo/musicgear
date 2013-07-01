import QtQuick 2.0

Item {
    id: root

    property string backgroundPressed
    property string background

    signal clicked

    Image {
        anchors.centerIn: parent
        source: mouseArea.pressed && mouseArea.containsMouse ? backgroundPressed : background
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: root.clicked()
    }
}
