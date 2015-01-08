import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtMultimedia 5.2
import com.iktwo.components 1.0

Page {
    id: root

    property Audio audioElement: audio
    property var shareModel

    focus: true

    onActivated: Qt.inputMethod.hide()

    titleBar: TitleBar {
        id: titleBar

        title: "Musicgear"

        ImageButton {
            anchors.right: searchButton.left
            source: "qrc:/images/" + Theme.getBestIconSize(Math.min(icon.height, icon.width)) + "help"

            onClicked: stackView.push(aboutPage)
        }

        ImageButton {
            id: searchButton

            anchors.right: parent.right
            source: "qrc:/images/" + Theme.getBestIconSize(Math.min(icon.height, icon.width)) + "search"

            onClicked: stackView.push(searchPage)
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
                    enabled: shareModel !== undefined && shareModel.code !== ""
                    onTriggered: musicStreamer.share(shareModel.name, "http://www.goear.com/listen/" + shareModel.code)
                }
            }

            anchors.fill: parent

            model: playlist
            clip: true

            delegate: PlaylistDelegate {
                onPressAndHold: {
                    if (Qt.platform.os === "android") {
                        root.shareModel = model
                        menu.popup()
                    } else {
                        console.log("Menu only implemented for Android")
                    }
                }

                onRequestedPlay: {
                    if (playlist.count >= index) {
                        playbackControls.song = playlist.get(index).name + " - <i>" + playlist.get(index).artist + "</i>"
                        audioElement.source = model.url
                        audioElement.index = index
                        audioElement.play()
                    }
                }

                onRequestedRemove: {
                    if (index < audioElement.index) {
                        audioElement.index = audioElement.index - 1
                    } else if (audioElement.index === index) {
                        audioElement.stop()

                        if (index < playlist.count - 1) {
                            /// Will copy next item data, no need to change index
                            playbackControls.song = playlist.get(index + 1).name + " - <i>" + playlist.get(index + 1).artist + "</i>"
                            audioElement.source = playlist.get(index + 1).url
                            audioElement.play()
                        } else if (index - 1 >= 0) {
                            /// Will copy previous item data, update index to -1
                            playbackControls.song = playlist.get(index - 1).name + " - <i>" + playlist.get(index - 1).artist + "</i>"
                            audioElement.source = playlist.get(index - 1).url
                            audioElement.index = audioElement.index - 1
                            audioElement.play()
                        }
                    }

                    playlist.remove(index)
                }
            }

            Timer {
                running: true
                interval: 100
                onTriggered: stackView.push(searchPage)
            }
        }
    }

    Label {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 8 * ScreenValues.dp
        }

        text: qsTr("You have no music on the playlist")
        visible: songList.count === 0

        color: Theme.mainTextColor

        font {
            pixelSize: 28 * ScreenValues.dp
            family: Theme.fontFamily
        }

        horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"

        wrapMode: "Wrap"
        elide: "ElideRight"
    }
}
