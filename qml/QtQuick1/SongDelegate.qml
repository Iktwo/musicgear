import QtQuick 1.1
import "style.js" as Style

Item {
    id: root

    signal addToPlaylist()
    signal download()

    height: column.height
    width: parent.width

    Column {
        id: column

        anchors {
            left: parent.left; leftMargin: 10
            right: row.left; rightMargin: 10
        }

        // Spacer
        Item {
            height: 30
            width: 1
        }

        Label {
            font {
                pointSize: 12
                weight: Font.Light
            }

            elide: Text.ElideRight
            text: model.name + " - <i>" + model.group + "</i>"
            width: parent.width
            // TODO: add a dialog to show full name in case it's too long
        }

        // Spacer
        Item {
            height: 10
            width: 1
        }

        Label {
            font {
                pointSize: 12
                weight: Font.Light
            }

            elide: Text.ElideRight
            color: Styler.darkTheme ? Style.TEXT_SECONDARY_COLOR_DARK : Style.TEXT_SECONDARY_COLOR_LIGHT
            text: model.length + " - <i>" + model.comment + "</i>"
            width: parent.width
        }

        // Spacer
        Item {
            height: 30
            width: 1
        }
    }

    Row {
        id: row

        anchors {
            top: column.top; topMargin: 10
            bottom: column.bottom; bottomMargin: 10
            right: parent.right; rightMargin: 15
        }

        spacing: 15

        ImageButton {
            height: parent.height
            width: 92

            background: Styler.darkTheme ? "qrc:/images/add_playlist_dark" : "qrc:/images/add_playlist_light"
            backgroundPressed: Styler.darkTheme ? "qrc:/images/add_playlist_dark_pressed" : "qrc:/images/add_playlist_light_pressed"

            visible: model.url === "" ? false : true

            onClicked: root.addToPlaylist()
        }

        ImageButton {
            height: parent.height
            width: 92

            background: Styler.darkTheme ? "qrc:/images/download_dark" : "qrc:/images/download_light"
            backgroundPressed: Styler.darkTheme ? "qrc:/images/download_dark_pressed" : "qrc:/images/download_light_pressed"

            visible: model.url === "" ? false : true

            onClicked: root.download()
        }
    }

    Divider { anchors.top: column.bottom }
}
