import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import "components" as Components

Components.Page {
    id: root

    titleBar: Components.TitleBar {
        id: titleBar

        enabled: parent.enabled

        Components.TitleBarImageButton {
            anchors.left: parent.left
            source: "qrc:/images/" + uiValues.getBestIconSize(Math.min(icon.height, icon.width)) + "back"

            onClicked: stackview.pop()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#e5e5e5"

        ScrollView {
            id: scrollView

            anchors {
                fill: parent
                margins: 4 * uiValues.dpMultiplier
            }

            flickableItem.interactive: true; focus: true

            Flickable {
                width: scrollView.width
                contentWidth: scrollView.width
                contentHeight: column.height
                flickableDirection: Flickable.VerticalFlick

                Column {
                    id: column

                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width

                    spacing: 4 * uiValues.dpMultiplier

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
    }
}
