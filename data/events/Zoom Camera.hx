function onEvent(beanongusWasHere) {
    if (beanongusWasHere.event.name == "Zoom Camera") {
        var params = {
            zoomVal: beanongusWasHere.event.params[0],
            duration: beanongusWasHere.event.params[1],
            twnEase: beanongusWasHere.event.params[2],
            twnType: beanongusWasHere.event.params[3],
        }

        FlxTween.cancelTweensOf(camGame, ["zoom"]);
        if (params.duration == 0)
            camGame.zoom = params.zoomVal;
        else
            FlxTween.tween(camGame, {zoom: params.zoomVal}, (Conductor.stepCrochet / 1000) * params.duration, {ease: CoolUtil.flxeaseFromString(params.twnEase, params.twnType)});

        defaultCamZoom = params.zoomVal;
    }
}