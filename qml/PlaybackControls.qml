import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.1
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
    height: column.height
    width: parent.width

    ColumnLayout {
        id: column

        anchors {
            left: parent.left
            right: parent.right
        }

        ProgressBar {
            id: progressBar

            //            anchors {
            //                left: parent.left
            //                right: parent.right
            //                top: parent.top
            //            }

            maximumValue: audio.duration
            minimumValue: 0
            value: audio.position
            width: parent.width

            style: ProgressBarStyle {
                background: Rectangle {
                    //radius: 2
                    color: Styler.darkTheme ? Style.PROGRESS_BAR_BACKGROUND_DARK : Style.PROGRESS_BAR_BACKGROUND_LIGHT
                    //border.color: "gray"
                    //border.width: 1
                    implicitWidth: control.width
                    implicitHeight: 10
                }
                progress: Rectangle {
                    color: "#99cc00"
                    //color: "lightsteelblue"
                    //border.color: "steelblue"
                }
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

        RowLayout {
            height: playBtn.height
            width: parent.width

            Label {
                //                width: column.width / 2
                Layout.fillWidth: true//: column.width / 2

                //                anchors {
                //                    left: parent.left; leftMargin: 5
                //                    bottom: parent.bottom
                //                }

                color: Styler.darkTheme ? Style.TEXT_SECONDARY_COLOR_DARK : Style.TEXT_SECONDARY_COLOR_LIGHT
                font.pointSize: 12
                height: parent.height
                verticalAlignment: "AlignVCenter"
                text: formatMilliseconds(audio.position)
            }

            RowLayout {
                spacing: 0.35 * dpi

                TitleBarImageButton {
                    id: previousBtn

                    height: 0.35 * dpi
                    width: 0.35 * dpi

                    source: "qrc:/images/previous_" + (Styler.darkTheme ? "dark" : "light")
                    visible: false
                }

                TitleBarImageButton {
                    id: playBtn

                    height: 0.35 * dpi
                    width: 0.35 * dpi

                    source: (audio.playbackState == Audio.PlayingState ? "qrc:/images/pause_" : "qrc:/images/play_") + (Styler.darkTheme ? "dark" : "light")

                    onClicked: {
                        if (audio.playbackState == Audio.PlayingState)
                            audio.pause();
                        else if (audio.source != "")
                            audio.play();
                    }
                }

                TitleBarImageButton {
                    id: nextBtn

                    height: 0.35 * dpi
                    width: 0.35 * dpi

                    source: "qrc:/images/next_" + (Styler.darkTheme ? "dark" : "light")

                    //onClicked:
                    visible: false
                }
            }

            Label {
                Layout.fillWidth: true

                //                width: column.width / 2.1
                //                Layout.minimumWidth: column.width / 2.1
                //                anchors {
                //                    right: parent.right; rightMargin: 5
                //                    bottom: parent.bottom
                //                }

                color: Styler.darkTheme ? Style.TEXT_SECONDARY_COLOR_DARK : Style.TEXT_SECONDARY_COLOR_LIGHT
                font.pointSize: 12
                text: formatMilliseconds(audio.duration)
                horizontalAlignment: "AlignRight"
            }
        }

        Label {
            id: songLabel

            //            anchors {
            //                top: progressBar.bottom; topMargin: 10
            //                left: parent.left; leftMargin: 10
            //            }

            color: Styler.darkTheme ? Style.TEXT_COLOR_DARK : Style.TEXT_COLOR_LIGHT

            font.pointSize: 15
        }
    }

    //    TitleBarImageButton {
    //        height: parent.height
    //        width: 0.40 * dpi
    //    }
}
