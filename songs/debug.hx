import funkin.editors.charter.Charter;
import funkin.editors.character.CharacterEditor;
import funkin.backend.system.Conductor;

/*
function update(elapsed:Float) {
	if(FlxG.keys.justPressed.SEVEN) 
		FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty));
	if(FlxG.keys.justPressed.EIGHT && FlxG.keys.pressed.B) 
		FlxG.switchState(new CharacterEditor(PlayState.instance.boyfriend.curCharacter));
	else if(FlxG.keys.justPressed.EIGHT && !FlxG.keys.pressed.B) 
		FlxG.switchState(new CharacterEditor(PlayState.instance.dad.curCharacter));

	FlxG.timeScale = inst.pitch = vocals.pitch = FlxG.keys.pressed.SIX ? 20 : 1;

	if(FlxG.keys.justPressed.FIVE) enableBotplay = !enableBotplay;
	for(strumLine in strumLines) {
		if(!strumLine.opponentSide){
			strumLine.cpu = FlxG.keys.pressed.FIVE || enableBotplay;
		}
	}
	if(FlxG.keys.justPressed.F1) FlxG.save.data.beans += 1000;
}

public var enableBotplay:Bool = false;
function onNoteHit(event) {
    if (!enableBotplay || event.character != boyfriend) return;
    
    event.player = true;
    event.countAsCombo = true;
    event.showSplash = !event.note.isSustainNote;
    event.healthGain = 0.023;
    event.rating = "sick";
    event.countScore = true;
    event.score = 300;
    event.accuracy = 1;
}
*/