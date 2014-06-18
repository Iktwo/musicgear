import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Window 2.1
import QtMultimedia 5.1
import "."

ApplicationWindow {
    id: applicationWindow

    property int dpi: Screen.pixelDensity * 25.4

    function next() {
        if (audio.index + 1 < playlist.count)
            audio.index = audio.index + 1
        else
            audio.index = 0

        playbackControls.song = playlist.get(audio.index).name + " - <i>" + playlist.get(audio.index).group + "</i>"
        audio.source = playlist.get(audio.index).url
        audio.play()
    }

    function previous() {
        if (audio.index - 1 >= 0)
            audio.index = audio.index - 1
        else
            audio.index = playlist.count - 1

        playbackControls.song = playlist.get(audio.index).name + " - <i>" + playlist.get(audio.index).group + "</i>"
        audio.source = playlist.get(audio.index).url
        audio.play()
    }

    height: 720
    width: 720
    visible: true

    StackView {
        id: stackview

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: playbackControls.top
        }

        initialItem: mainPage
    }

    Component {
        id: mainPage
        MainPage { audioElement: audio }
    }

    ListModel {
        id: playlist

        onRowsInserted: {
            // If new item is first on list, play it
            if (count === 1) {
                playbackControls.song = playlist.get(0).name + " - <i>" + playlist.get(0).group + "</i>"
                audio.source = playlist.get(0).url
                audio.play()
            }
        }

        onCountChanged: {
            if (count == 0)
                playbackControls.anchors.bottomMargin = -playbackControls.height
            else
                playbackControls.anchors.bottomMargin = 0
        }
    }

    Audio {
        id: audio

        property int index: 0

        autoLoad: true

        onBufferProgressChanged: console.log("BUFFER PROGRESS:", bufferProgress)

        onStatusChanged: {
            switch(status) {
            case Audio.NoMedia:
                console.log("NO MEDIA")
                break
            case Audio.Loading:
                console.log("Loading")
                break
            case Audio.Loaded:
                console.log("Loaded")
                break
            case Audio.Buffering:
                console.log("Buffering")
                break
            case Audio.Stalled:
                console.log("Stalled")
                break
            case Audio.Buffered:
                console.log("Buffered")
                break
            case Audio.EndOfMedia:
                console.log("EndOfMedia")
                if (index !== playlist.count - 1)
                    next()
                break
            case Audio.InvalidMedia:
                console.log("InvalidMedia")
                break
            case Audio.UnknownStatus:
                console.log("UnkownStatus")
                break
            }
        }
    }

    PlaybackControls {
        id: playbackControls

        anchors.bottom: parent.bottom
        anchors.bottomMargin: -playbackControls.height

        audioElement: audio
    }
}
