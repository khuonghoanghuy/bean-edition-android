import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.backend.utils.CoolUtil;
import flixel.util.FlxAxes;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import funkin.mobile.controls.FlxDPadMode;
import funkin.mobile.controls.FlxActionMode;

var storyButton:FlxSprite;
var storyText:FunkinText;
var freeplayButton:FlxSprite;
var freeplayText:FunkinText;

var selectedSomethin:Bool = false;
var curSelected:Int = 0;

var maxButtons:Int = 1;

function create() {
    selectedSomethin = false;

    var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    bg.alpha = 0;
    add(bg);

    var hLine:FlxSprite = new FlxSprite(0, 120);
    hLine.makeGraphic(1080, 12, FlxColor.WHITE);
    hLine.scale.set(0, 1);
    hLine.screenCenter(FlxAxes.X);
    add(hLine);

    var playBigText:FunkinText = new FunkinText(994, 0, 0, "Play", 80);
    playBigText.alignment = "right";
    playBigText.alpha = 0;
    add(playBigText);

    storyButton = new FlxSprite(240, 200);
    storyButton.frames = (FlxG.random.bool(5) ? Paths.getFrames('mainmenu/storySecret') : Paths.getFrames('mainmenu/story'));
    storyButton.animation.addByPrefix('idle', 'idle', 1);
    storyButton.animation.addByPrefix('smellect', 'select', 1);
    storyButton.animation.play('idle');
    storyButton.scale.set(0.25, 0.25);
    storyButton.updateHitbox();
    storyButton.alpha = 0;
    add(storyButton);

    storyText = new FunkinText(storyButton.x - 22, storyButton.y + 385, storyButton.width, "Story Mode", 52, false);
    storyText.alignment = "right";
    storyText.color = 0xFF0A3C33;
    storyText.alpha = 0;
    add(storyText);

    freeplayButton = new FlxSprite(680, 200);
    freeplayButton.frames = Paths.getFrames('mainmenu/freeplay');
    freeplayButton.animation.addByPrefix('idle', 'idle', 1);
    freeplayButton.animation.addByPrefix('smellect', 'select', 1);
    freeplayButton.animation.play('idle');
    freeplayButton.scale.set(0.25, 0.25);
    freeplayButton.updateHitbox();
    freeplayButton.alpha = 0;
    add(freeplayButton);

    freeplayText = new FunkinText(freeplayButton.x - 22, freeplayButton.y + 385, freeplayButton.width, "Freeplay", 52, false);
    freeplayText.alignment = "right";
    freeplayText.color = 0xFF0A3C33;
    freeplayText.font = Paths.font('vcr.ttf');
    freeplayText.alpha = 0;
    add(freeplayText);

    FlxTween.tween(bg, {alpha: 0.6}, 0.2, {ease: FlxEase.quartInOut});
    FlxTween.tween(hLine.scale, {x: 1}, 0.4, {ease: FlxEase.quartOut});
    FlxTween.tween(storyButton, {alpha: 1, y: 160}, 0.2, {ease: FlxEase.quartOut, startDelay: 0.05});
    FlxTween.tween(storyText, {alpha: 1, y: 545}, 0.2, {ease: FlxEase.quartOut, startDelay: 0.05});
    FlxTween.tween(freeplayButton, {alpha: 1, y: 160}, 0.2, {ease: FlxEase.quartOut, startDelay: 0.05});
    FlxTween.tween(freeplayText, {alpha: 1, y: 545}, 0.2, {ease: FlxEase.quartOut, startDelay: 0.05});
    FlxTween.tween(playBigText, {alpha: 1, y: 32}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.05});

	addVPad(LEFT_RIGHT, A_B);
	addVPadCamera();
	vPad.visible = true;
}

function update(elapsed:Float)
{
	if (!selectedSomethin)
	{
		if (controls.LEFT_P) gamemodesChange(-1);
		if (controls.RIGHT_P) gamemodesChange(1);

		if (curSelected == 0) // Story Mode
		{
			if (storyButton.animation != null) {
				storyButton.animation.play('smellect', true);
			} else {
                storyButton.animation.play('idle', true);
            }
			storyText.color = 0xFF10584B;
		}
		else
		{
			if (storyButton.animation != null) {
				storyButton.animation.play('idle', true);
			} else {
                storyButton.animation.play('idle', true);
            }
			storyText.color = 0xFF0A3C33;
		}

		if (curSelected == 1) // Freeplay
		{
			if (freeplayButton.animation != null) {
				freeplayButton.animation.play('smellect', true);
			} else {
                freeplayButton.animation.play('idle', true);
            }
			freeplayText.color = 0xFF10584B;
		}
		else
		{
			if (freeplayButton.animation != null) {
				freeplayButton.animation.play('idle', true);
			} else {
                freeplayButton.animation.play('idle', true);
            }
			freeplayText.color = 0xFF0A3C33;
		}

		if (controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('menu/confirm'));
			selectedSomethin = true;
			switch(curSelected)
			{
				case 0:
					FlxFlicker.flicker(storyButton, 1, 0.06, true, false, function(flick:FlxFlicker){
                        FlxG.switchState(new ModState("beanStoryMenuState"));
                    });
					FlxFlicker.flicker(storyText, 1, 0.06, true, false);
				case 1:
					FlxFlicker.flicker(freeplayButton, 1, 0.06, true, false, function(flick:FlxFlicker){
                        FlxG.switchState(new ModState("beanFreeplayState"));
                    });
					FlxFlicker.flicker(freeplayText, 1, 0.06, true, false);
			}
		}

		if (controls.BACK)
		{
			FlxG.mouse.visible = true;
			FlxG.sound.play(Paths.sound('menu/cancel'));
			MusicBeatState.skipTransOut = true;
			FlxG.resetState();
		}
	}
}

function gamemodesChange(ass:Int = 0)
{
	FlxG.sound.play(Paths.sound('menu/scroll'));
	curSelected += ass;
	if (curSelected > maxButtons) curSelected = 0;
	if (curSelected < 0) curSelected = maxButtons;
}