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
                height: musicStreamer.searching && resultsList.count > 0 ? 48 * ScreenValues.dp : 0

                Connections {
                    target: musicStreamer
                    onSearchingChanged: {
                        if (musicStreamer.searching && resultsList.count > 0)
                            busyFooterContainer.height = 48 * ScreenValues.dp
                        else
                            busyFooterContainer.height = 0
                    }
                }

                Connections {
                    target: resultsList
                    onCountChanged: {
                        if (musicStreamer.searching && resultsList.count > 0)
                            busyFooterContainer.height = 48 * ScreenValues.dp
                        else
                            busyFooterContainer.height = 0
                    }
                }

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
                id: resultsList

                anchors.fill: parent

                model: musicStreamer
                clip: true

                footer: busyFooter
                delegate: SongDelegate {

                    onPressAndHold: {
                        if (Qt.platform.os === "android") {
                            root.shareModel = model
                            menu.popup()
                        }
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
}
