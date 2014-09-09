import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import com.iktwo.components 1.0

Page {
    id: root

    titleBar: TitleBar {
        id: titleBar

        enabled: parent.enabled

        ImageButton {
            anchors.left: parent.left
            source: "qrc:/images/" + Theme.getBestIconSize(Math.min(icon.height, icon.width)) + "back"

            onClicked: stackView.pop()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#e5e5e5"

        ScrollView {
            id: scrollView

            anchors {
                fill: parent
                margins: 4 * ScreenValues.dpMultiplier
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

                    spacing: 4 * ScreenValues.dpMultiplier

                    Label {
                        width: parent.width
                        horizontalAlignment: "AlignHCenter"
                        wrapMode: "Wrap"
                        text: "Musicgear by <a href=\"http://iktwo.com\">Iktwo</a>"
                        color: Theme.mainTextColor
                        linkColor: color

                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                    Item {
                        height: ScreenValues.dpMultiplier * 8
                        width: 1
                    }

                    Label {
                        width: parent.width
                        horizontalAlignment: "AlignHCenter"
                        wrapMode: "Wrap"
                        text: qsTr("Stream your favorite music from <a href=\"http://goear.com\">Goear</a>")
                        color: Theme.mainTextColor
                        linkColor: color

                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                    Label {
                        width: parent.width
                        horizontalAlignment: "AlignHCenter"
                        wrapMode: "Wrap"
                        text: qsTr("Icons under <a href=\"http://creativecommons.org/licenses/by/3.0/legalcode\">CC 3.0</a> by <a href=\"http://www.freepik.com/\">Freepik</a>")
                        color: Theme.mainTextColor
                        linkColor: color

                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                    Label {
                        width: parent.width
                        horizontalAlignment: "AlignHCenter"
                        wrapMode: "Wrap"
                        text: qsTr("Built on") + " " + buildDate
                        color: Theme.mainTextColor
                        linkColor: color

                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                    Item {
                        height: ScreenValues.dpMultiplier * 8
                        width: 1
                    }

                    Label {
                        width: parent.width
                        horizontalAlignment: "AlignHCenter"
                        wrapMode: "Wrap"
                        text: qsTr("Source code is available at <a href=\"http://github.com/iktwo/musicgear\">Github</a>")
                        color: Theme.mainTextColor
                        linkColor: color

                        onLinkActivated: Qt.openUrlExternally(link)
                    }
                }
            }
        }
    }
}
