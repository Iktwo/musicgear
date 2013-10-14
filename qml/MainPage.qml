import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Page {
    id: main

    tools: commonTools

    TitleBar {
        id: titleBar

        tittle: "MusicGear"
        author: "By Iktwo"
        color: "darkviolet"
        authorLink: "http://iktwo.com"
        logoWidth: 0
        z: 1
    }

    ListModel {
        id: playlist

        /*onRowsInserted: {
            // If new item is first on list, play it
            if (count === 1) {
                toolBar.song = playlist.get(0).name + " - <i>" + playlist.get(0).group + "</i>"
                audio.source = playlist.get(0).url
                audio.play()
            }
        }*/
    }

    TabGroup {
        id: tabgroup

        anchors {
            top: titleBar.bottom
            bottom: parent.Bottom; //bottomMargin:300
            //bottom: commonTools.top
        }

        currentTab: searchPage

        SearchPage {
            id: searchPage

            orientationLock: PageOrientation.LockPortrait
        }

        /*DownloadPage {
            id: downloadPage

            orientationLock: PageOrientation.LockPortrait
        }*/

        PlaylistPage {
            id: listenPage

            orientationLock: PageOrientation.LockPortrait
        }
    }

    ToolBarLayout {
        id: commonTools

        ButtonRow {
            checkedButton: dialBtn
            style: TabButtonStyle { }

            TabButton {
                id: searchBtn

                tab: searchPage

                Image {
                    x: parent.width / 2 - width / 2
                    y: parent.height / 2 - height / 2
                    source: "qrc:/images/search"
                }

                onClicked: myMenu.close()
            }

            TabButton {
                id: listenBtn

                tab: listenPage

                Image {
                    x: parent.width / 2 - width / 2
                    y: parent.height / 2 - height / 2
                    source: "qrc:/images/listen"
                }

                onClicked: myMenu.close()
            }
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"

            anchors.right: parent === undefined ? undefined : parent.right

            onClicked: myMenu.status === DialogStatus.Closed ? myMenu.open() : myMenu.close()
        }
    }

    InfoBanner {
        id: messageBanner

        //timerEnabled: true
        //timerShowTime: 2500
        z: 9
    }

    InfoBanner {
        id: downloadingBanner

        timerEnabled: true
        timerShowTime: 750
        z: 9
    }
}
