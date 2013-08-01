import QtQuick 2.0
import Styler 1.0
import "style.js" as Style

Dialog {
    id: root

    function search() {
        if (!downloaderComponent.searching)
            if (textEdit.text.length > 0) {
                downloaderComponent.search(textEdit.text)
                vkControl.close()
            }
    }

    onOpenedChanged: {
        if (opened)
            textEdit.focus = true
        else
            vkControl.close()
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

            TitleBarTextInput {
                id: textEdit

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                placeholderText: "Artist, Song"

                focus: true

                onSubmit: root.search()
            }

            TitleBarImageButton {
                anchors.right: parent.right

                source: Styler.darkTheme ? "qrc:/images/search_dark"
                                         : "qrc:/images/search_light"

                onClicked: root.search()
            }
        }

        ListView {
            id: resultsList

            anchors {
                top: titleBar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            model: downloaderComponent
            clip: true

            delegate: SongDelegate {
                onAddToPlaylist: playlist.append({   "name" : model.name,
                                                     "group" : model.group,
                                                     "length" : model.length,
                                                     "comment" : model.comment,
                                                     "code" : model.code,
                                                     "url": model.url })

                onDownload: downloaderComponent.downloadSong(model.name, model.url)
            }

            onContentYChanged: {
                vkControl.close()
                if (contentHeight != 0)
                    //if (((contentY + height) / contentHeight) > 0.85)
                    if (atYEnd)
                        downloaderComponent.fetchMore()
            }
        }

        Rectangle {
            anchors.fill: parent

            color: "#88000000"
            opacity: downloaderComponent.searching ? 1 : 0

            Label {
                anchors.centerIn: parent

                text: "Searching.."
            }
        }
    }

    //    states: [
    //        State {
    //            when: root.opened
    //            name: "opened"
    //            PropertyChanges { target: root; opacity: 1; scale: 1 }
    //        },
    //        State {
    //            when: !root.opened
    //            name: "closed"
    //            PropertyChanges { target: root; opacity: 0; scale: 0.5 }
    //        }
    //    ]

    //    transitions: [
    //        Transition {
    //            from: "opened"
    //            to: "closed"
    //            ParallelAnimation {
    //                NumberAnimation { properties: "scale"; easing.type: "InOutQuad" }
    //                NumberAnimation { properties: "opacity"; easing.type: "InOutQuad" }
    //            }
    //        },
    //        Transition {
    //            from: "closed"
    //            to: "opened"
    //            ParallelAnimation {
    //                NumberAnimation { properties: "scale"; easing.type: "InOutQuad" }
    //                NumberAnimation { properties: "opacity"; easing.type: "InOutQuad" }
    //            }
    //        }
    //    ]
}
