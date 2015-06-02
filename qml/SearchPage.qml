import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import com.iktwo.components 1.0

Page {
    id: root

    property var shareModel

    function search() {
        if (!musicStreamer.searching) {
            if (textEdit.text.length > 0) {
                labelNoResults.opacity = 0
                musicStreamer.search(textEdit.text)
                Qt.inputMethod.hide()
            }
        }
    }

    onActivated: {
        if (!listResults.count) {
            textEdit.focus = true
        } else {
            Qt.inputMethod.hide()
            listResults.forceActiveFocus()
        }
    }

    titleBar: TitleBar {
        enabled: parent.enabled

        ImageButton {
            anchors.left: parent.left
            source: "qrc:/images/" + Theme.getBestIconSize(Math.min(icon.height, icon.width)) + "back"

            onClicked: stackView.pop()
        }

        /// TODO: add X button to clear this
        TextField {
            id: textEdit

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            inputMethodHints: Qt.ImhNoPredictiveText
            placeholderText: qsTr("Search songs and artists")

            font {
                pixelSize: 14 * ScreenValues.dp
                family: Theme.fontFamily
            }

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
                        height: 1 * ScreenValues.dp
                    }

                    Rectangle {
                        anchors {
                            left: parent.left
                            bottom: parent.bottom
                        }

                        color: "#ddefefef"
                        width: 1 * ScreenValues.dp
                        height: width * 5
                    }

                    Rectangle {
                        anchors {
                            right: parent.right
                            bottom: parent.bottom
                        }

                        color: "#ddefefef"
                        width: 1 * ScreenValues.dp
                        height: width * 5
                    }
                }
            }

            Keys.onDownPressed: {
                if (listResults.count)
                    listResults.forceActiveFocus()
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
                width: listResults.width
                height: musicStreamer.activeConnections > 0 && listResults.count > 0 ? 48 * ScreenValues.dp : 0

                BusyIndicator {
                    anchors.centerIn: parent
                    height: parent.height - 8 * ScreenValues.dp
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
                id: listResults

                anchors.fill: parent

                model: musicStreamer
                clip: true

                highlight: Rectangle {
                    height: 100
                    width: 100
                    color: "#343498db"
                }

                footer: busyFooter
                delegate: SongDelegate {
                    Keys.onEnterPressed: addToPlaylist()
                    Keys.onReturnPressed: addToPlaylist()

                    onPressAndHold: {
                        if (Qt.platform.os === "android") {
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
                                            "artist" : model.artist,
                                            "length" : model.length,
                                            "code" : model.code,
                                            "url": model.url,
                                            "picture": model.picture })
                    }

                    onDownload: {
                        ui.showMessage("Downloading " + model.name)
                        musicStreamer.downloadSong(model.name, model.url)
                    }
                }

                /// TODO: consider adding a button on the bottom to fetch more if list doesn't cover whole page

                onContentYChanged: {
                    Qt.inputMethod.hide()
                    if (contentHeight != 0) {
                        // if (!musicStreamer.searching && ((contentY + height) / contentHeight) > 0.85)
                        if (musicStreamer.activeConnections === 0 && atYEnd)
                            musicStreamer.fetchMoreResulst()
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
                running: (musicStreamer.searching || musicStreamer.activeConnections > 0) && listResults.count == 0
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
            color: "white"

            font {
                pixelSize: 22 * ScreenValues.dp
                family: Theme.fontFamily
            }

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

            onNoResults: {
                if (listResults.count === 0)
                    labelNoResults.opacity = 1
            }
        }
    }

    Label {
        id: labelNoResults

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 8 * ScreenValues.dp
        }

        color: Theme.mainTextColor

        elide: "ElideRight"
        wrapMode: "Wrap"

        font {
            pixelSize: 28 * ScreenValues.dp
            family: Theme.fontFamily
        }

        horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"

        text: qsTr("No results")

        opacity: 0

        Behavior on opacity { NumberAnimation { } }
    }
}
