import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.1
import "components" as Components
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
    height: column.height + 1 * ui.dpMultiplier
    width: parent.width

    ColumnLayout {
        Connections {
            target: audioElement
            onDurationChanged: progressBar.maximumValue = audioElement.duration
            onPositionChanged: progressBar.value = audioElement.position
        }

        id: column

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
                    implicitHeight: 4 * ui.dpMultiplier
                }
                progress: Rectangle {
                    color: "#0066CC"
                }
            }

            MouseArea {
                anchors {
                    fill: parent
                    margins: -0.04 * ui.dpi
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
                margins: 1 * ui.dpMultiplier
            }

            RowLayout {
                anchors.fill: parent

                Label {
                    /// TODO: add animation where this flashes if paused
                    Layout.fillWidth: true
                    color: Style.TEXT_SECONDARY_COLOR_DARK
                    height: parent.height
                    verticalAlignment: "AlignVCenter"
                    text: formatMilliseconds(audioElement.position)
                    font {
                        pixelSize: 12 * ui.dpMultiplier
                        weight: Font.Light
                    }
                }

                RowLayout {
                    spacing: 8 * ui.dpMultiplier

                    Components.TitleBarImageButton {
                        id: previousBtn

                        height: 48 * ui.dpMultiplier
                        width: 48 * ui.dpMultiplier

                        source: "qrc:/images/" + ui.getBestIconSize(Math.min(icon.height, icon.width)) + "previous"

                        onClicked: applicationWindow.previous()
                    }

                    Components.TitleBarImageButton {
                        id: playBtn

                        height: 48 * ui.dpMultiplier
                        width: 48 * ui.dpMultiplier

                        source: "qrc:/images/" + ui.getBestIconSize(Math.min(icon.height, icon.width)) + (audioElement.playbackState == Audio.PlayingState || (audioElement.status == Audio.Buffering || audioElement.status == Audio.Stalled) && audioElement.playbackState != Audio.PausedState ? "pause" : "play")

                        onClicked: {
                            if (audioElement.playbackState == Audio.PlayingState)
                                audioElement.pause();
                            else if (audioElement.source != "")
                                audioElement.play();
                        }
                    }

                    Components.TitleBarImageButton {
                        id: nextBtn

                        height: 48 * ui.dpMultiplier
                        width: 48 * ui.dpMultiplier

                        source: "qrc:/images/" + ui.getBestIconSize(Math.min(icon.height, icon.width)) + "next"

                        onClicked: applicationWindow.next()
                    }
                }

                Label {
                    Layout.fillWidth: true

                    color: Style.TEXT_SECONDARY_COLOR_DARK
                    text: formatMilliseconds(audioElement.duration)
                    horizontalAlignment: "AlignRight"
                    font {
                        pixelSize: 12 * ui.dpMultiplier
                        weight: Font.Light
                    }
                }
            }
        }

        Label {
            id: songLabel

            anchors {
                left: parent.left
                right: parent.right
                margins: 1 * ui.dpMultiplier
            }

            color: Style.TEXT_COLOR_DARK
            font {
                pixelSize: 14 * ui.dpMultiplier
                weight: Font.Light
            }
        }
    }
}
