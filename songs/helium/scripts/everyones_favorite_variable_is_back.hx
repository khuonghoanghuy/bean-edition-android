// ignore the file name LOL
import flixel.tweens.FlxTween.FlxTweenType;

var cinematic1:FlxSprite;
var cinematic2:FlxSprite;
var guess_what_the_same_camera_bug_keeps_haunting_me_across_engines_bruh:FlxSprite;

function create() {
    cinematic1 = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    cinematic1.camera = camHUD;
    cinematic1.y -= cinematic1.height;
    insert(2, cinematic1);

    cinematic2 = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    cinematic2.camera = camHUD;
    cinematic2.y = FlxG.height;
    insert(2, cinematic2);

    guess_what_the_same_camera_bug_keeps_haunting_me_across_engines_bruh = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    guess_what_the_same_camera_bug_keeps_haunting_me_across_engines_bruh.camera = camHUD;
    guess_what_the_same_camera_bug_keeps_haunting_me_across_engines_bruh.alpha = 0;
    insert(0, guess_what_the_same_camera_bug_keeps_haunting_me_across_engines_bruh);
}

function stepHit() {
    switch(curStep) {
        case 544: tweenCinematic1(0.15, 8, FlxEase.sineOut); tweenCinematic2(0.15, 8, FlxEase.sineOut);
        case 672: tweenCinematic1(0, 128, FlxEase.sineOut); tweenCinematic2(0, 128, FlxEase.sineOut);
        case 800: camFadeWorkaroundLol(1, 0, 16);
        case 816: camFadeWorkaroundLol(0.5, 1, 128); tweenCinematic1(0.2, 0); tweenCinematic2(0.2, 0);
        case 1072: camFadeWorkaroundLol(0, 0.5, 256); tweenCinematic1(0, 256, FlxEase.sineInOut); tweenCinematic2(0, 256, FlxEase.sineInOut);
        case 1888: camFadeWorkaroundLol(1, 0, 24);
    }
}

function camFadeWorkaroundLol(fromAlpha:Float, toAlpha:Float, duration:Int) {
    // for some reason this is backwards
    FlxTween.cancelTweensOf(guess_what_the_same_camera_bug_keeps_haunting_me_across_engines_bruh, ["alpha"]);
    guess_what_the_same_camera_bug_keeps_haunting_me_across_engines_bruh.alpha = toAlpha;
    FlxTween.tween(guess_what_the_same_camera_bug_keeps_haunting_me_across_engines_bruh, {alpha: fromAlpha}, (Conductor.stepCrochet / 1000) * duration, {ease: FlxEase.linear});
}

function tweenCinematic1(percent:Float, duration:Int, daEase:FlxEase = FlxEase.linear) {
    var yPosCinematic1:Float = FlxG.height * percent;
    yPosCinematic1 -= cinematic1.height;
    if (duration < 1)
        cinematic1.y = yPosCinematic1;
    else
        FlxTween.tween(cinematic1, {y: yPosCinematic1}, (Conductor.stepCrochet / 1000) * duration, {ease: daEase});
}

function tweenCinematic2(percent:Float, duration:Int, daEase:FlxEase = FlxEase.linear) {
    var yPosCinematic2:Float = FlxG.height * FlxMath.remapToRange(percent, 0, 1, 1, 0);
    if (duration < 1)
        cinematic2.y = yPosCinematic2;
    else
        FlxTween.tween(cinematic2, {y: yPosCinematic2}, (Conductor.stepCrochet / 1000) * duration, {ease: daEase});
}