var descText:FunkinText;

var youtube:FlxSprite;
var discord:FlxSprite;

function create() {
    FlxG.mouse.visible = true;

    var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    bg.alpha = 0;
    add(bg);
    
    var pageTitle = new FunkinText(0, 165, 0, "Socials Bean Edition");
    pageTitle.setFormat(Paths.font("tardling.otf"), 72, FlxColor.WHITE);
    pageTitle.screenCenter(FlxAxes.X);
    add(pageTitle);

    youtube = new FlxSprite(256, FlxG.height - 355);
    youtube.frames = Paths.getFrames("social/youtube");
    youtube.animation.addByPrefix("idle", "Untitled-2000", 12, true);
    youtube.animation.play("idle");
    youtube.scale.set(0.4, 0.4);
    youtube.updateHitbox();
    youtube.alpha = 0;
    add(youtube);

    discord = new FlxSprite(FlxG.width - 475, FlxG.height - 355);
    discord.frames = Paths.getFrames("social/discord");
    discord.animation.addByPrefix("idle", "discordwhite", 18, true);
    discord.animation.play("idle");
    discord.scale.set(0.6, 0.6);
    discord.updateHitbox();
    discord.alpha = 0;
    add(discord);

    descText = new FunkinText(pageTitle.x - 175, 650, 0, "");
    descText.setFormat(Paths.font("tardling.otf"), 42, FlxColor.WHITE);
    descText.updateHitbox();
    add(descText);

    FlxTween.tween(bg, {alpha: 0.6}, 0.1, {ease: FlxEase.quartInOut});
    FlxTween.tween(youtube, {alpha: 0.6}, 0.1, {ease: FlxEase.quartInOut});
    FlxTween.tween(discord, {alpha: 0.6}, 0.1, {ease: FlxEase.quartInOut});
    FlxTween.tween(pageTitle, {alpha: 1, y: 150}, 0.1, {ease: FlxEase.quartInOut});
}

var selected:Bool = false;
var curSelected:Int = 0;
function update(elapsed:Float) {
    if (!selected){
        if (FlxG.keys.justPressed.ESCAPE) {
            close();
        }

        if (FlxG.mouse.overlaps(youtube)) {
            if (curSelected != 1)
            {
                curSelected = 1;
                FlxG.sound.play(Paths.sound('menu/scroll'));
                FlxTween.cancelTweensOf(youtube);
                FlxTween.tween(youtube, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
                FlxTween.cancelTweensOf(discord);
                FlxTween.tween(discord, {alpha: 0.6}, 0.1, {ease: FlxEase.quartInOut});
                descText.text = "Check out the official Bean Edition Youtube channel!";
                descText.screenCenter(FlxAxes.X);
                descText.updateHitbox();
            }
            if (FlxG.mouse.justPressed) {
                selected = true;
                FlxG.openURL("https://www.youtube.com/@FNFBeanEdition");
                selected = false;
            }
        }
        else if (FlxG.mouse.overlaps(discord)) {
            if (curSelected != 2)
            {
                curSelected = 2;
                FlxG.sound.play(Paths.sound('menu/scroll'));
                FlxTween.cancelTweensOf(discord);
                FlxTween.tween(discord, {alpha: 1}, 0.2, {ease: FlxEase.quartInOut});
                FlxTween.cancelTweensOf(youtube);
                FlxTween.tween(youtube, {alpha: 0.6}, 0.2, {ease: FlxEase.quartInOut});
                descText.text = "Join the Offcial Beanpostorm Discord Server!";
                descText.screenCenter(FlxAxes.X);
                descText.updateHitbox();
            }
            if (FlxG.mouse.justPressed) {
                selected = true;
                FlxG.openURL("https://discord.gg/ap5mvrwvnx"); // if u see this, pls join our discord server :3
                selected = false;
            }
        }
        else if (curSelected != 0)
        {
            curSelected = 0;
            descText.text = "";
            descText.updateHitbox();
            FlxTween.cancelTweensOf(youtube);
            FlxTween.cancelTweensOf(discord);
            FlxTween.tween(youtube, {alpha: 0.6}, 0.2, {ease: FlxEase.quartInOut});
            FlxTween.tween(discord, {alpha: 0.6}, 0.2, {ease: FlxEase.quartInOut});
        }
    }
}

function beatHit() {
    discord.animation.play("idle");
}