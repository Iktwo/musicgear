import QtQuick 2.2

Item {
    id: root

    /// TODO: think about how to fix "Cannot assign object to list"
    default property alias content: contentItem.children
    property alias titleBar: titleBarContainer.children

    signal activated

    Connections {
        target: stackview

        onCurrentItemChanged: {
            if (stackview.currentItem == root)
                root.activated()
        }
    }

    Item {
        id: titleBarContainer

        height: childrenRect.height
        width: parent.width
    }

    Item {
        id: contentItem

        anchors {
            top: titleBarContainer.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }
}
