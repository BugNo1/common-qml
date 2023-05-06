import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Shapes 1.15

Item {
    id: collectibleItem
    width: 50
    height: 50

    property int minimalWaitTime: 30000
    property string itemImageSource: ""
    property string hitSoundSource: ""
    property string dropSoundSource: "../common-media/item-drop.wav"
    property bool itemActive: false
    visible: false

    // used for collision detection (hitbox is a circle)
    property int hitboxRadius: 25
    property int hitboxX: 0
    property int hitboxY: 0
    signal hit(condition: bool, action: var)

    property var actionAppend: function func() {}
    property var timerTriggeredAppend: function func() {}

    onHit: function(condition, action) {
        if (condition) {
            action()
            collectibleItem.visible = false
            hitSound.source = ""
            hitSound.source = hitSoundSource
            hitSound.play()
            startTimer()
            actionAppend()
        }
    }

    onItemActiveChanged: {
        if (itemActive) {
            startTimer()
        } else {
            timer.stop()
            collectibleItem.visible = false
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
        timer.interval = Math.round(Math.random() * minimalWaitTime) + minimalWaitTime
        timer.start()
    }

    Timer {
        id: timer
        interval: 0
        running: false
        repeat: false
        onTriggered: {
            setRandomPosition()
            collectibleItem.visible = true
            dropSound.source = ""
            dropSound.source = dropSoundSource
            dropSound.play()
            timerTriggeredAppend()
        }
    }

    Image {
        id: itemImage
        anchors.fill: parent
        source: itemImageSource
    }

    Audio {
        id: dropSound
        source: dropSoundSource
    }

    Audio {
        id: hitSound
        source: hitSoundSource
    }
}
