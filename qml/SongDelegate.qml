import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import "style.js" as Style

Item {
    id: root

    signal addToPlaylist()
    signal download()

    height: 64 * dpMultiplier + 1 * dpMultiplier
    width: parent.width

    Label {
        id: songName

        anchors {
            top: parent.top; topMargin: 12 * dpMultiplier
            right: row.left; rightMargin: 8 * dpMultiplier
            left: parent.left; leftMargin: 16 * dpMultiplier
        }

        font {
            pixelSize: 18 * dpMultiplier
            weight: Font.Light
        }

        color: Style.TEXT_COLOR_DARK
        elide: Text.ElideRight
        text: model.name + " - <i>" + model.group + "</i>"
        width: parent.width
        // TODO: add a dialog to show full name in case it's too long ???
    }

    Label {
        anchors {
            bottom: divider.top; bottomMargin:  12 * dpMultiplier
            right: row.left; rightMargin: 8 * dpMultiplier
            left: parent.left; leftMargin: 16 * dpMultiplier
        }

        font {
            pixelSize: 12 * dpMultiplier
            weight: Font.Light
        }

        elide: Text.ElideRight
        color: Style.TEXT_SECONDARY_COLOR_DARK
        text: model.length + " - <i>" + model.comment + "</i>"
        width: parent.width
    }

    BusyIndicator {
        anchors { fill: row; margins: 0.02 * dpi }
        running: model.url === ""
        opacity: 0.2
    }

    RowLayout {
        id: row

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right; rightMargin: 16 * dpMultiplier
        }

        spacing: 0.02 * dpi
        width: spacing + (48 * dpMultiplier * 2)

        TitleBarImageButton {
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            width: 48 * dpMultiplier
            source: "qrc:/images/" + getBestIconSize(Math.min(icon.height, icon.width)) + "add_to_playlist"
            visible: model.url === "" ? false : true

            onClicked: root.addToPlaylist()
        }

        TitleBarImageButton {
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            width: 48 * dpMultiplier

            source: "qrc:/images/" + getBestIconSize(Math.min(icon.height, icon.width)) + "download"
            visible: model.url === "" ? false : true

            onClicked: root.download()
        }
    }

    Divider { id: divider; anchors.bottom: parent.bottom }
}
