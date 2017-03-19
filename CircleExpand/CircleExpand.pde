
/*
    Saw this little animation in CSS and quickly threw it together in Processing.
*/

/* Runtime variables. */
Circle currentCircle;
int currentHue = 0;

// Main class of the expanding circle. Uses currentCircle as the main register.
class Circle {
    float x;
    float y;
    color c;

    private float progress = 0;
    private float speed = 0;

    Circle(float x, float y, color c) {
        this.x = x;
        this.y = y;
        this.c = c;

        // Set the global circle to this instance.
        currentCircle = this;
    }

    // Draw the circle with the current progress. Nothing special.
    void draw() {
        fill(this.c);
        ellipse(this.x, this.y, this.progress, this.progress);
    }

    // Update the circle math/expansion. Uses some simple lerps.
    void update() {
        // Do a lerp for the progression of the circle and the speed of it.
        this.progress = this.progress + ((width + height) * 1.5 - this.progress) * this.speed;
        this.speed = this.speed + (1 - this.speed) * 0.0025;

        // If the circle is clearly bigger than the screen we can complete the animation.
        if(this.progress > (width + height) * 1.5) currentCircle = null;
    }
}

void setup() {
    size(256, 256);
    frameRate(60);
    background(0, 0, 0);
    colorMode(HSB, 255, 255, 255);
    noStroke();
}

void draw() {
    // Draw a circle if it is currently set.
    if(currentCircle != null) {
        currentCircle.draw();
        currentCircle.update();
    }
}

void mouseClicked() {
    if(mouseButton == LEFT) {
        // Create a new circle and shift hue if the user presses the left mouse button.
        currentHue = (currentHue + (int) random(64, 192)) % 255;
        new Circle(mouseX, mouseY, color(currentHue, 255, 255));

    } else {
        // Create a new black circle which will clear the canvas.
        new Circle(mouseX, mouseY, color(currentHue, 0, 0));
    }
}
