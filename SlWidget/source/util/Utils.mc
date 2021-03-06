using Toybox.Application;
using Toybox.Attention;
using Toybox.System;
using Toybox.Math;

// app

(:glance)
function buildStops(ids, names) {
    var stops = [];

    for (var i = 0; i < ids.size() && i < names.size(); i++) {
        var stop = new Stop(ids[i], names[i], null);
        stops.add(stop);
    }

    return stops;
}

// math

//! The Monkey C modulo operator uses truncated division, which gives the remainder with same sign as the dividend.
//! This uses floored division, which gives the remainder with same sign as the divisor.
function mod(dividend, divisor) {
    var quotient = Math.floor(dividend.toFloat() / divisor.toFloat()).toNumber();
    var remainder = dividend - divisor * quotient;
    return remainder;
}

(:glance)
function coerceIn(value, min, max) {
    return min > max ? null : (value < min ? min : (value > max ? max : value));
}

function min(a, b) {
    return a <= b ? a : b;
}

function max(a, b) {
    return a >= b ? a : b;
}

// resource

(:glance)
function rez(rezId) {
    return Application.loadResource(rezId);
}

// system

(:glance)
function hasGlance() {
    var ds = System.getDeviceSettings();
    return ds has :isGlanceModeEnabled && ds.isGlanceModeEnabled;
}

function vibrate() {
    if (Attention has :vibrate) {
        var vibeData = [ new Attention.VibeProfile(25, 100) ];
        Attention.vibrate(vibeData);
        Log.d("vibrate");
    }
}
