import QtQuick 2.1
import QtQuick.Controls 1.1
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

    z: 9999

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

        width: parent.width * 0.75
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

            height: 0.40 * dpi
            color: Styler.darkTheme ? Style.MENU_TITLE_BACKGROUND_COLOR_DARK : Style.MENU_TITLE_BACKGROUND_COLOR_LIGHT

            Label {
                id: menuTitle

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left; leftMargin: 10
                    right: parent.right; rightMargin: 10
                }

                color: Styler.darkTheme ? Style.TEXT_COLOR_DARK : Style.TEXT_COLOR_LIGHT

                text: qsTr("Menu")

                elide: Text.ElideRight

                font {
                    weight: Font.Light
                    pointSize: 17
                }
            }

            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                height: 2

                color: Styler.darkTheme ? Style.TITLE_BAR_HIGHLIGHTER_DARK : Style.TITLE_BAR_HIGHLIGHTER_LIGHT
            }
        }

        Flickable {
            anchors {
                top: titleContainer.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            clip: true
            contentHeight: column.height

            interactive: contentHeight > height

            Column {
                id: column

                signal close()

                objectName: "menu"

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
            when: root.opened
            name: "opened"
            PropertyChanges { target: background; x: leftToRight ? 0 : root.width - background.width; }
            PropertyChanges { target: dimmer; opacity: 0.35; }
            PropertyChanges { target: background; opacity: 1 }
        },
        State {
            when: !root.opened
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
