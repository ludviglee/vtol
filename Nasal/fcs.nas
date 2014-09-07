# VTOL fcs

var INIT = false;

var pid = {
  pitch_rate: PID.new(0.05, 0, 0),
  roll_rate:  PID.new(0.05, 0, 0)
};

var update = func {
    var roll      = getprop("/orientation/roll-deg");
    var pitch     = getprop("/orientation/pitch-deg");
    var heading   = getprop("/orientation/heading-deg");

    var pitch_rate = getprop("/orientation/pitch-rate-degps");
    var roll_rate = getprop("/orientation/roll-rate-degps");

    pid.pitch_rate.target = -pitch * 0.01;
    pid.pitch_rate.input  = -pitch_rate;

    pid.roll_rate.target = -(roll + 5) * 0.01;
    pid.roll_rate.input  =  roll_rate;

    pid.pitch_rate.tick();
    pid.roll_rate.tick();

    var aileron = pid.roll_rate.get();
    var elevator = pid.pitch_rate.get();

    setprop("/controls/flight/aileron",  aileron);
    setprop("/controls/flight/elevator", elevator);
#    setprop("/controls/flight/rudder",   rudder);

    settimer(update, 0);
};

var init = func {
    if(INIT == false) {
        settimer(update, 0);
        INIT = true;
    }
};

setlistener("/sim/signals/fdm-initialized", init);
