import QtQuick 2.0
import Styler 1.0
import "style.js" as Style

Item {
    id: root

    readonly property bool opened: false

    function open() {
        state = "opened"
    }

    function close() {
        state = "closed"
    }

    anchors.fill: parent

    state: "closed"

    z: 9999

    enabled: root.state === "opened"

    MouseArea { // mouse eater
        anchors.fill: parent
    }

    Rectangle {
        anchors.fill: parent

        color: Styler.darkTheme ? Style.MENU_BACKGROUND_COLOR_DARK : Style.MENU_BACKGROUND_COLOR_LIGHT

        TitleBar {
            id: titleBar

            TitleBarImageButton {
                anchors.left: parent.left

                source: Styler.darkTheme ? "qrc:/images/back_dark" : "qrc:/images/back_light"

                onClicked: root.close()
            }

            TitleBarTextInput {
                id: textEdit

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                placeholderText: "Artist, Song"

                focus: true

                onSubmit: {
                    if (!downloaderComponent.searching)
                        downloaderComponent.search(textEdit.text)
                }
            }

            TitleBarImageButton {
                anchors.right: parent.right

                source: Styler.darkTheme ? "qrc:/images/search_dark" : "qrc:/images/search_light"

                onClicked: {
                    if (!downloaderComponent.searching)
                        downloaderComponent.search(textEdit.text)
                }
            }
        }

        ListView {
            anchors {
                top: titleBar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            model: downloaderComponent
            clip: true

            delegate: SongDelegate {
                onAddToPlaylist: playlist.append({"name" : model.name, "group" : model.group, "length" : model.length, "comment" : model.comment, "code" : model.code, "url": model.url})

                onDownload: downloaderComponent.downloadSong(model.name, model.url)
            }

            onContentYChanged: {
                if (contentHeight != 0)
                    if (((contentY + height) / contentHeight) > 0.85)
                        downloaderComponent.fetchMore()
            }
        }

        Label {
            anchors.centerIn: parent

            text: "Searching.."
            opacity: downloaderComponent.searching ? 1 : 0
        }
    }

    states: [
        State {
            name: "opened"
            PropertyChanges { target: root; opacity: 1; scale: 1 }
        },
        State {
            name: "closed"
            PropertyChanges { target: root; opacity: 0; scale: 0.5 }
        }
    ]

    transitions: [
        Transition {
            from: "opened"
            to: "closed"
            ParallelAnimation {
                NumberAnimation { properties: "scale"; easing.type: "InOutQuad" }
                NumberAnimation { properties: "opacity"; easing.type: "InOutQuad" }
            }
        },
        Transition {
            from: "closed"
            to: "opened"
            ParallelAnimation {
                NumberAnimation { properties: "scale"; easing.type: "InOutQuad" }
                NumberAnimation { properties: "opacity"; easing.type: "InOutQuad" }
            }
        }
    ]
}
