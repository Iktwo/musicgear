import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import com.iktwo.components 1.0

ButtonStyle {
    id: buttonStyle

    background: Rectangle {
        height: buttonStyle.control.height
        width: buttonStyle.control.width
        color: control.pressed ? Qt.darker(Theme.titleBarColor) : Theme.titleBarColor
    }

    label: Label {
        color: control.pressed ? Qt.darker(Theme.titleBarTextColor) : Theme.titleBarTextColor
        text: buttonStyle.control.text
        font.pixelSize: buttonStyle.control.height * 0.5
        renderType: "NativeRendering"
        verticalAlignment: "AlignVCenter"
        horizontalAlignment: "AlignHCenter"
    }
}
