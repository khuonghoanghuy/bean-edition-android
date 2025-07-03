var lyrics1:FunkinText;
var lyrics2:FunkinText;

function postCreate() {
    camGame.visible = false;
    stage.getSprite("spooky_cunt").alpha = 0;

    lyrics1 = new FunkinText(0, 0, FlxG.width, "", 40);
    lyrics1.borderSize = 3;
    lyrics1.alignment = "center";
    lyrics1.camera = camHUD;
    lyrics1.y = healthBarBG.y - (100 + lyrics1.height / 2);
    add(lyrics1);

    lyrics2 = new FunkinText(0, 0, FlxG.width, "", 64);
    lyrics2.borderSize = 4.5;
    lyrics2.alignment = "center";
    lyrics2.camera = camHUD;
    lyrics2.y = healthBarBG.y - (100 + lyrics2.height / 2);
    lyrics2.color = FlxColor.RED;
    add(lyrics2);
}

function onStartSong() {
    if (PlayState.chartingMode)
        camGame.visible = true;
}

function stepHit() {
    switch (curStep) {
        case 0: camGame.visible = true;
        case 32: FlxTween.tween(stage.getSprite("spooky_cunt"), {alpha: 0.6}, 0.5, {ease: FlxEase.quadInOut});
        case 744: FlxTween.tween(stage.getSprite("spooky_cunt"), {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});
        case 768:
            dad.alpha = 0;
            stage.getSprite("Browndie").visible = true;
            stage.getSprite("Browndie").animation.play("idle");
            stage.getSprite("redkill").visible = true;
            stage.getSprite("redkill").animation.play("idle");
            stage.getSprite("dedbody").alpha = 0;
            lyrics1.text = "Heyyyy...";
        case 782: lyrics1.text = "";
        case 785: lyrics1.text = "I'm alive again...";
        case 804: lyrics1.text = "";
        case 810: lyrics1.text = "Hold up";
        case 815: lyrics1.text = "no...";
        case 818: lyrics1.text = "";
        case 820: lyrics1.text = "no";
        case 824: lyrics1.text = "NO";
        case 827:
            lyrics1.text = "NOOOOOOOOOOOOOOO";
            lyrics1.size = 52;
            lyrics1.y = healthBarBG.y - (100 + lyrics1.height / 2);
        case 828:
            lyrics2.text = "Die!! >:D";
            FlxTween.shake(lyrics2, 0.01, (Conductor.stepCrochet / 1000) * 3);
        case 832:
            stage.getSprite("Browndie").visible = false;
            stage.getSprite("redkill").visible = false;
            stage.getSprite("dedbody").alpha = 1;
            dad.alpha = 1;
            lyrics1.text = "";
            lyrics2.text = "";
            lyrics1.destroy();
        case 836: lyrics2.destroy();
        case 864: FlxTween.tween(stage.getSprite("spooky_cunt"), {alpha: 0.6}, 0.5, {ease: FlxEase.quadInOut});
        case 1423:
            FlxTween.tween(camGame, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut, onComplete: function (tween:FlxTween){
                FlxTween.tween(camHUD, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});
            }});
    }
}