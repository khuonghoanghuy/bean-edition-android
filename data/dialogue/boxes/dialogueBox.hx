import funkin.game.cutscenes.dialogue.DialogueCharacter;

var bubble1:FlxSprite;
var bubble2:FlxSprite;

var lastLineIcon:FlxSprite;
var curLineIcon:FlxSprite;

var charName:FunkinText;
var lastCharName:FunkinText;

var lastText:FunkinText;

var defaultPath:String = "dialogue/icons/";

function postCreate() {
    bubble1 = new FlxSprite(this.x + 124, this.y + 92).loadGraphic(Paths.image("dialogue/boxes/bubble"));
    bubble1.scale.set(0.9, 1);
    bubble1.updateHitbox();

    bubble2 = new FlxSprite(bubble1.x, bubble1.y + bubble1.height + 10).loadGraphic(Paths.image("dialogue/boxes/bubble"));
    bubble2.scale.set(0.9, 1);
    bubble2.updateHitbox();
    bubble2.visible = false;

    curLineIcon = new FlxSprite(bubble1.x, bubble1.y - 10).loadGraphic(Paths.image(defaultPath + "blank"));
    curLineIcon.scale.set(0.85, 0.85);
    curLineIcon.updateHitbox();

    lastLineIcon = new FlxSprite(bubble2.x, bubble2.y - 10).loadGraphic(Paths.image(defaultPath + "blank"));
    lastLineIcon.visible = false;
    lastLineIcon.scale.set(0.85, 0.85);
    lastLineIcon.updateHitbox();

    lastText = new FunkinText(text.x, bubble2.y + 36, text.fieldWidth, "", text.size, false);
    lastText.font = text.font;
    lastText.color = text.color;

    charName = new FunkinText(bubble1.x + 124, bubble1.y + 2, 200, "", 28, true);
    charName.bold = true;
    charName.font = Paths.font("arial.ttf");
    charName.borderSize = 2.5;

    lastCharName = new FunkinText(bubble2.x + 124, bubble2.y + 2, 200, "", 28, true);
    lastCharName.bold = true;
    lastCharName.font = Paths.font("arial.ttf");
    lastCharName.borderSize = 2.5;
    lastCharName.visible = false;
}

function postPlayBubbleAnim(event) {
    cutscene.insert(cutscene.members.indexOf(this) + 1, bubble1);
    cutscene.insert(cutscene.members.indexOf(bubble1) + 1, charName);
    cutscene.insert(cutscene.members.indexOf(bubble1) + 1, curLineIcon);
    cutscene.insert(cutscene.members.indexOf(bubble1) + 1, bubble2);
    cutscene.insert(cutscene.members.indexOf(text) + 1, lastText);
    cutscene.insert(cutscene.members.indexOf(bubble2) + 1, lastCharName);
    cutscene.insert(cutscene.members.indexOf(bubble2) + 1, lastLineIcon);
}

var isFirstLine:Bool = true;
var secondLine:String;
function onPlayAnim(event) {
    if (secondLine == null)
        secondLine = cutscene.dialogueLines[0].text;
    if (cutscene.curLine.text == secondLine) {
        isFirstLine = false;
        bubble2.visible = true;
        lastLineIcon.visible = true;
        lastCharName.visible = true;
    }

    if (!isFirstLine) {
        if (cutscene.lastLine.text != lastText.text) {
            lastText.text = cutscene.lastLine.text;
        }
    }

    setNewIcon(event.animName);
}

function setNewIcon(icon:String) {
    lastLineIcon.loadGraphicFromSprite(curLineIcon);
    curLineIcon.loadGraphic(Paths.image(defaultPath + icon));

    lastCharName.text = charName.text;
    if (icon == "bf") icon = "boyfriend";
    charName.text = toTitleCase(icon);
}

public static function toTitleCase(value:String):String {
    var words:Array<String> = value.split(' ');
    var result:String = '';
    for (i in 0...words.length) {
        var word:String = words[i];
        result += word.charAt(0).toUpperCase() + word.substr(1).toLowerCase();
        if (i < words.length - 1)
        {
            result += ' ';
        }
    }
    return result;
}