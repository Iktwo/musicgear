import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Dialog {
    id: root

    TitleBar {
        id: titleBar

        enabled: parent.enabled

        TitleBarImageButton {
            anchors.left: parent.left
            source: "qrc:/images/" + getBestIconSize(Math.min(icon.height, icon.width)) + "back"

            onClicked: aboutDialog.close()
        }
    }

    ScrollView {
        id: scrollView

        anchors {
            top: titleBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: dpi * 0.06
        }

        flickableItem.interactive: true; focus: true

        Column {
            width: scrollView.width

            spacing: dpi * 0.06

            Label {
                width: parent.width
                horizontalAlignment: "AlignHCenter"
                wrapMode: "Wrap"
                text: "Musicgear"
            }

            Label {
                width: parent.width
                textFormat: Text.RichText
                horizontalAlignment: "AlignHCenter"
                wrapMode: "Wrap"
                text: qsTr("Stream your favorite music from <a href=\"http://goear.com\">Goear</a>")

                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                width: parent.width
                textFormat: Text.RichText
                horizontalAlignment: "AlignHCenter"
                wrapMode: "Wrap"
                text: qsTr("Icons under <a href=\"http://creativecommons.org/licenses/by/3.0/legalcode\">CC 3.0</a> by <a href=\"http://www.freepik.com/\">Freepik</a>")

                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                width: parent.width
                textFormat: Text.RichText
                horizontalAlignment: "AlignHCenter"
                wrapMode: "Wrap"
                text: qsTr("Built on") + " " + buildDate

                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
    }
}
