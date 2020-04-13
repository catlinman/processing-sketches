
/*
	Circular movement simulation.

    Created this to explain some math related questions to a friend. This helped
    a ton in the end. Should be simple enough to recognize and understand what it
    is showing!
*/

/* User variables. */
float rotation = radians(0.5);
float radius = 100;

/* Runtime variables. */
float rot = 0;
boolean hide = false;

void setup() {
    size(256, 256);
    frameRate(60);
    background(0, 0, 0);
}

void draw() {
    background(0, 0, 0); // Clear the frame.

    rot += rotation; // Add the user specified rotation each frame.

    // Calculate some frequently used variables.
    float x = cos(rot);
    float y = sin(rot);

    // Check if the helpers should be hidden.
    if(!hide) {
        // Draw the axis labels.
        fill(128, 128, 128);
        text("x = " + nf(x, 0, 3), width / 2 + radius - 54, height / 2 + 16);
        text("y = " + nf(-y, 0, 3), width / 2 + 12, height / 2 + radius - 24);

        // Draw the inner circle and the connecting line between circles.
        noFill();
        stroke(128, 128, 128);
        ellipse(width / 2, height / 2, abs(radius * x * 2), abs(radius * y * 2));
        line(x * radius + width / 2, height / 2, width / 2, y * radius + height / 2);

        // Draw the axes.
        stroke(255, 255, 255);
        line(width / 2 - radius, height / 2, width / 2 + radius, height / 2);
        line(width / 2, height / 2 - radius, width / 2, height / 2 + radius);

        // Draw the axis circles.
        ellipse(x * radius + width / 2, height / 2, 32, 32);
        ellipse(width / 2, y * radius + height / 2, 32, 32);
    }

    // Draw the outside circle.
    noFill();
    stroke(255, 255, 255);
    ellipse(width / 2, height / 2, radius * 2, radius * 2);

    // Draw the main circle.
    fill(255, 255, 255);
    ellipse(x * radius + width / 2, y * radius + height / 2, abs(x * y) * 16 + 16, abs(x * y) * 16 + 16);
}

// Catch mouse press input and toggle helpers on click.
void mousePressed() {hide = !hide;}
