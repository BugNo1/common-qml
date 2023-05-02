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

function range(start, end) {
    var result = []
    for (let i = start; i <= end; i++) {
        result.push(i)
    }
    return result
}
