(
// ---------------------------------
// ---- Define Global Variables ----
// ---------------------------------
~resolution=20;
~duration = 100;
~f_amp   = 0.102;
~w_amp   = 5.142;
~f_freq  = 0.00493;
~w_freq  = 9.64;

// -------------------------------------
// ---- Prepare Network connections ----
// -------------------------------------
NetAddr.broadcastFlag = true;
//m = NetAddr.new("192.168.1.255", 57120);  // create the NetAddr when using BLO router
m = NetAddr.new("127.0.0.1", 57120);      // create the NetAddr when using localhost

// -------------------------------
// ---- Define time and tempo ----
// -------------------------------
TempoClock.default.tempo = 1;           // 2 beats/sec, or 120 BPM
t = TempoClock.default.beats;
"Time is now: ".post; t.postln;

fork{
	(~resolution*~duration).do({arg i;
		12.do({arg j;
			var msg, ampl, freq;
			// Amplitude
			msg  = "/"++(j+1)++"/ampl";
			ampl = 0.5*(1.25+(0.75*(sin((~f_amp*2*pi*(i/~resolution))+(j*2*pi/~w_amp))))); ampl = ampl.linlin(0,1,1,15).asFloat;
			m.sendMsg(msg,ampl);
			// Frequency
			msg  = "/"++(j+1)++"/freq";
			freq = 0.5*(1+(1*(sin((~f_freq*2*pi*(i/~resolution))+(j*2*pi/~w_freq))))); freq = freq.linlin(0,1,50,165).asFloat;
			m.sendMsg(msg,freq);

			//TempoClock.default.schedAbs(t + i/~resolution,{ m.sendMsg(msg,ampl); thisThread.clock.beats.postln; nil });
			//TempoClock.default.schedAbs(t + i/~resolution, { m.sendMsg(msg,freq); thisThread.clock.beats.postln; nil });
			//TempoClock.default.schedAbs(t + 4.0,{ m.sendMsg("/1/tone",0  ); thisThread.clock.beats.postln; nil });
			//TempoClock.default.schedAbs(t + 6.0,{ m.sendMsg("/1/misc",100); thisThread.clock.beats.postln; nil });
		});
		(1/~resolution).wait;

	});
};
)


