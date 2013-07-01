import QtQuick 2.0
import "style.js" as Style
import Styler 1.0

Item {
    id: root

    default property alias content: column.children
    property bool opened: false
    property bool leftToRight: true
    property bool generateDivider: true
    property alias menuWidth: background.width
    property alias title: menuTitle.text

    function open() {
        opened = true;
    }

    function close() {
        opened = false;
    }

    anchors.fill: parent

    state: "closed"

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

        onClicked: root.close();
    }

    Rectangle {
        id: background

        width: Math.min(480, parent.width - 80)
        height: parent.height
        color: Styler.darkTheme ? Style.MENU_BACKGROUND_COLOR_DARK : Style.MENU_BACKGROUND_COLOR_LIGHT

        Behavior on opacity { NumberAnimation {} }

        MouseArea { // MouseEater
            anchors.fill: parent
        }

        Rectangle {
            id: titleContainer

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            height: menuTitle.height + 20

            color: Styler.darkTheme ? Style.MENU_TITLE_BACKGROUND_COLOR_DARK : Style.MENU_TITLE_BACKGROUND_COLOR_LIGHT

            Label {
                id: menuTitle

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left; leftMargin: 10
                    right: parent.right; rightMargin: 10
                }

                text: "Menu"

                elide: Text.ElideRight
                font {
                    weight: Font.Light
                    pointSize: 18
                }
            }
        }

        Flickable {
            anchors {
                top: titleContainer.bottom; topMargin: 5
                left: parent.left
                right: parent.right
                bottom: parent.bottom; bottomMargin: 5
            }

            clip: true
            contentHeight: column.height

            interactive: contentHeight > height

            Column {
                id: column

                signal close()

                objectName: "menu"

                spacing: 5
                width: parent.width

                onClose: root.close()

                onChildrenChanged: {
                    var i = children.length;
                    if (root.generateDivider && children[i-1].objectName !== "divider")
                        Qt.createQmlObject(" \
                            import QtQuick 2.0; \
                            import \"style.js\" as Style; \
                            import Styler 1.0; \
                            \
                            Rectangle { \
                                objectName: \"divider\"; \
                                color: Styler.darkTheme ? \"#515151\" : \"#d8d8d8\"; \
                                width: parent.width; \
                                height: 1 \
                            }", column);
                }
            }
        }
    }

    Component {
        id: divider

        Rectangle {
            height: 2
            width: parent.width
            color: "red"
        }
    }

    states: [
        State {
            name: "opened"
            PropertyChanges { target: background; x: leftToRight ? 0 : root.width - background.width; }
            PropertyChanges { target: dimmer; opacity: 0.35; }
            PropertyChanges { target: background; opacity: 1 }
        },
        State {
            name: "closed"
            PropertyChanges { target: background; x: leftToRight ? -background.width : root.width + background.width; }
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
