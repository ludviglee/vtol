# VTOL control functions

var INIT = false;

var update = func {
    var aileron    = getprop("/controls/flight/aileron");
    var elevator   = getprop("/controls/flight/elevator");
    var rudder     = getprop("/controls/flight/rudder");
    var throttle   = getprop("/controls/engines/throttle");

    var aileron_factor = 0.3;
    var elevator_factor = 0.3;
    var rudder_factor = 1.0;

    var prop1 = 0;
    prop1 += clamp(-1, aileron,  1) * aileron_factor;
    prop1 -= clamp(-1, elevator, 1) * elevator_factor;
    prop1 -= clamp(-1, rudder,   1) * rudder_factor;

    var prop2 = 0;
    prop2 -= clamp(-1, aileron,  1) * aileron_factor;
    prop2 -= clamp(-1, elevator, 1) * elevator_factor;
    prop2 += clamp(-1, rudder,   1) * rudder_factor;

    var prop3 = 0;
    prop3 -= clamp(-1, aileron,  1) * aileron_factor;
    prop3 += clamp(-1, elevator, 1) * elevator_factor;
    prop3 -= clamp(-1, rudder,   1) * rudder_factor;

    var prop4 = 0;
    prop4 += clamp(-1, aileron,  1) * aileron_factor;
    prop4 += clamp(-1, elevator, 1) * elevator_factor;
    prop4 += clamp(-1, rudder,   1) * rudder_factor;

    prop1 *= 1.0;
    prop2 *= 1.0;
    prop3 *= 1.0;
    prop4 *= 1.0;

    prop1 += throttle;
    prop2 += throttle;
    prop3 += throttle;
    prop4 += throttle;

    setprop("/controls/engines/engine[0]/throttle", clamp(0, prop1, 1));
    setprop("/controls/engines/engine[1]/throttle", clamp(0, prop2, 1));
    setprop("/controls/engines/engine[2]/throttle", clamp(0, prop3, 1));
    setprop("/controls/engines/engine[3]/throttle", clamp(0, prop4, 1));
    settimer(update, 0);
};

var init = func {
    if(INIT == false) {
        settimer(update, 0);
        INIT = true;
    }
};

setlistener("/sim/signals/fdm-initialized", init);

