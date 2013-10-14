import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Item {
    id: root

    signal requestedPlay()
    signal requestedRemove()
    signal requestedDownload()

    height: 80
    width: parent.width

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: root.requestedPlay()
    }

    Rectangle {
        height: parent.height
        width: parent.width

        color: Qt.darker(container.color)
        opacity: 0.6
    }

    Rectangle {
        id: container

        height: parent.height
        width: parent.width

        color: mouseArea.pressed ? "#575757" : "#000000"

        Label {
            anchors {
                left: parent.left; leftMargin: 10
                right: removeButton.left; rightMargin: 10
            }

            elide: Text.ElideRight

            font {
                pointSize: 9
                weight: Font.Light
            }

            text: model.name + " - " + model.group

            height: parent.height / 2
            clip: true
        }

        Label {
            anchors {
                left: parent.left; leftMargin: 10
                right: removeButton.left; rightMargin: 10
                bottom: parent.bottom
            }

            color: "#d1d1d1"
            elide: Text.ElideRight

            font {
                pointSize: 8
                weight: Font.Light
            }

            text: model.length + " - " + model.comment
            height: parent.height / 2
            clip: true
        }

        Button {
            id: removeButton

            anchors {
                right: downloadButton.left; rightMargin: 10
                verticalCenter: parent.verticalCenter
            }

            iconSource: "qrc:/images/remove"
            width: 80

            onClicked: root.requestedRemove()
            visible: model.url !== ""
        }

        Button {
            id: downloadButton

            anchors {
                right: parent.right; rightMargin: 5
                verticalCenter: parent.verticalCenter
            }

            iconSource: "qrc:/images/download"
            width: 80

            onClicked: root.requestedDownload()
            visible: model.url !== ""
        }
    }


    Rectangle {
        anchors.bottom: parent.bottom

        width: parent.width
        height: 2

        color: "#515151"
    }

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: root; property: "ListView.delayRemove"; value: true }

        ParallelAnimation {
            NumberAnimation { target: container; property: "x"; to: -root.width; duration: 450; easing.type: Easing.InOutQuad }
            NumberAnimation { target: container; property: "opacity"; to: 0.35; duration: 350; easing.type: Easing.InOutQuad }
        }

        PropertyAction { target: root; property: "ListView.delayRemove"; value: false }
    }
}
