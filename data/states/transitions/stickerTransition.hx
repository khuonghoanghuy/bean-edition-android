import funkin.backend.MusicBeatState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.util.FlxSort;

var stickerGroup:FlxGroup;

var stckrSet:Int = 1;
var stckrPack:String = "all";

var newState:FlxState;
var transitionIn:Bool;

function create(event) {
    event.cancel();

    newState = event.newState;
    transitionIn = event.transOut; // for some reason this is backwards

    var songMeta:Json;

    if (PlayState.SONG != null) {
        var jsonPathExistance:Bool = Assets.exists(Paths.file("songs/" + PlayState.SONG.meta.name + "/meta.json"));
        if (jsonPathExistance)
            songMeta = Json.parse(Assets.getText(Paths.file("songs/" + PlayState.SONG.meta.name + "/meta.json")));
    }

    if (songMeta != null && songMeta.customValues != null) {
        var daSet = songMeta.customValues.stickerSet != null ? songMeta.customValues.stickerSet : 1;
        var daPac = songMeta.customValues.stickerPack != null ? songMeta.customValues.stickerPack : "all";
        stckrSet = daSet;
        stckrPack = daPac;
    }
    else {
        stckrSet = 1;
        stckrPack = "all";
    }

    transitionCamera.bgColor = 0x00FFFFFF;

    stickerGroup = new FlxGroup();
    stickerGroup.camera = transitionCamera;
    add(stickerGroup);

    if (newState == null || !transitionIn) {
        if (MusicBeatState.skipTransOut) {
            switching = false;
            close();
            return;
        }

        if (stickerGroup.members.length > 0) {
            stickerGroup.clear();
        }

        if (oldStickers[0] != null) {
            for (oldSticker in oldStickers) {
                var newSticker:FunkinSprite = new FunkinSprite().loadGraphic(oldSticker.image);
                newSticker.x = oldSticker.x;
                newSticker.y = oldSticker.y;
                newSticker.scale.x = newSticker.scale.y = oldSticker.scale;
                newSticker.angle = oldSticker.angle;
                newSticker.extra["timing"] = oldSticker.timing;
                stickerGroup.add(newSticker);
            }
            stickerGroup.sort((ord, a, b) -> {
                return FlxSort.byValues(ord, a.timing, b.timing);
            });
            despawnStickers();
        }
        else {
            respawnStickers(); // creates the stickers and then initiates the trans out animation
        }
    }
    else {
        if (MusicBeatState.skipTransIn)
            transitionImmediatly();
        else
            spawnStickers();
    }
}

var switching:Bool = false;

function spawnStickers() {
    resetOldStickers();

    if (stickerGroup.members.length > 0) {
        stickerGroup.clear();
    }

    var stickInfo:StickerMeta = new StickerMeta(stckrSet);
    var anotherStickersVar:Map<String, Array<String>> = [];

    for (sets in stickInfo.getPack(stckrPack)) {
        anotherStickersVar.set(sets, stickInfo.getStickers(sets));
    }

    var xPos:Float = -100;
    var yPos:Float = -100;
    while (xPos <= FlxG.width) {
        var stickID:Int = FlxG.random.int(0, anotherStickersVar.keys().array.length - 1);
        var stckrGroup = anotherStickersVar.get(anotherStickersVar.keys().array[stickID]);
        if (stckrGroup == null) throw "Couldn't get Sticker Pack [" + stickID + "]";

        var bean:Int = FlxG.random.int(0, stckrGroup.length - 1);
        var path:String = Paths.image("stickers/set" + Std.string(stckrSet) + "/" + stckrGroup[bean]);
        var sticker:FunkinSprite = new FunkinSprite().loadGraphic(path);
        sticker.extra["image"] = path;
        sticker.visible = false;

        sticker.x = xPos;
        sticker.y = yPos;
        xPos += sticker.frameWidth * 0.5;

        if (xPos >= FlxG.width) {
            if (yPos <= FlxG.height) {
                xPos = -100;
                yPos += FlxG.random.float(70, 120);
            }
        }

        sticker.angle = FlxG.random.int(-60, 70);
        stickerGroup.add(sticker);
    }

    shuffle(stickerGroup.members);

    for (i => sticker in stickerGroup.members) {
        sticker.extra["timing"] = FlxMath.remapToRange(i, 0, stickerGroup.members.length, 0, 0.9);

        new FlxTimer().start(sticker.extra["timing"], _ -> {
            sticker.visible = true;

            var sound = Paths.soundRandom("stickers/click", 1, 8);
            FlxG.sound.play(sound);

            var frameTimer:Int = FlxG.random.int(0, 2);
            if (i == stickerGroup.members.length - 1) frameTimer = 2;

            new FlxTimer().start((1 / 24) * frameTimer, _ -> {
                sticker.scale.x = sticker.scale.y = FlxG.random.float(0.97, 1.02);

                if (i == stickerGroup.members.length - 1) {
                    switching = true;
                    FlxG.switchState(newState);
                }
            });
        });
    }

    stickerGroup.sort((ord, a, b) -> {
        return FlxSort.byValues(ord, a.timing, b.timing);
    });

    var lastSticker:FunkinSprite = stickerGroup.members[stickerGroup.members.length - 1];
    lastSticker.updateHitbox();
    lastSticker.angle = 0;
    lastSticker.screenCenter();

    for (i in 0...stickerGroup.members.length - 1) {
        var sticker = stickerGroup.members[i];
        oldStickers.push({
            image: sticker.extra["image"],
            x: sticker.x,
            y: sticker.y,
            scale: sticker.scale.x,
            angle: sticker.angle,
            timing: sticker.extra["timing"]
        });
    }
}

// from flixel.math.FlxRandom
function shuffle(array:Array):Void {
    var maxValidIndex = array.length - 1;
    for (i in 0...maxValidIndex) {
        var j = FlxG.random.int(i, maxValidIndex);
        var tmp = array[i];
        array[i] = array[j];
        array[j] = tmp;
    }
}

function despawnStickers() {
    for (i => sticker in stickerGroup.members) {
        new FlxTimer().start(sticker.extra["timing"], _ -> {
            sticker.visible = false;

            var sound = Paths.soundRandom("stickers/click", 1, 8);
            FlxG.sound.play(sound);

            if (i == stickerGroup.length - 1) {
                switching = false;
                close();
            }
        });
    }

    resetOldStickers();
}

function respawnStickers() {
    if (stickerGroup.members.length > 0) {
        stickerGroup.clear();
    }

    var stickInfo:StickerMeta = new StickerMeta(stckrSet);
    var anotherStickersVar:Map<String, Array<String>> = [];

    for (sets in stickInfo.getPack(stckrPack)) {
        anotherStickersVar.set(sets, stickInfo.getStickers(sets));
    }

    var xPos:Float = -100;
    var yPos:Float = -100;
    while (xPos <= FlxG.width) {
        var stickID:Int = FlxG.random.int(0, anotherStickersVar.keys().array.length - 1);
        var stckrGroup = anotherStickersVar.get(anotherStickersVar.keys().array[stickID]);
        if (stckrGroup == null) {
            throw "Couldn't get Sticker Pack [" + stickID + "]";
            break;
        }

        var bean:Int = FlxG.random.int(0, stckrGroup.length - 1);
        var path:String = Paths.image("stickers/set" + Std.string(stckrSet) + "/" + stckrGroup[bean]);
        var sticker:FunkinSprite = new FunkinSprite().loadGraphic(path);

        sticker.x = xPos;
        sticker.y = yPos;
        xPos += sticker.frameWidth * 0.5;

        if (xPos >= FlxG.width) {
            if (yPos <= FlxG.height) {
                xPos = -100;
                yPos += FlxG.random.float(70, 120);
            }
        }

        sticker.angle = FlxG.random.int(-60, 70);
        sticker.scale.x = sticker.scale.y = FlxG.random.float(0.97, 1.02);
        stickerGroup.add(sticker);
    }

    shuffle(stickerGroup.members);

    for (i => sticker in stickerGroup.members) {
        sticker.extra["timing"] = FlxMath.remapToRange(i, 0, stickerGroup.members.length, 0, 0.9);

        new FlxTimer().start(sticker.extra["timing"], _ -> {
            sticker.visible = false;

            var sound = Paths.soundRandom("stickers/click", 1, 8);
            FlxG.sound.play(sound);

            if (i == stickerGroup.length - 1) {
                switching = false;
                close();
            }
        });
    }

    resetOldStickers();
}

function onSkip(event) {
    FlxTimer.globalManager.completeAll();
}

function transitionImmediatly() {
    switching = true;
    FlxG.switchState(newState);
}

override function close() {
    if (switching) {
        throw "Tried closing the Sticker Transition in the middle of it!";
        return;
    }
    this.close();
}

function resetOldStickers() {
    oldStickers = [];
}

class StickerMeta {
    public var packs:Map<String, Array<String>> = [];
    public var stickers:Map<String, Array<String>> = [];

    public function new(stickerSet:Int) {
        var path = Paths.file("images/stickers/set" + Std.string(stickerSet) + "/stickers.json");
        var json = Json.parse(Assets.getText(path));

        for (field in Reflect.fields(json.packs)) {
            var thePacks = json.packs;
            var ahh1 = Reflect.field(thePacks, field);

            packs.set(field, ahh1);
        }

        for (field in Reflect.fields(json.stickers)) {
            var theStickers = json.stickers;
            var ahh2 = Reflect.field(theStickers, field);

            stickers.set(field, ahh2);
        }
    }

    public function getStickers(name:String):Array<String> {
        return this.stickers[name];
    }

    public function getPack(name:String, fallback:String = "all"):Array<String> {
        if (!this.packs.exists(name)) return this.packs[fallback];

        return this.packs[name];
    }
}