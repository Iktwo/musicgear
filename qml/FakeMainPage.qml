import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import com.iktwo.components 1.0

Item {
    id: root

    property var shareModel

    signal tutorialPageCompleted

    Page {
        id: page

        anchors.fill: parent

        titleBar: TitleBar {
            id: titleBar

            title: "Musicgear"

            ImageButton {
                anchors.right: searchButton.left
                source: "qrc:/images/" + Theme.getBestIconSize(Math.min(icon.height, icon.width)) + "help"
                enabled: false
            }

            ImageButton {
                id: searchButton

                anchors.right: parent.right
                source: "qrc:/images/" + Theme.getBestIconSize(Math.min(icon.height, icon.width)) + "search"
                enabled: false
            }
        }

        Menu {
            id: menu
            title: qsTr("Menu")

            MenuItem {
                text: qsTr("Share")
                enabled: root.shareModel !== undefined && root.shareModel.code !== ""
            }
        }

        ListModel {
            id: fakeModel

            ListElement {
                name: "Arrullo De Estrellas"; artist: "Zoé"
                length: "4:14"; code: ""; url: "xxx"
            }

            ListElement {
                name: "Goodbye Lovers and Friends"; artist: "Franz Ferdinand"
                length: "4:34"; code: ""; url: "xxx"
            }

            ListElement {
                name: "Addicted to you"; artist: "Avicii"
                length: "3:24"; code: ""; url: "xxx"
            }
        }

        ListView {
            id: songList

            width: parent.width
            height: (64 * ScreenValues.dp + 1 * ScreenValues.dp) * count

            model: fakeModel
            clip: true
            interactive: false

            delegate: PlaylistDelegate {
                onPressAndHold: {
                    if (root.state !== "1")
                        return

                    if (Qt.platform.os === "android") {
                        root.shareModel = model
                        menu.popup()
                    } else {
                        console.log("Menu only implemented for Android")
                    }
                }
            }
        }

        Rectangle {
            id: messageBackground

            property int margin: ScreenValues.dp * 8

            width: parent.width
            height: Math.min(margin * 2 + (buttonDone.y + buttonDone.height) - (labelMessage.y + (labelMessage.height - labelMessage.paintedHeight)), columnMessage.height)
            y: columnMessage.y + labelMessage.y - margin
            opacity: 0
        }

        ColumnLayout {
            id: columnMessage
            anchors {
                top: songList.bottom
                bottom: playbackControls.top
                horizontalCenter: parent.horizontalCenter
            }

            width: isScreenPortrait ? root.width * 0.8 : root.height * 0.8
            opacity: messageBackground.opacity

            Item { width: 1; Layout.fillHeight: true }
            Item { width: 1; Layout.fillHeight: true }

            Label {
                id: labelMessage

                anchors.horizontalCenter: parent.horizontalCenter
                Layout.fillWidth: true

                font {
                    pixelSize: 18 * ScreenValues.dp
                    family: Theme.fontFamily
                }

                color: Theme.mainTextColor
                text: qsTr("This is your playlist. The music that you add will appear here. Also when you play music the media controls will appear at the bottom.")
                renderType: Text.NativeRendering
                verticalAlignment: "AlignVCenter"
                horizontalAlignment: "AlignHCenter"
                wrapMode: "Wrap"
                elide: "ElideRight"
                maximumLineCount: 4
            }

            Item { width: 1; Layout.fillHeight: true }

            Button {
                id: buttonDone

                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Done")
                Layout.preferredHeight: 40 * ScreenValues.dp
                Layout.preferredWidth: 152 * ScreenValues.dp
                height: 40 * ScreenValues.dp
                style: FlatButtonStyle { }

                onClicked: {
                    if (parseInt(root.state, 10) < "2") {
                        Theme.nextNumericState(root)
                    } else {
                        stackView.clear()
                        stackView.push(mainPage)
                    }
                }
            }

            Item { width: 1; Layout.fillHeight: true }
            Item { width: 1; Layout.fillHeight: true }
        }

        FakePlaybackControls {
            id: playbackControls

            anchors.bottom: parent.bottom
            song: fakeModel.get(songList.currentIndex).name
        }
    }

    ItemHighlighter {
        id: tutorialHighlighter
        opacity: 0
        mapFrom: background
        highlightedItem: songList.currentItem
        borderColor: Qt.lighter(Theme.titleBarColor)
        blockMouseInput: opacity === 1
    }

    Rectangle {
        id: messageBackgroundDettached

        property int margin: ScreenValues.dp * 8

        width: parent.width
        height: Math.min(margin * 2 + (buttonDoneDettached.y + buttonDoneDettached.height) - (labelMessageDettached.y + (labelMessageDettached.height - labelMessageDettached.paintedHeight)), columnMessageDettached.height)
        y: columnMessageDettached.y + labelMessageDettached.y - margin
        opacity: 0
    }

    ColumnLayout {
        id: columnMessageDettached
        anchors {
            top: parent.top; topMargin: songList.height
            bottom: parent.bottom; bottomMargin: playbackControls.height
            horizontalCenter: parent.horizontalCenter
        }

        width: isScreenPortrait ? root.width * 0.9 : root.height * 0.9
        opacity: messageBackgroundDettached.opacity

        Item { width: 1; Layout.fillHeight: true }
        Item { width: 1; Layout.fillHeight: true }

        Label {
            id: labelMessageDettached

            anchors.horizontalCenter: parent.horizontalCenter
            Layout.fillWidth: true

            font {
                pixelSize: 18 * ScreenValues.dp
                family: Theme.fontFamily
            }

            color: Theme.mainTextColor
            text: qsTr("This is your playlist. The music that you add will appear here. Also when you play music the media controls will appear at the bottom.")
            renderType: Text.NativeRendering
            verticalAlignment: "AlignVCenter"
            horizontalAlignment: "AlignHCenter"
            wrapMode: "Wrap"
            elide: "ElideRight"
            maximumLineCount: 4
        }

        Item { width: 1; Layout.fillHeight: true }

        Button {
            id: buttonDoneDettached

            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Done")
            Layout.preferredHeight: 40 * ScreenValues.dp
            Layout.preferredWidth: 152 * ScreenValues.dp
            height: 40 * ScreenValues.dp
            style: FlatButtonStyle { }

            onClicked: {
                if (parseInt(root.state, 10) < root.states.length)
                    Theme.nextNumericState(root)
                else
                    root.tutorialPageCompleted()
            }
        }

        Item { width: 1; Layout.fillHeight: true }
        Item { width: 1; Layout.fillHeight: true }
    }

    state: "0"

    states: [
        State {
            name: "0"
            PropertyChanges {
                target: messageBackground
                opacity: 1
            }
        }, State {
            name: "1"
            PropertyChanges { target: tutorialHighlighter; opacity: 1 }
            PropertyChanges { target: messageBackgroundDettached; opacity: 1 }
            PropertyChanges {
                target: labelMessageDettached
                text: qsTr("Now press and hold a song, you will see the song menu, you can share your favorite songs there. This works while searching for music too!")
            }
        }, State {
            name: "2"
            extend: "1"
            PropertyChanges { target: searchButton; enabled: true }
            PropertyChanges { target: tutorialHighlighter; highlightedItem: searchButton }
            PropertyChanges {
                target: labelMessageDettached
                text: qsTr("This is the search button, press it!")
            }
        }
    ]

    transitions: [
        Transition {
            from: "0"
            to: "1"
            NumberAnimation { properties: "opacity" }
        }
    ]
}
