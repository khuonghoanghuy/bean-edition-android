// workaround, fix something

var position:Float = downscroll ? -26 : 26;

function postCreate() {
    iconP2.y -= position;
}