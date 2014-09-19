import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.1
import com.iktwo.components 1.0
import "components/style.js" as Style

Rectangle {
    property Audio audioElement
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

    color: "#fafafa"
    height: column.height + 1 * ScreenValues.dp
    width: parent.width

    ColumnLayout {
        id: column

        Connections {
            target: audioElement
            onDurationChanged: progressBar.maximumValue = audioElement.duration
            onPositionChanged: progressBar.value = audioElement.position
        }

        anchors {
            left: parent.left
            right: parent.right
        }

        ProgressBar {
            id: progressBar

            maximumValue: audioElement.duration
            minimumValue: 0
            value: audioElement.position
            width: parent.width

            style: ProgressBarStyle {
                background: Rectangle {
                    color: Style.PROGRESS_BAR_BACKGROUND_LIGHT
                    implicitWidth: control.width
                    implicitHeight: 4 * ScreenValues.dp
                }
                progress: Rectangle {
                    color: "#0066CC"
                }
            }

            MouseArea {
                anchors {
                    fill: parent
                    margins: -0.04 * ScreenValues.dpi
                }

                onClicked: {
                    if (audioElement.seekable)
                        audioElement.seek((mouseX / parent.width) * audioElement.duration)
                }
            }
        }

        Item {
            height: playBtn.height

            anchors {
                left: parent.left
                right: parent.right
                margins: 1 * ScreenValues.dp
            }

            RowLayout {
                anchors.fill: parent

                Item {
                    height: 1
                    Layout.preferredWidth: 4 * ScreenValues.dp
                }

                Label {
                    /// TODO: add animation where this flashes if paused
                    Layout.fillWidth: true
                    color: Style.TEXT_SECONDARY_COLOR_DARK
                    height: parent.height
                    verticalAlignment: "AlignVCenter"
                    text: formatMilliseconds(audioElement.position)
                    renderType: Text.NativeRendering
                    font.pixelSize: 12 * ScreenValues.dp
                }

                RowLayout {
                    spacing: 8 * ScreenValues.dp

                    ImageButton {
                        id: previousBtn

                        height: 48 * ScreenValues.dp
                        width: 48 * ScreenValues.dp

                        source: "qrc:/images/" + Theme.getBestIconSize(Math.min(icon.height, icon.width)) + "previous"

                        onClicked: applicationWindow.previous()
                    }

                    ImageButton {
                        id: playBtn

                        height: 48 * ScreenValues.dp
                        width: 48 * ScreenValues.dp

                        source: "qrc:/images/" + Theme.getBestIconSize(Math.min(icon.height, icon.width)) + (audioElement.playbackState == Audio.PlayingState || (audioElement.status == Audio.Buffering || audioElement.status == Audio.Stalled) && audioElement.playbackState != Audio.PausedState ? "pause" : "play")

                        onClicked: {
                            if (audioElement.playbackState == Audio.PlayingState)
                                audioElement.pause();
                            else if (audioElement.source != "")
                                audioElement.play();
                        }
                    }

                    ImageButton {
                        id: nextBtn

                        height: 48 * ScreenValues.dp
                        width: 48 * ScreenValues.dp

                        source: "qrc:/images/" + Theme.getBestIconSize(Math.min(icon.height, icon.width)) + "next"

                        onClicked: applicationWindow.next()
                    }
                }

                Label {
                    Layout.fillWidth: true

                    color: Style.TEXT_SECONDARY_COLOR_DARK
                    text: formatMilliseconds(audioElement.duration)
                    horizontalAlignment: "AlignRight"
                    renderType: Text.NativeRendering
                    font.pixelSize: 12 * ScreenValues.dp
                }

                Item {
                    height: 1
                    Layout.preferredWidth: 4 * ScreenValues.dp
                }
            }
        }

        Label {
            id: songLabel

            anchors.horizontalCenter: parent.horizontalCenter

            width: parent.width - (16 * ScreenValues.dp)
            Layout.preferredWidth: parent.width - (16 * ScreenValues.dp)
            color: Style.TEXT_COLOR_DARK
            renderType: Text.NativeRendering
            font.pixelSize: 14 * ScreenValues.dp
        }
    }
}
