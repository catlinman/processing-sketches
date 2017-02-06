
/*
	Simple rect based wavelength animation. Nothing special. Learning.

	The smart way of doing this is clearly over a shader or just
	iterating over pixels but I haven't gotten that far yet.
*/

time = 0;

cellsize = 2;
cellcount = 16;
wavelength = 0.5;
wavespeed = 2;

void setup() {
	size(256, 256);
	background(0, 0, 0);
	frameRate(30)

	noStroke();
	rectMode(3);
}

void draw() {
	background(0, 0, 0);

	time += wavespeed;

	for(i = 0; i < cellcount; i++) {
		for(j = 0; j < cellcount; j++) {
			fill(255, 255, 255, abs(cos(time / 50 + (i * j / 2) / cellcount / wavelength) * 255));
			rect((cellsize * 2 * i) + cellsize, (cellsize * 2 * j) + cellsize, cellsize * 2, cellsize * 2);
		}
	}
}
