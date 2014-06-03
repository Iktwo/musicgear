import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.0
import "style.js" as Style
import Styler 1.0

Rectangle {
    property variant audioElement: audio

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

    Audio {
        id: audio

        property int index: 0

        onErrorStringChanged: console.log("ERROR STRING: ", errorString)

        onPlaybackStateChanged: {
            // console.log("Audio.StoppedState, ", playbackState === Audio.StoppedState)
            if (playbackState === Audio.StoppedState) {
                if (duration != 0)
                    if ((position > duration) || (position == duration) || (1 - (position / duration) <= 0.03 )) {
                        if (index + 1 < playlist.count) {
                            audio.index = index + 1
                            toolBar.song = playlist.get(index).name + " - <i>" + playlist.get(index).group + "</i>"
                            audio.source = playlist.get(index).url
                            audio.play()
                        } else {
                            index = 0
                        }
                    }
            }
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

    ListModel {
        id: playlist

        onRowsInserted: {
            // If new item is first on list, play it
            if (count === 1) {
                toolBar.song = playlist.get(0).name + " - <i>" + playlist.get(0).group + "</i>"
                audio.source = playlist.get(0).url
                audio.play()
            }
        }
    }

    SearchDialog {
        id: searchDialog
    }

    TitleBar {
        id: titleBar

        title: "MusicGear"

        TitleBarImageButton {
            anchors.right: searchButton.left

            source: Styler.darkTheme ? "qrc:/images/settings_dark"
                                     : "qrc:/images/settings_light"

            onClicked: mainMenu.open()
        }

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
            bottom: toolBar.top
        }

        model: playlist
        clip: true

        delegate: PlaylistDelegate {
            onRequestedPlay: {
                toolBar.song = playlist.get(index).name + " - <i>" + playlist.get(index).group + "</i>"
                audio.source = model.url
                audio.index = index
                audio.play()
            }

            onRequestedRemove: {
                playlist.remove(index)

                if (audio.index === index)
                    audio.stop()
            }
        }
    }

    PlaybackControls {
        id: toolBar

        anchors.bottom: parent.bottom
        audio: audio
    }

    Component.onCompleted: searchDialog.open()
    //Component.onCompleted: playlist.append({"name" : "First Song",
    //"group" : "First Group", "length" : "3:31", "comment" : "this is a test",
    //"code" : "XASDDASD", "url": "invalid"})
}
