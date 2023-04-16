import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15

import Theme 1.0

Item {
    id: lifeIndicator
    width: 200
    height: parent.height

    property string imageSource: ""
    property string lifeLostAudioSource: ""
    property var model
    property var player

    property var lifeObjects: []

    Component.onCompleted: {
        model.maxLivesChanged.connect(onMaxLivesChanged)
        model.livesChanged.connect(onLivesChanged)
        model.lifeLost.connect(onLifeLost)
    }

    function onMaxLivesChanged() {
        for (var i = 0; i < model.maxLives; i++)  {
            var currentObject = Qt.createQmlObject('import QtQuick 2.15; Image { y: 29; width: 30; height: 30; rotation: 45; source: "' + imageSource + '"}',
                                                   lifeIndicator,
                                                   "lifeindicator");
            currentObject.x = Math.floor(width / (model.maxLives + 1)) * (i + 1) - 15
            lifeObjects.push(currentObject)
        }
    }

    function onLivesChanged() {
        for (var i = 0; i < model.lives; i++) {
            lifeObjects[i].visible = true
        }
        for (var j = model.lives; j < model.maxLives; j++) {
            lifeObjects[j].visible = false
        }
    }

    function onLifeLost() {
        lifeLostAudio.source = ""
        lifeLostAudio.source = lifeLostAudioSource
        lifeLostAudio.play()
    }

    Text {
        id: name
        width: parent.width
        text: player.name
        font.family: Theme.mainFont
        font.pixelSize: Theme.textFontSize
        color: Theme.lightTextColor
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
    }

    Rectangle {
        id: background
        width: parent.width
        height: 40
        anchors.top: name.bottom
        color: Theme.overlayBackgroundColor
        radius: 10
        border.width: Theme.overlayBorderWidth
        border.color: Theme.overlayBorderColor
    }

    Text {
        id: lastResult
        width: parent.width
        text: player.timeAchievedText + " (Level: " + player.levelAchieved + ")"
        font.family: Theme.mainFont
        font.pixelSize: Theme.smallTextFontSize
        color: Theme.lightTextColor
        visible: !model.enabled
        anchors.top: background.bottom
        horizontalAlignment: Text.AlignHCenter
    }

    Audio {
        id: lifeLostAudio
        source: lifeLostAudioSource
    }
}
