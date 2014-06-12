import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.1
import "style.js" as Style
import Styler 1.0

Rectangle {
    property Audio audioElement: audio

    anchors.fill: parent

    color: Styler.darkTheme ? Style.MENU_BACKGROUND_COLOR_DARK
                            : Style.MENU_BACKGROUND_COLOR_LIGHT

    focus: true

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            if (searchDialog.opened)
                searchDialog.close()

            event.accepted = true
        }
    }

    Dialog { // TODO: write a nice dialog, create InformationDialog component?
        id: aboutDialog

        onOuterClicked: close()

        Label {
            anchors.centerIn: parent

            text: "TODO: write a nice dialog"
            color: Styler.darkTheme ? Style.TITLE_TEXT_COLOR_DARK : Style.TITLE_TEXT_COLOR_LIGHT
        }

        //        Flickable {
        //            anchors.fill: parent

        //            contentHeight: column.height

        //            enabled: parent.enabled ? (parent.opened ? true : false) : false

        //            Column {
        //                id: column

        //                anchors {
        //                    top: parent.top; topMargin: 25
        //                    left: parent.left
        //                    right: parent.right
        //                }

        //                /*Item {
        //                    height: authorImage.height
        //                    width: parent.width
        //                }*/

        //                Image {
        //                    id: authorImage

        //                    anchors {
        //                        horizontalCenter: parent.horizontalCenter
        //                    }

        //                    source: "qrc:/images/logo"
        //                }

        //                Label {
        //                    anchors.horizontalCenter: parent.horizontalCenter
        //                    text: "Music Gear v1.0 by Iktwo Sh"
        //                }
        //            }
        //        }
    }

    SearchDialog { id: searchDialog }

    TitleBar {
        id: titleBar

        title: "MusicGear"

        TitleBarImageButton {
            id: searchButton

            anchors.right: parent.right

            source: Styler.darkTheme ? "qrc:/images/search_dark"
                                     : "qrc:/images/search_light"
            onClicked: searchDialog.open()
        }
    }

    ListView {
        id: songList

        anchors {
            top: titleBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        model: playlist
        clip: true

        delegate: PlaylistDelegate {
            onRequestedPlay: {
                playbackControls.song = playlist.get(index).name + " - <i>" + playlist.get(index).group + "</i>"
                audioElement.source = model.url
                audioElement.index = index
                audioElement.play()
            }

            onRequestedRemove: {
                playlist.remove(index)

                if (audioElement.index === index)
                    audioElement.stop()
            }
        }
    }

    Component.onCompleted: searchDialog.open()

    //Component.onCompleted: playlist.append({"name" : "First Song",
    //"group" : "First Group", "length" : "3:31", "comment" : "this is a test",
    //"code" : "XASDDASD", "url": "invalid"})
}
