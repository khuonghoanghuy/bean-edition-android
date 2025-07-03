function onDadHit(event) {
    switch (dad.curCharacter) {
        case "red":
            if (health > 0.1) {
                health -= 0.023;
            }
            if (health < 0) {
                health = 0;
            }
        default:
            // no
    }
}

// funni mechanic
function onPlayerHit(event) {
    switch (boyfriend.curCharacter) {
        case "mini-red":
            event.healthGain = 0.045;
            event.score -= 25;
        default:
            // no
    }
}

function onPlayerMiss(event) {
    switch (boyfriend.curCharacter) {
        case "mini-red":
            event.score -= misses * 25;
        default:
            // no
    }
}