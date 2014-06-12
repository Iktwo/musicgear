import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import Styler 1.0
import "style.js" as Style
import "." 1.0

Dialog {
    id: root

    function search() {
        if (!musicStreamer.searching)
            if (textEdit.text.length > 0) {
                musicStreamer.search(textEdit.text)
                Qt.inputMethod.hide()
            }
    }

    onOpenedChanged: {
        if (opened)
            textEdit.focus = true
        else
            Qt.inputMethod.hide()
    }

    Item {
        anchors.fill: parent

        TitleBar {
            id: titleBar

            enabled: parent.enabled

            TitleBarImageButton {
                anchors.left: parent.left

                source: Styler.darkTheme ? "qrc:/images/playlist_dark"
                                         : "qrc:/images/playlist_light"

                onClicked: root.close()
            }

            TextField {
                id: textEdit

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText: qsTr("Search songs and artists")

                onAccepted: root.search()

                style: TextFieldStyle {
                    placeholderTextColor: "#ccdedede"
                    textColor: "#ddefefef"
                    background: Item {
                        implicitWidth: dpi * 1.3
                        implicitHeight: dpi * 0.20

                        Rectangle {
                            id: bottomBorder

                            anchors {
                                left: parent.left
                                right: parent.right
                                bottom: parent.bottom
                            }

                            color: "#ddefefef"
                            height: dpi * 0.01
                        }

                        Rectangle {
                            anchors {
                                left: parent.left
                                bottom: parent.bottom
                            }

                            color: "#ddefefef"
                            width: dpi * 0.01
                            height: width * 5
                        }

                        Rectangle {
                            anchors {
                                right: parent.right
                                bottom: parent.bottom
                            }

                            color: "#ddefefef"
                            width: dpi * 0.01
                            height: width * 5
                        }
                    }
                }
            }

            TitleBarImageButton {
                anchors.right: parent.right

                source: Styler.darkTheme ? "qrc:/images/search_dark"
                                         : "qrc:/images/search_light"

                onClicked: root.search()
            }
        }

        ScrollView {
            anchors {
                top: titleBar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            ListView {
                id: resultsList

                anchors.fill: parent

                model: musicStreamer
                clip: true

                delegate: SongDelegate {
                    onAddToPlaylist: playlist.append({ "name" : model.name,
                                                       "group" : model.group,
                                                       "length" : model.length,
                                                       "comment" : model.comment,
                                                       "code" : model.code,
                                                       "url": model.url })

                    onDownload: musicStreamer.downloadSong(model.name, model.url)
                }

                onContentYChanged: {
                    Qt.inputMethod.hide()
                    if (contentHeight != 0)
                        //if (((contentY + height) / contentHeight) > 0.85)
                        if (atYEnd)
                            musicStreamer.fetchMore()
                }
            }

        }


        Rectangle {
            anchors.fill: parent

            color: "#88000000"
            opacity: musicStreamer.searching ? 1 : 0

            Label {
                anchors.centerIn: parent

                color: Styler.darkTheme ? Style.TITLE_TEXT_COLOR_DARK : Style.TITLE_TEXT_COLOR_LIGHT
                font.pointSize: 26

                text: qsTr("Searching...") /// TODO: replace this with a busy indicator
            }
        }
    }

    Rectangle {
        anchors.fill: parent

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

            font {
                pointSize: 22
                weight: Font.Light
            }

            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
        }

        // TODO: add cancel button

        ProgressBar {
            maximumValue: 1
            minimumValue: 0
            value: progressLabel.progress
            anchors {
                left: parent.left
                right: parent.right
                top: progressLabel.bottom; topMargin: 15
            }
            style: ProgressBarStyle {
                background: Rectangle {
                    radius: 2
                    color: "lightgray"
                    border.color: "gray"
                    border.width: 1
                    implicitWidth: 200
                    implicitHeight: 24
                }
                progress: Rectangle {
                    color: "lightsteelblue"
                    border.color: "steelblue"
                }
            }
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
