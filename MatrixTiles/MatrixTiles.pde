
/*
    Animation inspired by that seen in the Matrix movies. Been wanting to create
    something like this for a while now.
 */

/* User variables; */
int gridCount = 16; // Number of active characters.
int gridSize = 10; // Size of characters.
color gridColor = color(0, 255, 0); // Color of characters.

float decaySeconds = 0.5; // Time in seconds that the animation takes to decay.

float stopProbablity = 1 / 5; // Probabilty of a letter pausing.
float killProbablity = 1 / 50; // Probabilty of a letter resetting.

String selection = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789!§$%&="; // Input characters.

/* Runtime variables. */
MatrixGrid mainGrid;

// Helper class for the MatrixGrid class.
class MatrixLetter {
    float x;
    float y;
    int s;
    color c;

    MatrixLetter(float x, float y, int s, color c) {
        this.x = x;
        this.y = y;
        this.s = s;
        this.c = c;
    }
}

// Main handler class. Takes care of drawing and animation.
class MatrixGrid {
    float x;
    float y;
    int fontSize;
    color fontColor;

    // Stores the number of rows available for the given screen size.
    private int rangeX;
    private int rangeY;

    // Stores each active letter.
    private MatrixLetter[] collection;

    MatrixGrid(float x, float y, int n, int s, color c) {
        this.x = x;
        this.y = y;
        this.fontSize = s;
        this.fontColor = c;

        // Calculate the maximum available rows and columns.
        this.rangeX = (int) (width / this.fontSize);
        this.rangeY = (int) (height / this.fontSize);

        // Instantiate the array with the required length/count.
        this.collection = new MatrixLetter[n];

        // Instantiate new letter objects and assign random positions to them.
        for(int i = 0; i < n; i++) {
            this.collection[i] = new MatrixLetter(
                this.x + this.fontSize / 2 + (int) random(0, this.rangeX) * this.fontSize,
                this.y + (int) random(0, this.rangeY) * this.fontSize,
                this.fontSize,
                this.fontColor
            );
        }
    }

    // Draw function handles all letters within the grid object.
    void draw() {
        for(int i = 0; i < this.collection.length; i++) {
            MatrixLetter m = this.collection[i];

            char character = selection.charAt((int) random(0, selection.length()));

            fill(m.c);
            textSize(m.s);
            text(character, m.x, m.y);
        }
    }

    // Updates the logic of each letter and advancing the animation.
    void update() {
        for(int i = 0; i < this.collection.length; i++) {
            MatrixLetter m = this.collection[i]; // Assign the current letter for easier access.

            // Create some simple flags to better manage the probability states.
            boolean stopFlag = random(0, 1) < stopProbablity;
            boolean killFlag = random(0, 1) < killProbablity;

            // Skip this loop if the stop flag has been raised.
            if (stopFlag) continue;

            // Increment by the size of a character.
            m.y += this.fontSize;

            // Reset a letter if it leaves the screen or the kill flag has been raised.
            if(m.y > height || killFlag) {
                m.x = this.x + this.fontSize / 2 + (int) random(0, this.rangeX) * this.fontSize;
                m.y = 0;
            }
        }
    }
}

void setup() {
    size(256, 256);
    frameRate(15);
    background(0, 0, 0);
    textAlign(CENTER);

    // Instantiate and assign the main grid object.
    mainGrid = new MatrixGrid(0, 0, gridCount, gridSize, gridColor);
}

void draw() {
    fill(0, 0, 0, 255 / frameRate * (1 / decaySeconds * 2)); // Slowly decay the animation.
    rect(0, 0, width, height); // Fill with a mostly transparent rectangle.

    // Run the main functions of the grid to draw and advance the animation.
    mainGrid.draw();
    mainGrid.update();
}
