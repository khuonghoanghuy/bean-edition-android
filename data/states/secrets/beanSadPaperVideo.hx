import hxvlc.flixel.FlxVideoSprite;

var paperVideo:FlxVideoSprite;

function create() {
    var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    add(bg);

    paperVideo = new FlxVideoSprite();
    paperVideo.load(Paths.video("secrets/0702_44_1_1"));
    paperVideo.bitmap.onEndReached.add(goback);
    paperVideo.scale.set(0.4, 0.4);
    paperVideo.updateHitbox();
    paperVideo.x += FlxG.width / 12;
    paperVideo.y -= 580;
    add(paperVideo);
    paperVideo.play();
}

function goback() {
    remove(paperVideo);
    paperVideo.destroy();
    close();
}