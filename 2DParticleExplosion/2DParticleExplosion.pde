
/*
	Radial destributed particle explosion.

	Playing around with classes and objects to see how fast I can code some sort of
	particle system and play around with it. Nothing in 3D yet but I'll convert this
	the first chance I get.

	Particles are killed if they leave the screen or become too small. Next iteration
	will include particle life as well as random damping. Another thing to note is that
	the size calculation each frame is not normalized meaning the resulting animation
	is not distributed as it should. This is clearly visible when not clearing the frame
	and just continuously drawing.
*/

// User variables.
int particleCount = 256;
float particleRadius = 16;
float particleMaxVel = 4;
float particleRanVel = 0.25;
float particleNoise = 0.1;
float particleDamping = 0.03;

// Main particle class.
class Particle {
	static ArrayList<Particle> system = new ArrayList<Particle>();

	float x;
	float y;
	float vx;
	float vy;
	float r;

	Particle(float x, float y, float vx, float vy, float r) {
		this.x = x;
		this.y = y;
		this.vx = vx;
		this.vy = vy;
		this.r = r;

		// Add the instantiated particle to the static array.
		Particle.system.add(this);
	}
}

void setup() {
	frameRate(60);
	size(256, 256);
	background(0, 0, 0);
	noStroke();

	// Create particles up to the max count.
	for(int i = 0; i < particleCount; i++) {
		// Create random normalized vectors.
		vx = random(-1, 1);
		vy = random(-1, 1);
		l = sqrt((vx * vx) + (vy * vy));
		nx = vx / l;
		ny = vy / l;

		// Speed of the particles on spawn. Can be multiplied with random for more distribution.
		s = particleMaxVel + random(-particleRanVel, particleRanVel);

		// Create the new particle with the correct parameters.
		new Particle(width / 2, height / 2, nx * s, ny * s, particleRadius);
	}
}

void draw() {
	background(0, 0, 0); // Clears the frame. Remove this line for extra spice.

	Iterator<Particle> itr = Particle.system.iterator(); // Get an iterator for the System.

	// Start handling particles.
	while (itr.hasNext()) {
		Particle p = itr.next(); // Fetch the current particle.

		if(p.r < 0.1 || p.x + p.r < 0 || p.x - p.r > width || p.y + p.r < 0 || p.y - p.r > height) {
			Particle.system.remove(p); // This is not the right way...
			continue;
		}

		// Add some random movement to the velocities. Should possible be lerped.
		p.vx += random(-particleNoise, particleNoise);
		p.vy += random(-particleNoise, particleNoise);

		// Slowly damp particle velocities.
		p.vx = lerp(p.vx, 0, particleDamping);
		p.vy = lerp(p.vy, 0, particleDamping);

		// Add velocity values to positional values.
		p.x += p.vx;
		p.y += p.vy;

		// Calculate size from velocity. Is not normalized. Clips at preset radius.
		p.r = min(abs(p.vx * p.vy) * particleRadius, particleRadius);

		// Calculate the color from velocity. Color clips values. Multiplication determines phases.
		fill(color(abs(p.vx * p.vy) * 1000, abs(p.vx * p.vy) * 350, abs(p.vx * p.vy) * 150));

		// Draw the particle.
		ellipse(p.x, p.y, p.r / 2, p.r / 2);
	}

	// Debug count of particles.
	// fill(color(255, 255, 255));
	// text(Particle.system.size(), 4, 16);
}
