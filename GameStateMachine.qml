import QtQuick 2.15
import QtQml.StateMachine 1.15 as DSM

Item {
    property var gameResetAction: function f() {}
    property var gameCountdownAction: function f() {}
    property var gameStartAction: function f() {}
    property var gameStopAction: function f() {}

    signal signalResetGame()
    signal signalStartCountdown()
    signal signalStartGame()
    signal signalStopGame()

    DSM.StateMachine {
        id: stateMachine
        initialState: resetState
        running: true

        DSM.State {
            id: resetState
            DSM.SignalTransition {
                targetState: countdownState
                signal: signalStartCountdown
            }
            onEntered: gameResetAction()
        }
        DSM.State {
            id: countdownState
            DSM.SignalTransition {
                targetState: gameRunningState
                signal: signalStartGame
            }
            onEntered: gameCountdownAction()
        }
        DSM.State {
            id: gameRunningState
            DSM.SignalTransition {
                targetState: gameStoppedState
                signal: signalStopGame
            }
            DSM.SignalTransition {
                targetState: countdownState
                signal: signalStartCountdown
            }
            onEntered: gameStartAction()
        }
        DSM.State {
            id: gameStoppedState
            DSM.SignalTransition {
                targetState: resetState
                signal: signalResetGame
            }
            onEntered: gameStopAction()
        }
    }
}
