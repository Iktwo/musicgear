import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.2
import "style.js" as Style

Rectangle {
    property Audio audioElement: audio

    anchors.fill: parent
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
            source: "qrc:/images/help"

            onClicked: aboutDialog.open()
        }

        TitleBarImageButton {
            id: searchButton

            anchors.right: parent.right
            source: "qrc:/images/search"

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

        ListView {
            id: songList

            anchors.fill: parent

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
    }

    Component.onCompleted: searchDialog.open()

    //Component.onCompleted: playlist.append({"name" : "First Song",
    //"group" : "First Group", "length" : "3:31", "comment" : "this is a test",
    //"code" : "XASDDASD", "url": "invalid"})
}
