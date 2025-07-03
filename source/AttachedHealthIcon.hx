class AttachedHealthIcon extends HealthIcon
{
	public var sprTracker:FlxSprite;
	public var xAdd:Float = 0;
	public var yAdd:Float = 0;

	public function new()
	{
		super();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null) {
			setPosition(sprTracker.x + xAdd, sprTracker.y + yAdd);
			scale.set(sprTracker.scale.x, sprTracker.scale.y);
			alpha = sprTracker.alpha;
		}
	}
}