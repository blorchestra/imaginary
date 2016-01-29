(
// --------------------------------
// ---- PREPARE OSC CONNECTION ----
// --------------------------------
NetAddr.broadcastFlag = true;
m = NetAddr("192.168.1.255", 57120); // <---- Put your IP address and port here.

MIDIIn.connectAll;
MIDIdef.noteOn (\padOn , { |vel, note, chan, port|
	var te, ve;
	postf("Sending OSC: ");
	te=postf("/0/push%",note-35);
	postf(" %\n",vel/127);
	ve=vel/127;
	m.sendMsg(te,ve.asString)
});
MIDIdef.noteOff(\padOff, { |vel, note, chan, port|
	var te, ve;
	postf("Sending OSC: ");
	te=postf("/0/push%",note-35);
	postf(" %\n",0);
	ve=0;
	m.sendMsg(te,ve.asString)
});
MIDIdef.cc(\radio , { |vel, note, chan, port|
	var te, ve;
	postf("Sending OSC: ");
	if(note<5,{
		te=postf("/%/freq",note);
		postf(" %\n",vel);
		ve=vel.linlin(0,127,50,165).asInteger;
		m.sendMsg(te,ve);
	},{
		te=postf("/%/ampl",note-4);
		postf(" %\n",vel);
		ve=vel.linlin(0,127,1,15);
		m.sendMsg(te,ve);
	});
});
)

(
// ---------------
// ---- CLOSE ----
// ---------------
m.disconnect;
MIDIdef.freeAll;
)


