(
// -------------------------------------
// ---- Prepare Network connections ----
// -------------------------------------
NetAddr.broadcastFlag = true;
//m = NetAddr.new("192.168.1.255", 57120);  // create the NetAddr when using BLO router
m = NetAddr.new("127.0.0.1", 57120);      // create the NetAddr when using localhost

// -------------------------------
// ---- Define time and tempo ----
// -------------------------------
TempoClock.default.tempo = 2;           // 2 beats/sec, or 120 BPM
t = TempoClock.default.beats;
"Time is now: ".post; t.postln;

fork{
	10000.do({arg i;
		12.do({arg j;
			var msg, ampl, freq;
			msg  = "/"++(j+1)++"/ampl";
			ampl = 0.5*(1.25+(0.75*(sin(4*pi*(i/1000)+(j*2*pi/12))))); ampl = ampl.linlin(0,1,1,15).asFloat;
			TempoClock.default.schedAbs(t + i/100,{ m.sendMsg(msg,ampl); thisThread.clock.beats.postln; nil });
			0.005.wait;
			msg  = "/"++(j+1)++"/freq";
			freq = 0.5*(1+(1*(sin(2*pi*(i/1000)+(j*2*pi/12))))); freq = freq.linlin(0,1,50,165).asFloat;
			TempoClock.default.schedAbs(t + i/100, { m.sendMsg(msg,freq); thisThread.clock.beats.postln; nil });
			//TempoClock.default.schedAbs(t + 4.0,{ m.sendMsg("/1/tone",0  ); thisThread.clock.beats.postln; nil });
			//TempoClock.default.schedAbs(t + 6.0,{ m.sendMsg("/1/misc",100); thisThread.clock.beats.postln; nil });
			0.005.wait;
		});
	});
};
)


