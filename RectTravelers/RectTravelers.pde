
/*
    Saw this animation being done in After Effects and wanted to created a
    program out of it. Rectangles travel along a grid like structure one cell
    at a time in a random direction. They can not intersect though in which case
    they simply don't move for the current update.
 */

/* User variables. */
// Number of travelers to spawn.
int count = 8;

// Rows and column count.
int rows = 4;
int columns = 42;

// Global offset of the grid.
float offsetX = 4;
float offsetY = 6;

// Size of rectangles and margin between each of them.
int rectSize = 2;
int rectMargin = 4;

// Directional push. Should best clamp -0.9 -> 0.9.
float flowX = 0.5;
float flowY = 0;

// Time in seconds that the animation takes to decay.
float decaySeconds = 0.5;

/* Runtime variables. */
TravelGrid grid;

class TravelGrid {
    // Rows and columns.
    int nx;
    int ny;

    // Global position offsets.
    float ox;
    float oy;

    // Positional flow values. Effect all active cells.
    float fx;
    float fy;

    int s; // Size of cells.
    float m; // Margin between cells.

    // Storage of cells.
    private boolean[][] cells;

    TravelGrid(int nx, int ny, float ox, float oy, float fx, float fy, int s, float m) {
        this.nx = nx;
        this.ny = ny;

        this.ox = ox;
        this.oy = oy;

        this.fx = fx;
        this.fy = fy;

        this.s = s;
        this.m = m;

        // Set the correct size for the cell array.
        this.cells = new boolean[this.nx][this.ny];
    }

    // Adds a select number of new traveller cells.
    void add(int count) {
        int fills = 0;

        for(int c = 0; c < count; c++) {
            int selectX = (int) random(0, this.nx);
            int selectY = (int) random(0, this.ny);

            this.cells[selectX][selectY] = true;
        }
    }

    // Iterates over active cells and draws them.
    void draw() {
        fill(255, 255, 255);

        for(int x = 0; x < this.nx; x++) {
            for(int y = 0; y < this.ny; y++) {
                if(this.cells[x][y] == true) rect((x * (this.s + this.m)) + this.ox, (y * (this.s + this.m)) + this.oy, this.s, this.s);
            }
        }
    }

    // Iterates over each cell and move active ones while checking neighbors.
    void update() {
        for(int x = 0; x < this.nx; x++) {
            for(int y = 0; y < this.ny; y++) {
                if(this.cells[x][y] == true) {
                    // Chose a direction at random and add the flow values.
                    int selectX = round(random(-1, 1) + this.fx);
                    int selectY = round(random(-1, 1) + this.fy);

                    // Logic trap of doom to assure only one movement angle at a time.
                    if((selectX != 0 && selectY != 0) || (selectX == 0 && selectY == 0)) continue;

                    // Calculate the new position and wrap out of bounds positions.
                    int newX = (this.nx + (x + selectX)) % this.nx;
                    int newY = (this.ny + (y + selectY)) % this.ny;

                    // If the new cell is already taken skip this iteration.
                    if(this.cells[newX][newY] == true) continue;

                    // Deactivate the last cell and move its state to the new one.
                    this.cells[x][y] = false;
                    this.cells[newX][newY] = true;
                }
            }
        }
    }
}

void setup() {
    size(256, 32);
    frameRate(15);
    background(0, 0, 0);

    fill(255, 255, 255);
    noStroke();

    grid = new TravelGrid(
        columns,
        rows,
        offsetX,
        offsetY,
        flowX,
        flowY,
        rectSize,
        rectMargin
    );

    grid.add(count);
}

void draw() {
    fill(0, 0, 0, 255 / frameRate * (1 / decaySeconds * 2)); // Slowly decay the animation.
    rect(0, 0, width, height); // Fill with a mostly transparent rectangle.

    grid.draw();
    grid.update();
}
