import hxvlc.flixel.FlxVideoSprite;

var hehehehe:FlxVideoSprite;

function create() {
    var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    add(bg);

    hehehehe = new FlxVideoSprite();
    hehehehe.load(Paths.file("videos/secrets/themissileleroy.mov"));
    hehehehe.bitmap.onEndReached.add(goback);
    hehehehe.x += FlxG.width / 4;
    add(hehehehe);
    hehehehe.play();
}

function goback() {
    remove(hehehehe);
    hehehehe.destroy();
    close();
}