import QtQuick 2.1
import QtQuick.Controls 1.1
import "style.js" as Style
import Styler 1.0

Item {
    id: root

    signal requestedPlay()
    signal requestedRemove()

    height: column.height + (0.08 * dpi)
    width: parent.width

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: root.requestedPlay()
    }

    Rectangle {
        height: parent.height
        width: parent.width

        color: "#CECECE"
        opacity: 0.6
    }

    Rectangle {
        id: container

        height: parent.height
        width: parent.width

        color: "#e5e5e5"

        Column {
            id: column

            anchors {
                left: parent.left; leftMargin: 0.08 * dpi
                right: removeButton.left; rightMargin: 10
                verticalCenter: parent.verticalCenter
            }

            spacing: 0.02 * dpi

            Label {
                elide: Text.ElideRight

                font {
                    pointSize: 17
                    weight: Font.Light
                }

                color: Style.TEXT_COLOR_DARK
                text: model.name + " - <i>" + model.group + "</i>"
                width: parent.width
            }

            Label {
                color: Style.TEXT_SECONDARY_COLOR_DARK
                elide: Text.ElideRight

                font {
                    pointSize: 14
                    weight: Font.Light
                }

                text: model.length + " - <i>" + model.comment + "</i>"
                width: parent.width
            }
        }

        TitleBarImageButton {
            id: removeButton

            anchors {
                right: parent.right; rightMargin: 0.02 * dpi
            }

            height: parent.height
            width: 0.35 * dpi

            iconMargins: height * 0.29

            source: "qrc:/images/remove_light"

            visible: model.url === "" ? false : true

            onClicked: root.requestedRemove()
        }

    }


    Divider {
        id: divider

        anchors.bottom: parent.bottom
    }

    //    ListView.onRemove: Transition {
    //        ParallelAnimation {
    //            NumberAnimation { property: "opacity"; to: 0; duration: 5000 }
    //            NumberAnimation { properties: "x"; to: -300; duration: 5000 }
    //        }
    //    }

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: root; property: "ListView.delayRemove"; value: true }

        ParallelAnimation {
            NumberAnimation { target: container; property: "x"; to: -root.width; duration: 450; easing.type: Easing.InOutQuad }
            NumberAnimation { target: container; property: "opacity"; to: 0.35; duration: 350; easing.type: Easing.InOutQuad }
        }

        PropertyAction { target: root; property: "ListView.delayRemove"; value: false }
    }
}
