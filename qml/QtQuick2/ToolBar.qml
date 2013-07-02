import QtQuick 2.0
import QtMultimedia 5.0
import "style.js" as Style
import Styler 1.0

Rectangle {
    property Audio audio
    property alias song: songLabel.text

    function formatMilliseconds(ms) {
        var hours = Math.floor((((ms / 1000) / 60) / 60) % 60).toString()
        var minutes = Math.floor(((ms / 1000) / 60) % 60).toString()
        var seconds = Math.floor((ms / 1000) % 60).toString()

        var time = ""

        if (hours > 0)
            time += hours + ":"

        if (minutes < 10)
            time += "0" + minutes + ":"
        else
            time += minutes + ":"

        if (seconds < 10)
            time += "0" + seconds
        else
            time += seconds

        return time
    }

    color: Styler.darkTheme ? Style.MENU_TITLE_BACKGROUND_COLOR_DARK : Style.MENU_TITLE_BACKGROUND_COLOR_LIGHT
    height: 122

    Item {
        id: progressBar

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: progressBarContainer.height + currentTimeLabel.height

        Rectangle {
            id: progressBarContainer

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            color: Styler.darkTheme ? Style.PROGRESS_BAR_BACKGROUND_DARK : Style.PROGRESS_BAR_BACKGROUND_LIGHT
            height: 8

            Rectangle {
                color: "green"
                height: parent.height
                width: audio.duration === 0 ? 0 : (audio.position / audio.duration) * parent.width
            }
        }

        Label {
            id: currentTimeLabel

            anchors {
                left: parent.left; leftMargin: 5
                bottom: parent.bottom
            }

            color: Styler.darkTheme ? Style.SECONDARY_TEXT_COLOR_DARK : Style.SECONDARY_TEXT_COLOR_LIGHT
            font.pointSize: 8
            text: formatMilliseconds(audio.position)
        }

        Label {
            anchors {
                right: parent.right; rightMargin: 5
                bottom: parent.bottom
            }

            color: Styler.darkTheme ? Style.SECONDARY_TEXT_COLOR_DARK : Style.SECONDARY_TEXT_COLOR_LIGHT
            font.pointSize: 8
            text: formatMilliseconds(audio.duration)
        }

        MouseArea {
            anchors {
                fill: parent
                margins: -10
            }

            onClicked: {
                if (audio.seekable)
                    audio.seek((mouseX / parent.width) * audio.duration)
            }
        }
    }

    Label {
        id: songLabel

        anchors {
            top: progressBar.bottom; topMargin: 10
            left: parent.left; leftMargin: 10
        }

        font.pointSize: 9
    }
}
