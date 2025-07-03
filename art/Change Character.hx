import haxe.ds.StringMap;

var charMap:Array<Array<StringMap<Character>>> = [];

// credits to rodney568 on Codename Engine's discord, he made this script
// https://discord.com/channels/860561967383445535/1222286035225022604
// this event was slightly modified!

function postCreate() {
	for (event in events) {
		if (event.name == 'Change Character') {
			for (strumLane in strumLines) {
				var strumIndex:Int = strumLines.members.indexOf(strumLane);
				if (charMap[strumIndex] == null) charMap[strumIndex] = [];
				trace('Strum Index: ' + strumIndex);
				
				for (char in strumLane.characters) {
					var charIndex:Int = strumLane.characters.indexOf(char);
					if (charMap[strumIndex][charIndex] == null) charMap[strumIndex][charIndex] = new StringMap();
					trace('Character Index: ' + charIndex);

					var charName:String = event.params[1];
					if (char.curCharacter == charName) {
						trace('Old Character: ' + char.curCharacter);
						charMap[strumIndex][charIndex].set(char.curCharacter, char);
					}
					if (!charMap[strumIndex][charIndex].exists(charName)) {
						var newChar:Character = new Character(char.x, char.y, charName, char.isPlayer);
						trace('New Character: ' + newChar.curCharacter);
						charMap[strumIndex][charIndex].set(newChar.curCharacter, newChar);
						newChar.active = newChar.visible = false;
						newChar.drawComplex(FlxG.camera);
					}
				}
			}
		}
	}
}

function onEvent(event) {
	if (event.event.name == 'Change Character')
		switchCharacter(event.event.params[0], event.event.params[1],event.event.params[2])
}

public function switchCharacter(sIndex:Int, charName:String, cIndex:Int) {
		var oldChar:Character = strumLines.members[sIndex].characters[cIndex];
		var newChar:Character = charMap[sIndex][cIndex].get(charName);

		if (oldChar == null || newChar == null) return;
		if (oldChar.curCharacter == newChar.curCharacter) return;

		if (cIndex == 0) {
			if (sIndex == 0) {
				iconP2.setIcon(newChar.getIcon());
				if (Options.colorHealthBar) healthBar.createColoredEmptyBar(newChar.iconColor ?? (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000));
			}
			else if (sIndex == 1) {
				iconP1.setIcon(newChar.getIcon());
				if (Options.colorHealthBar) healthBar.createColoredFilledBar(newChar.iconColor ?? (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33));
			}
		}
		var group = FlxTypedGroup.resolveGroup(oldChar) ?? this;
		group.insert(group.members.indexOf(oldChar), newChar);
		newChar.active = newChar.visible = true;
		group.remove(oldChar);

		newChar.setPosition(oldChar.x, oldChar.y);
		newChar.playAnim(oldChar.animation.name);
		newChar.animation?.curAnim?.curFrame = oldChar.animation?.curAnim?.curFrame;
		strumLines.members[sIndex].characters[cIndex] = newChar;
}