
/*
	Sand transition animation as seen in older games such as DOOM.

	FIXME: Currently broken. I need to get this working.
*/

// User variables.
float maxspeed = 20.0;
float damping = 100;
float noise = 2.0;
float delay = 1.5;
boolean debug = true;

// Runtime variables.
float time = 0.0;
float speed = 0.0;
int zero = color(0, 0, 0, 0);
PImage frame;

boolean[] flags; // Stores which columns have completed.
int flagcount = 0;
boolean transition = true;

void setup() {
	frameRate(20);
	size(128, 64);
	background(0, 0, 0);

	// Draw anything here that should then be read and converted into particles.
	textAlign(CENTER);
	textSize(32);
	text("TEST", width / 2, height / 2 + 12);

	frame = get();

	flags = new boolean[frame.width]; // Set the correct size of the array.
}

void draw() {
	time += (1 / frameRate); // Add to the time with seconds.

	background(75, 75, 75); // Clear the background.

	text("DONE", width / 2, height / 2 + 12);

	// Interpolate towards the maximum speed once the delay is passed.
	if(time > delay) speed = speed + (maxspeed - speed) / damping;

	if (transition) {
		int[] rowlast = new int[width]; // Stores the last sampled row.

		for (int i = 0; i < frame.height; i++) {
			// Check if the column has completed and skip it if needed.
			if(flags[i]) continue;

			// Random displacement per column.
			float displace = random(noise / 100, noise);

			for (int j = 0; j < frame.width; j++) {
				// If we are in the last row we should check if the current pixel is empty.
				if(i == frame.height - 1) {
					if(frame.pixels[i] == zero) {
						flags[i] = true;

						flagcount++;

						if(flagcount == frame.width) transition = false;

						continue;
					}
				}

				// Make sure that out of range pixels are transparent.
				if(j - 1 < 0) {
					rowlast[j] = zero;
				}

				// Shift the row
				int p = rowlast[j];

				// Store the current pixel in the row.
				rowlast[j] = frame.pixels[j + (i * frame.width)];

				frame.pixels[
					j + (i * frame.width) + (int) (i * frame.width)
				] = p;
			}
		}

		set(0, 0, frame);

		if(debug) {
			stroke(color(255, 0, 0, 100));

			for(int i = 0; i < frame.height; i++) {
				if(flags[i] == true) line(i, 0, i, frame.height);
			}
		}
	}
}
