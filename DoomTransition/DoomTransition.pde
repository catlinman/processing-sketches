
/*
	Doom transition animation as seen when changing menus and loading levels in
    the original games.

    Was struggling with this in the beginning because of lacks of time but finally
    got around to completing this and it looks rather spot on.
*/

// User variables.
float maxspeed = 20.0;
float damping = 100;
float delay = 1.0;
boolean debug = false;

// Runtime variables.
float time = 0.0;
float speed = 0.0;

// Image buffers.
PImage frame;
PImage inImage;
PImage outImage;

// Transition relevant variables.
int[] columnShifts; // Counts the shift for each column.
boolean columnDone = false; // Value is true if the transition has completed.

// Iterates over array integers and sums them up.
static final int sum(int[] arr) {
    int sum = 0;
    for (final int f : arr) sum += f;
    return sum;
}

void setup() {
	frameRate(60);
	size(256, 256);

    // Load the images.
    inImage = loadImage("doom1.jpg");
    outImage = loadImage("doom2.jpg");

    // Draw the base image we will star the transition with.
	image(inImage, 0, 0, width, height);

    // Set an extra simple background in case we want to debug.
    if(debug) background(0, 0, 0);

    // Get the current image buffer and construct an array with column shifts.
	frame = get();

	columnShifts = new int[frame.width]; // Set the correct size of the array.
}

void draw() {
	time += (1 / frameRate); // Add to the time with seconds.

    // Draw the base image we will star the transition with.
	image(outImage, 0, 0, width, height);

    // Set an extra simple background in case we want to debug.
    if(debug) background(255, 255, 255);

    if(!columnDone) {
        // Interpolate towards the maximum speed once the delay is passed.
        if(time > delay) speed = speed + (maxspeed - speed) / damping;

        frame.loadPixels(); // Load the pixels first before using them.

        for (int i = 0; i < frame.width; i++) {
            // If the shift has reached the bottom we can skip everything.
            if(columnShifts[i] == frame.height) continue;

            // The current random shift to apply on the given frame for the column.
            int shift = (int) random(0, speed);

            // We have to shift columns multiple times to match the noise.
            for(int j = 0; j < shift; j++) {
                // This value is the cached last pixel used to shift the column.
                int cachePixel = 0;

                // Store the last shift in a variable to avoid constant array access.
                int lastShift = columnShifts[i];

                // Iterate over all pixels in the column and shift them down.
                for(int k = 0; k < frame.height; k++) {
                    // Optimization pass. Ignore already shifted pixels.
                    if(k < lastShift + 1) continue;

                    int currentPixel = frame.pixels[
                        (k * frame.width) + i
                    ];

                    frame.pixels[
                        (k * frame.width) + i
                    ] = cachePixel;

                    cachePixel = currentPixel;
                }
            }

            // Add the new shift to the column.
            columnShifts[i] = min(columnShifts[i] + shift, frame.height);
        }

        frame.updatePixels(); // Update the pixels of our frame buffer.

        // Set our transitioned base frame.
        image(frame, 0, 0);

        // Check if all shifted column have reached the bottom of the screen.
        if(sum(columnShifts) == frame.width * frame.height) columnDone = true;

        // Draw helpers for completed columns for easier debugging and optimization.
    	if(debug) {
    		stroke(color(255, 0, 0, 100));

    		for(int i = 0; i < frame.width; i++) {
    			if(columnShifts[i] == frame.height) line(i, 0, i, frame.height);
    		}
    	}

    } else {
        noLoop();
    }
}
