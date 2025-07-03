function create() {
    gfSpeed = 1;
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 1800:
            camHUD.fade(0x010101, (Conductor.stepCrochet / 1000) * 8, function () {
                camGame.visible = false;
            }, true);
        case 1808:
            camGame.visible = false; // prevent from game is not DO THIS
        case 1838:
            camHUD.visible = false; // for final cutscene
    }
}