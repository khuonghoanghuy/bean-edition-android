// handled by events
public var doCameraMovement:Bool = true;

function postCreate() {
    setFunniCam(0, 0, 0);
}

function postUpdate(elapsed:Float) {
    if (!FlxG.save.data.camMove) return;

    if (doCameraMovement) {
        if (curCameraTarget == 1) { // bf turn
            switch (boyfriend.animation.name) {
                case "singLEFT":
                    setFunniCam(-15, 0, -1);
                case "singRIGHT":
                    setFunniCam(15, 0, 1);
                case "singUP":
                    setFunniCam(0, -15);
                case "singDOWN":
                    setFunniCam(0, 15);
                default:
                    setFunniCam(0, 0);
            }
        } else if (curCameraTarget == 0) { // dad turn
            switch (dad.animation.name) {
                case "singLEFT":
                    setFunniCam(-15, 0, -1);
                case "singRIGHT":
                    setFunniCam(15, 0, 1);
                case "singUP":
                    setFunniCam(0, -15);
                case "singDOWN":
                    setFunniCam(0, 15);
                default:
                    setFunniCam(0, 0);
            }
        }
    }
    else {
        setFunniCam(0, 0);
    }
}

function setFunniCam(xOffset:Float, yOffset:Float, ?angle:Float = 0) {
    camGame.targetOffset.x = xOffset;
    camGame.targetOffset.y = yOffset;
    FlxTween.cancelTweensOf(camGame, ["angle"]);
    FlxTween.tween(camGame, {angle: angle}, 1, {ease: FlxEase.expoOut});
    //camGame.angle = angle; // that doesn't work ;-;
}
