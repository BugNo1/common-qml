import QtQuick 2.15

import Theme 1.0

Item {
    id: playerNameInput
    width: parent.width
    height: 35
    anchors.horizontalCenter: parent.horizontalCenter

    property string imageSource: ""
    property var player

    Component.onCompleted: {
        player.nameChanged.connect(changePlayerName)
        changePlayerName()
    }

    // should not be necessary for Qt 6.X
    // https://bugreports.qt.io/browse/QTBUG-29676
    Component.onDestruction: {
        player.nameChanged.disconnect(changePlayerName)
    }

    function changePlayerName() {
        nameInput.text = player.name
    }

    Image {
        id: playerIcon
        width: 30
        height: 30
        rotation: 45
        source: imageSource
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.rightMargin: 25
    }

    Rectangle {
        id: playerName
        width: parent.width - 130
        height: 35
        color: Theme.overlayBackgroundColor
        radius: 10
        border.width: Theme.overlayBorderWidth
        border.color: Theme.overlayBorderColor
        anchors.left: playerIcon.right
        anchors.leftMargin: 25
        anchors.rightMargin: 25

        MouseArea {
            anchors.fill: parent
            onClicked: { nameInput.focus = true }
        }

        TextInput {
            id: nameInput
            anchors.centerIn: parent
            font.family: Theme.mainFont
            font.pixelSize: Theme.textFontSize
            color: Theme.lightTextColor
            onTextEdited: {
                player.name = text
            }
        }
    }
}
