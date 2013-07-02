import QtQuick 1.1

Rectangle {
    id: button

    signal clicked

    property alias text: txt.text

    width: 100
    height: 100

    Text {
        id: txt

        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            button.clicked()
        }
    }
}
