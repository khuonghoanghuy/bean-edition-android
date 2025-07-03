import funkin.backend.shaders.CustomShader;
import DropDownShader;

var shine1:DropDownShader;
var shine2:DropDownShader;
var shine3:DropDownShader;

function create() {
    overlay.blend = 0; // add

    shine1 = new DropDownShader();
    shine2 = new DropDownShader();
    shine3 = new DropDownShader();

    shine1.setAdjustColor(8, 14, 26, -24);
    shine2.setAdjustColor(12, -16, 26, -24);
    shine3.setAdjustColor(16, 13, 26, -20);

    shine1.setColor(0xFFF9FF9F);
    shine2.setColor(0xFFF9FF9F);
    shine3.setColor(0xFF000000);

    shine1.setAttachedSprite(boyfriend);
    shine2.setAttachedSprite(dad);
    shine3.setAttachedSprite(gf);

    shine1.setAngle(120);
    shine2.setAngle(90);
    shine3.setAngle(100);

    boyfriend.shader = shine1.shader;
    dad.shader = shine2.shader;
    gf.shader = shine3.shader;

    /*
    gf.anim.onFrame.add(function() {
        shine3.updateFrameInfo(gf.frame);
    });
    */

    floor.shader = new CustomShader("adjustColor");
    floor.shader.brightness = 24.0;
    floor.shader.hue = 40.0;
    floor.shader.contrast = 30.0;
    floor.shader.saturation = -28.0;
}

function draw() {
    bootlegAnimFrameUpdate();
}

var cloudsSpeed1:Float = 10;
var cloudsSpeed2:Float = 45;

var timer:Float = 0;
function update(elapsed:Float) {
    timer += elapsed;
    clouds3.x += Math.sin(timer * 0.45) * 1.25;

    clouds1_1.x += cloudsSpeed1 * elapsed;
    clouds1_2.x += cloudsSpeed1 * elapsed;
    clouds1_3.x += cloudsSpeed1 * elapsed;

    clouds2_1.x += cloudsSpeed2 * elapsed;
    clouds2_2.x += cloudsSpeed2 * elapsed;

    resetPositions();
}

function resetPositions() {
    // this is hella confusing
    if (clouds1_1.x >= 480)
        clouds1_1.x = clouds1_3.x - clouds1_3.frameWidth * 0.4;
    if (clouds1_2.x >= 480)
        clouds1_2.x = clouds1_1.x - clouds1_1.frameWidth * 0.4;
    if (clouds1_3.x >= 480)
        clouds1_3.x = clouds1_2.x - clouds1_2.frameWidth * 0.4;

    if (clouds2_1.x >= 539) {
        clouds2_1.x = clouds2_2.x - clouds2_2.frameWidth;
        clouds2_1.y = FlxG.random.float(-500, -600);
    }
    if (clouds2_2.x >= 539) {
        clouds2_2.x = clouds2_1.x - clouds2_1.frameWidth;
        clouds2_2.y = FlxG.random.float(-500, -600);
    }
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