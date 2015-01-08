import QtQuick 2.4
import QtQuick.Controls 1.3
import com.iktwo.components 1.0
import "components" as ThisComponents
import "components/style.js" as Style

Item {
    id: root

    signal requestedPlay()
    signal requestedRemove()
    signal pressAndHold()

    height: 64 * ScreenValues.dp + 1 * ScreenValues.dp
    width: parent.width

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onPressAndHold: root.pressAndHold()
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

        height: parent.height - divider.height
        width: parent.width

        color: index === audio.index ? "#F2F2F2" : "#e5e5e5"

        Label {
            id: songName

            anchors {
                top: parent.top; topMargin: 12 * ScreenValues.dp
                right: removeButton.left; rightMargin: 8 * ScreenValues.dp
                left: parent.left; leftMargin: 8 * ScreenValues.dp
            }

            font {
                pixelSize: 18 * ScreenValues.dp
                family: Theme.fontFamily
            }

            color: Style.TEXT_COLOR_DARK
            elide: Text.ElideRight
            text: model.name
            width: parent.width
            renderType: Text.NativeRendering
            // TODO: add a dialog to show full name in case it's too long ???
        }

        Label {
            anchors {
                bottom: parent.bottom; bottomMargin:  12 * ScreenValues.dp
                right: removeButton.left; rightMargin: 8 * ScreenValues.dp
                left: parent.left; leftMargin: 8 * ScreenValues.dp
            }

            font {
                pixelSize: 12 * ScreenValues.dp
                family: Theme.fontFamily
            }

            elide: Text.ElideRight
            color: Style.TEXT_SECONDARY_COLOR_DARK
            text: model.length
            width: parent.width
            renderType: Text.NativeRendering
        }

        ImageButton {
            id: removeButton

            anchors { right: parent.right; rightMargin: 8 * ScreenValues.dp }

            height: parent.height
            width: 48 * ScreenValues.dp

            source: "qrc:/images/" + Theme.getBestIconSize(Math.min(icon.height, icon.width)) + "remove"

            visible: model.url === "" ? false : true

            onClicked: root.requestedRemove()
        }
    }


    ThisComponents.Divider {
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
