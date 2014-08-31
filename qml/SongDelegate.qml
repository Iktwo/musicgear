import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import com.iktwo.components 1.0
import "components" as ThisComponents
import "components/style.js" as Style

Item {
    id: root

    signal addToPlaylist()
    signal download()
    signal pressAndHold()

    function colorForKbps(kbps) {
        // 320, 256, 192, 128, 64
        if (kbps === 0)
            return "#2c3e50"
        else if (kbps < 64)
            return "#e74c3c"
        else if (kbps < 112)
            return "#d35400"
        else if (kbps < 128)
            return "#f39c12"
        else if (kbps < 192)
            return "#e67e22"
        else if (kbps < 256)
            return "#48C9B0"
        else if (kbps < 320)
            return "#27ae60"
        else
            return "#2ecc71"
    }

    height: 84 * ui.dpMultiplier
    width: parent.width

    RowLayout {
        anchors.fill: parent

        Image {
            id: imageAlbum

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left; leftMargin: 8 * ui.dpMultiplier
            }

            antialiasing: true
            Layout.preferredHeight: 68 * ui.dpMultiplier
            Layout.preferredWidth: 68 * ui.dpMultiplier
            fillMode: Image.PreserveAspectCrop
            source: "http://www.goear.com/band/picture/" + model.picture
        }

        Item {
            Layout.preferredWidth: 8 * ui.dpMultiplier
            Layout.fillHeight: true
        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Label {
                id: songName

                font.pixelSize: 14 * ui.dpMultiplier

                Layout.fillWidth: true
                color: Style.TEXT_COLOR_DARK
                elide: Text.ElideRight
                text: model.name + " - <i>" + model.group + "</i>"
                renderType: Text.NativeRendering
                maximumLineCount: 1
            }

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: 12 * ui.dpMultiplier

                    elide: Text.ElideRight
                    color: Style.TEXT_SECONDARY_COLOR_DARK
                    text: model.length + (model.comment !== "" && model.length !== "" ? " - "  : "") + model.comment
                    width: parent.width
                    renderType: Text.NativeRendering
                    maximumLineCount: 1
                }

                Rectangle {
                    anchors.right: parent.right

                    radius: height * 0.1
                    color: colorForKbps(model.kbps)
                    Layout.preferredHeight: labelKbps.height * 1.1
                    Layout.preferredWidth: labelKbps.width * 1.1

                    Label {
                        id: labelKbps

                        anchors.centerIn: parent

                        font.pixelSize: 12 * ui.dpMultiplier

                        color: Style.TEXT_COLOR_LIGHT
                        elide: Text.ElideRight
                        text: model.kbps + "kbps " //+ model.hits
                        renderType: Text.NativeRendering
                        maximumLineCount: 1
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                font.pixelSize: 12 * ui.dpMultiplier

                elide: Text.ElideRight
                color: Style.TEXT_SECONDARY_COLOR_DARK
                text: "▶ " + model.hits
                width: parent.width
                renderType: Text.NativeRendering
            }
        }

        RowLayout {
            id: row

            anchors.right: parent.right

            spacing: 4 * ui.dpMultiplier
            Layout.preferredWidth: spacing + (48 * ui.dpMultiplier * 2)
            Layout.fillHeight: true

            Item {
                Layout.fillHeight: true
                Layout.preferredWidth: 48 * ui.dpMultiplier

                ImageButton {
                    anchors.fill: parent
                    source: "qrc:/images/" + ui.getBestIconSize(Math.min(icon.height, icon.width)) + "add_to_playlist"
                    visible: model.url === "" ? false : true

                    onClicked: root.addToPlaylist()
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.preferredWidth: 48 * ui.dpMultiplier

                ImageButton {
                    anchors.fill: parent
                    source: "qrc:/images/" + ui.getBestIconSize(Math.min(icon.height, icon.width)) + "download"
                    visible: model.url === "" ? false : true

                    onClicked: root.download()
                }
            }
        }
    }

    Rectangle {
        color: "#55bdc3c7"
        height: 1 * ui.dpMultiplier
        width: parent.width
    }
}
