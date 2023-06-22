import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtMultimedia 5.15

import Theme 1.0

Item {
    id: gameEndOverlay
    width: 400
    height: 570
    anchors.centerIn: parent

    property var gameType
    property var scoreType
    property var winner: GameData.winner
    property var signalStart
    property string highscoreAnimatedImageSource: ""
    property var nextState

    enum GameType {
        Coop,
        PvP
    }

    enum ScoreType {
        Level,
        Points
    }

    function onButtonPressed() {
        if (highscoreListItem.visible) {
            if (button1.buttonState && button2.buttonState) {
                signalStart()
                gameEndOverlay.destroy()
            }
        } else {
            if (gameType === GameEndOverlay.GameType.PvP) {
                if ((button1.buttonState && button1.visible) || (button2.buttonState && button2.visible)) {
                    nextState()
                }
            } else if (gameType === GameEndOverlay.GameType.Coop) {
                if (button1.buttonState && button2.buttonState) {
                    nextState()
                }
            }
        }
    }

    Component.onCompleted: {
        stateShowWinner()
    }

    Timer {
        id: stateTimer
        interval: 5000
        running: false
        repeat: false
        onTriggered: {
            nextState()
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Theme.overlayBackgroundColor
        radius: 10
        border.width: Theme.overlayBorderWidth
        border.color: Theme.overlayBorderColor
    }

    Item {
        id: winnerItem
        width: parent.width
        height: parent.height
        visible: false

        Image {
            id: winnerImage
            width: parent.width - 50
            height: parent.height / 2
            visible: false
            fillMode: Image.PreserveAspectFit
            source: "../common-media/winner.png"
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.horizontalCenter: parent.horizontalCenter
            ScaleAnimator {
                id: winnerImageAnimation
                target: winnerImage
                from: 0
                to: 1
                duration: 500
                running: false
            }
        }

        AnimatedImage {
            id: highscoreAnimatedImage
            width: parent.width - 50
            height: parent.height / 2
            fillMode: Image.PreserveAspectFit
            source: highscoreAnimatedImageSource
            visible: false
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: winnerHeadline
            text: "Herzlichen Glückwunsch:"
            font.family: Theme.mainFont
            font.pixelSize: Theme.headline2FontSize
            color: Theme.highlightTextColor
            width: parent.width
            anchors.top: winnerImage.bottom
            anchors.margins: 25
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: winnerName
            text: winner.name
            font.family: Theme.mainFont
            font.pixelSize: Theme.textFontSize
            color: Theme.lightTextColor
            width: parent.width
            anchors.top: winnerHeadline.bottom
            anchors.margins: 25
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: winnerResult
            text: {
                if (scoreType === GameEndOverlay.ScoreType.Level) {
                    winner.timeAchievedText + " (Level: " + winner.levelAchieved + ")"
                } else if (scoreType === GameEndOverlay.ScoreType.Points) {
                    "Punkte: " + winner.pointsAchieved
                }
            }
            font.family: Theme.mainFont
            font.pixelSize: Theme.textFontSize
            color: Theme.lightTextColor
            width: parent.width
            anchors.top: winnerName.bottom
            anchors.bottomMargin: 25
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Item {
        id: highscoreListItem
        width: parent.width
        height: parent.height
        visible: false

        Text {
            id: headline
            width: parent.width
            text: "Highscores"
            font.family: Theme.mainFont
            font.pixelSize: Theme.headline1FontSize
            color: Theme.lightTextColor
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            id: highscores
            width: 300
            height: highscoreTableViewHeader.height + highscoreTableView.height
            anchors.top: headline.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 25
            anchors.bottomMargin: 25

            HorizontalHeaderView {
                id: highscoreTableViewHeader
                width: parent.width
                syncView: highscoreTableView
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }

            TableView {
                id: highscoreTableView
                width: parent.width
                height: 300
                anchors.top: highscoreTableViewHeader.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                model: HighscoreData
                delegate: Rectangle {
                    implicitWidth: size
                    implicitHeight: 30
                    color: cellColor
                    clip: true
                    Text {
                        text: value
                        font.pixelSize: 13
                        anchors.centerIn: column === 1 ? undefined : parent
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Rectangle {
                width: parent.width + 6
                height: parent.height + 6
                color: "transparent"
                border.width: 3
                border.color: Theme.overlayBorderColor
                anchors.centerIn: parent
            }
        }

        Text {
            id: againText
            text: "Nochmal spielen:"
            font.family: Theme.mainFont
            font.pixelSize: Theme.textFontSize
            color: Theme.lightTextColor
            width: parent.width
            anchors.top: highscores.bottom
            anchors.margins: 25
            horizontalAlignment: Text.AlignHCenter
        }
    }

    RowLayout {
        id: buttonLayout
        width: parent.width
        height: 50
        visible: false
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        CrossButton {
            id: button1
            width: 50
            height: 50
            visible: false
            borderColor: "red"
            Layout.alignment: Qt.AlignCenter
            Connections {
                target: QJoysticks
                function onButtonChanged() {
                    button1.buttonPressed = QJoysticks.getButton(0, 0)
                }
            }
            onButtonStateChanged: {
                onButtonPressed()
            }
        }
        CrossButton {
            id: button2
            width: 50
            height: 50
            visible: false
            borderColor: "blue"
            Layout.alignment: Qt.AlignCenter
            Connections {
                target: QJoysticks
                function onButtonChanged() {
                    button2.buttonPressed = QJoysticks.getButton(1, 0)
                }
            }
            onButtonStateChanged: {
                onButtonPressed()
            }
        }
    }

    Audio {
        id: sound
        source: "../common-media/win.wav"
    }

    function stateShowWinner() {
        winnerItem.visible = true
        winnerImage.visible = true
        winnerImageAnimation.running = true
        sound.play()
        if (GameData.newHighscore) {
            nextState = stateShowHighScore
        } else {
            nextState = stateShowHighScoreList
        }
        stateTimer.start()
    }

    function stateShowHighScore() {
        winnerImage.source = "../common-media/highscore.png"
        winnerImageAnimation.start()
        sound.source = "../common-media/highscore.wav"
        sound.play()
        nextState = stateShowHighScoreAnimatedImage
        stateTimer.start()
    }

    function stateShowHighScoreAnimatedImage() {
        winnerImage.visible = false
        highscoreAnimatedImage.visible = true
        highscoreAnimatedImageSource = gifPath + "winner" + (Math.round(Math.random() * 24) + 1).toString().padStart(2, "0") + ".gif"
        sound.source = "../common-media/highscore-music.mp3"
        sound.loops = Audio.Infinite
        sound.play()
        buttonLayout.visible = true
        if (gameType === GameEndOverlay.GameType.PvP) {
            if (winner.playerId === 1) {
                button1.visible = true
            } else {
                button2.visible = true
            }
        } else if (gameType === GameEndOverlay.GameType.Coop) {
            button1.visible = true
            button2.visible = true
        }

        nextState = stateShowHighScoreList
    }

    function stateShowHighScoreList() {
        winnerItem.visible = false
        highscoreListItem.visible = true
        buttonLayout.visible = true
        button1.visible = true
        button2.visible = true
        sound.stop()
    }
}
