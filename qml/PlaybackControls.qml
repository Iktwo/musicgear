import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import com.iktwo.components 1.0

Item {
    width: parent.width
    height: playButton.height + progressBar.height + 10

    Button {
        id: playButton

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        iconSource: audio.playbackState === AudioComponent.Playing ? "qrc:/images/pause" : "qrc:/images/play"

        width: 100

        onClicked: {
            if (audio.playbackState === AudioComponent.Playing)
                audio.pause()
            else
                audio.play()
        }
    }

    ProgressBar {
        id: progressBar

        anchors.bottom: parent.bottom

        width: parent.width
        minimumValue: 0
        maximumValue: audio.totalTime
        value: audio.currentTime
    }

    //Row {
    //  spacing: 15

    /*Button {
            iconSource: "qrc:/images/previous"

            width: 100
        }*/

    /*Button {
            iconSource: "qrc:/images/next"

            width: 100
        }*/
    //}


}
