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

        onSeekableChanged: console.log("Seekable", seekable)

        onPlaybackStateChanged: {
            if (playbackState === Audio.StoppedState)
                if (duration != 0)
                    if ((position > duration) || (position == duration) || (1 - (position / duration) <= 0.03 )) {
                        if (index + 1 < playlist.count) {
                            toolBar.song = playlist.get(index).name
                            audio.index = index + 1
                            audio.source = playlist.get(index).url
                            audio.play()
                        } else {
                            index = 0
                        }
                    }
        }
    }

    ListModel {
        id: playlist

        onRowsInserted: {
            // First song, play it!
            if (count === 1 && audio.playbackState == Audio.StoppedState) {
                audio.source = playlist.get(0).url
                toolBar.song = playlist.get(0).name
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

        MouseArea {
            anchors.fill: parent
            onClicked: Styler.darkTheme = !Styler.darkTheme
        }

        TitleBarImageButton {
            anchors.right: parent.right
            source: Styler.darkTheme ? "qrc:/images/search_dark" : "qrc:/images/search_light"
            onClicked: searchDialog.open()
        }

        Behavior on y { NumberAnimation { } }
    }

    ListView {
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
            onPlay: {
                toolBar.song = playlist.get(index).name
                audio.source = model.url
                audio.index = index
                audio.play()
            }

            onRemove: {
                playlist.remove(index)

                if (audio.index === index)
                    audio.stop()
            }
        }

        onFlickStarted: {
            if (contentHeight > height) {
                titleBar.y = -titleBar.height
                hideBarTimer.stop()
                titleBar.hideme = true
            }
        }

        onFlickEnded: hideBarTimer.restart()

        Timer {
            id: hideBarTimer

            interval: 1000

            onTriggered: {
                if (titleBar.hideme) {
                    titleBar.y = 0
                    titleBar.hideme = false
                }
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
}
