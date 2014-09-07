
# Generic utility functions

var true=1;
var false=0;

var show = func(what) {print(what,"\n");}

var trange=func(il,i,ih,ol,oh) {
  return((((i-il)/(ih-il))*(oh-ol))+ol);
};

var clamp=func(il,i,ih) {
  if(il > ih) {
    var temp=il;
    il=ih;
    ih=temp;
  }
  if(i < il) {
    i=il;
  } else if(i > ih) {
    i=ih;
  }
  return(i);
};

var crange=func(il,i,ih,ol,oh) {
  return(clamp(ol,trange(il,i,ih,ol,oh),oh));
};

var PID = {
  new: func(pfac, ifac, dfac) {
    var m_ = { parents: [PID] };
    m_.pfac = pfac;
    m_.ifac = ifac;
    m_.dfac = dfac;

    m_.proportional = 0;
    m_.integral     = 0;

    m_.target   = 0;
    m_.input    = 0;
    m_.value    = 0;

    return m_;
  },
  get: func {
    return me.value;
  },
  tick: func {
    var delta = getprop("/sim/time/delta-sec") * getprop("/sim/speed-up");

    var error = me.target - me.input;

    me.proportional = error * me.pfac;
    me.integral += error * me.ifac * delta;
    
    me.value = me.proportional + me.integral;
  }
};
