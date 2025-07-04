import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;
import flixel.group.FlxTypedGroup;
import flixel.tweens.FlxTween.FlxTweenType;
import funkin.backend.assets.AssetsLibraryList.AssetSource;
import funkin.backend.chart.Chart;
import funkin.backend.system.Main;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.utils.FlxInterpolateColor;
import funkin.game.HealthIcon;
import funkin.options.Options;
import funkin.savedata.FunkinSave;
import funkin.savedata.FunkinSave.HighscoreChange;

/**
 * TODO:
 * #1: implement inst playing after hovering on a song for 1 second
 * #2: implement the ability to play with gameplay changers
 */

var pages:Array<Any> = [/*
    {
        title: String,
        songs: Array<String>
    }
*/];
var songs:Array<Any> = [/*
    {
        name: String,
        bpm: String,
        displayName: String,
        beatsPerMeasure: Float,
        stepsPerBeat: Float,
        needsVoices: Bool,
        icon: String,
        color: Dynamic,
        difficulties: Array<String>,
        coopAllowed: Bool,
        opponentModeAllowed: Bool,
        customValues: Dynamic,
        parsedColor: FlxColor
    }
*/];

// how long it takes for being able to change between pages
var pageChangeDelayAmount = 0.25;

var curPage:Int = 0;
var curSong:Int = 0;
var curMode:Int = 0;
var curCoopMode:Int = 0;

var songGroup:FlxTypedGroup<FunkinText>;
var iconGroup:FlxTypedGroup<HealthIcon>;
var musicNote:FlxSprite;

var pageTitle:FunkinText;
var leftArrow:FunkinText;
var rightArrow:FunkinText;

var scoreTxt:FunkinText;
var scoreLerp:Int = 0;
var scoreValue:Int = 0;

var accuracyTxt:FunkinText;
var accuracyLerp:Float = 0.0;
var accuracyValue:Float = 0.0;

var gamemodesTxt:FunkinText;
var gamemodesTable:Array<String> = [
    "Solo [TAB]",
    "Opponent Mode [TAB]",
    "Co-Op Mode [TAB]",
    "Co-Op Mode (Switched) [TAB]"
];

var portrait:FlxSprite;

var glowThing:FlxSprite;
var interpolateColor:FlxInterpolateColor;

function create() {
    importScript("data/global");

    CoolUtil.playMenuSong();

    DiscordUtil.call("onMenuLoaded", ["Freeplay"]);

    var jsonExists:Bool = Assets.exists(Paths.json("freeplayList"));
    if (jsonExists) {
        var daJson = Json.parse(Assets.getText(Paths.json("freeplayList")));
        if (daJson.pages != null || daJson.pages.length > 0) {
            pages = daJson.pages;
        }
    }

    createStars();

    glowThing = new FlxSprite().loadGraphic(Paths.image("freeplaymenu/glow"));
    glowThing.scale.set(3, 3);
    glowThing.updateHitbox();
    glowThing.setPosition(FlxG.width - (glowThing.width / 2), FlxG.height - (glowThing.height / 1.75));
    glowThing.alpha = 0.6;
    add(glowThing);

    portrait = new FlxSprite();
    add(portrait);

    musicNote = new FlxSprite().loadGraphic(Paths.image("freeplaymenu/musicNote"));
    musicNote.scale.set(0.9, 0.9);
    musicNote.updateHitbox();
    musicNote.alpha = 0;
    add(musicNote);

    songGroup = new FlxTypedGroup();
    add(songGroup);

    iconGroup = new FlxTypedGroup();
    add(iconGroup);

    var tempTopBar1:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height * 0.125, FlxColor.BLACK);
    var tempTopBar2:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 8, FlxColor.WHITE);
    tempTopBar2.y += tempTopBar1.height;

    scoreTxt = new FunkinText(FlxG.width, (tempTopBar2.y + tempTopBar2.height) + 4, 500, "", 40, true);
    scoreTxt.x -= scoreTxt.width + 18;
    scoreTxt.alignment = "right";
    scoreTxt.borderSize = 3;
    add(scoreTxt);

    accuracyTxt = new FunkinText(FlxG.width, (scoreTxt.y + scoreTxt.height) - 5, 500, "", 40, true);
    accuracyTxt.x -= accuracyTxt.width + 18;
    accuracyTxt.alignment = "right";
    accuracyTxt.borderSize = 3;
    add(accuracyTxt);

    gamemodesTxt = new FunkinText(FlxG.width, (accuracyTxt.y + accuracyTxt.height) - 1, 600, "", 28, true);
    gamemodesTxt.x -= gamemodesTxt.width + 18;
    gamemodesTxt.alignment = "right";
    gamemodesTxt.borderSize = 2.5;
    add(gamemodesTxt);

    // top bar stuff
    add(tempTopBar1);
    add(tempTopBar2);

    pageTitle = new FunkinText(0, tempTopBar1.height / 5, 0, "");
    pageTitle.setFormat(Paths.font("tardling.otf"), 72, FlxColor.WHITE);
    pageTitle.screenCenter(FlxAxes.X);

    createPageArrows();
    add(pageTitle);

    lastPage = lastFreeplayPage;
    curPage = lastFreeplayPage;
    updatePage();
    for (i => song in songs) {
        if (song.name == Options.freeplayLastSong)
            curSong = i;
    }

    interpolateColor = new FlxInterpolateColor(glowThing.color);

    if (songInst != null)
        startMusicNoteDance();

    changeGamemode(0);

	addVPad(FULL, A_B_C_X_Y);
	addVPadCamera();
	vPad.visible = true;
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

function createPageArrows() {
    leftArrow = new FunkinText(0, 0, 0, "<");
    leftArrow.setFormat(Paths.font("phantom.ttf"), 64, FlxColor.WHITE);
    leftArrow.setPosition(pageTitle.x, pageTitle.y - (pageTitle.height / 8));
    add(leftArrow);

    rightArrow = new FunkinText(0, 0, 0, ">");
    rightArrow.setFormat(Paths.font("phantom.ttf"), 64, FlxColor.WHITE);
    rightArrow.setPosition(pageTitle.x + pageTitle.width, pageTitle.y - (pageTitle.height / 8));
    add(rightArrow);
}

function update(elapsed:Float) {
    handleInput(elapsed);
    handleSongSelection();
    handleInstPlayer(elapsed);

    scoreLerp = Math.floor(lerp(scoreLerp, scoreValue, 0.4));
    if (Math.abs(scoreLerp - scoreValue) <= 10)
		scoreLerp = scoreValue;

    accuracyLerp = lerp(accuracyLerp, accuracyValue, 0.2);
    if (Math.abs(accuracyLerp - accuracyValue) <= 0.01)
		accuracyLerp = accuracyValue;
    FlxMath.roundDecimal(accuracyLerp, 2);

    updateScoreTexts();

    if (songs != null && songs.length > 0 && songs[curSong] != null)
        interpolateColor.fpsLerpTo(songs[curSong].parsedColor, 0.0625);
    else
        interpolateColor.fpsLerpTo(FlxColor.WHITE, 0.0625);
    glowThing.color = interpolateColor.color;
}

function updateScoreTexts() {
    scoreTxt.text = "Personal Best: " + scoreLerp;
    accuracyTxt.text = "PB Accuracy: " + FlxMath.roundDecimal(accuracyLerp * 100, 2) + "%";
}

var pageChangeDelay:Float = 0;
var allowInput = true;
function handleInput(elapsed:Float) {
    if (!allowInput) return;

    if (pageChangeDelay > 0) pageChangeDelay -= elapsed;
    else pageChangeDelay = 0;

    if (FlxG.keys.justPressed.Q || vPad.buttonX.justPressed) {
        pageArrowPressed(true);
		changePage(-1);
    }
    if (FlxG.keys.justPressed.E || vPad.buttonY.justPressed) {
        pageArrowPressed(false);
		changePage(1);
    }

    if (controls.UP_P) {
        changeSelection(-1);
    }
    if (controls.DOWN_P) {
        changeSelection(1);
    }

    if (FlxG.keys.justPressed.TAB || vPad.buttonC.justPressed) {
        changeGamemode(1);
    }

    if (controls.ACCEPT) {
        playSelectedSong();
    }

    if (controls.BACK) {
        lastFreeplayPage = 0;
		FlxG.switchState(new ModState("beanMenuState"));
	}
}

function handleSongSelection() {
    var songHeight:Float = 160;
    for (i => song in songGroup.members) {
        var ySong:Float = ((FlxG.height - songHeight) / 2) + ((i - curSong) * songHeight) + 60;

        song.y = CoolUtil.fpsLerp(song.y, ySong, 0.2);
        song.x = 50 + (Math.abs(Math.cos((song.y + (songHeight / 2) - (FlxG.camera.scroll.y + (FlxG.height / 2))) / (FlxG.height * 1.25) * Math.PI)) * 150);

        iconGroup.members[i].y = song.y - (iconGroup.members[i].height / 4);
        iconGroup.members[i].x = song.x - iconGroup.members[i].width;

        if (songGroup.members.indexOf(song) != curSong) {
            song.alpha = 0.6;
        }
        else {
            song.alpha = 1;
        }
    }
}

var timeBeforePlaying:Float = 1;
var autoplayElapsed:Float = 0;

static var songInst:String = null;
static var curInstPlaying:String = null;

var instPlaying:Bool = false;
var mnX:Float = 25;

var disableInstPlayer:Bool = false;
function handleInstPlayer(elapsed:Float) {
    autoplayElapsed += elapsed;

    if (!disableInstPlayer && !instPlaying && autoplayElapsed > timeBeforePlaying || FlxG.keys.justPressed.SPACE) {
        if (pages[curPage].songs != null && pages[curPage].songs.length >= 1 && curInstPlaying != (curInstPlaying = Paths.inst(songs[curSong].name, songs[curSong].difficulties[0]))) {
            var player:Void->Void = function() {
                FlxG.sound.playMusic(curInstPlaying, 0);
                FlxG.sound.music.fadeIn();
                Conductor.changeBPM(songs[curSong].bpm, songs[curSong].beatsPerMeasure, songs[curSong].stepsPerBeat);

                startMusicNoteDance();

                songInst = songs[curSong].name;
            }
            Main.execAsync(player);
        }
        instPlaying = true;
    }

    if (pages[curPage].songs != null && pages[curPage].songs.length >= 1) {
        for (pageSong in songs) {
            if (pageSong.name == songInst) {
                musicNote.visible = true;
            }
        }
    }
    else {
        musicNote.visible = false;
    }

    for (i => song in songs) {
        if (song.name == songInst) {
            musicNote.y = songGroup.members[i].y - (musicNote.height / 8) + danceOff[1];
            musicNote.x = songGroup.members[i].x + songGroup.members[i].width + mnX + danceOff[0];
        }
    }
}

var danceOff:Array<Float> = [0, 0];
function startMusicNoteDance() {
    FlxTween.cancelTweensOf(musicNote, ["alpha"]);
    musicNote.alpha = 0;
    FlxTween.tween(musicNote, {alpha: 1}, 0.2);
    FlxTween.num(0, 25, 0.2, {ease: FlxEase.sineOut}, function(val:Float) {
        mnX = val;
    });

    danceOff = [0, 0];
    FlxTween.cancelTweensOf(musicNote, ["angle"]);

    // x coords
    FlxTween.num(0, 4, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.expoOut, type: FlxTweenType.PINGPONG}, function(val:Float) {
        danceOff[0] = val;
    });
    // y coords
    FlxTween.num(0, -8, (Conductor.stepCrochet / 1000) * 2.01, {startDelay: (Conductor.stepCrochet / 1000) * 2, ease: FlxEase.expoIn, type: FlxTweenType.PINGPONG}, function(val:Float) {
        danceOff[1] = val;
    });
    // the angle
    FlxTween.angle(musicNote, -2, 2, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.expoOut, type: FlxTweenType.PINGPONG});
}

var lastSong:Int = 0;
function changeSelection(change:Int = 0) {
    curSong = FlxMath.wrap(curSong + change, 0, songs.length - 1);

    updateScores();
    updatePortrait();

    autoplayElapsed = 0;
    instPlaying = false;

    if (curSong != lastSong) {
        FlxG.sound.play(Paths.sound("menu/scroll"), 1);
        lastSong = curSong;
    }
}

var __opponentMode:Bool = false;
var __coopMode:Bool = false;
function updateCoopModes() {
    __opponentMode = false;
    __coopMode = false;

    if (songs[curSong] == null) return;

    if (songs[curSong].coopAllowed && songs[curSong].opponentModeAllowed) {
        __opponentMode = curCoopMode % 2 == 1;
        __coopMode = curCoopMode >= 2;
    } else if (songs[curSong].coopAllowed) {
        __coopMode = curCoopMode == 1;
    } else if (songs[curSong].opponentModeAllowed) {
        __opponentMode = curCoopMode == 1;
    }
}

function updateScores() {
    if (songs[curSong] != null && songs[curSong].difficulties.length <= 0) {
		scoreValue = 0;
        accuracyValue = 0;
		return;
	}
    updateCoopModes();
    var changes:Array<HighscoreChanges> = [];
    if (__coopMode) changes.push(HighscoreChange.CCoopMode);
	if (__opponentMode) changes.push(HighscoreChange.COpponentMode);
    var saveData = FunkinSave.getSongHighscore(songs[curSong].name, songs[curSong].difficulties[0], changes);
    scoreValue = saveData.score ?? 0;
    accuracyValue = saveData.accuracy ?? 0;
}

var curPortrait:String = "";
var lastPortrait:String = "";
function updatePortrait() {
    var portJson:Array<Any>;
    if (songs[curSong] != null && songs[curSong].customValues != null && songs[curSong].customValues.portrait != null) {
        var portJexists:Bool = Assets.exists(Paths.file("images/freeplaymenu/portraits/" + songs[curSong].customValues.portrait + ".json"));
        if (portJexists) {
            portJson = Json.parse(Assets.getText(Paths.file("images/freeplaymenu/portraits/" + songs[curSong].customValues.portrait + ".json")));
            curPortrait = Paths.image("freeplaymenu/portraits/" + songs[curSong].customValues.portrait);
        }
    }

    if (curPortrait != lastPortrait) {
        FlxTween.cancelTweensOf(portrait);

        portrait.loadGraphic(curPortrait);
        portrait.scale.set(portJson.scale, portJson.scale);
        portrait.updateHitbox();

        portrait.setPosition(FlxG.width * 0.5, 0);
        portrait.x += portJson.offsets[0];
        portrait.y += portJson.offsets[1];

        var ogHval:Float = portrait.x;
        portrait.x += 50;
        portrait.alpha = 0;
        FlxTween.tween(portrait, {x: ogHval}, 0.2, {ease: FlxEase.quartOut});
        FlxTween.tween(portrait, {alpha: 1}, 0.2);

        lastPortrait = curPortrait;
    }

    if (curPortrait == null || curPortrait == "null") {
        FlxTween.tween(portrait, {alpha: 0}, 0.2);
    }
}

function changeGamemode(change:Int = 0) {
    var bothEnabled:Bool = songs[curSong].coopAllowed && songs[curSong].opponentModeAllowed;
    curCoopMode = FlxMath.wrap(curCoopMode + change, 0, bothEnabled ? 3 : 1);

    updateScores();

    if (bothEnabled) {
        gamemodesTxt.text = gamemodesTable[curCoopMode];
    }
    else {
        gamemodesTxt.text = gamemodesTable[curCoopMode * (songs[curSong].coopAllowed ? 2 : 1)];
    }
}

var lastPage:Int = 0;
function changePage(change:Int = 0) {
    if (pageChangeDelay > 0) return;

    if ((curPage + change) >= pages.length || (curPage + change) < 0)
        return;

    curPage = FlxMath.wrap(curPage + change, 0, pages.length - 1);

    pageChangeDelay = pageChangeDelayAmount;

    if (curPage != lastPage) {
        FlxG.sound.play(Paths.sound("menu/scroll"), 1);
        lastPage = curPage;
        lastFreeplayPage = curPage;
        updatePage();
    }
}

function updatePage() {
    if (pages.length < 1) return;

    pageTitle.text = pages[curPage].title;
    pageTitle.screenCenter(FlxAxes.X);

    reviveArrow(true);
    reviveArrow(false);
    leftArrow.setPosition(pageTitle.x - 60, pageTitle.y - (pageTitle.height / 8));
    rightArrow.setPosition(pageTitle.x + pageTitle.width + 20, pageTitle.y - (pageTitle.height / 8));

    if (curPage == pages.length - 1)
        killArrow(false);
    if (curPage == 0)
        killArrow(true);

    FlxTween.cancelTweensOf(leftArrow, ["x"]);
    FlxTween.cancelTweensOf(rightArrow, ["x"]);
    FlxTween.tween(leftArrow, {x: leftArrow.x - 10}, 1, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});
    FlxTween.tween(rightArrow, {x: rightArrow.x + 10}, 1, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});

    // resets the page
    songs = [];

    songGroup.forEach(function(sus) {
        sus.destroy();
    });
    songGroup.clear();

    iconGroup.forEach(function(icon) {
        icon.destroy();
    });
    iconGroup.clear();

    if (pages[curPage].songs != null) {
        getSongList();
        for (i in 0...songs.length) {
            var daSong = songs[i];

            var sngTxt:FunkinText = new FunkinText(0, (70 * i) + 30, 0, daSong.displayName);
            sngTxt.setFormat(Paths.font("phantom.ttf"), 64, FlxColor.WHITE);
            songGroup.add(sngTxt);

            var icon:HealthIcon = new HealthIcon(daSong.icon);
            //icon.sprTracker = sngTxt;
            //icon.setUnstretchedGraphicSize(150, 150, true);
            icon.updateHitbox();
            iconGroup.add(icon);
        }
    }
    curSong = 0;
    changeSelection(0);
}

function pageArrowPressed(left:Bool) {
    if (pageChangeDelay > 0) return;

    if (left) {
        if (curPage == 0) return;
        FlxTween.cancelTweensOf(leftArrow);
        leftArrow.scale.set(1.25, 1.25);
        FlxTween.tween(leftArrow, {"scale.x": 1, "scale.y": 1}, 1, {ease: FlxEase.quartOut});
        FlxTween.color(leftArrow, 0.5, FlxColor.CYAN, FlxColor.WHITE);
    }
    else {
        if (curPage == pages.length - 1) return;
        FlxTween.cancelTweensOf(rightArrow);
        rightArrow.scale.set(1.25, 1.25);
        FlxTween.tween(rightArrow, {"scale.x": 1, "scale.y": 1}, 1, {ease: FlxEase.quartOut});
        FlxTween.color(rightArrow, 0.5, FlxColor.CYAN, FlxColor.WHITE);
    }
}

function playSelectedSong() {
    allowInput = false;

    updateCoopModes();

    if (songs[curSong].difficulties.length < 1) return;

    disableInstPlayer = true;
    songInst = null;
    curInstPlaying = null;

    lastFreeplayPage = curPage;
    Options.freeplayLastSong = curSong;

    PlayState.loadSong(songs[curSong].name, songs[curSong].difficulties[0], __opponentMode, __coopMode);

    FlxG.sound.play(Paths.sound('menu/confirm'), 1);
    FlxFlicker.flicker(iconGroup.members[curSong], 1, Options.flashingMenu ? 0.06 : 0.15, true, false);
    FlxFlicker.flicker(songGroup.members[curSong], 1, Options.flashingMenu ? 0.06 : 0.15, true, false, _ -> {
        FlxG.switchState(new PlayState());
    });
}

function getSongList() {
    if (pages[curPage].songs.length > 0) {
        for (gnos in pages[curPage].songs) {
            songs.push(Chart.loadChartMeta(gnos, "normal", false));
        }
    }
}

function killArrow(left:Bool) {
    if (left) {
        FlxTween.tween(leftArrow, {alpha: 0}, 0.5, {startDelay: 0.5});
    }
    else {
        FlxTween.tween(rightArrow, {alpha: 0}, 0.5, {startDelay: 0.5});
    }
}

function reviveArrow(left:Bool) {
    if (left) {
        FlxTween.cancelTweensOf(leftArrow, ["alpha"]);
        leftArrow.alpha = 1;
    }
    else {
        FlxTween.cancelTweensOf(rightArrow, ["alpha"]);
        rightArrow.alpha = 1;
    }
}

// taken from MusicBeatState
function lerp(v1:Float, v2:Float, ratio:Float, fpsSensitive:Bool = false) {
    if (fpsSensitive)
        return FlxMath.lerp(v1, v2, ratio);
    else
        return CoolUtil.fpsLerp(v1, v2, ratio);
}