
/*
	Radial destributed particle explosion.

	Playing around with classes and objects to see how fast I can code some sort of
	particle collection and play around with it. Nothing in 3D yet but I'll convert this
	the first chance I get.

	Particles are killed if they leave the screen or become too small. Next iteration
	will include particle life as well as random damping. Another thing to note is that
	the size calculation each frame is not normalized meaning the resulting animation
	is not distributed as it should. This is clearly visible when not clearing the frame
	and just continuously drawing.
*/

// Imports for compatability.
import java.util.Iterator;

/* User variables. */
int particleCount = 256;
float particleRadius = 16;
float particleMaxVel = 4;
float particleRanVel = 0.25;
float particleNoise = 0.1;
float particleDamping = 0.03;

/* Runtime variables. */
ArrayList<Particle> particleCollection;
ArrayList<Particle> removeCollection;

// Main particle class.
class Particle {
    // Positional values.
	float x;
	float y;

    // Local velocity values.
	float vx;
	float vy;

    // Size radius of the particle in pixels.
	float r;

	Particle(float x, float y, float vx, float vy, float r) {
		this.x = x;
		this.y = y;
		this.vx = vx;
		this.vy = vy;
		this.r = r;

		// Add the instantiated particle to the static array.
		particleCollection.add(this);
	}

    // Main logic handling method for particles.
    void update() {
        if(this.r < 0.1 || this.x + this.r < 0 || this.x - this.r > width || this.y + this.r < 0 || this.y - this.r > height) {
            //removeCollection.add(this);
            return;
        }

        // Add some random movement to the velocities. Should possible be lerped.
        this.vx += random(-particleNoise, particleNoise);
        this.vy += random(-particleNoise, particleNoise);

        // Slowly damp particle velocities.
        this.vx = lerp(this.vx, 0, particleDamping);
        this.vy = lerp(this.vy, 0, particleDamping);

        // Add velocity values to positional values.
        this.x += this.vx;
        this.y += this.vy;

        // Calculate size from velocity. Is not normalized. Clips at preset radius.
        this.r = min(abs(this.vx * this.vy) * particleRadius, particleRadius);
    }

    // Main drawing method for particles.
    void draw() {
        // Calculate the color from velocity. Color clips values. Multiplication determines phases.
		fill(color(abs(this.vx * this.vy) * 800, abs(this.vx * this.vy) * 350, abs(this.vx * this.vy) * 150));

		// Draw the particle.
		ellipse(this.x, this.y, this.r / 2, this.r / 2);
    }
}

void setup() {
	frameRate(30);
	size(256, 256);
	background(0, 0, 0);
	noStroke();

    // Instantiate the array lists.
    particleCollection = new ArrayList<Particle>();
    removeCollection = new ArrayList<Particle>();

	// Create particles up to the max count.
	for(int i = 0; i < particleCount; i++) {
		// Create random normalized vectors.
		float vx = random(-1, 1);
		float vy = random(-1, 1);
		float l = sqrt((vx * vx) + (vy * vy));
		float nx = vx / l;
		float ny = vy / l;

		// Speed of the particles on spawn. Can be multiplied with random for more distribution.
		float s = particleMaxVel + random(-particleRanVel, particleRanVel);

		// Create the new particle with the correct parameters.
		new Particle(width / 2, height / 2, nx * s, ny * s, particleRadius);
	}
}

void draw() {
    background(0, 0, 0); // Clears the frame. Remove this line for extra spice.

	Iterator<Particle> itr = particleCollection.iterator(); // Get an iterator for the collection.

	// Start handling particles.
	while (itr.hasNext()) {
		Particle p = itr.next(); // Fetch the current particle.

        p.update(); // Update particle logic.
        p.draw(); // Draw particles.
	}

    // Remove all flagged particles at the end of the frame.
    Iterator<Particle> delitr = removeCollection.iterator();
    while (delitr.hasNext()) {
        Particle p = delitr.next(); // Fetch the current deletion particle.

        // Remove the current particle from the main collection.
        particleCollection.remove(p);
    }

    // Wipe the removal array list.
    removeCollection.clear();

	// Debug count of particles.
	fill(color(255, 255, 255));
	text(particleCollection.size(), 4, 16);
}
