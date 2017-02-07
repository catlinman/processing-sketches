
/*
	Simple rect based wave animation. Nothing special. Learning!

	The smart way of doing this is clearly over a shader or just iterating over
	pixels. Didn't start this off with Pixels so I didn't bother changing anything!
*/

// User variables.
int cellsize = 8;
int cellcount = 16;
float wavelength = 1;
float wavespeed = 2;

// Runtime variables.
float time = 0;

void setup() {
	frameRate(30);
	size(256, 256);
	background(0, 0, 0);

	noStroke();
	rectMode(3);
}

void draw() {
	background(0, 0, 0);

	time += wavespeed;

	for(int i = 0; i < cellcount; i++) {
		for(int j = 0; j < cellcount; j++) {
			fill(255, 255, 255, abs(cos(time / 50 + (i * j / 2) / cellcount / wavelength) * 255));
			rect((cellsize * 2 * i) + cellsize, (cellsize * 2 * j) + cellsize, cellsize * 2, cellsize * 2);
		}
	}
}
