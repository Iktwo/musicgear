import QtQuick 2.1
import QtQuick.Controls 1.1
import Styler 1.0
import QtQuick.Window 2.1
import "."

ApplicationWindow {
    id: root

    property int dpi: Screen.pixelDensity * 25.4

    height: 720
    width: 720
    visible: true

    MainPage {
        id: mainPage
    }



    Menu {
        id: mainMenu

        MenuTextItem {
            text: Styler.darkTheme ? qsTr("Light theme") : qsTr("Dark theme")
            onClicked: Styler.darkTheme = !Styler.darkTheme
        }

        MenuTextItem {
            text: qsTr("About MusicGear")
            onClicked: aboutDialog.open()
        }
    }
}
