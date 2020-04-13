
/*
    Interference wave pattern example.

    Made this for a friend and his high school project to show the interference
    pattern of intersecting wavelengths with addition and subtraction.
 */

// Imports for compatability.
import java.util.Iterator;

/* User variables. */
int waveWidth = 6;
int waveCount = 16;
int waveSpeed = 1;
int waveDistance = 8;
Boolean waveBlur = false;

/* Runtime variables. */
ArrayList<Wave> waveCollection;

class Wave {
    float v; // Value of this wave. Used for addition and subtraction.

    // Positional values.
    float x;
    float y;

    float border; // Border width of the wave in pixels.
    float speed; // Expansion speed of the wave in pixels.

    // Expansion radius of the wave.
    private float r = 0;

    Wave(float v, float x, float y, float border, float speed) {
        this.v = v;
        this.x = x;
        this.y = y;

        this.border = border;
        this.speed = speed;

        // Add the instantiated wave to the static array.
        waveCollection.add(this);
    }

    void draw() {
        this.r += this.speed;

        float c = 128 + (255 * this.v); // Convert the -1/1 range to 255.

        noFill(); // Make sure we are not drawing anything inside the wave.
        stroke(c); // Set the correct stroke color.
        strokeWeight(this.border); // Set the wave border width.

        // Draw the ellipse shape for the wave.
        ellipse(this.x, this.y, this.r, this.r);
    }
}

void setup() {
    size(256, 256);
    frameRate(60);
    background(128, 128, 128, 255);

    // Instantiate our array list.
    waveCollection = new ArrayList<Wave>();

    for(int i = 0; i < waveCount; i++) {
        new Wave(((i % 2) * 2) - 1, - waveDistance * i, height + waveDistance * i, waveWidth, waveSpeed);
        new Wave((((i + 1) % 2) * 2) - 1, width + waveDistance * i, height + waveDistance * i, waveWidth, waveSpeed);
    }
}

void draw() {
    // Reset the background.
    background(128, 128, 128);

    // Set the correct blend mode.
    blendMode(SOFT_LIGHT);

    Iterator<Wave> itr = waveCollection.iterator(); // Get an iterator for the collection.

	// Start handling waves.
	while (itr.hasNext()) {
        Wave w = itr.next(); // Fetch the current wave.

        // Draw the current wave.
        w.draw();
    }

    // Optionally blur waves.
    if(waveBlur) filter(BLUR, 4);
}
