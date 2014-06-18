import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.1
import "style.js" as Style
import Styler 1.0

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
    height: column.height + dpi * 0.04
    width: parent.width

    ColumnLayout {
        id: column

        anchors {
            left: parent.left
            right: parent.right
        }

        Connections {
            target: audioElement
            onDurationChanged: progressBar.maximumValue = audioElement.duration
            onPositionChanged: progressBar.value = audioElement.position
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
                    implicitHeight: 10
                }
                progress: Rectangle {
                    color: "#0066CC"
                }
            }

            MouseArea {
                anchors {
                    fill: parent
                    margins: -0.04 * dpi
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
                margins: dpi * 0.04
            }


            RowLayout {
                anchors.fill: parent

                Label {
                    Layout.fillWidth: true
                    color: Style.TEXT_SECONDARY_COLOR_DARK
                    font.pointSize: 12
                    height: parent.height
                    verticalAlignment: "AlignVCenter"
                    text: formatMilliseconds(audioElement.position)
                }

                RowLayout {
                    spacing: 0.34 * dpi

                    TitleBarImageButton {
                        id: previousBtn

                        height: 0.34 * dpi
                        width: 0.34 * dpi

                        source: "qrc:/images/previous"

                        onClicked: applicationWindow.previous()
                    }

                    TitleBarImageButton {
                        id: playBtn

                        height: 0.34 * dpi
                        width: 0.34 * dpi

                        source: audioElement.playbackState == Audio.PlayingState || (audioElement.status == Audio.Buffering || audioElement.status == Audio.Stalled) ? "qrc:/images/pause" : "qrc:/images/play"

                        onClicked: {
                            if (audioElement.playbackState == Audio.PlayingState)
                                audioElement.pause();
                            else if (audioElement.source != "")
                                audioElement.play();
                        }
                    }

                    TitleBarImageButton {
                        id: nextBtn

                        height: 0.34 * dpi
                        width: 0.34 * dpi

                        source: "qrc:/images/next"

                        onClicked: applicationWindow.next()
                    }
                }

                Label {
                    Layout.fillWidth: true

                    color: Style.TEXT_SECONDARY_COLOR_DARK
                    font.pointSize: 12
                    text: formatMilliseconds(audioElement.duration)
                    horizontalAlignment: "AlignRight"
                }
            }

        }

        Label {
            id: songLabel

            anchors {
                left: parent.left
                right: parent.right
                margins: dpi * 0.04
            }

            color: Style.TEXT_COLOR_DARK
            font.pointSize: 15
        }
    }
}
