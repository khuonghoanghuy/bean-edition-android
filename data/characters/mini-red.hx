var position:Float = PlayState.instance.downscroll ? -26 : 26;

function postCreate() {
    PlayState.instance.iconP1.y -= position;
}