// filter out jitter and ensure that the value goes back to 0.0 after the joystick went back to middle position
function filterAxis(axisValue) {
    if ((axisValue <= -0.07) || (axisValue >= 0.07)) {
        return axisValue
    }
    return 0.0
}

function detectCollisionCircleCircle(item1, item2) {
    var dx = item1.hitboxX - item2.hitboxX
    var dy = item1.hitboxY - item2.hitboxY
    var distance = Math.sqrt(dx * dx + dy * dy)
    var colliding = distance < item1.hitboxRadius + item2.hitboxRadius
    return colliding
}

function detectCollisionRectangleRectangle(item1, item2) {
    if (item1.x + item1.width >= item2.x &&
        item1.x <= item2.x + item2.width &&
        item1.y + item1.height >= item2.y &&
        item1.y <= item2.y + item2.height) {
            return true
    }
    return false
}

function detectCollisionCircleRectangle(circle, rectangle) {
    var closestX = circle.hitboxX
    var closestY = circle.hitboxY

    // get closest edge
    if (circle.hitboxX < rectangle.x) {
        closestX = rectangle.x
    } else if (circle.hitboxX > rectangle.x + rectangle.width) {
        closestX = rectangle.x + rectangle.width
    }
    if (circle.hitboxY < rectangle.y) {
        closestY = rectangle.y
    } else if (circle.hitboxY > rectangle.y + rectangle.height) {
        closestY = rectangle.y + rectangle.height
    }

    var d = distance(circle.hitboxX, circle.hitboxY, closestX, closestY)

    return d <= circle.hitboxRadius
}

function centerYDistanceRelativeRectangleRectangle(item1, item2) {
    // item1 is racket, item2 is ball
    // result is from -1.0 to 1.0
    var centerYItem1 = item1.y + (item1.height / 2)
    var centerYItem2 = item2.y + (item2.height / 2)
    var centerYDistance =  centerYItem2 - centerYItem1
    return centerYDistance / (item1.height / 2)
}

function distance(x1, y1, x2, y2) {
    var a = x1 - x2
    var b = y1 - y2
    return Math.sqrt(a*a + b*b)
}

function range(start, end) {
    var result = []
    for (let i = start; i <= end; i++) {
        result.push(i)
    }
    return result
}

function getStartQuadrant() {
    return Math.round(Math.random() * 5) + 1
}

function getTargetQuadrant(startQuadrant) {
    switch(startQuadrant) {
        case 1: {
            return 3
        }
        case 2: {
            return 4
        }
        case 3: {
            return 1
        }
        case 4: {
            return 2
        }
        case 5: {
            return 6
        }
        case 6: {
            return 5
        }
    }
}

function getRandomPosition(item, window, quadrant) {
    // quadrant:
    // 1: top left
    // 2: top right
    // 3: bottom right
    // 4: bottom left
    // 5: left
    // 6: right

    var x1 = 0
    var x2 = 0
    var y1 = 0
    var y2 = 0

    switch(quadrant) {
        case 1: {
            x1 = - item.width
            x2 = (window.width / 2) - item.width
            y1 = - item.height
            y2 = - item.height
            break
        }
        case 2: {
            x1 = window.width / 2
            x2 = window.width
            y1 = - item.height
            y2 = - item.height
            break
        }
        case 3: {
            x1 = window.width / 2
            x2 = window.width
            y1 = window.height + item.height
            y2 = window.height + item.height
            break
        }
        case 4: {
            x1 = - item.width
            x2 = (window.width / 2) - item.width
            y1 = window.height + item.height
            y2 = window.height + item.height
            break
        }
        case 5: {
            x1 = - (item.height + 300)
            x2 = - (item.height + 300)
            y1 = 0
            y2 = window.height
            break
        }
        case 6: {
            x1 = window.width + item.height
            x2 = window.width + item.height
            y1 = 0
            y2 = window.height
            break
        }
    }

    return {
        x: Math.round(Math.random() * (x2 - x1 + 1)) + x1,
        y: Math.round(Math.random() * (y2 - y1 + 1)) + y1
    }
}
