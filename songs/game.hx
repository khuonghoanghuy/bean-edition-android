import funkin.editors.charter.Charter;
import funkin.savedata.FunkinSave;
import funkin.savedata.FunkinSave.HighscoreChange;
import funkin.options.Options;
import Date;

var healthLerp:Float = 0;
var beanAmount:Int = 0;

function postCreate() {
    healthLerp = health;
    healthBar.setParent();

    if (FlxG.save.data.campainBean == null)
        FlxG.save.data.campainBean = 0;

    // dont ask pls
    if (FlxG.save.data.tempSongScore == null)
        FlxG.save.data.tempSongScore = 0;

    if (FlxG.save.data.tempAccuracy == null)
        FlxG.save.data.tempAccuracy = 0;

    if (FlxG.save.data.tempMisses == null)
        FlxG.save.data.tempMisses = 0;
}

function onStartSong() {
    inst.onComplete = aosefmnriwfgniorweugth;
}

function update(elapsed:Float) {
    healthLerp = FlxMath.lerp(healthLerp, health, 0.15);
    healthBar.value = healthLerp;

    if (FlxG.keys.justPressed.NINE)
        aosefmnriwfgniorweugth();
}

function aosefmnriwfgniorweugth() /* ignore the function's name LMAO */ {
    scripts.call("onSongEnd");
    inst.volume = 0;
    vocals.volume = 0;
    for (strumLine in strumLines.members) {
		strumLine.vocals.volume = 0;
		strumLine.vocals.pause();
	}
	inst.pause();
	vocals.pause();

    if (validScore) {
        FunkinSave.setSongHighscore(PlayState.SONG.meta.name, PlayState.difficulty, {
			score: songScore,
			misses: misses,
			accuracy: accuracy,
			hits: [],
			date: Date.now().toString()
		}, getSongChanges());
    }

    startCutscene("end-", endCutscene, save);
    PlayState.resetSongInfos();
}

function save() {
    FlxG.save.data.tempSongScore = songScore;
    FlxG.save.data.tempAccuracy = accuracy;
    FlxG.save.data.tempMisses = misses;
    
    if (PlayState.isStoryMode) {
        PlayState.campaignScore += songScore;
        PlayState.campaignMisses += misses;
        PlayState.campaignAccuracyTotal += accuracy;
        PlayState.campaignAccuracyCount++;
        FlxG.save.data.campainBean += Math.floor(songScore / 600);
        PlayState.storyPlaylist.shift();

        if (PlayState.storyPlaylist.length <= 0) {
            if (validScore) {
                FunkinSave.setWeekHighscore(PlayState.storyWeek.id, PlayState.difficulty, {
                    score: PlayState.campaignScore,
                    misses: PlayState.campaignMisses,
                    accuracy: PlayState.campaignAccuracy,
                    hits: [],
                    date: Date.now().toString()
                });
            }
            beanCountup(FlxG.save.data.campainBean);
        }
        else {
            if (validScore) {
                FunkinSave.setSongHighscore(PlayState.SONG.meta.name, PlayState.difficulty, {
                    score: songScore,
                    accuracy: accuracy,
                    misses: misses,
                    hits: [],
                    date: Date.now().toString()
                }, getSongChanges());
            }
            
            PlayState.instance.registerSmoothTransition(PlayState.storyPlaylist[0].toLowerCase(), PlayState.difficulty);
            registerSmoothTransition();
            FlxG.sound.music.stop();
            PlayState.__loadSong(PlayState.storyPlaylist[0].toLowerCase(), PlayState.difficulty);
            FlxG.switchState(new PlayState());
        }
    }
    else {
        if (PlayState.chartingMode) {
            FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, false));
        }
        else {
            beanCountup(0);
        }
    }
}

function getSongChanges():Array<HighscoreChange> {
    var a = [];
    if (PlayState.opponentMode) 
        a.push(HighscoreChange.COpponentMode);
    if (PlayState.coopMode) 
        a.push(HighscoreChange.CCoopMode);
    return a;
}

function beanCountup(?totalBeans:Int = 0) {
    var displayScore = FlxG.save.data.tempSongScore;
    var displayAccuracy = FlxG.save.data.tempAccuracy;
    var displayMisses = FlxG.save.data.tempMisses;

    if (totalBeans == 0) {
        beanAmount = Math.floor(displayScore / 600);
    } else {
        beanAmount = totalBeans;
    }

    var beanDoneGoesAmount:Bool = false;
    var beanSoundPlayOnce:Bool = false;

    var beanCam:FlxCamera = new FlxCamera();
    beanCam.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(beanCam, false);

    var beans:FlxSprite = new FlxSprite(20, 20, Paths.image("bean"));
    beans.camera = beanCam;
    beans.alpha = 0;
    add(beans);

    var currentBeans:Float = beanAmount;
    var beansTxt:FunkinText = new FunkinText((beans.x + beans.width) + 20, ((beans.y + beans.height) / 4) + 5, 0, Std.string(Math.floor(currentBeans)), 64);
    beansTxt.alignment = "left";
    beansTxt.borderSize = 2.5;
    beansTxt.camera = beanCam;
    add(beansTxt);

    FlxTween.tween(beans, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});
    FlxTween.tween(beansTxt, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});

    new FlxTimer().start(2, function(tmr:FlxTimer) {
        FlxG.save.data.beans += beanAmount;
        FlxTween.num(beanAmount, 0, 1, {ease: FlxEase.expoIn}, function(value:Float) {
            currentBeans = value;
            beansTxt.text = Std.string(Math.floor(currentBeans));
            if (!beanSoundPlayOnce) {
                FlxG.sound.play(Paths.sound("getbeans"));
                beanSoundPlayOnce = true;
            }
        }).onComplete = function(_) {
            FlxTween.tween(beans, {alpha: 0}, 0.5, {ease: FlxEase.expoIn});
            FlxTween.tween(beansTxt, {alpha: 0}, 0.5, {ease: FlxEase.expoIn});
            
            FlxG.save.data.tempSongScore = 0;
            FlxG.save.data.tempAccuracy = 0;
            FlxG.save.data.tempMisses = 0;
            FlxG.save.data.campainBean = 0;
            
            new FlxTimer().start(1, function(tmr:FlxTimer) {
                FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new ModState("beanFreeplayState"));
            });
        };
    });
}