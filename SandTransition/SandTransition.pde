
/*
	Sand transition animation as seen in older games such as DOOM.

	Playing around with pixel reading and setting. Felt this was a good starting point.
	At the moment the animation uses an ArrayList of Particles. The final sketch
	should run off an integer array with speeds for each pixel column.
*/

// User variables.
float maxspeed = 20.0;
float damping = 100;
float delay = 1.5;

// Particle class.
class Particle {
	int x;
	int y;
	int c;

	Particle(int x, int y, int c) {
		this.x = x;
		this.y = y;
		this.c = c;
	}
}

// Runtime variables.
float time = 0.0;
float speed = 0.0;

ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
	frameRate(30);
	size(128, 128);
	background(0, 0, 0);

	// Draw anything here that should then be read and converted into particles.
	textAlign(CENTER);
	textSize(32);
	text("TEST", width / 2, height / 2 + 12);

	loadPixels(); // Load and then read pixels.

	for (int i = 0; i < pixels.length; i++) {
		int x = i % width;
		int y = i / width;
		int c = pixels[i];

		particles.add(new Particle(x, y, c));
	}

	updatePixels();
}

void draw() {
	time += (1 / frameRate); // Add to the time with seconds.

	background(0, 0, 0); // Clear the background.

	// Interpolate towards the maximum speed once the delay is passed.
	if(time > delay) speed = speed + (maxspeed - speed) / damping;

	loadPixels(); // Load pixels for direct manipulation.

	for (int i = 0; i < particles.size(); i++) {
		Particle p = particles.get(i);

		pixels[((int) p.y * height + (int) p.x)] = p.c;

		p.y = p.y + (int) random(speed / 100, speed);

		if(p.x < 0 || p.x > width || p.y < 0 || p.y > height) particles.remove(i);
	}

	updatePixels();	// Set new pixel array.
}
