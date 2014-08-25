import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.1
import QtMultimedia 5.1
import com.iktwo.components 1.0
import "."

ApplicationWindow {
    id: applicationWindow

    property var resolutions: [
        {"height": 480, "width": 320}, // HVGA
        {"height": 640, "width": 480}, // VGA
        {"height": 800, "width": 480}, // WVGA
        {"height": 800, "width": 600}, // SVGA
        {"height": 640, "width": 360}, // nHD
        {"height": 960, "width": 540}  // qHD
    ]

    property int currentResolution: 3
    property bool isScreenPortrait: height >= width

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

    visible: true
    width: resolutions[currentResolution]["width"]
    height: resolutions[currentResolution]["height"]

    Rectangle {
        anchors.fill: parent
        color: Theme.backgroundColor
    }

    StackView {
        id: stackView

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: playbackControls.top
        }

        initialItem: mainPage

        focus: true
        Keys.onBackPressed: {
            if (stackView.depth > 1)
                stackView.pop()
        }
    }

    Component {
        id: mainPage
        MainPage { audioElement: audio }
    }

    Component {
        id: aboutPage
        AboutPage { }
    }

    Component {
        id: searchPage
        SearchPage { }
    }

    Connections {
        target: musicStreamer
        /// TODO: handle errors that end with "server replied: Not Found"
        onServerError: ui.showMessage("Error, do you have internet connection? Please try again..")
    }

    ListModel {
        id: playlist

        onRowsInserted: {
            // If new item is first on list, play it
            if (count === 1) {
                playbackControls.song = playlist.get(audio.index).name + " - <i>" + playlist.get(audio.index).group + "</i>"
                audio.source = playlist.get(audio.index).url
                audio.play()
            } else if (audio.status == Audio.EndOfMedia) {
                next()
            }
        }

        onCountChanged: {
            if (count == 0) {
                playbackControls.anchors.bottomMargin = -playbackControls.height
                audio.stop()
            } else {
                playbackControls.anchors.bottomMargin = 0
            }
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
                ui.showMessage("Invalid media")
                break
            case Audio.UnknownStatus:
                console.log("UnkownStatus")
                break
            }
        }
    }

    PlaybackControls {
        id: playbackControls

        anchors {
            bottom: parent.bottom; bottomMargin: -playbackControls.height
        }

        audioElement: audio
    }

    Connections {
        target: ui
        onDpiChanged: ScreenValues.dpi = ui.dpi
        onDpMultiplierChanged: ScreenValues.dpMultiplier = ui.dpMultiplier
    }

    Component.onCompleted: {
        ScreenValues.dpi = ui.dpi
        ScreenValues.dpMultiplier = ui.dpMultiplier

        Theme.titleBarColor = "#0066CC"
    }
}
