import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.1
import QtMultimedia 5.1
import "."

ApplicationWindow {
    id: applicationWindow

    // HVGA, VGA, WVGA, SVGA, nHD, qHD
    property var resolutions: [ {"height": 480, "width": 320}, {"height": 640, "width": 480}, {"height": 800, "width": 480}, {"height": 800, "width": 600}, {"height": 640, "width": 360}, {"height": 960, "width": 540} ]
    property int currentResolution: 3
    property int dpi: musicStreamer.dpi ? musicStreamer.dpi : Screen.pixelDensity * 25.4
    property real dpMultiplier: dpi / 160
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

    /// TODO: think of a better way to handle this, as this considers square icons
    function getBestIconSize(height) {
        // 36,  48,  72,  96, 144, 192
        // 42,  60,  84, 120, 168
        if (height < 42)
            return "ldpi/"
        else if (height < 60)
            return "mdpi/"
        else if (height < 84)
            return "hdpi/"
        else if (height < 120)
            return "xhdpi/"
        else if (height < 168)
            return "xxhdpi/"
        else if (height < 216)
            return "xxxhdpi/"
        else
            return ""
    }

    visible: true
    width: resolutions[currentResolution]["width"]
    height: resolutions[currentResolution]["height"]

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
