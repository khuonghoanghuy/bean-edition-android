function postCreate() {
    camGame.visible = false;
}

function onStartSong() {
    if (PlayState.chartingMode)
        camGame.visible = true;
}

function stepHit() {
    switch(curStep) {
        case 0: camGame.visible = true;
        case 896:
            var iNote:Int = 0;
            for (strumline in strumLines) {
                for (i in 0...4) {
                    var strum = strumline.members[i];
                    var delay:Int = (Conductor.stepCrochet / 1000) * (iNote == 6 ? 16 : 0);
                    FlxTween.tween(strum, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadIn, startDelay: delay});
                    iNote++;
                }
            }
            FlxTween.tween(healthBarBG, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadIn});
            FlxTween.tween(healthBar, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadIn});
            FlxTween.tween(iconP1, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadIn});
            FlxTween.tween(iconP2, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadIn});
            FlxTween.tween(scoreTxt, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadIn});
            FlxTween.tween(accuracyTxt, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadIn});
            FlxTween.tween(missesTxt, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadIn});
        case 1024:
            var strumOpp = strumLines.members[0].members[0];
            var strumPly = strumLines.members[1].members[0];
            FlxTween.tween(strumOpp, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
            FlxTween.tween(strumPly, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
        case 1040:
            var strumOpp = strumLines.members[0].members[1];
            var strumPly = strumLines.members[1].members[1];
            FlxTween.tween(strumOpp, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
            FlxTween.tween(strumPly, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
        case 1056:
            var strumOpp = strumLines.members[0].members[2];
            var strumPly = strumLines.members[1].members[2];
            FlxTween.tween(strumOpp, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
            FlxTween.tween(strumPly, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
        case 1072:
            var strumOpp = strumLines.members[0].members[3];
            var strumPly = strumLines.members[1].members[3];
            FlxTween.tween(strumOpp, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
            FlxTween.tween(strumPly, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
        case 1088:
            FlxTween.tween(healthBarBG, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
            FlxTween.tween(healthBar, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
            FlxTween.tween(iconP1, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
            FlxTween.tween(iconP2, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
            FlxTween.tween(scoreTxt, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
            FlxTween.tween(accuracyTxt, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
            FlxTween.tween(missesTxt, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
    }
}

/**
 * Notes:
 * Strums default Y: 50
 */
