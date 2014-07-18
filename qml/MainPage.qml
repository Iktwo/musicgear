import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.2
import "style.js" as Style

Rectangle {
    property Audio audioElement: audio

    color: "#e5e5e5"
    focus: true

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            if (searchDialog.opened)
                searchDialog.close()

            event.accepted = true
        }
    }

    SearchDialog { id: searchDialog }

    AboutDialog { id: aboutDialog }

    TitleBar {
        id: titleBar

        title: "MusicGear"

        TitleBarImageButton {
            anchors.right: searchButton.left
            source: "qrc:/images/" + getBestIconSize(Math.min(icon.height, icon.width)) + "help"

            onClicked: stackview.push(aboutDialog)
        }

        TitleBarImageButton {
            id: searchButton

            anchors.right: parent.right
            source: "qrc:/images/" + getBestIconSize(Math.min(icon.height, icon.width)) + "search"

            onClicked: searchDialog.open()
        }
    }

    ScrollView {
        anchors {
            top: titleBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        flickableItem.interactive: true; focus: true

        ListView {
            id: songList

            anchors.fill: parent

            model: playlist
            clip: true

            delegate: PlaylistDelegate {
                onRequestedPlay: {
                    if (playlist.count >= index) {
                        playbackControls.song = playlist.get(index).name + " - <i>" + playlist.get(index).group + "</i>"
                        audioElement.source = model.url
                        audioElement.index = index
                        audioElement.play()
                    }
                }

                onRequestedRemove: {
                    console.log("REQUEST REMOVE:", index)
                    if (index < audioElement.index) {
                        audioElement.index = audioElement.index - 1
                        if (audioElement.index >= 0) {
                            playbackControls.song = playlist.get(audioElement.index).name + " - <i>" + playlist.get(audioElement.index).group + "</i>"
                            audioElement.source = playlist.get(audioElement.index).url
                            audioElement.play()
                        }
                    } else if (audioElement.index === index) {
                        audioElement.stop()
                        if (playlist.count >= index - 1 && playlist.count - 1 > 0) {
                            playbackControls.song = playlist.get(index + 1).name + " - <i>" + playlist.get(index + 1).group + "</i>"
                            audioElement.source = playlist.get(index + 1).url
                            audioElement.play()
                        }
                    }

                    playlist.remove(index)
                }
            }
        }
    }

    Component.onCompleted: searchDialog.open()

    //Component.onCompleted: playlist.append({"name" : "First Song",
    //"group" : "First Group", "length" : "3:31", "comment" : "this is a test",
    //"code" : "XASDDASD", "url": "invalid"})
}
