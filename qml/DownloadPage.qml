import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Page{
    id: downloadPage;

    Rectangle{
        id: downloadBar;
        width: parent.width
        height: lblDownloadQueue.height+10
        color: "black"
        z:1

        Label{
            id: lblDownloadQueue
            text: "Download Queue:"
            font.pixelSize: 32;
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    ListView {
        id: downloadList
        y: downloadBar.y + downloadBar.height
        height: downloadPage.height - downloadBar.height - 72;
        width: downloadPage.width
        model: downloadQueueModel

        delegate: ListDelegate{

            Label {
                id: lblSongName;
                text: songname
                anchors.fill: parent
            }

            MouseArea{
                id: btnRemove;
                height: parent.height
                width: 50;
                anchors.right: parent.right;

                Image{
                    source: "qrc:/images/remove.png";
                    anchors.verticalCenter: parent.verticalCenter
                }

                onClicked: {
                    QMLAccess.removeFromDownloadQueue(code);
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: searchResultList
    }
}
