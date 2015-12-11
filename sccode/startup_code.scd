//// copy and paste this code into you SuperCollider startup file
//// see the instructions in README file
s.boot;
s.doWhenBooted({
	var imaginarypath = "/your/path/to/imaginary/"; // substitute this whit your own path
	(imaginarypath++"imaginary_startup.scd").load;
});
