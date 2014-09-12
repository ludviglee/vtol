# VTOL fcs

var INIT = false;

var pid = {
  pitch_rate: PID.new(1, 0, 0),
  roll_rate:  PID.new(1, 0, 0),
  yaw_rate:   PID.new(1, 0, 0)
};

var target = func {
    var ret = {};
    
    ret["pitch"]   = 0;
    ret["roll"]    = 0;
    ret["heading"] = 0;

    return ret;
};

var update = func {
    var t = target();
    
    var roll      = getprop("/orientation/roll-deg");
    var pitch     = getprop("/orientation/pitch-deg");
    var heading   = getprop("/orientation/heading-deg");

    var pitch_rate = getprop("/orientation/pitch-rate-degps");
    var roll_rate  = getprop("/orientation/roll-rate-degps");
    var yaw_rate   = getprop("/orientation/yaw-rate-degps");

    pid.pitch_rate.target =  angle_difference(pitch, t["pitch"]) * 0.2;
    pid.pitch_rate.input  = -pitch_rate;

    pid.roll_rate.target = angle_difference(roll, t["roll"]) * 0.2;
    pid.roll_rate.input  = roll_rate;

    pid.yaw_rate.target = clamp(-10, angle_difference(heading, t["heading"]) * 0.5, 10);
    pid.yaw_rate.input  = yaw_rate;

    pid.pitch_rate.tick();
    pid.roll_rate.tick();
    pid.yaw_rate.tick();

    var aileron  = pid.roll_rate.get() * 0.2;
    var elevator = pid.pitch_rate.get() * 0.2;
    var rudder   = pid.yaw_rate.get() * 0.2;

    setprop("/controls/flight/aileron",   aileron);
    setprop("/controls/flight/elevator",  elevator);
    setprop("/controls/flight/rudder",    rudder);
    setprop("/controls/engines/throttle", 1);

    settimer(update, 0);
};

var init = func {
    if(INIT == false) {
        settimer(update, 0);
        INIT = true;
    }
};

#setlistener("/sim/signals/fdm-initialized", init);
