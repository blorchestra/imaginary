(
NetAddr.broadcastFlag = true; // mandatory to use broadcast
// m = NetAddr("127.0.0.1", 57120); // localhost
m = NetAddr("192.168.1.255", 57120); // BLO network broadcast address
~bloRP = Window.new("An OSC Radio Player by Barcelona Laptop Orchestra", Rect(40,40,810,60)).front;
~bloRP.onClose_{m.disconnect; "Please, visit us at http://www.blo.cat".postln};
~bloText1 = StaticText(~bloRP, Rect(10,10,120,20))
.string_("Send to IP");
~bloIP = TextField(~bloRP, Rect(10,30,120,20))
.string_("127.0.0.1")
.action_({arg field;
	m.disconnect;
	m = NetAddr(field.value.asString, ~bloPort.value.asInteger).postln;
});
~bloText2 = StaticText(~bloRP, Rect(140,10,50,20))
.string_("Port");
~bloPort = TextField(~bloRP, Rect(140,30,50,20))
.string_("57120")
.action_({arg field;
	m.disconnect;
	m = NetAddr(~bloIP.value.asString, field.value.asInteger).postln;
});
~bloText3 = StaticText(~bloRP, Rect(200,10,60,20))
.string_("Radio n.");
~bloPlayerID = PopUpMenu(~bloRP,Rect(200,30,60,20))
.items_([1,2,3,4,5,6,7,8,9,10,11,12]);
~bloText4 = StaticText(~bloRP, Rect(270,10,200,20))
.string_("Dial");
~bloSetDial = Slider(~bloRP, Rect(270, 30, 200, 20))
.action_({
	var header, value;
	//	header = postf("/%/freq",~bloPlayerID.value+1);
	//	value  = postf(" %\n",~bloSetDial.value.linlin(0,1,50,165).asFloat);
	header = "/"++(~bloPlayerID.value+1)++"/freq";
	value = ~bloSetDial.value.linlin(0,1,50,165).asFloat;
	m.sendMsg(header,value);
	postf("Sending freq via OSC: "+header+value+"%\n");
});
~bloText5 = StaticText(~bloRP, Rect(480,10,200,20))
.string_("Volume");
~bloSetAmpl = Slider(~bloRP, Rect(480, 30, 200, 20))
.action_({
	var header, value;
	header = "/"++(~bloPlayerID.value+1)++"/ampl";
	value  = ~bloSetAmpl.value.linlin(0,1,1,15).asFloat;
	m.sendMsg(header,value);
	postf("Sending ampl via OSC: "+header+value+"%\n");
});
~bloText5 = StaticText(~bloRP, Rect(690,10,50,20))
    .string_("Tone");
~bloTone = Button(~bloRP, Rect(690,30,50,20))
    .states_([["Low",Color.black,Color.gray],["Hi",Color.blue,Color.gray]])
    .action_({arg butt;
	var header, value;
	postf("Sending OSC: ");
	header = "/"++(~bloPlayerID.value+1)++"/tone";
	value  = butt.value.asInteger;
	m.sendMsg(header,value);
	postf("Sending tone via OSC: "+header+value+"%\n");
});
~bloClose = Button(~bloRP, Rect(750,30,50,20))
    .states_([["close",Color.black,Color.gray]])
    .action_({~bloRP.close});
)

// this eventually send the server IP address as a broadcast message
m.sendMsg("/server/address", "192.168.1.666")
