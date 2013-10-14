import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Page {
    id: listenPage

    ListView {
        id: playlistList

        anchors {
            top: parent.top
            bottom: playbackControls.top
            left: parent.left
            right: parent.right
        }

        clip: true

        model: playlist

        delegate:  PlaylistDelegate {
            onRequestedRemove: {
                playlist.remove(index)
                //if (audio.index === index)
                //audio.stop()
            }

            onRequestedPlay: {
                audio.source = model.url
                console.log("Trying to play: ", model.url)
                audio.play()
            }

            onRequestedDownload: musicStreamer.downloadSong(model.name, model.url)
        }
    }

    PlaybackControls {
        id: playbackControls

        anchors {
            bottom: parent.bottom; bottomMargin: 72
        }
    }

    ScrollDecorator {
        flickableItem: playlistList
    }

    Rectangle {
        anchors {
            top: parent.top
            bottom: parent.bottom; bottomMargin: 72
            left: parent.left
            right: parent.right
        }

        visible: musicStreamer.downloading
        color: "black"

        MouseArea {
            anchors.fill: parent

            enabled: parent.visible
        }

        Label {
            id: progressLabel

            anchors.centerIn: parent

            property double progress: 0
            property string name: ""

            text: qsTr("Downloading") + "\n" + (name.length > 20 ? name.substring(0, 20) + "..." : name) + "\n" + Math.floor(progress * 100) + "%"

            style: LabelStyle {
                fontPixelSize: 48
            }

            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
        }

        Connections {
            target: musicStreamer

            onProgressChanged: {
                progressLabel.progress = progress
                progressLabel.name = name
            }

            onServerError: {
                messageBanner.text = "Server error"
                messageBanner.show()
            }
        }
    }
}
