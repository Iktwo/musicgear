import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import com.iktwo.components 1.0

Dialog {
    id: root

    property UpdateChecker updateCheckerElement

    buttons: [
        Button {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            text: qsTr("Update")
            height: 40 * ScreenValues.dpMultiplier
            Layout.preferredHeight: 40 * ScreenValues.dpMultiplier
            width: Math.min(root.width / 2.5, 220 * ScreenValues.dpMultiplier)
            Layout.preferredWidth: Math.min(root.width / 2.5, 220 * ScreenValues.dpMultiplier)
            style: FlatButtonStyle { }
            onClicked: updateCheckerElement.openPackageOnGooglePlay()
        },
        Button {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            text: qsTr("Skip")
            height: 40 * ScreenValues.dpMultiplier
            Layout.preferredHeight: 40 * ScreenValues.dpMultiplier
            width: Math.min(root.width / 2.5, 220 * ScreenValues.dpMultiplier)
            Layout.preferredWidth: Math.min(root.width / 2.5, 220 * ScreenValues.dpMultiplier)
            style: FlatButtonStyle { backgroundColor: "#cccccc"; fontColor: "#757575" }

            onClicked: root.close()
        },
        Button {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            text: qsTr("Skip until next")
            height: 40 * ScreenValues.dpMultiplier
            Layout.preferredHeight: 40 * ScreenValues.dpMultiplier
            width: Math.min(root.width / 2.5, 220 * ScreenValues.dpMultiplier)
            Layout.preferredWidth: Math.min(root.width / 2.5, 220 * ScreenValues.dpMultiplier)
            style: FlatButtonStyle { backgroundColor: "#cccccc"; fontColor: "#757575" }

            onClicked: {
                /// TODO: store skipped version, if new version is greater than skipped then show dialog
                root.close()
            }
        }
    ]
}
