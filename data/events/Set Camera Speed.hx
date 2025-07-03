var cameraSpeed:Float = 1;

function onEvent(amongus) {
    if (amongus.event.name == "Set Camera Speed") {
        cameraSpeed = amongus.event.params[0];
    }
}

function postUpdate(elapsed:Float) {
    FlxG.camera.followLerp = 0.04 * cameraSpeed;
}