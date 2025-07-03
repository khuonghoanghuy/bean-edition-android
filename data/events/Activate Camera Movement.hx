function create() importScript("songs/cameraMove");

function onEvent(camare) {
    if (camare.event.name == "Activate Camera Movement") {
        doCameraMovement = camare.event.params[0];
    }
}