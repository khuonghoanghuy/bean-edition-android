import Std;
import StringTools;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.util.FlxSpriteUtil;
import funkin.backend.shaders.CustomShader;
import funkin.backend.utils.FlxInterpolateColor;

var bg:FlxSprite;

var imageArray:Array<Dynamic> = [];
var curSelected:Int = 0;

var dotArray:Array<FlxSprite> = [];

var galleryTxtArray:Array<FlxSprite> = [];

var displayBaseScale:Float = 0.5;
var imageDisplay:FlxSprite;
var descText:FunkinText;
var creditsTxt:FunkinText;

var leftArrow:FlxSprite;
var rightArrow:FlxSprite;

var interpolateColor:FlxInterpolateColor;

function create() {
    imageArray = Json.parse(Assets.getText(Paths.file("images/gallery/data.json")));

    bg = new FlxSprite(-3, -5).loadGraphic(Paths.image('menus/menuDesat'));
    bg.setGraphicSize(FlxG.width, FlxG.height);
    add(bg);

    var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x22FFFFFF, 0x00FFFFFF));
	grid.velocity.set(40, 40);
    grid.blend = 0;
	add(grid);

    imageDisplay = new FlxSprite();
    imageDisplay.scale.set(displayBaseScale, displayBaseScale);
	imageDisplay.updateHitbox();
	imageDisplay.screenCenter(FlxAxes.XY);
    add(imageDisplay);

    var balls:Array<String> = ["G", "a", "l", "l", "e", "r", "y"];
    var fixness:Float = 0;
    var funniDelay:Float = 0;
    for (i in 0...balls.length) {
        var heheh:FunkinText = new FunkinText(30 + (58 * i), 0, 0, balls[i], 80);
        heheh.font = Paths.font("comicsans.ttf");
        heheh.borderSize = 2.5;
        heheh.color = FlxColor.RED;
        heheh.shader = new CustomShader("rgb");
        heheh.shader.uTime = 0;
        add(heheh);
        galleryTxtArray.push(heheh);

        if (balls[i] == "l") {
            heheh.x -= 18 + fixness;
            fixness += 40;
        }
        else if (i > 1) {
            heheh.x -= fixness * 1.2;
            fixness += 12;
        }

        var tweenTo:Float = heheh.y + 4;
        heheh.y -= 4;
        FlxTween.tween(heheh, {y: tweenTo}, 0.6, {startDelay: funniDelay, ease: FlxEase.sineInOut, type: FlxTweenType.PINGPONG});
        funniDelay += 0.15;
    }

    leftArrow = new FlxSprite();
    leftArrow.frames = Paths.getFrames("gallery/arrow");
    leftArrow.animation.addByPrefix("idle", "arrow idle0", 12, false);
    leftArrow.animation.addByPrefix("push", "arrow push0", 12, false);
    leftArrow.animation.play("idle");
    leftArrow.animation.finishCallback = _ -> {leftArrow.animation.play("idle");};
    leftArrow.scale.set(1.5, 1.5);
    leftArrow.updateHitbox();
    leftArrow.setPosition(200, 280);
    add(leftArrow);

    rightArrow = new FlxSprite();
    rightArrow.frames = Paths.getFrames("gallery/arrow");
    rightArrow.animation.copyFrom(leftArrow.animation);
    rightArrow.animation.play("idle");
    rightArrow.animation.finishCallback = _ -> {rightArrow.animation.play("idle");};
    rightArrow.scale = leftArrow.scale;
    rightArrow.updateHitbox();
    rightArrow.setPosition(FlxG.width - rightArrow.width - 200, 280);
    rightArrow.flipX = true;
    add(rightArrow);

    for (i in 0...imageArray.images.length) {
        var dot:FlxSprite = new FlxSprite(0, 680).loadGraphic(Paths.image("gallery/dot"));
        dot.setGraphicSize(18, 18);
        dot.updateHitbox();
        dot.alpha = 0.35;

        add(dot);
        dotArray.push(dot);
    }

    rearrangeDots();

    descText = new FunkinText(0, 600, 0, "", 40);
    descText.font = Paths.font("arial.ttf");
	descText.borderSize = 1.6;
	add(descText);

    creditsTxt = new FunkinText(0, 640, 0, "", 28);
    creditsTxt.font = Paths.font("arial.ttf");
	creditsTxt.borderSize = 1.2;
    add(creditsTxt);

    interpolateColor = new FlxInterpolateColor(bg.color);

    changeSelection(0);
}

function update(elapsed:Float) {
    if (imageArray.images != null && imageArray.images.length > 0 && imageArray.images[curSelected].color != null)
        interpolateColor.fpsLerpTo(Std.parseInt(StringTools.replace(imageArray.images[curSelected].color, "#", "0x")), 0.0625);
    else
        interpolateColor.fpsLerpTo(0xFFFFFFFF, 0.0625);
    bg.color = interpolateColor.color;

    var fakeElapsedLol:Float = elapsed;
    for (i => letter in galleryTxtArray) {
        new FlxTimer().start(0.1 * i, _ -> {
            letter.shader.uTime += fakeElapsedLol;
        });
    }

    if (controls.BACK) {
        FlxG.switchState(new MainMenuState());
    }

    if (controls.LEFT_P) {
        leftArrow.animation.play("push", true);
        changeSelection(-1);
    }
    
    if (controls.RIGHT_P) {
        rightArrow.animation.play("push", true);
        changeSelection(1);
    }
}

function changeSelection(huh:Int = 0) {
    curSelected = FlxMath.wrap(curSelected + huh, 0, imageArray.images.length - 1);

    FlxG.sound.play(Paths.sound('menu/scroll'));

    updateDisplay();
    rearrangeDots();
}

function updateDisplay() {
    descText.text = imageArray.images[curSelected].comment;

    if (descText.fieldWidth > FlxG.width)
        descText.scale.x = FlxG.width / descText.fieldWidth;
    else
        descText.scale.x = 1;

    descText.updateHitbox();
    descText.screenCenter(FlxAxes.X);

    if (imageArray.images[curSelected].credits != null) {
        if (imageArray.images[curSelected].credits.length > 0 || imageArray.images[curSelected].credits.length != "")
            creditsTxt.text = "by: " + imageArray.images[curSelected].credits;
        else
            creditsTxt.text = "";
    }
    else
        creditsTxt.text = "";

    creditsTxt.screenCenter(FlxAxes.X);

    // image loading is done this way so it supports more image formats than "png"
    imageDisplay.loadGraphic(Paths.file('images/gallery/images/' + imageArray.images[curSelected].file));
    imageDisplay.scale.set((imageArray.images[curSelected].scale ?? 1) * displayBaseScale, (imageArray.images[curSelected].scale ?? 1) * displayBaseScale);
    imageDisplay.updateHitbox();
	imageDisplay.screenCenter();
    imageDisplay.y -= (imageDisplay.height / 16);
}

function rearrangeDots() {
    if (dotArray.length < 1) return;
 
    var spacing:Float = 580 / dotArray.length;

    var totalWidth:Float = 0;
    for (dot in dotArray) {
        totalWidth += dot.width + spacing;
    }
    totalWidth -= spacing;

    var center:Float = FlxG.width / 2;
    var resultPos:Float = center - (totalWidth / 2);

    for (dot in dotArray) {
        dot.x = resultPos;
        resultPos += dot.width + spacing;
    }

    for (i => dot in dotArray) {
        FlxTween.cancelTweensOf(dot, ["alpha", "scale.x", "scale.y"]);
        if (i == curSelected) {
            FlxTween.tween(dot, {"scale.x": 0.4, "scale.y": 0.4}, 0.1);
            FlxTween.tween(dot, {alpha: 0.6}, 0.1);
        }
        else {
            FlxTween.tween(dot, {"scale.x": 0.281, "scale.y": 0.281}, 0.1);
            FlxTween.tween(dot, {alpha: 0.3}, 0.1);
        }
    }
}