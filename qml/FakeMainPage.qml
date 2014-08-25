import QtQuick 2.3
import com.iktwo.components 1.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

Page {
    id: root

    function nextAnimation(object) {
        if (object.state === "")
            object.state = "0"
        else if (!isNaN(parseInt(object.state, 10)) && parseInt(object.state, 10) < object.states.length - 1)
            object.state = parseInt(object.state, 10) + 1
    }

    anchors.fill: parent

    titleBar: TitleBar {
        id: titleBar

        title: "MusicGear"

        ImageButton {
            anchors.right: searchButton.left
            source: "qrc:/images/" + ui.getBestIconSize(Math.min(icon.height, icon.width)) + "help"
            enabled: false
        }

        ImageButton {
            id: searchButton

            anchors.right: parent.right
            source: "qrc:/images/" + ui.getBestIconSize(Math.min(icon.height, icon.width)) + "search"
            enabled: false
        }
    }

    ListModel {
        id: fakeModel

        ListElement {
            name: "Arrullo De Estrellas"; group: "Zoé"
            length: "4:14"; comment: "Bonita canción que me hace pensar en ti.."
            code: ""; url: ""
        }

        ListElement {
            name: "Goodbye Lovers and Friends"; group: "Franz Ferdinand"
            length: "4:34"; comment: "I love this song!"
            code: ""; url: ""
        }

        ListElement {
            name: "Addicted to you"; group: "Avicii"
            length: "3:24"; comment: "I am addicted to you"
            code: ""; url: ""
        }
    }

    ListView {
        id: songList

        width: parent.width
        height: (64 * ui.dpMultiplier + 1 * ui.dpMultiplier) * count

        model: fakeModel
        clip: true
        interactive: false

        delegate: PlaylistDelegate {
            //                    onPressAndHold: {
            //                        if (Q_OS === "ANDROID") {
            //                            root.shareModel = model
            //                            menu.popup()
            //                        }
            //                    }

            //                    onRequestedPlay: { }
            //                    onRequestedRemove: { }
        }
    }

    ColumnLayout {
        anchors {
            top: songList.bottom
            bottom: playbackControls.top
            horizontalCenter: parent.horizontalCenter
        }

        width: isScreenPortrait ? root.width * 0.8 : root.height * 0.8

        Item { height: 1; width: 1; Layout.fillHeight: true }
        Item { height: 1; width: 1; Layout.fillHeight: true }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.fillWidth: true

            font.pixelSize: ui.dpMultiplier * 18
            color: Theme.mainTextColor
            text: qsTr("This is your playlist. The music that you add will appear here.")
            renderType: Text.NativeRendering
            verticalAlignment: "AlignVCenter"
            horizontalAlignment: "AlignHCenter"
            wrapMode: "Wrap"
            elide: "ElideRight"
            maximumLineCount: 4
        }

        Item { height: 1; width: 1; Layout.fillHeight: true }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Done")
            Layout.preferredHeight: 40 * ui.dpMultiplier
            Layout.preferredWidth: 152 * ui.dpMultiplier
            style: ButtonStyle {
                id: buttonStyle

                background: Rectangle {
                    height: buttonStyle.control.height
                    width: buttonStyle.control.width
                    color: control.pressed ? Qt.darker(Theme.titleBarColor) : Theme.titleBarColor
                }

                label: Label {
                    color: control.pressed ? Qt.darker(Theme.titleBarTextColor) : Theme.titleBarTextColor
                    text: buttonStyle.control.text
                    font.pixelSize: buttonStyle.control.height * 0.5
                    renderType: "NativeRendering"
                    verticalAlignment: "AlignVCenter"
                    horizontalAlignment: "AlignHCenter"
                }
            }

            onClicked: {
                stackView.pop()
                stackView.push(mainPage)
            }
        }

        Item { height: 1; width: 1; Layout.fillHeight: true }
        Item { height: 1; width: 1; Layout.fillHeight: true }
    }

    FakePlaybackControls {
        id: playbackControls

        anchors.bottom: parent.bottom
        song: fakeModel.get(songList.currentIndex).name
    }
}
