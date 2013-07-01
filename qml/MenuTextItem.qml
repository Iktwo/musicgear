import QtQuick 2.0
import "." 1.0
import "style.js" as Style

Item {
    id: root

    property alias text: label.text
    property bool autoCloseMenu: true

    signal clicked

    width: parent.width
    height: 80

    Rectangle {
        anchors.fill: parent

        color: Styler.darkTheme ? Style.MENU_ITEM_HIGHLIGHT_DARK : Style.MENU_ITEM_HIGHLIGHT_LIGHT

        opacity: mouseArea.pressed && mouseArea.containsMouse ? 0.55 : 0

        Behavior on opacity { NumberAnimation {} }
    }

    Label {
        id: label

        verticalAlignment: Text.AlignVCenter

        anchors {
            fill: parent
            leftMargin: 20
            rightMargin: 20
        }

        font.pointSize: 16
        elide: Text.ElideRight
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: {
            root.clicked()

            if (root.parent.objectName == "menu" && root.autoCloseMenu) {
                root.parent.close()
            }
        }
    }
}
