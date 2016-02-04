(
// -------------------------------------------
// ---- RUN THIS FIRST TO BOOT THE SERVER ----
// -------------------------------------------
s.waitForBoot({
	// ---- LOAD AUDIO BUFFERS ----
	~landsFiles = [ Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/imaginary\ landscape/wav/radio1.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/imaginary\ landscape/wav/radio2.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/imaginary\ landscape/wav/radio3.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/imaginary\ landscape/wav/radio4.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/imaginary\ landscape/wav/radio5.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/imaginary\ landscape/wav/radio6.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/imaginary\ landscape/wav/radio7.wav"),
	                Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/imaginary\ landscape/wav/radio8.wav")];
	// ---- SYNTH1: RADIO FILES ----
	SynthDef(\read_file, {arg bufnum, amp=0, gate=1, rate=1, vol=0, del=0;
		var env = EnvGen.kr(Env.asr(10, 1, 3), gate, doneAction: 2) ;
		var snd = PlayBuf.ar(2, bufnum, rate, loop: 1, startPos: del, doneAction: 2);
		Out.ar(0, env * amp * vol * snd);
	}).add;
});
)

(
// ----------------------------------------
// ---- RUN THIS AFTER BOOTING SERVER -----
// ----------------------------------------
// ---- GENERAL FUNCTIONS ----
~gauss={arg mean, stdev, value;
	var amp  = (1/(sqrt(2*pi)*stdev));
	var form = exp(-0.5*(squared((value - mean))/squared(stdev)));
	var res=amp*form;
	res
};

~landsRadios=12.collect{arg i;
    y=8.collect{arg j;
		x=Synth.new(\read_file, [\bufnum, ~landsFiles[j], \amp, 0, \vol, 1, \del, rand(44100)]);
    };
};

~landsDialTmp=Array.fill(12, { arg i; 0 });
~landsAmplTmp=Array.fill(12, { arg i; 0 });

~landsSetDial={arg valueFromOscMsg, channel;
	var tmp  = valueFromOscMsg.asFloat.linlin(50,165,0,1);
	~landsDialTmp[channel]=tmp;
	8.do{arg i;
		var tmp2 = ~gauss.value((i+1)/(8+1),0.005,tmp)/~gauss.value((i+1)/(8+1),0.005,(i+1)/(8+1));
		~landsRadios[channel][i].set(\amp,tmp2*~landsAmplTmp[channel]);
	};
};

~landsSetAmpl={arg valueFromOscMsg, channel;
	var tmp  = valueFromOscMsg.asFloat.linlin(1,15,0,1);
	~landsAmplTmp[channel]=tmp;
	8.do{arg i; ~landsRadios[channel][i].set(\vol,tmp);
	};
};

//n = NetAddr("127.0.0.1", 57120);
o=[ OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetDial.value(msg[1],0)},  '/1/freq'),
	OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetDial.value(msg[1],1)},  '/2/freq'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetDial.value(msg[1],2)},  '/3/freq'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetDial.value(msg[1],3)},  '/4/freq'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetDial.value(msg[1],4)},  '/5/freq'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetDial.value(msg[1],5)},  '/6/freq'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetDial.value(msg[1],6)},  '/7/freq'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetDial.value(msg[1],7)},  '/8/freq'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetDial.value(msg[1],8)},  '/9/freq'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetDial.value(msg[1],9)}, '/10/freq'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetDial.value(msg[1],10)}, '/11/freq'),
	OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetDial.value(msg[1],11)}, '/12/freq'),

	OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetAmpl.value(msg[1],0)},  '/1/ampl'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetAmpl.value(msg[1],1)},  '/2/ampl'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetAmpl.value(msg[1],2)},  '/3/ampl'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetAmpl.value(msg[1],3)},  '/4/ampl'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetAmpl.value(msg[1],4)},  '/5/ampl'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetAmpl.value(msg[1],5)},  '/6/ampl'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetAmpl.value(msg[1],6)},  '/7/ampl'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetAmpl.value(msg[1],7)},  '/8/ampl'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetAmpl.value(msg[1],8)},  '/9/ampl'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetAmpl.value(msg[1],9)}, '/10/ampl'),
    OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetAmpl.value(msg[1],10)},'/11/ampl'),
	OSCFunc.newMatching({|msg, time, addr, recvPort| ~landsSetAmpl.value(msg[1],11)},'/12/ampl')];


// ---- GUI ----
~landsWindow = Window.new("A Radio management patch by the Barcelona Laptop Orchestra", Rect(40,40,800,500)).front;
~landsWindow.onClose_{
	n.disconnect;
	o.do(_.free);
	o = nil;
	~osc_xapussa.stop;
	12.do{arg i; 8.do{arg j;~landsRadios[i][j].free;};};
	"Please, visit us at http://www.blo.cat".postln
};
~landsText1 = StaticText(~landsWindow, Rect(20,40,50,20))
    .string_("Source");
~landsText2 = 12.collect{arg i;
	StaticText(~landsWindow, Rect(65+(55*i),20,20,20))
	.string_((i+1).asString);
};
~landsInput=12.collect{arg i;
	Button(~landsWindow, Rect(65+(55*i),40, 50,20))
	.states_([["Off",Color.black,Color.gray],["OSC",Color.blue,Color.gray],["Auto",Color.green,Color.gray]])
    .action_({arg butt;
		postf("From Input %, button set to %\n",i,butt.value);
    });
};
~landsClose = Button(~landsWindow, Rect(66+(55*12),40,50,20))
    .states_([["close",Color.black,Color.gray]])
    .action_({~landsWindow.close});
~landsText3 = StaticText(~landsWindow, Rect(20,65,50,20))
    .string_("Dial &");
~landsDial = 12.collect{arg i;
	LevelIndicator(~landsWindow, Rect(65+(55*i)+3,65,20,200))
	.warning_(0)
	.critical_(1)
	.numTicks_(21)
	.numMajorTicks_(5);
};
~landsText4 = StaticText(~landsWindow, Rect(20,85,50,20))
    .string_("Volume");
~landsAmpl = 12.collect{arg i;
	LevelIndicator(~landsWindow, Rect(65+(55*i)+27,65,20,200))
	.warning_(1)
	.critical_(1)
	.style_(3)
	.numTicks_(21)
	.numMajorTicks_(5);
};
~landsText5 = StaticText(~landsWindow, Rect(20,270,50,20))
    .string_("Tone");
~landsOutput = 12.collect{arg i;
	StaticText(~landsWindow, Rect(65+(55*i),270, 50,20))
	.stringColor_(Color.black)
	.string_("   Low");
};
~landsText5 = StaticText(~landsWindow, Rect(20,295,50,20))
    .string_("Dest.");
~landsOutput = 12.collect{arg i;
	Button(~landsWindow, Rect(65+(55*i),295, 50,20))
	.states_([["Off",Color.black,Color.gray],["OSC",Color.blue,Color.gray],["Int",Color.green,Color.gray]])
    .action_({arg butt;
		postf("From Output %, button set to %\n",i,butt.value);
    });
};

// ---- OSC Xapussa ----
// I can not directly move GUI objects via OSC
~osc_xapussa = Routine { inf.do { |i|
	12.do{ |j|
		~landsDial[j].value_(~landsDialTmp[j]);
		~landsAmpl[j].value_(~landsAmplTmp[j]);
	};
	0.05.wait;
}
}.play(AppClock);


)
