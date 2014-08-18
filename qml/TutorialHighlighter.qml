import QtQuick 2.2

Item {
    property alias color: bakground.color
    property color borderColor: "#3498db"
    property alias highlightOpacity: effect.opacity
    property variant highlightedItem

    anchors.fill: parent

    Rectangle {
        id: bakground
        anchors.fill: parent
        color: "#2c3e50"
        visible: false
    }

    Rectangle {
        id: maskItem

        anchors.fill: parent
        color: "transparent"
        visible: false

        Rectangle {
            x: highlightedItem !== undefined ? highlightedItem.x + highlightedItem.width / 2 - width / 2 : 0
            y: highlightedItem !== undefined ? highlightedItem.y + highlightedItem.height / 2 - height / 2 : 0
            width: highlightedItem !== undefined ? highlightedItem.width * 1.4 : 0
            height: highlightedItem !== undefined ? highlightedItem.height * 1.4 : 0
            radius: height / 2
        }
    }

    DifferenceBlend {
        id: effect
        source: bakground
        mask: maskItem
        anchors.fill: parent
        opacity: 0.5
    }

    Rectangle {
        id: borderHighlighter
        x: highlightedItem !== undefined ? highlightedItem.x + highlightedItem.width / 2 - width / 2 : 0
        y: highlightedItem !== undefined ? highlightedItem.y + highlightedItem.height / 2 - height / 2 : 0
        width: highlightedItem !== undefined ? highlightedItem.width * 1.4 : 0
        height: highlightedItem !== undefined ? highlightedItem.height * 1.4 : 0
        radius: height / 2
        color: "transparent"
        border {
            width: 3 * ui.dpMultiplier
            color: borderColor
        }
    }

    /// TODO: position this, to avoid highlightedItem, add title and subtitle
}
