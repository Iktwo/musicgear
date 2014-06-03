import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import Styler 1.0
import "style.js" as Style

Item {
    id: root

    signal addToPlaylist()
    signal download()

    height: column.height + (0.08 * dpi)
    width: parent.width

    Column {
        id: column

        anchors {
            left: parent.left; leftMargin: 10
            right: row.left; rightMargin: 10
            //            top: parent.top
            verticalCenter: parent.verticalCenter
        }

        spacing: 0.02 * dpi

        Label {
            font {
                pointSize: 17
                weight: Font.Light
            }

            color: Styler.darkTheme ? Style.TITLE_TEXT_COLOR_DARK : Style.TITLE_TEXT_COLOR_LIGHT
            elide: Text.ElideRight
            text: model.name + " - <i>" + model.group + "</i>"
            width: parent.width
            // TODO: add a dialog to show full name in case it's too long
        }

        Label {
            font {
                pointSize: 14
                weight: Font.Light
            }

            elide: Text.ElideRight
            color: Styler.darkTheme ? Style.TEXT_SECONDARY_COLOR_DARK : Style.TEXT_SECONDARY_COLOR_LIGHT
            text: model.length + " - <i>" + model.comment + "</i>"
            width: parent.width
        }
    }

    RowLayout {
        id: row

        anchors {
            //            top: column.top; topMargin: 10
            //            bottom: column.bottom; bottomMargin: 10
            top: parent.top
            bottom: parent.bottom
            right: parent.right; rightMargin: 15
        }

        spacing: 0.02 * dpi

        TitleBarImageButton {
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            width: 0.35 * dpi
            source: Styler.darkTheme ? "qrc:/images/add_playlist_dark" : "qrc:/images/add_playlist_light"
            //            background: Styler.darkTheme ? "qrc:/images/add_playlist_dark" : "qrc:/images/add_playlist_light"
            //            backgroundPressed: Styler.darkTheme ? "qrc:/images/add_playlist_dark_pressed" : "qrc:/images/add_playlist_light_pressed"

            visible: model.url === "" ? false : true

            onClicked: root.addToPlaylist()
        }

        TitleBarImageButton {
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            width: 0.35 * dpi

            source: Styler.darkTheme ? "qrc:/images/download_dark" : "qrc:/images/download_light"
            //            background: Styler.darkTheme ? "qrc:/images/download_dark" : "qrc:/images/download_light"
            //            backgroundPressed: Styler.darkTheme ? "qrc:/images/download_dark_pressed" : "qrc:/images/download_light_pressed"

            visible: model.url === "" ? false : true

            onClicked: root.download()
        }
    }

    Divider { anchors.bottom: parent.bottom }
}
