import QtQuick 2.0
import QtMultimedia 5.0
import "style.js" as Style
import Styler 1.0

Rectangle {
    anchors.fill: parent

    color: Styler.darkTheme ? Style.MENU_BACKGROUND_COLOR_DARK : Style.MENU_BACKGROUND_COLOR_LIGHT

    Audio {
        id: audio

        property int index: 0

        //        onPositionChanged: {
        //            if (position & duration)
        //                if (Math.abs((position - duration) / 1000) < 5 && index + 1 < playlist.count) {
        //                    console.log("La que sigue!")
        //                    audio.index = index + 1
        //                    toolBar.song = playlist.get(index).name + " - <i>" + playlist.get(index).group + "</i>"
        //                    audio.source = playlist.get(index).url
        //                    audio.play()
        //                }
        //        }

        onPlaybackStateChanged: {
            // console.log("Audio.StoppedState, ", playbackState === Audio.StoppedState)
            if (playbackState === Audio.StoppedState)
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

    Menu {
        id: menu

        MenuTextItem {
            text: Styler.darkTheme ? qsTr("Light theme") : qsTr("Dark theme")
            onClicked: Styler.darkTheme = !Styler.darkTheme
        }

        MenuTextItem {
            text: qsTr("About MusicGear")
            onClicked: aboutDialog.open()
        }
    }

    Dialog { // TODO: write a nice dialog, create InformationDialog component
        id: aboutDialog

        onOuterClicked: close()

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

        property bool hideme: false

        title: "MusicGear"

        TitleBarImageButton {
            anchors.right: searchButton.left

            source: Styler.darkTheme ? "qrc:/images/settings_dark" : "qrc:/images/settings_light"
            onClicked: menu.open()
        }

        TitleBarImageButton {
            id: searchButton

            anchors.right: parent.right

            source: Styler.darkTheme ? "qrc:/images/search_dark" : "qrc:/images/search_light"
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
        focus: true

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

    ToolBar {
        id: toolBar

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        audio: audio
    }

    Component.onCompleted: searchDialog.open()
    //Component.onCompleted: playlist.append({"name" : "First Song", "group" : "First Group", "length" : "3:31", "comment" : "this is a test", "code" : "XASDDASD", "url": "invalid"})
}
