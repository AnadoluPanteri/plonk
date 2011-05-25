import Qt 4.7
import com.meego 1.0

Item {
    id: playfield

    width: 400
    height: 400

    function collisionCheck(paddleObj, ballObj, isTop) {
        if (ballObj.x > paddleObj.x &&
            (ballObj.x + ballObj.width) < (paddleObj.x + paddleObj.width)) {
            /* horizontal collision */
            if (isTop) {
                if (ballObj.y < paddleObj.height) {
                    /* vertical collision */
                    ballObj.velocityY *= -1
                    ballObj.y = paddleObj.height
                }
            } else {
                if ((ballObj.y + ballObj.height) > (playfield.height - paddleObj.height)) {
                    ballObj.velocityY *= -1
                    ballObj.y = (playfield.height - paddleObj.height - ballObj.height)
                }
            }
        }
    }

    Text {
        id: score1
        font.pixelSize: 60
        font.bold: true
        color: "blue"
        text: paddle1.score

        anchors {
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
    }

    Text {
        id: score2
        font.pixelSize: 60
        font.bold: true
        color: "red"
        text: paddle2.score

        anchors {
            right: parent.right
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }
    }

    Item {
        id: bottomHalf
        height: parent.height / 2
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Paddle {
            id: paddle1
            x: tp1.x - paddle1.width / 2
            anchors.bottom: parent.bottom
        }

        TouchArea {
            id: touchArea1
            anchors.fill: parent
            touchPoints: [
                TouchPoint { id: tp1 }
            ]
        }
    }

    Item {
        id: topHalf
        height: parent.height / 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        Paddle {
            id: paddle2
            x: tp2.x - paddle2.width / 2
            anchors.top: parent.top
        }

        TouchArea {
            id: touchArea2
            anchors.fill: parent
            touchPoints: [
                TouchPoint { id: tp2 }
            ]
        }
    }

    Ball {
        id: ball
        onActiveChanged: {
            if (!active) {
                countDown.start();
            }
        }
    }

    Rectangle {
        id: countDown
        property int seconds: 3
        height: 200
        width: 200
        color: "lightblue"
        opacity: 0.8
        radius: 20
        anchors.centerIn: parent

        Text {
            text: countDown.seconds
            font.pixelSize: 150
            anchors.centerIn: parent
        }

        Timer {
            id: innerTimer
            repeat: true
            interval: 1000
            onTriggered: {
                countDown.seconds--;
                if (countDown.seconds == 0) {
                    running = false;
                    countDown.seconds = 3;
                    countDown.opacity = 0;
                    ball.active = true;
                }
            }
        }

        Behavior on opacity {
            PropertyAnimation { duration: 200 }
        }

        function start() {
            opacity = 1;
            innerTimer.start();
        }
    }

    Component.onCompleted: countDown.start()

}

