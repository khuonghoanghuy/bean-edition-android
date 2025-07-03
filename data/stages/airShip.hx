import funkin.backend.shaders.CustomShader;
import DropDownShader;

var shine1:DropDownShader;
var shine2:DropDownShader;
var shine3:DropDownShader;

var globalCloudSpeed:Float = 2;

function create() {
    overlay.blend = 0; //add

    shine1 = new DropDownShader();
    shine2 = new DropDownShader();
    shine3 = new DropDownShader();

    shine1.setAdjustColor(12, 8, 14, -4);
    shine2.setAdjustColor(17, 10, 20, -8);
    shine3.setAdjustColor(12, 8, 14, -4);

    shine1.setColor(0xFFFDFFDF);
    shine2.setColor(0xFFFDFFDF);
    shine3.setColor(0xFF000000);

    shine1.setAttachedSprite(boyfriend);
    shine2.setAttachedSprite(dad);
    shine3.setAttachedSprite(gf);

    shine1.setAngle(100);
    shine2.setAngle(85);
    shine3.setAngle(90);

    boyfriend.shader = shine1.shader;
    dad.shader = shine2.shader;
    gf.shader = shine3.shader;

    /*
    boyfriend.shader = new CustomShader("adjustColor");
    boyfriend.shader.brightness = 12.0;
    boyfriend.shader.hue = 8.0;
    boyfriend.shader.contrast = 14.0;
    boyfriend.shader.saturation = -4.0;

    dad.shader = new CustomShader("adjustColor");
    dad.shader.brightness = 17.0;
    dad.shader.hue = 10.0;
    dad.shader.contrast = 20.0;
    dad.shader.saturation = -8.0;

    gf.shader = new CustomShader("adjustColor");
    gf.shader.brightness = 12.0;
    gf.shader.hue = 8.0;
    gf.shader.contrast = 14.0;
    gf.shader.saturation = -4.0;
    */

    // yes, even the floor lol
    floor.shader = new CustomShader("adjustColor");
    floor.shader.brightness = 14.0;
    floor.shader.hue = 6.0;
    floor.shader.contrast = 9.0;
    floor.shader.saturation = -12.0;
}

function draw() {
    bootlegAnimFrameUpdate();
}

var cloudsSpeed:Array<Int> = [360, 320, 280];
var backCloudsSpeed:Int = 50;

function update(elapsed:Float) {
    movingCloud1.x += cloudsSpeed[0] * (elapsed * 8) * globalCloudSpeed;
    movingCloud2.x += cloudsSpeed[1] * (elapsed * 8) * globalCloudSpeed;
    movingCloud3.x += cloudsSpeed[2] * (elapsed * 8) * globalCloudSpeed;

    backClouds1.x += backCloudsSpeed * (elapsed * 8) * globalCloudSpeed;
    backClouds2.x += backCloudsSpeed * (elapsed * 8) * globalCloudSpeed;

    resetPositions();
}

function resetPositions() {
    // front clouds
    if (movingCloud1.x > 2400) {
        movingCloud1.x = -2000;
        movingCloud1.y = FlxG.random.int(800, 100);
        cloudsSpeed[0] = FlxG.random.int(280, 520);
    }
    if (movingCloud2.x > 1800) {
        movingCloud2.x = -2000;
        movingCloud2.y = FlxG.random.int(-40, 100);
        cloudsSpeed[1] = FlxG.random.int(180, 600);
    }
    if (movingCloud3.x > 2400) {
        movingCloud3.x = -2000;
        movingCloud3.y = FlxG.random.int(-150, 60);
        cloudsSpeed[2] = FlxG.random.int(100, 440);
    }

    // back clouds
    if (backClouds1.x > 2320.5)
        backClouds1.x = backClouds2.x - backClouds2.frameWidth;
    if (backClouds2.x > 2320.5)
        backClouds2.x = backClouds1.x - backClouds1.frameWidth;
}

var bfLastFrame;
var bfCurFrame;

var dadLastFrame;
var dadCurFrame;

var gfLastFrame;
var gfCurFrame;

function bootlegAnimFrameUpdate() {
    bfCurFrame = boyfriend.frame;
    dadCurFrame = dad.frame;
    //gfCurFrame = gf.frame;

    if (bfCurFrame != bfLastFrame) {
        shine1.updateFrameInfo(boyfriend.frame);
        bfLastFrame = bfCurFrame;
    }

    if (dadCurFrame != dadLastFrame) {
        shine2.updateFrameInfo(dad.frame);
        dadLastFrame = dadCurFrame;
    }

    /*
    if (gfCurFrame != gfLastFrame) {
        shine3.updateFrameInfo(gf.frame);
        gfLastFrame = gfCurFrame;
    }
    */
}