import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxAngle;
import funkin.backend.shaders.CustomShader;
import funkin.backend.shaders.FunkinShader;
import openfl.display.BitmapData;

// taken from V-Slice, credits to the Funkin Crew
// modified to work on codename
class DropDownShader {
    // internal
    public var shader:FunkinShader;

    /**
     * The color of the drop shadow.
     */
    public var color:FlxColor;

    /**
     * The angle of the drop shadow.
     * 
     * for reference, depending on theangle, the affected side will be:
     * 0 = RIGHT
     * 90 = UP
     * 180 = LEFT
     * 270 = DOWN
     */
    public var angle:Float;

    /*
        The distance or size of the drop shadow, in pixels,
        relative to the texture itself... NOT the camera.
    */
    public var distance:Float;

    /*
        The strength of the drop shadow.
        Effectively just an alpha multiplier.
    */
    public var strength:Float;

    /*
        The brightness threshold for the drop shadow.
        Anything below this number will NOT be affected by the drop shadow shader.
        A value of 0 effectively means theres no threshold, and vice versa.
    */
    public var threshold:Float;

    /*
        The amount of antialias samples per-pixel,
        used to smooth out any hard edges the brightness thresholding creates.
        Defaults to 2, and 0 will remove any smoothing.
    */
    public var antialiasAmt:Float;

    /*
        Whether the shader should try and use the alternate mask.
        False by default.
    */
    public var useAltMask:Bool;

    /*
        The image for the alternate mask.
        At the moment, it uses the blue channel to specify what is or isnt going to use the alternate threshold.
        (its kinda sloppy rn i need to make it work a little nicer)
        TODO: maybe have a sort of "threshold intensity texture" as well? where higher/lower values indicate threshold strength..
    */
    public var altMaskImage:BitmapData;

    /*
        An alternate brightness threshold for the drop shadow.
        Anything below this number will NOT be affected by the drop shadow shader,
        but ONLY when the pixel is within the mask.
    */
    public var maskThreshold:Float;

    /*
        The FlxSprite that the shader should get the frame data from.
        Needed to keep the drop shadow shader in the correct bounds and rotation.
    */
    public var attachedSprite:FlxSprite;

    public function new() {
        shader = new CustomShader("dropDownFlash", 100);

        setAngle(0);
        setStrength(1);
        setDistance(15);
        setThreshold(0.1);

        setAdjustColor(0, 0, 0, 0);

        setAntialiasAmt(2);

        setUseAltMask(false);

        shader.angOffset = 0;
    }

    /*
        Sets all 4 adjust color values.
    */
    public function setAdjustColor(b:Float, h:Float, c:Float, s:Float) {
        setBaseBrightness(b);
        setBaseHue(h);
        setBaseContrast(c);
        setBaseSaturation(s);
    }

    public function setBaseHue(val:Float) {
        baseHue = val;
        shader.hue = val;
    }

    public function setBaseSaturation(val:Float) {
        baseSaturation = val;
        shader.saturation = val;
    }

    public function setBaseBrightness(val:Float) {
        baseBrightness = val;
        shader.brightness = val;
    }

    public function setBaseContrast(val:Float) {
        baseContrast = val;
        shader.contrast = val;
    }

    public function setThreshold(val:Float) {
        threshold = val;
        shader.thr = val;
    }

    public function setAntialiasAmt(val:Float) {
        antialiasAmt = val;
        shader.AA_STAGES = val;
    }

    public function setColor(color:Int) {
        colRed = getColorRed(color);
        colGreen = getColorGreen(color);
        colBlue = getColorBlue(color);
        shader.dropColor = [colRed / 255, colGreen / 255, colBlue / 255];
    }

    public function getColorRed(color:Int):Int {
        return (color >> 16) & 0xFF;
    }
    public function getColorGreen(color:Int):Int {
        return (color >> 8) & 0xFF;
    }
    public function getColorBlue(color:Int):Int {
        return (color) & 0xFF;
    }

    public function setAngle(val:Float) {
        angle = val;
        shader.ang = FlxAngle.asRadians(angle);
    }

    public function setDistance(val:Float) {
        distance = val;
        shader.dist = val;
    }

    public function setStrength(val:Float) {
        strength = val;
        shader.str = val;
    }

    public function setAttachedSprite(spr:FlxSprite) {
        attachedSprite = spr;
        updateFrameInfo(attachedSprite.frame);
    }

    /*
        Loads an image for the mask.
        While you *could* directly set the value of the mask, this function works for both HTML5 and desktop targets.
    */
    public function loadAltMask(path:String) {
        setAltMaskImage(BitmapData.fromFile(path));
    }

    /*
        Should be called on the animation.callback of the attached sprite.
        TODO: figure out why the reference to the attachedSprite breaks on web??
    */
    public function onAttachedFrame(name, frameNum, frameIndex) {
        if (attachedSprite != null)
            updateFrameInfo(attachedSprite.frame);
    }

    /*
        Updates the frame bounds and angle offset of the sprite for the shader.
    */
    public function updateFrameInfo(frame:FlxFrame) {
        // NOTE: uv.width is actually the right pos and uv.height is the bottom pos
        shader.uFrameBounds = [frame.uv.x, frame.uv.y, frame.uv.width, frame.uv.height];

        // if a frame is rotated the shader will look completely wrong lol
        shader.angOffset = FlxAngle.asRadians(frame.angle);
    }

    public function setAltMaskImage(_bitmapData:BitmapData) {
        shader.altMask.input = _bitmapData;
    }

    public function setMaskThreshold(val:Float) {
        maskThreshold = val;
        shader.thr2 = val;
    }

    public function setUseAltMask(val:Bool) {
        useAltMask = val;
        shader.useMask = val;
    }
}