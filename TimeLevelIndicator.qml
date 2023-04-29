import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15

import Theme 1.0

Item {
    id: timeLevelIndicator
    height: 40
    width: 300

    signal setLevel(level: int)
    signal setTime(time: string)

    onSetLevel: function(level) {
        levelText.text = "Level: " + level
    }

    onSetTime: function(time) {
        timeText.text = getTimeString(time)
    }

    function getTimeString(time) {
        var s = Math.floor((time / 1000) % 60).toString().padStart(2, "0")
        var m = Math.floor(time / 1000 / 60).toString().padStart(2, "0")
        return m + ":" + s
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Theme.overlayBackgroundColor
        radius: 10
        border.width: Theme.overlayBorderWidth
        border.color: Theme.overlayBorderColor
    }

    Text {
        id: levelText
        x: 25
        y: 3
        font.pointSize: 18
        font.family: "Courier"
        text: "Level:"
        color: Theme.darkTextColor
    }

    Text {
        id: timeText
        x: 195
        y: 3
        font.pointSize: 18
        font.family: "Courier"
        text: "00:00"
        color: Theme.darkTextColor
    }
}
