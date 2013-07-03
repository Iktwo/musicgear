import QtQuick 2.0
import "style.js" as Style
import Styler 1.0

Item {
    id: root

    default property alias content: container.children
    property bool opened: false

    signal outerClicked

    function open() {
        opened = true;
    }

    function close() {
        opened = false;
    }

    anchors.fill: parent

    state: "closed"

    z: 9999

    onOpenedChanged: {
        if (opened)
            state = "opened"
        else
            state = "closed"
    }

    Rectangle {
        id: dimmer

        anchors.fill: parent

        color: "black"

        Behavior on opacity { NumberAnimation {} }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.opened

        onClicked: root.outerClicked()
    }

    Rectangle {
        id: background

        width: parent.width
        height: parent.height

        color: Styler.darkTheme ? Style.MENU_BACKGROUND_COLOR_DARK : Style.MENU_BACKGROUND_COLOR_LIGHT

        Behavior on opacity { NumberAnimation {} }

        Item {
            id: container

            anchors.fill: parent
        }
    }

    states: [
        State {
            name: "opened"
            PropertyChanges { target: dimmer; opacity: 0.35; }
            PropertyChanges { target: background; opacity: 1 }
        },
        State {
            name: "closed"
            PropertyChanges { target: dimmer; opacity: 0; }
            PropertyChanges { target: background; opacity: 0 }
        }
    ]

    transitions: [
        Transition {
            from: "opened"
            to: "closed"
            ParallelAnimation {
                NumberAnimation { properties: "opacity"; }
                NumberAnimation { properties: "x"; easing.type: Easing.OutQuart }
            }
        },
        Transition {
            from: "closed"
            to: "opened"
            ParallelAnimation {
                NumberAnimation { properties: "opacity"; }
                NumberAnimation { properties: "x"; easing.type: Easing.OutQuart }
            }
        }
    ]
}
