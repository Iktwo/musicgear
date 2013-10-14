import QtQuick 1.1
import com.nokia.meego 1.0
import com.iktwo.components 1.0

PageStackWindow {
    id: appWindow

    initialPage: mainPage

    AudioComponent {
        id: audio

        /*onSourceChanged: console.log("Source changed:", source)

        onPlaybackStateChanged: {
            if (playbackState === AudioComponent.Playing)
                console.log("Playing")
            else if (playbackState === AudioComponent.Paused)
                console.log("Paused")
            else if (playbackState === AudioComponent.Stopped)
                console.log("Stopped")
            else if (playbackState === AudioComponent.Loading)
                console.log("Loading")
            else if (playbackState === AudioComponent.Buffering)
                console.log("Buffering")
            else if (playbackState === AudioComponent.Error)
                console.log("Error")

        }*/
    }

    MainPage {
        id: mainPage

        orientationLock: PageOrientation.LockPortrait

        Component.onCompleted: {
            orientationLock = PageOrientation.LockPortrait
            theme.inverted = true
        }
    }

    ToolBarLayout {
        id: settingsTools

        visible: false

        ToolIcon {
            platformIconId: "toolbar-back"

            anchors.left: parent === undefined ? undefined : parent.left

            onClicked: {
                pageStack.pop()
                myMenu.close()
            }
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"

            anchors.right: parent === undefined ? undefined : parent.right

            onClicked: myMenu.status === DialogStatus.Closed ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu

        visualParent: pageStack

        MenuLayout {
            MenuItem {
                text: qsTr("About MusicGear")

                onClicked: aboutDialog.open()
            }
        }
    }

    AboutDialog{
        id: aboutDialog
    }
}
