function create() {
    importScript("data/global");
}

function postCreate() {
    if (PlayState.isStoryMode) return;

    // fuck this shit bruh
    var positionX:Float = strumLines.members[1].characters[0].x;
	var positionY:Float = strumLines.members[1].characters[0].y;
    var oldChar:Character = strumLines.members[1].characters[0];
    var newChar:Character = new Character(positionX, positionY, playableBean, true);

    newChar.shader = oldChar.shader;

    var group = FlxTypedGroup.resolveGroup(oldChar) ?? this;
    group.insert(group.members.indexOf(oldChar), newChar);
    newChar.active = newChar.visible = true;
    group.remove(oldChar);

    strumLines.members[1].characters[0] = newChar;

    iconP1.setIcon(newChar.getIcon());
	if (Options.colorHealthBar) {
        healthBar.createColoredFilledBar(newChar.iconColor);
        healthBar.updateBar();
    }
}