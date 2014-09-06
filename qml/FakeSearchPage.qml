import QtQuick 2.3
import com.iktwo.components 1.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Page {
    id: root

    property var shareModel

    signal tutorialPageCompleted

    function search() {
        if (!musicStreamer.searching)
            if (textEdit.text.length > 0) {
                musicStreamer.search(textEdit.text)
                Qt.inputMethod.hide()
            }
    }

    onActivated: Qt.inputMethod.hide()

    titleBar: TitleBar {
        enabled: parent.enabled

        ImageButton {
            anchors.left: parent.left
            source: "qrc:/images/" + Theme.getBestIconSize(Math.min(icon.height, icon.width)) + "back"

            onClicked: stackView.pop()
        }

        TextField {
            id: textEdit

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            inputMethodHints: Qt.ImhNoPredictiveText
            placeholderText: qsTr("Search songs and artists")
            font.pointSize: 14

            onAccepted: root.search()

            style: TextFieldStyle {
                placeholderTextColor: "#ccdedede"
                textColor: "#ddefefef"
                background: Item {
                    implicitWidth: ScreenValues.dpi * 1.3
                    implicitHeight: ScreenValues.dpi * 0.20

                    Rectangle {
                        id: bottomBorder

                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }

                        color: "#ddefefef"
                        height: 1 * ScreenValues.dpMultiplier
                    }

                    Rectangle {
                        anchors {
                            left: parent.left
                            bottom: parent.bottom
                        }

                        color: "#ddefefef"
                        width: 1 * ScreenValues.dpMultiplier
                        height: width * 5
                    }

                    Rectangle {
                        anchors {
                            right: parent.right
                            bottom: parent.bottom
                        }

                        color: "#ddefefef"
                        width: 1 * ScreenValues.dpMultiplier
                        height: width * 5
                    }
                }
            }
        }

        ImageButton {
            anchors.right: parent.right
            source: "qrc:/images/" + Theme.getBestIconSize(Math.min(icon.height, icon.width)) + "search"

            onClicked: root.search()
        }
    }

    Item {
        anchors.fill: parent

        Menu {
            id: menu
            title: qsTr("Menu")

            MenuItem {
                text: qsTr("Share")
                enabled: shareModel === undefined ? false : (shareModel.code !== "")
                onTriggered: musicStreamer.share(shareModel.name, "http://www.goear.com/listen/" + shareModel.code)
            }
        }

        Component {
            id: busyFooter
            Item {
                id: busyFooterContainer
                width: resultsList.width
                height: musicStreamer.searching && resultsList.count > 0 ? 48 * ScreenValues.dpMultiplier : 0

                Connections {
                    target: musicStreamer
                    onSearchingChanged: {
                        if (musicStreamer.searching && resultsList.count > 0)
                            busyFooterContainer.height = 48 * ScreenValues.dpMultiplier
                        else
                            busyFooterContainer.height = 0
                    }
                }

                Connections {
                    target: resultsList
                    onCountChanged: {
                        if (musicStreamer.searching && resultsList.count > 0)
                            busyFooterContainer.height = 48 * ScreenValues.dpMultiplier
                        else
                            busyFooterContainer.height = 0
                    }
                }

                BusyIndicator {
                    anchors.centerIn: parent
                    height: parent.height - 8 * ScreenValues.dpMultiplier
                    width: height
                    running: parent.height > 0
                    style: BusyIndicatorStyle {
                        indicator: Image {
                            id: busyIndicator
                            visible: control.running
                            height: control.height
                            width: control.width
                            source: "qrc:/images/" + Theme.getBestIconSize(height) + "busy_dark"
                            antialiasing: true
                            RotationAnimator {
                                target: busyIndicator
                                running: control.running
                                loops: Animation.Infinite
                                duration: 2000
                                from: 0; to: 360
                            }
                        }
                    }
                }
            }
        }

        ScrollView {
            anchors.fill: parent
            flickableItem.interactive: true; focus: true

            ListView {
                id: resultsList

                anchors.fill: parent

                model: musicStreamer
                clip: true

                footer: busyFooter
                delegate: SongDelegate {

                    onPressAndHold: {
                        if (Q_OS === "ANDROID") {
                            root.shareModel = model
                            menu.popup()
                        }
                    }

                    onAddToPlaylist: {
                        for (var i = 0; i < playlist.count; i++) {
                            if (playlist.get(i).url === model.url) {
                                ui.showMessage("Song is already in playlist")
                                return
                            }
                        }

                        playlist.append({ "name" : model.name,
                                            "group" : model.group,
                                            "length" : model.length,
                                            "comment" : model.comment,
                                            "code" : model.code,
                                            "url": model.url })
                    }

                    onDownload: {
                        ui.showMessage("Downloading " + model.name)
                        musicStreamer.downloadSong(model.name, model.url)
                    }
                }

                onContentYChanged: {
                    Qt.inputMethod.hide()
                    if (contentHeight != 0) {
                        // if (!musicStreamer.searching && ((contentY + height) / contentHeight) > 0.85)
                        if (!musicStreamer.searching && atYEnd)
                            musicStreamer.fetchMore()

                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent

            color: "#88000000"
            opacity: busyIndicatorComponent.running ? 1 : 0

            BusyIndicator {
                id: busyIndicatorComponent
                anchors.centerIn: parent
                running: musicStreamer.searching && resultsList.count == 0
                height: (applicationWindow.height > applicationWindow.width ? applicationWindow.width : applicationWindow.height) * 0.4
                width: height

                style: BusyIndicatorStyle {
                    indicator: Image {
                        id: busyIndicator
                        visible: control.running
                        source: "qrc:/images/" + Theme.getBestIconSize(height) + "busy"
                        antialiasing: true
                        RotationAnimator {
                            target: busyIndicator
                            running: control.running
                            loops: Animation.Infinite
                            duration: 2000
                            from: 0; to: 360
                        }
                    }
                }
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

            font.pointSize: 22

            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            renderType: Text.NativeRendering
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
        }
    }
}
