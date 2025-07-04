import flixel.util.FlxTimer;
import flixel.group.FlxTypedGroup;
import flixel.group.FlxGroup;
import funkin.backend.MusicBeatGroup;
import funkin.backend.shaders.CustomShader;
import funkin.game.HealthIcon;
import AttachedHealthIcon;
import funkin.mobile.controls.FlxDPadMode;
import funkin.mobile.controls.FlxActionMode;

var textTitleEachOptions:FunkinText;
var line:FlxSprite;

var beanWallet:FunkinText;

var nametag:FlxSprite;

var animOffsets:Map<String, Array<Float>> = [];
var previewSprite:FlxSprite; // preview thingie
var curSelected:Int = 0; // selected thing

var flashCamera:FlxCamera = new FlxCamera();

var stuffList:Array<String> = ["bf", "mini-red"];
var stuffGroup:Array<BoxSprite> = [];

function create() {
	importScript("data/global");

	flashCamera.bgColor = 0x00000000;
	FlxG.cameras.add(flashCamera, false);

	scroll = FlxG.sound.load(Paths.sound('menu/scroll'));

	curSelected = stuffList.indexOf(playableBean);

	//animationOffsets = new Map();

	var bg:FlxSprite = new FlxSprite(0, 0, Paths.image("shopmenu/bg"));
	bg.setGraphicSize(0, Std.int(760));
	bg.updateHitbox();
	bg.screenCenter();
	add(bg);

	previewSprite = new FlxSprite(175, 275);
	add(previewSprite);

	// These line need a box
	line = new FlxSprite(FlxG.width / 1.2, -50);
	line.makeGraphic(10, FlxG.height + 75, 0xffffffff);
	line.x -= line.width / 2;
	add(line);

	for (i in 0...stuffList.length) {
		var item:BoxSprite = new BoxSprite(0, line.y + (i * 256) + 312);
		item.ID = i;
		item.targetY = i;
		item.x = line.x + ((line.width / 2) - (item.width / 2));
		item.antialiasing = true;
		item.offsetY = 50;
		add(item);
		stuffGroup.push(item);

		var icon:AttachedHealthIcon = new AttachedHealthIcon(stuffList[i], true);
		icon.sprTracker = item;
		icon.xAdd = ((item.width / 2) - (icon.width / 2));
		icon.yAdd = ((item.height / 2) - (icon.height / 2));
		icon.scrollFactor.set(1, 1);
		add(icon);
	}

	nametag = new FlxSprite().loadGraphic(Paths.image("shopmenu/nametags/" + stuffList[curSelected]));
	nametag.shader = new CustomShader("mosaic");
	nametag.shader.uBlocksize = [1, 1];
	add(nametag);

	var aieofhnrwg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height * 0.16, FlxColor.BLACK);
	add(aieofhnrwg);

	var shopTitle:FunkinText = new FunkinText(0, 9, 0, "Shop", 80);
	shopTitle.font = Paths.font("phantom.ttf");
	shopTitle.alignment = "left";
	shopTitle.borderSize = 5;
	shopTitle.screenCenter(FlxAxes.X);
	add(shopTitle);

	var beanImg:FlxSprite = new FlxSprite(40, aieofhnrwg.height / 8).loadGraphic(Paths.image("bean"));
	beanImg.scale.set(1.2, 1.2);
	add(beanImg);

	var beansTxt:FunkinText = new FunkinText(beanImg.x, (beanImg.y + beanImg.height) + 4, beanImg.width * 2, "Beans", 24);
	beansTxt.x -= beansTxt.width / 4;
	beansTxt.alignment = "center";
	beansTxt.borderSize = 2;
	add(beansTxt);

	var beans:Int = FlxG.save.data.beans;
	beanWallet = new FunkinText((beanImg.x + beanImg.width) + 20, ((beanImg.y + beanImg.height) / 4) + 5, 0, beans, 64);
	beanWallet.alignment = "left";
	beanWallet.borderSize = 2.5;
	add(beanWallet);

	textTitleEachOptions = new FunkinText(50, (shopTitle.y + shopTitle.height) + 5, 0, "Boyfriend", 75);
	textTitleEachOptions.alignment = "left";
	textTitleEachOptions.borderSize = 4;
	textTitleEachOptions.visible = false;
	add(textTitleEachOptions);

	getPreviewSprite(stuffList[curSelected]);
	for(i=>item in stuffGroup) {
		item.targetY = i - curSelected;
	}

	addVPad(FlxDPadMode.UP_DOWN, FlxActionMode.A_B);
	addVPadCamera();
	vPad.visible = true;
}

function getPreviewSprite(name:String) {
	animOffsets.clear();
	switch (name) {
		case "bf":
			textTitleEachOptions.text = "Boyfriend";
			previewSprite.setPosition(200, 275);
			previewSprite.frames = Paths.getSparrowAtlas("shopmenu/item/skin1");
			previewSprite.animation.addByPrefix("idle", "BF idle dance0", 24, false);
			previewSprite.animation.addByPrefix("selected", "BF HEY!!0", 24, false);
			//previewSprite.animation.addByPrefix("unselected", "BF NOTE LEFT MISS0", 24, false);
			previewSprite.flipX = true;
			animOffsets.set("idle", [-5, 0]);
			animOffsets.set("selected", [-3, 6]);
			//playableBean = "bf";
		case "mini-red":
			textTitleEachOptions.text = "Red Bean";
			previewSprite.setPosition(180, 95);
			previewSprite.frames = Paths.getSparrowAtlas("shopmenu/item/skin2");
			previewSprite.animation.addByPrefix("idle", "idle", 24, false);
			previewSprite.flipX = true;
			animOffsets.set("idle", [0, 0]);
	}
	playAnimation("idle");

	doMosaicEffect(false);
	new FlxTimer().start(4 / 30, _ -> {
		nametag.loadGraphic(Paths.image("shopmenu/nametags/" + stuffList[curSelected]));
		updateNametagPosition();
		doMosaicEffect(true);
	});
}

function doMosaicEffect(fadeOut:Bool) {
	if (fadeOut) {
		setMosaicTimer(0, 1, 1);
		setMosaicTimer(0, nametag.width / 27, nametag.height / 26);
		setMosaicTimer(2, nametag.width / 10, nametag.height / 10);

		setMosaicTimer(3, 1, 1);
	}
	else {
		setMosaicTimer(0, nametag.width / 10, nametag.height / 10);
		setMosaicTimer(1, nametag.width / 73, nametag.height / 6);
		setMosaicTimer(2, nametag.width / 10, nametag.height / 10);
	}
}

function setMosaicTimer(frame:Int, forceX:Float, forceY:Float) {
	var daX:Float = forceX ?? 10 * FlxG.random.int(1, 4);
	var daY:Float = forceY ?? 10 * FlxG.random.int(1, 4);

	new FlxTimer().start(frame / 30, () -> {
		nametag.shader.uBlocksize = [daX, daY];
	});
}

var midpointX:Float = 250;
var midpointY:Float = 200;
public function updateNametagPosition() {
    var offsetX:Float = nametag.getMidpoint().x - midpointX;
    var offsetY:Float = nametag.getMidpoint().y - midpointY;

    nametag.x -= offsetX;
    nametag.y -= offsetY;
}

function update(elapsed:Float) {
	beanWallet.text = FlxG.save.data.beans;

	if (controls.BACK)
		FlxG.switchState(new MainMenuState());

	if (controls.UP_P)
		changeSelection(-1);

	if (controls.DOWN_P)
		changeSelection(1);

	if (controls.ACCEPT) {
		switch (stuffList[curSelected]) { // this is how beans work for nows
			case "bf":
				playableBean = "bf";
				playAnimation("selected");
				FlxG.sound.play(Paths.sound("menu/confirm"), 1);
			case "mini-red":
				if (FlxG.save.data.ownedBeans == null) FlxG.save.data.ownedBeans = ["bf"];
				if (FlxG.save.data.ownedBeans.contains("mini-red")) {
					playableBean = "mini-red";
					previewSprite.animation.play("selected", true);
					FlxG.sound.play(Paths.sound("menu/confirm"), 1);
				} else if (FlxG.save.data.beans >= 100) {
					FlxG.save.data.beans -= 100;
					FlxG.save.data.ownedBeans.push("mini-red");
					playableBean = "mini-red";
					previewSprite.animation.play("selected", true);
					FlxG.sound.play(Paths.sound("menu/confirm"), 1);
				} else {
					FlxG.sound.play(Paths.sound("menu/cancel"), 1);
					flashScreen(0xffff0000, 0.5, 0.75);
					shakeCamera(0.2, 7);
				}
		}
	}

	if (allowShaking) {
		FlxG.camera.scroll.x = lerp(FlxG.camera.scroll.x, FlxG.random.int(-shakingAmount, shakingAmount), 1.5);
		FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, FlxG.random.int(-shakingAmount, shakingAmount), 1.5);
		FlxG.camera.angle = lerp(FlxG.camera.angle, FlxG.random.int(-shakingAmount, shakingAmount), 0.08);
	} else {
		FlxG.camera.scroll.x = FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.x, 0, 0.5);
		FlxG.camera.angle = lerp(FlxG.camera.angle, 0, 0.5);
	}

	for(item in stuffGroup) {
		item.update(elapsed); // why codename, just why
		item.scale.x = item.scale.y = FlxMath.lerp(item.scale.x, (item.targetY == 0 ? 1.2 : 1), 0.08);
	}
}

function flashScreen(color:FlxColor, time:Float, startAlpha:Float)
{
    var flash:FlxSprite = new FlxSprite();
	flash.makeGraphic(FlxG.width + 50, FlxG.height + 50, color);
    flash.alpha = startAlpha;
	flash.cameras = [flashCamera];
    add(flash);

	FlxTween.tween(flash, {alpha: 0}, time, {onComplete: function() {
		flash.destroy();
		remove(flash);
	}});
}

var shakingAmount:Float = 0;
var allowShaking:Bool = false;
function shakeCamera(time, amount)
{
	allowShaking = true;
	new FlxTimer().start(time, function (tim:FlxTimer) {
		allowShaking = false;
	});
	shakingAmount = amount;
}

function changeSelection(change:Int = 0) {
	scroll.play(true);
	scroll.volume = 1;
	curSelected = FlxMath.wrap(curSelected + change, 0, stuffList.length - 1);
	getPreviewSprite(stuffList[curSelected]);

	for(i=>item in stuffGroup) {
		item.targetY = i - curSelected;
	}
}

function beatHit() {
	if (previewSprite.animation.curAnim.finished)
		playAnimation("idle");
}

function playAnimation(anim:String) {
	var offsets:Array<Float> = animOffsets[anim];
	previewSprite.offset.set(offsets[0], offsets[1]);
	previewSprite.animation.play(anim);
}

function destroy() {
	FlxG.save.data.playableBean = playableBean;
	trace("Playable Character [" + FlxG.save.data.playableBean + "] has been saved!");
}

class BoxSprite extends FlxSprite
{
	public var offsetY:Float = 0;
	public var targetY:Int = 0;

	public function new(x, y)
	{
		super(x, y);

		makeGraphic(150, 150);
		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		y = FlxMath.lerp(y, ((FlxG.height / 2) - (height / 2)) + (targetY * (height * 1.75)) + offsetY, 0.08);
	}
}
