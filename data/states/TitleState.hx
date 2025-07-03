function beatHit(curBeat:Int) {
    if (curBeat % 4 == 0) 
	{
		FlxG.camera.zoom = 1.05;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 0.5, {ease: FlxEase.circOut});
	}
}