import flixel.effects.FlxFlicker;

/*
import funkin.backend.scripting.EventManager;
import funkin.backend.scripting.events.WeekSelectEvent;
*/

import funkin.backend.utils.DiscordUtil;
import funkin.savedata.FunkinSave;
import funkin.backend.week.Week;

import funkin.mobile.controls.FlxDPadMode;
import funkin.mobile.controls.FlxActionMode;

// loaf say using the public beta one
var bg:FlxSprite;
var bar:FlxSprite;
var exitbutton:FlxSprite;

var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();

var weeks:Array<WeekData> = [];
var curDifficulty:Int = 0;
var curWeek:Int = 0;
var weekList:StoryWeeklist;

var curSelected:Int = 0;
var max:Int = 1;

var storyData = [
	{x: 130, y: 155, img: 'redstory'},
	{x: 775, y: 150, img: 'limestory'}
];

var scoreText:FunkinText;
var lerpScore:Float = 0;
var intendedScore:Int = 0;

var selectedSomethin:Bool = false;
var isHovering:Bool = false;

function create() {
	DiscordUtil.call("onMenuLoaded", ["Story Menu"]);

	CoolUtil.playMenuSong();

	selectedSomethin = false;

	loadXMLs();

	bg = new FlxSprite(0, 0, Paths.image("storymenu/bg"));
	bg.screenCenter();
	bg.scale.set(0.35, 0.35);
	add(bg);

	bar = new FlxSprite(0, 0, Paths.image("storymenu/bar"));
	add(bar);

	exitbutton = new FlxSprite(20, 0, Paths.image("storymenu/funni-exit-button"));
	exitbutton.alpha = 0.6;
	add(exitbutton);

	scoreText = new FunkinText(10, 670, 0, "SCORE: -", 36);
	scoreText.setFormat(Paths.font("vcr.ttf"), 32);
	add(scoreText);

	add(menuItems);

	for (i in 0...storyData.length) {
		var data = storyData[i];
		var menuItem = new FlxSprite(data.x, data.y, Paths.image('storymenu/' + data.img));
		menuItem.scale.set(0.4, 0.4);
		menuItem.origin.set();
		menuItem.alpha = 0.7;
		menuItem.ID = i;
		menuItem.updateHitbox();
		menuItems.add(menuItem);
	}

	addVPad(LEFT_RIGHT, A_B);
	addVPadCamera();
	vPad.visible = true;
}

function update(elapsed:Float) {
	lerpScore = lerp(lerpScore, intendedScore.score, 0.5);
	scoreText.text = 'SCORE: ' + Math.round(lerpScore);
	if (FlxG.mouse.overlaps(exitbutton)) {
		exitbutton.alpha = 1;
		if (!isHovering) {
			FlxG.sound.play(Paths.sound('menu/scroll'));
			isHovering = true;
		}
		if (FlxG.mouse.justPressed) {
			FlxG.sound.play(Paths.sound('menu/confirm'));
			FlxFlicker.flicker(exitbutton, 1, 0.06, true, false, function(flick:FlxFlicker) {
				FlxG.switchState(new MainMenuState());
			});
		}
	} else {
		exitbutton.alpha = 0.6;
		isHovering = false;
	}

	if (controls.BACK) {
		FlxG.sound.play(Paths.sound('menu/confirm'));
		FlxG.switchState(new MainMenuState());
	}

	if (!selectedSomethin)
	{
		if (controls.LEFT_P) changeStory(-1);
		if (controls.RIGHT_P) changeStory(1);

		for (i in 0...menuItems.members.length)
		{
			if (i == curSelected)
				menuItems.members[i].alpha = 1;
			else
				menuItems.members[i].alpha = 0.7;
		}

		if (controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('menu/confirm'));
			selectedSomethin = true;
			switch (curSelected)
			{
				case 0:
					FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, true, false, function(flick:FlxFlicker) {
						selectWeek();
					});
				case 1:
					FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, true, false, function(flick:FlxFlicker) {
						selectWeek();
					});
			}
		}
	}
}

function loadXMLs() {
	weekList = getWeeks(true, false);
	weeks = weekList;
}

function selectWeek() {
	var weekThing = weeks[curSelected];
	var difficult = "normal";

	selectedSomethin = false;

	PlayState.loadWeek(weekThing, difficult);
	FlxG.switchState(new PlayState());
}

function changeStory(sel:Int) {
	FlxG.sound.play(Paths.sound('menu/scroll'));

	var newWeek = curWeek;
	if (weeks.length > 0) {
		newWeek = FlxMath.wrap(curWeek + sel, 0, weeks.length - 1);
	}

	curSelected += sel;
	if (curSelected > max) curSelected = 0;
	if (curSelected < 0) curSelected = max;

	intendedScore = FunkinSave.getWeekHighscore(weeks[curWeek].id, weeks[curWeek].difficulties[curDifficulty]);
}

function getWeeks(useTxt:Bool = true, loadChars:Bool = false):Array<Dynamic> {
	var path:String = Paths.txt('weeks/weeks');
	var weeksFound:Array<String> = useTxt && Paths.assetsTree.existsSpecific(path, "TEXT", false) ? CoolUtil.coolTextFile(path) :
		[for (c in Paths.getFolderContent('data/weeks/weeks/', false, false)) if (Path.extension(c).toLowerCase() == "xml") Path.withoutExtension(c)];

	var weeks2return:Array<Dynamic> = [];
	if (weeksFound.length > 0) {
		for (w in weeksFound) {
			var week = Week.loadWeek(w, loadChars);
			if (week != null) weeks2return.push(week);
		}
	}

	return weeks2return;
}