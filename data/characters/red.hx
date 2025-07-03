var position:Float = PlayState.instance.downscroll ? -26 : 26;

function postCreate() {
    PlayState.instance.iconP2.y -= position;
}