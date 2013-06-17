import QtQuick 2.0
import com.iktwo.components 1.0

Item {
    height: Math.max(column.height, row.height) + 20
    width: parent.width

    Column {
        id: column

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left; leftMargin: 10
            right: row.left; rightMargin: 10
        }

        Label {
            font.pointSize: 18
            text: model.name + " - <i>" + model.group + "</i>"
        }

        Label {
            font.pointSize: 16
            text: model.length + " - <i>" + model.comment + "</i>"
            color: Styler.darkTheme ? Style.SECONDARY_TEXT_COLOR_DARK : Style.SECONDARY_TEXT_COLOR_LIGHT
        }

        Item { // Spacer
            height: 20
            width: 1
        }
    }

    Divider {
        anchors {
            top: column.bottom
        }
    }

    Row {
        id: row

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right; anchors.rightMargin: 15

        height: 80
        spacing: 15

        Rectangle {
            height: 80
            width: 80

            color: "green"
            visible: model.url === "" ? false : true

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    audio.source = model.url
                    audio.play()
                }
            }
        }

        Rectangle {
            height: 80
            width: 80

            color: "red"
            visible: model.url === "" ? false : true

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    console.log("Download")
                    // downloader.downloadSong()
                }
            }
        }
    }
}
