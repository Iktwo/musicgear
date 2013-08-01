import QtQuick 2.0
import Styler 1.0
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

        color: Styler.darkTheme ? Style.MENU_ITEM_HIGHLIGHT_DARK
                                : Style.MENU_ITEM_HIGHLIGHT_LIGHT

        opacity: mouseArea.pressed && mouseArea.containsMouse ? 0.55 : 0

        Behavior on opacity { NumberAnimation {} }
    }

    Label {
        id: label

        anchors {
            fill: parent
            leftMargin: 20
            rightMargin: 20
        }
        elide: Text.ElideRight

        font {
            weight: Font.Light
            pointSize: 11
        }

        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: {
            root.clicked()

            if (root.parent.objectName == "menu" && root.autoCloseMenu)
                root.parent.close()
        }
    }
}
