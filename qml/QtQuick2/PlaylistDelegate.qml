import QtQuick 2.0
import "style.js" as Style
import Styler 1.0

Item {
    id: root

    signal play()
    signal remove()

    height: column.height + divider.height + 20
    width: parent.width

    Column {
        id: column

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left; leftMargin: 10
            right: row.left; rightMargin: 10
        }

        Label {
            elide: Text.ElideRight

            font {
                pointSize: 9
                weight: Font.Light
            }

            text: model.name + " - <i>" + model.group + "</i>"

            width: parent.width
        }

        Label {
            color: Styler.darkTheme ? Style.SECONDARY_TEXT_COLOR_DARK : Style.SECONDARY_TEXT_COLOR_LIGHT
            elide: Text.ElideRight

            font {
                pointSize: 8
                weight: Font.Light
            }

            text: model.length + " - <i>" + model.comment + "</i>"
            width: parent.width
        }

        Item { // Spacer
            height: 20
            width: 1
        }
    }

    Divider {
        id: divider

        anchors.top: column.bottom
    }

    Row {
        id: row

        anchors {
            right: parent.right; rightMargin: 15
        }

        height: column.height
        spacing: 15

        ImageButton {
            height: parent.height
            width: 92

            background: Styler.darkTheme ? "qrc:/images/play_dark" : "qrc:/images/play_light"
            backgroundPressed: Styler.darkTheme ? "qrc:/images/play_dark_pressed" : "qrc:/images/play_light_pressed"

            visible: model.url === "" ? false : true

            onClicked: root.play()
        }

        ImageButton {
            height: parent.height
            width: 92

            background: Styler.darkTheme ? "qrc:/images/remove_dark" : "qrc:/images/remove_light"
            backgroundPressed: Styler.darkTheme ? "qrc:/images/remove_dark_pressed" : "qrc:/images/remove_light_pressed"

            visible: model.url === "" ? false : true

            onClicked: root.remove()
        }
    }
}
