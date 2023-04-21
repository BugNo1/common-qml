import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Shapes 1.15

Item {
    id: itemSpeed
    width: 50
    height: 50

    property bool itemActive: false
    visible: false

    // used for collision detection (hitbox is a circle)
    property int hitboxRadius: 25
    property int hitboxX: 0
    property int hitboxY: 0
    signal hit(condition: bool, action: var)

    property int speed: 0

    onHit: function(condition, action) {
        if ((! keepVisibleTimer.running) && (! fadeOut.running)) {
            if (condition) {
                action(speed)
                speedText.text = speed
                hitSound.source = ""
                hitSound.source = "../common-media/impact.wav"
                hitSound.play()
                keepVisibleTimer.start()
            }
        }
    }

    onItemActiveChanged: {
        if (itemActive) {
            startTimer()
        } else {
            timer.stop()
            itemSpeed.visible = false
            dropSound.source = ""
            hitSound.source = ""
        }
    }

    function setRandomPosition() {
        x = Math.round(Math.random() * (mainWindow.width - 200)) + 100
        y = Math.round(Math.random() * (mainWindow.height - 200)) + 100
        hitboxX = x + width / 2
        hitboxY = y + height / 2
    }

    function startTimer() {
        timer.interval = Math.round(Math.random() * 30000) + 30000
        timer.start()
    }

    function setSpeed() {
        speed = (Math.round(Math.random() * 5) + 1) * 50
    }

    Timer {
        id: timer
        interval: 0
        running: false
        repeat: false
        onTriggered: {
            setRandomPosition()
            speedText.text = "?"
            setSpeed()
            itemSpeed.visible = true
            itemImage.opacity = 1
            speedText.opacity = 1
            dropSound.source = ""
            dropSound.source = "../common-media/item-drop.wav"
            dropSound.play()
        }
    }

    Timer {
        id: keepVisibleTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            fadeOut.start()
            startTimer()
        }
    }

    Image {
        id: itemImage
        anchors.fill: parent
        source: "../common-media/speed-sign.png"
    }

    Text {
        id: speedText
        font.family: "Ubuntu"
        font.pixelSize: 20
        font.bold: true
        color: "black"
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Audio {
        id: dropSound
        source: "../common-media/item-drop.wav"
    }

    Audio {
        id: hitSound
        source: "../common-media/invincible.wav"
    }

    PropertyAnimation {
        id: fadeOut
        targets: [itemImage, speedText]
        properties: "opacity"
        to: 0
        duration: 500
        onRunningChanged: {
            if (! fadeOut.running) {
                itemSpeed.visible = false
            }
        }
    }
}
