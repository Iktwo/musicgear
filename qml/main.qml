import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.1
import QtMultimedia 5.1
import com.iktwo.components 1.0
import "."

ApplicationWindow {
    id: applicationWindow

    property var resolutions: [
        {"height": 480, "width": 320, "name": "HVGA", "ratio": "3:2"},
        {"height": 640, "width": 360, "name": "nHD", "ratio": "16:9"},
        {"height": 640, "width": 480, "name": "VGA", "ratio": "4:3"},
        {"height": 800, "width": 480, "name": "WVGA", "ratio": "5:3"},
        {"height": 800, "width": 600, "name": "SVGA", "ratio": "4:3"},
        {"height": 960, "width": 540, "name": "qHD", "ratio": "16:9"},
        {"height": 1280, "width": 720, "name": "720p", "ratio": "16:9"},
        {"height": 1280, "width": 800, "name": "WXGA", "ratio": "16:10"},
        {"height": 1920, "width": 1080, "name": "1080p", "ratio": "16:9"}
    ]

    property int currentResolution: 3
    property bool isScreenPortrait: height >= width

    function next() {
        if (audio.index + 1 < playlist.count)
            audio.index = audio.index + 1
        else
            audio.index = 0

        playbackControls.song = playlist.get(audio.index).name + " - <i>" + playlist.get(audio.index).comment + "</i>"
        audio.source = playlist.get(audio.index).url
        audio.play()
    }

    function previous() {
        if (audio.index - 1 >= 0)
            audio.index = audio.index - 1
        else
            audio.index = playlist.count - 1

        playbackControls.song = playlist.get(audio.index).name + " - <i>" + playlist.get(audio.index).comment + "</i>"
        audio.source = playlist.get(audio.index).url
        audio.play()
    }

    visible: true
    width: resolutions[currentResolution]["width"]
    height: resolutions[currentResolution]["height"]

    FontLoader { source: "qrc:/fonts/Muli-Italic" }
    FontLoader { source: "qrc:/fonts/Muli-Light" }
    FontLoader { source: "qrc:/fonts/Muli-Light" }
    FontLoader {
        id: font

        source: "qrc:/fonts/Muli-Regular"
        onStatusChanged: {
            if (status === FontLoader.Ready)
                Theme.fontFamily = font.name
        }
    }

    Rectangle {
        id: background

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
        id: tutorialPage
        TutorialPage { }
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
                playbackControls.song = playlist.get(audio.index).name + " - <i>" + playlist.get(audio.index).comment + "</i>"
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

    UpdateChecker {
        id: updateChecker
        onLatestVersionChanged: {
            if (latestVersion > version && updateChecker.skippedVersion !== latestVersion)
                updateDialog.open()
        }
    }

    UpdateDialog {
        id: updateDialog

        title: qsTr("Update")
        updateCheckerElement: updateChecker
        text: qsTr("There's a new update available, you are running version %1 and you can update to version %2.").arg(updateChecker.version).arg(updateChecker.latestVersion)
    }

    Component.onCompleted: {
        Theme.titleBarColor = "#0066CC"

        var now = new Date()
        now.setHours(0)
        now.setMinutes(0)
        now.setSeconds(0)
        now.setMilliseconds(0)

        if (ApplicationInfo.timesLaunched > 15 && Math.floor((now.getTime() - ApplicationInfo.firstTimeLaunched.getTime()) / 86400000) >= 5 && Qt.platform.os === "android") {
            /// TODO: ANDROID - Show dialog and ask to review
        }

        if (font.status === FontLoader.Ready)
            Theme.fontFamily = font.name
        updateChecker.checkForUpdateOnGooglePlay()
    }
}
