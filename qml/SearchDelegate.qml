import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Item {
    id: root

    signal addToPlaylist()

    height: 80
    width: parent.width
    visible: model.url !== ""

    Label {
        anchors {
            left: parent.left
            right: addButton.left
        }

        font {
            pointSize: 9
            weight: Font.Light
        }

        elide: Text.ElideRight
        text: model.name + " - " + model.group
        height: parent.height / 2
        // TODO: add a dialog to show full name in case it's too long
        clip: true
    }

    Label {
        anchors {
            left: parent.left
            right: addButton.left
            bottom: parent.bottom
        }

        font {
            pointSize: 8
            weight: Font.Light
        }

        elide: Text.ElideRight
        text: model.length + " - " + model.comment
        height: parent.height / 2
        clip: true
    }

    Button {
        id: addButton

        anchors {
            right: parent.right; rightMargin: 15
            verticalCenter: parent.verticalCenter
        }

        iconSource: "qrc:/images/add_playlist"
        width: 80

        onClicked: {
            addToPlaylist()
            downloadingBanner.text = "Added " + (model.name.length > 20 ? model.name.substring(0, 20) + "..." : model.name) + " to the playlist"
            downloadingBanner.show()
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom

        width: parent.width
        height: 2

        color: "#515151"
    }
}
