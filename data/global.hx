import funkin.backend.MusicBeatTransition;
import lime.graphics.Image;

public static var playableBean:String = "bf";

public static var oldStickers:Array<Any>;

public static var lastFreeplayPage:Int = 0;

function new() {
    initSaveData();

    oldStickers = [/*
        {
            image: "",
            x: 0,
            y: 0,
            scale: 1.0,
            angle: 0,
            timing: 0
        }
    */];

    window.title = "Friday Night Funkin': Bean Edition";
    window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image("appIcon"))));
    FlxSprite.defaultAntialiasing = true;
}

function initSaveData() {
    if (FlxG.save.data.beans == null) FlxG.save.data.beans = 0;
    if (FlxG.save.data.camMove == null) FlxG.save.data.camMove = true;
    if (FlxG.save.data.playableBean == null) FlxG.save.data.playableBean = "bf";
    if (FlxG.save.data.ownedBeans == null) FlxG.save.data.ownedBeans = ["bf"];
    playableBean = FlxG.save.data.playableBean;
}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.F5) reloadState();
}

function reloadState() {
    FlxG.resetState();
}

function preStateSwitch() {
    MusicBeatTransition.script = "data/states/transitions/stickerTransition";
}
function postStateSwitch() {
    MusicBeatTransition.script = "data/states/transitions/stickerTransition";
}

// da states
var redirectStates:Map<FlxState, String> = [
    MainMenuState => "beanMenuState",
    StoryMenuState => "beanStoryMenuState",
    FreeplayState => "beanFreeplayState"
];

// the actual state modification
function preStateSwitch() {
    for (redirectState in redirectStates.keys()) {
        if (FlxG.game._requestedState is redirectState) {
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
        }
    }
}