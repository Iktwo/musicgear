import QtQuick 1.1
import "style.js" as Style

FocusScope {
    id: root

    property alias text: textEdit.text
    property alias placeholderText: placeholderLabel.text

    signal submit

    width: highlighter.width
    height: textEdit.height + highlighter.height

    Label {
        id: placeholderLabel

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        color: Qt.darker(textEdit.color)
        elide: Text.ElideRight

        font {
            pointSize: 12
            weight: Font.Light
        }

        opacity: textEdit.text === "" ? 0.8 : 0

        width: 320

        Behavior on opacity { NumberAnimation { } }
    }

    TextInput {
        id: textEdit

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        clip: true
        color: Styler.darkTheme ? Style.TEXT_COLOR_DARK : Style.TEXT_COLOR_LIGHT


        focus: true

        font {
            pointSize: 18
            weight: Font.Light
        }

        Keys.onPressed: {
            if ((!event.isAutoRepeat ) && (event.key === Qt.Key_Enter
                                               || event.key === Qt.Key_Return)) {
                event.accepted = true;
                root.submit()
            }
        }

        selectByMouse: true

        width: 320
    }

    TitleBarImageButton {
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }

        source: Styler.darkTheme ? "qrc:/images/clear_dark" : "qrc:/images/clear_light"

        onClicked: textEdit.text = ""
    }

    Rectangle {
        id: highlighter

        anchors {
            top: textEdit.bottom
            left: textEdit.left
            right: textEdit.right; rightMargin: -80
        }

        height: 1

        color: Styler.darkTheme ? Qt.lighter(Style.TEXT_COLOR_DARK) : Qt.darker(Style.TEXT_COLOR_LIGHT)
    }
}
