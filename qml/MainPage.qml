import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.2
import com.iktwo.components 1.0

Page {
    id: root

    property Audio audioElement: audio
    property var shareModel

    focus: true

    titleBar: TitleBar {
        id: titleBar

        title: "MusicGear"

        ImageButton {
            anchors.right: searchButton.left
            source: "qrc:/images/" + ui.getBestIconSize(Math.min(icon.height, icon.width)) + "help"

            onClicked: stackview.push(aboutPage)
        }

        ImageButton {
            id: searchButton

            anchors.right: parent.right
            source: "qrc:/images/" + ui.getBestIconSize(Math.min(icon.height, icon.width)) + "search"

            onClicked: stackview.push(searchPage)
        }
    }

    ScrollView {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        flickableItem.interactive: true; focus: true

        ListView {
            id: songList

            Menu {
                id: menu
                title: qsTr("Menu")

                MenuItem {
                    text: qsTr("Share")
                    enabled: shareModel === undefined ? false : (shareModel.code !== "")
                    onTriggered: musicStreamer.share(shareModel.name, "http://www.goear.com/listen/" + shareModel.code)
                }
            }

            anchors.fill: parent

            model: playlist
            clip: true

            delegate: PlaylistDelegate {
                onPressAndHold: {
                    if (Q_OS === "ANDROID") {
                        root.shareModel = model
                        menu.popup()
                    }
                }

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

            Timer {
                running: true
                interval: 100
                onTriggered: stackview.push(searchPage)
            }
        }
    }

    //Component.onCompleted: playlist.append({"name" : "First Song",
    //"group" : "First Group", "length" : "3:31", "comment" : "this is a test",
    //"code" : "XASDDASD", "url": "invalid"})
}
