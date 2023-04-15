import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {
    property string borderColor: "white"
    property bool buttonPressed: false
    property bool buttonState: false

    property int currentSweepAngle: 0

    // to have antialiasing
    layer.enabled: true
    layer.samples: 4

    onButtonPressedChanged: {
        if (buttonPressed) {
            animationTimer.start()
        } else {
            buttonState = false
            animationTimer.stop()
            currentSweepAngle = 0
            borderPath.sweepAngle = currentSweepAngle
        }
    }

    Timer {
        id: animationTimer
        interval: 20
        running: false
        repeat: true
        onTriggered: {
            currentSweepAngle += 15
            borderPath.sweepAngle = currentSweepAngle
            if (currentSweepAngle >= 360) {
                buttonState = true
            }
        }
    }

    Shape {
        id: backgound
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        antialiasing: true
        ShapePath {
            fillColor: "black"
            strokeColor: "black"
            PathAngleArc {
                centerX: width / 2
                centerY: height / 2
                radiusX: (width / 2) - 2
                radiusY: (height / 2) - 2
                startAngle: 0
                sweepAngle: 360
            }
        }
    }

    Shape {
        id: border
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        antialiasing: true
        ShapePath {
            fillColor: "transparent"
            strokeColor: borderColor
            strokeWidth: 3
            PathAngleArc {
                id: borderPath
                centerX: width / 2
                centerY: height / 2
                radiusX: (width / 2) - 2
                radiusY: (height / 2) - 2
                // to start on top
                startAngle: -90
                sweepAngle: 0
            }
        }
    }

    Shape {
        id: cross
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        antialiasing: true
        ShapePath {
            strokeColor: "darkgrey"
            strokeWidth: 3
            startX: width / 4
            startY: height / 4
            PathLine {
                x: width - (width / 4)
                y: height - (height / 4)
            }
        }
        ShapePath {
            strokeColor: "darkgrey"
            strokeWidth: 3
            startX: width - (width / 4)
            startY: height / 4
            PathLine {
                x: width / 4
                y: height - (height / 4)
            }
        }
    }
}
