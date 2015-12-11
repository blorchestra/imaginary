///////////////////////////////////////////////////////
// GUI for the execution of Imaginary Landscape N° 4 //
///////////////////////////////////////////////////////
~imaginary_GUI = {
	var mainwin, ctrlview, playbtn, pausebtn;
	mainwin = Window("Imaginary Landscape 4").setTopLeftBounds(Rect(0,0,420,420)).front;
	ctrlview = CompositeView(mainwin, Rect(10,10,400,40));
	playbtn = Button(ctrlview, Rect(0,0,40,40))
	.states_([["PLAY",Color.black, Color.gray],["PLAY",Color.black, Color.green]])
	.action_{|me| me.value.postln };
	pausebtn = Button(ctrlview, Rect(50,0,40,40))
	.states_([["||",Color.black,Color.gray],["||",Color.black,Color.magenta]])
	.action_{|me| me.value.postln };
};

"".resolveRelative;