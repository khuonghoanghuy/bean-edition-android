import flixel.effects.FlxFlicker;
import flixel.group.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;
import funkin.options.Options;
import funkin.options.OptionsMenu;
import lime.app.Application;
import sys.FileSystem;

var codenameVersion = Application.current.meta.get("version");
var beanVersion = "1.0 DEMO";

var mainOptions:Array<Any> = [
	{
		name: "Play",
		offsets: [0, -8],
		scale: 1,
		colorIdle: 0xFF0A3C33,
		colorSelect: 0xFF10584B
	},
	{
		name: "Shop",
		offsets: [4, 0],
		scale: 0.75,
		colorIdle: 0xFF0A3C33,
		colorSelect: 0xFF10584B
	},
	{
		name: "Gallery",
		offsets: [4, -1],
		scale: 1,
		colorIdle: 0xFF0A3C33,
		colorSelect: 0xFF10584B
	},
];
var otherOptions:Array<Any> = [
	{
		name: "Socials",
		offsets: [4, -1],
		scale: 0.78,
		colorIdle: 0xFFAAE2DC,
		colorSelect: 0xFFFFFFFF
	},
	{
		name: "Credits",
		offsets: [-2, -12],
		scale: 0.7,
		colorIdle: 0xFFAAE2DC,
		colorSelect: 0xFFFFFFFF
	},
	{
		name: "Options",
		offsets: [10, -3],
		scale: 0.75,
		colorIdle: 0xFFAAE2DC,
		colorSelect: 0xFFFFFFFF
	},
];
// im probably going to get rid of this later on
var exitOption:Array<Any> = [
	{
		name: "Exit",
		colorIdle: 0xFFFFFFFF,
		colorSelect: 0xFFFFFFFF
	}
];
var buttons:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var buttonIcons:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var buttonLabels:FlxTypedGroup<FunkinText> = new FlxTypedGroup();

var confirm:FlxSound;
var cancel:FlxSound;

static var curEntry:Int = 0;

function create() {
	DiscordUtil.call("onMenuLoaded", ["Main Menu"]);

	CoolUtil.playMenuSong();

	subStateClosed.add(resetInput);

	FlxG.mouse.visible = true;

	window.title = "Friday Night Funkin': Bean Edition";

	confirm = FlxG.sound.load(Paths.sound('menu/confirm'));
	cancel = FlxG.sound.load(Paths.sound('menu/cancel'));

	FlxG.sound.music.fadeIn(4, 1, 0.7); // most of the time u cant hear the main menu music

	createStars();

	var bg:FlxSprite = new FlxSprite(-6, -4).loadGraphic(Paths.image("mainmenu/bg"));
	bg.scale.set(1, 0.99);
	bg.updateHitbox();
	bg.antialiasing = Options.antialiasing;
	add(bg);

	var buttonsBack:FlxSprite = new FlxSprite(36, 200).loadGraphic(Paths.image("mainmenu/buttons-back"));
	buttonsBack.scale.set(1, 0.99);
	buttonsBack.updateHitbox();
	buttonsBack.antialiasing = Options.antialiasing;
	add(buttonsBack);

	createMainButtons();
	createOtherButtons();
	createExitButton();
	add(buttons);
	add(buttonIcons);
	add(buttonLabels);

	var versionText:FunkinText = new FunkinText(buttonsBack / 4, (buttonsBack.y + buttonsBack.height) + 20, buttonsBack.width + 80, 'Codename Engine v' + codenameVersion + ' | Bean Edition v' + beanVersion, 16, false);
	versionText.font = Paths.font("arial.ttf");
	versionText.alignment = "center";
	versionText.antialiasing = true;
	versionText.y -= versionText.height;
	add(versionText);
}

function createStars() {
	// the 3 stars layers are the same, so just use 1 path from a variable
	var path:String = "stars";

	var stars1:FlxBackdrop = new FlxBackdrop();
	stars1.loadGraphic(Paths.image(path));
	stars1.antialiasing = true;
	stars1.velocity.x = 10;
	stars1.scale.set(0.6, 0.6);
	stars1.updateHitbox();
	stars1.setPosition(0, 0);
	add(stars1);

	var stars2:FlxBackdrop = new FlxBackdrop();
	stars2.loadGraphic(Paths.image(path));
	stars2.antialiasing = true;
	stars2.velocity.x = 20;
	stars2.scale.set(0.8, 0.8);
	stars2.updateHitbox();
	stars2.setPosition(40, 25);
	stars2.flipX = true;
	add(stars2);

	var stars3:FlxBackdrop = new FlxBackdrop();
	stars3.loadGraphic(Paths.image(path));
	stars3.antialiasing = true;
	stars3.velocity.x = 30;
	stars3.updateHitbox();
	stars3.setPosition(-80, -54);
	stars3.flipX = stars3.flipY = true;
	add(stars3);
}

function createMainButtons() {
	for (i in 0...mainOptions.length) {
		var item:FlxSprite = new FlxSprite(58, 226 + (71 * i) + (6 * i));
		item.frames = Paths.getSparrowAtlas("mainmenu/button-main");
		item.animation.addByPrefix("idle", "idle", 24, true);
		item.animation.addByPrefix("select", "select", 24, true);
		item.antialiasing = Options.antialiasing;
		buttons.add(item);

		var icon:FlxSprite = new FlxSprite(item.x + 2, item.y + 2);
		icon.loadGraphic(Paths.image("mainmenu/icons/" + mainOptions[i].name.toLowerCase()));
		icon.antialiasing = Options.antialiasing;
		icon.scale.set(mainOptions[i].scale, mainOptions[i].scale);
		icon.updateHitbox();
		icon.x += mainOptions[i].offsets[0];
		icon.y += mainOptions[i].offsets[1];
		buttonIcons.add(icon);

		var text:FunkinText = new FunkinText(item.x + 2, item.y + (item.height / 4) - 2, item.width - 20, mainOptions[i].name, 40, false);
		text.alignment = "right";
		text.color = mainOptions[i].colorIdle;
		text.antialiasing = Options.antialiasing;
		buttonLabels.add(text);
	}
}

function createOtherButtons() {
	for (i in 0...otherOptions.length) {
		var item:FlxSprite = new FlxSprite(58, 473 + (47 * i) + (7 * i));
		item.frames = Paths.getSparrowAtlas("mainmenu/button-other");
		item.animation.addByPrefix("idle", "idle", 24, true);
		item.animation.addByPrefix("select", "select", 24, true);
		item.antialiasing = Options.antialiasing;
		buttons.add(item);

		var icon:FlxSprite = new FlxSprite(item.x + 2, item.y + 2);
		icon.loadGraphic(Paths.image("mainmenu/icons/" + otherOptions[i].name.toLowerCase()));
		icon.antialiasing = Options.antialiasing;
		icon.scale.set(otherOptions[i].scale, otherOptions[i].scale);
		icon.updateHitbox();
		icon.x += otherOptions[i].offsets[0];
		icon.y += otherOptions[i].offsets[1];
		buttonIcons.add(icon);

		var text:FunkinText = new FunkinText(item.x + 2, item.y + (item.height / 4) - 6, item.width - 20, otherOptions[i].name, 32, false);
		text.alignment = "right";
		text.color = otherOptions[i].colorIdle;
		text.antialiasing = Options.antialiasing;
		buttonLabels.add(text);
	}
}

function createExitButton() {
	var item:FlxSprite = new FlxSprite(58.5, 635);
	item.frames = Paths.getSparrowAtlas("mainmenu/button-exit");
	item.animation.addByPrefix("idle", "idle", 24, true);
	item.animation.addByPrefix("select", "select", 24, true);
	buttons.add(item);

	var text:FunkinText = new FunkinText(item.x, item.y + (item.height / 4) - 5, item.width - 10, exitOption[0].name, 26, false);
	text.alignment = "right";
	text.color = exitOption[0].colorIdle;
	text.antialiasing = Options.antialiasing;
	buttonLabels.add(text);
}

function postCreate() {
	changeSelection(0);
}

function update(elapsed:Float) {
	if (!itemSelected) {
		handleMouse();
		handleBtnSound();
		handleInput();
	}
}

var allowMouse:Bool = true;
function handleMouse() {
	updateMouse();

	if (!allowMouse) return;

	if (!isHoveringBtn) return;

	for (i in 0...buttons.members.length) {
		if (FlxG.mouse.overlaps(buttons.members[i])) {
			/*if (curEntry != buttons.members.indexOf(buttons.members[i])) {
				FlxG.sound.play(Paths.sound("menu/scroll"), 1);
			}*/
			curEntry = buttons.members.indexOf(buttons.members[i]);

			buttons.members[i].animation.play("select");

			if (i >= 3 && i < 6)
				buttonLabels.members[i].color = otherOptions[i - 3].colorSelect;
			else if (i >= 6)
				buttonLabels.members[i].color = exitOption[0].colorSelect;
			else
				buttonLabels.members[i].color = mainOptions[i].colorSelect;

			if (FlxG.mouse.justPressed)
				selectItem();
		}
		else {
			buttons.members[i].animation.play("idle");

			if (i >= 3 && i < 6)
				buttonLabels.members[i].color = otherOptions[i - 3].colorIdle;
			else if (i >= 6)
				buttonLabels.members[i].color = exitOption[0].colorIdle;
			else
				buttonLabels.members[i].color = mainOptions[i].colorIdle;
		}
	}
}

var allowHovering:Bool = true;
function updateMouse() {
	if (FlxG.mouse.justMoved && allowHovering) {
		FlxG.mouse.visible = true;
		allowMouse = true;
	}
}

var isHoveringBtn:Bool = false;
var lastHoverBtn:Int = -1;
function handleBtnSound() {
	if (!allowMouse) return;

	var isMouseOverBtn:Bool = false;
	buttons.forEach(function(spr:FlxSprite) {
		if(FlxG.mouse.overlaps(spr)) {
			isMouseOverBtn = true;
			currentHoverBtn = spr.ID;
		} 
	});

	if (isMouseOverBtn) {
		if (!isHoveringBtn) {
			isHoveringBtn = true;
			FlxG.sound.play(Paths.sound("menu/scroll"), 1);
		} else if (currentHoverBtn != lastHoverBtn) {
			FlxG.sound.play(Paths.sound("menu/scroll"), 1);
		}
		lastHoverBtn = currentHoverBtn;
	} else {
		if (isHoveringBtn) isHoveringBtn = false;
		lastHoverBtn = -1;
	}
}

var itemSelected:Bool = false;
function selectItem() {
	confirm.play();

	disableInput();

	var time:Float = 1;

	itemSelected = true;

	FlxFlicker.flicker(buttonLabels.members[curEntry], time, Options.flashingMenu ? 0.06 : 0.15, true);
	if (buttonIcons.members[curEntry] != null) FlxFlicker.flicker(buttonIcons.members[curEntry], time, Options.flashingMenu ? 0.06 : 0.15, true);
	FlxFlicker.flicker(buttons.members[curEntry], time, Options.flashingMenu ? 0.06 : 0.15, true, false, _ -> {
		switch (curEntry) {
			case 0: openSubState(new ModSubState("beanSelectMode"));
			case 1: FlxG.switchState(new ModState("beanShopState"));
			case 2: FlxG.switchState(new ModState("beanGalleryState"));
			case 3: openSubState(new ModSubState("beanSocialSubState"));
			case 4: FlxG.switchState(new CreditsMain());
			case 5: FlxG.switchState(new OptionsMenu());
			case 6: FlxG.switchState(new TitleState()); // cannot make the game close itself, otherwise the engine will take it as a crash bruh
		}
	});
}

var allowKeyboard:Bool = true;
var totalMenuItems:Int = mainOptions.length + otherOptions.length + exitOption.length;

function handleInput() {
	if (!allowKeyboard) return;

	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = !(persistentDraw = true);
		openSubState(new EditorPicker());
	}

	if (controls.SWITCHMOD) {
		openSubState(new ModSwitchMenu());
		persistentUpdate = !(persistentDraw = true);
	}

	if (controls.BACK) {
		cancel.play();
		disableInput();
		FlxG.switchState(new TitleState());
	}

    if (controls.UP_P) {
        changeSelection(-1);
    }

    if (controls.DOWN_P) {
        changeSelection(1);
    }

    if (controls.ACCEPT) {
        selectItem();
    }

	silly1();
	silly2();
}

function changeSelection(change:Int) {
	curEntry = FlxMath.wrap(curEntry + change, 0, totalMenuItems - 1);

	FlxG.mouse.visible = false;
	allowMouse = false;

	for (i in 0...buttons.members.length) {
		if (i == curEntry) {
			buttons.members[i].animation.play("select");

			if (i >= mainOptions.length && i < mainOptions.length + otherOptions.length)
				buttonLabels.members[i].color = otherOptions[i - mainOptions.length].colorSelect;
			else if (i >= mainOptions.length + otherOptions.length)
				buttonLabels.members[i].color = exitOption[0].colorSelect;
			else
				buttonLabels.members[i].color = mainOptions[i].colorSelect;
		} else {
			buttons.members[i].animation.play("idle");
			
			if (i >= mainOptions.length && i < mainOptions.length + otherOptions.length)
				buttonLabels.members[i].color = otherOptions[i - mainOptions.length].colorIdle;
			else if (i >= mainOptions.length + otherOptions.length)
				buttonLabels.members[i].color = exitOption[0].colorIdle;
			else
				buttonLabels.members[i].color = mainOptions[i].colorIdle;
		}
	}

	FlxG.sound.play(Paths.sound("menu/scroll"), 1);
}

var funni1:Array<Int> = [76, 69, 82, 79, 89];
var curPos1:Int = 0;
function silly1() {
	if (FlxG.keys.justPressed.ANY) silly1Code(FlxG.keys.firstJustPressed());
}

function silly1Code(input:Int) {
	if (input == funni1[curPos1]) {
		curPos1 += 1;
		if (curPos1 >= funni1.length) silly1Video();
	}
	else
		curPos1 += 0;
}

var activated1:Bool = false;
function silly1Video() {
	disableInput();
	FlxG.sound.music.pause();
	openSubState(new ModSubState("secrets/beanLoafVideo"));
	curPos1 = 0;

	activated1 = true;
}

var funni2:Array<Int> = [80, 65, 80, 69, 82, 67, 85, 84];
var curPos2:Int = 0;
function silly2() {
	if (FlxG.keys.justPressed.ANY) silly2Code(FlxG.keys.firstJustPressed());
}

function silly2Code(input:Int) {
	if (input == funni2[curPos2]) {
		curPos2 += 1;
		if (curPos2 >= funni2.length) silly2Video();
	}
	else
		curPos2 += 0;
}

var activated2:Bool = false;
function silly2Video() {
	disableInput();
	FlxG.sound.music.pause();
	openSubState(new ModSubState("secrets/beanSadPaperVideo"));
	curPos2 = 0;

	activated2 = true;
}

function disableInput() {
	FlxG.mouse.visible = false;
	allowMouse = false;
	allowKeyboard = false;
	allowHovering = false;
}

function enableInput() {
	FlxG.mouse.visible = true;
	allowMouse = true;
	allowKeyboard = true;
	allowHovering = true;
}

function resetInput() {
	enableInput();

	itemSelected = false;

	if (activated1 || activated2) {
		FlxG.sound.music.resume();
		FlxG.sound.music.volume = 0;

		if (activated1) {
			FlxG.sound.music.fadeIn(8);
			jumpscare();
		}
		else {
			FlxG.sound.music.fadeIn(1);
		}

		activated1 = activated2 = false;
	}
}

function jumpscare() {
	var imagesArrayLol:Array<String> = FileSystem.readDirectory(Assets.getPath(Paths.file("images/mainmenu/loaf")));
	var theChosenOne:String = imagesArrayLol[FlxG.random.int(0, imagesArrayLol.length - 1)];

	var loaf:FlxSprite = new FlxSprite().loadGraphic(Paths.file("images/mainmenu/loaf/" + theChosenOne));
	loaf.setGraphicSize(FlxG.width, FlxG.height);
	loaf.updateHitbox();
	loaf.screenCenter();
	add(loaf);

	FlxTween.tween(loaf, {alpha: 0}, 2, {startDelay: 0.25});

	FlxG.sound.play(Paths.sound("vine-boom"), 1);
}