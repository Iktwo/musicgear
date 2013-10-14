import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Page {
    id: searchPage

    Item {
        id: searchBar

        width: parent.width
        height: txtFldSearch.height + 10

        TextField {
            id: txtFldSearch

            y: 5
            width: parent.width-120

            placeholderText: "Enter Song, Artist or Album"

            platformStyle: TextFieldStyle {
                paddingRight: clearButton.width
            }

            platformSipAttributes: SipAttributes {
                actionKeyLabel: "Search"
                actionKeyHighlighted: true
            }

            Keys.onReturnPressed: {
                if(txtFldSearch.text.length > 0) {
                    musicStreamer.search(txtFldSearch.text)
                    txtFldSearch.platformCloseSoftwareInputPanel()
                }
            }

            Image {
                id: clearButton

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                source: "image://theme/icon-m-input-clear"
                //visible: txtFldSearch.text != ""

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        inputContext.reset()
                        txtFldSearch.text = ""
                        searchBtn.focus = true
                    }
                }
            }
        }

        Button {
            width: 110
            height: txtFldSearch.height
            y: 5
            x: txtFldSearch.x + txtFldSearch.width + 5

            Image {
                source: "qrc:/images/search"
                x: parent.width / 2 - width / 2
                y: parent.height / 2 - height / 2
            }
            onClicked: {
                if (txtFldSearch.text.length > 0) {
                    /// TODO: check if result list is cleared
                    musicStreamer.search(txtFldSearch.text)
                    txtFldSearch.platformCloseSoftwareInputPanel()
                }
            }
        }
    }

    ListView {
        id: searchResultList

        height: searchPage.height - searchBar.height - 72
        width: parent.width

        y: searchBar.y + searchBar.height

        model: musicStreamer

        clip: true

        onFlickStarted: {
            txtFldSearch.platformCloseSoftwareInputPanel()
            searchBtn.focus = true

            if (atYEnd)
                musicStreamer.fetchMore()
        }

        delegate: SearchDelegate {
            onAddToPlaylist: playlist.append({   "name" : model.name,
                                                 "group" : model.group,
                                                 "length" : model.length,
                                                 "comment" : model.comment,
                                                 "code" : model.code,
                                                 "url": model.url })
        }
    }

    ScrollDecorator {
        flickableItem: searchResultList
    }

    BusyIndicator {
        id: searchBusyIndicator

        platformStyle: BusyIndicatorStyle { size: "large" }
        anchors.centerIn: parent
        visible: running
        running: musicStreamer.searching
    }
}
