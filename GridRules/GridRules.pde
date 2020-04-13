
/*

Rule system handles node logic and spread. States represent unified states that
rules interpret.

States can be handled in any which way a rule chooses but a few pointers should
probably be considered to keep them easily understood between rulesets.

ACTIVE      The node executes the basic growth rule.
INACTIVE    The node has finished executing its growth rule.
EMPTY       The node does not execute any rule logic.
BLOCKED     The node may not be selected for othere node's logic.
SPECIAL     The node executes an additional custom rule.

 */
enum State {
    ACTIVE,
    INACTIVE,
    EMPTY,
    BLOCKED,
    SPECIAL
}

/*

A node is always a part of a grid and aligned inside of it. Its position is a
location inside of the grid. The value it receives is handled by the rule and
as such acts as a generic representation of any sort of data a rule handles.

Each node follows its own rule. This way, a grid can comprise of various rulesets
that all interact at the same time.

 */
class Node {
    // Parent grid this node belongs to.
    Grid grid;

    // Grid identifier of this node.
    int idx;
    int idy;

    // Positional values for this node relative to the grid origin.
    float x;
    float y;

    //
    float value;
    State state;
    Rule rule;

    Node(Grid grid, int idx, int idy, float x, float y, float value, State state, Rule rule) {
        this.grid = grid;

        this.idx = idx;
        this.idy = idy;

        this.x = x;
        this.y = y;
        this.value = value;

        this.state = state;
        this.rule = rule;
    }
}

// Main handler class. Takes care of managing nodes and generation from rules.
class Grid {
    Node[][] nodes;

    float x;
    float y;
    float w;
    float h;
    float spacing;

    // ArrayList to store all non-inactive Nodes in.
    private ArrayList<Node> activeNodes;

    // Set up a new grid and have it dynamically decide the amount of nodes.
    Grid(float x, float y, float w, float h, float spacing) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;

        this.spacing = spacing;

        // Calculate the total amount of nodes needed to fit within the grid bounds.
        int amountX = int(this.w / this.spacing);
        int amountY = int(this.h / this.spacing);

        // Set the dimensions on our node arrays.
        this.nodes = new Node[amountX][amountY];

        // Placeholder values. We populate the grid and its positions but don't
        // apply any rule information.
        int value = 0;
        State state = State.INACTIVE;
        Rule rule = new PlaceholderRule();

        // Iterate over items in the node arrays and instantiate them.
        for(int idx = 0; idx < amountX; idx++) {
            for(int idy = 0; idy < amountY; idy++) {
                nodes[idx][idy] = new Node(
                    this,
                    idx,
                    idy,
                    this.x + idx * spacing,
                    this.y + idy * spacing,
                    value,
                    state,
                    rule
                );
            }
        }

        // Initialize our list of active nodes.
        this.activeNodes = new ArrayList<Node>();
    }

    // Check if a node exists within our grid.
    boolean contains(int idx, int idy) {
        int lengthX = this.nodes.length;
        int lengthY = this.nodes[0].length;

        return idx >= 0 && idx <= lengthX && idy >= 0 && idy <= lengthY;
    }

    // Get a node on the grid by its IDs. Unsafe. Make sure it's contained.
    Node get(int idx, int idy) {
        return this.nodes[idx][idy];
    }

    // Get a node on the grid by its IDs. Clip at edges.
    Node getClipped(int idx, int idy) {
        int clippedX = Math.clip(idx, 0, this.nodes.length - 1);
        int clippedY = Math.clip(idy, 0, this.nodes[clippedX].length - 1);
        return this.nodes[clippedX][clippedY];
    }

    // Get a node on the grid by its IDs. Allow wrapping.
    Node getWrapped(int idx, int idy) {
        return this.nodes[Math.modulus(idx, this.nodes.length)][Math.modulus(idy, this.nodes[0].length)];
    }

    // Get all nodes around a given node in a set box distance.
    Node[] getNeighborsBox(int idx, int idy, int distance, boolean wrapped) {
        // Reserve the right amount of nodes in our neighbors collection.
        ArrayList<Node> neighbors = new ArrayList<Node>((int) pow(distance * 2 + 1, 2) - 1);

        // Begin iterating over an imaginary grid of our node locations.
        for(int x = idx - distance; x <= idx + distance; x++) {
            for(int y = idy - distance; y <= idy + distance; y++) {
                // Skip the main root node.
                if(x == idx && y == idy) continue;

                // Reserve the node as we will evaluate if it's the root or already present.
                Node node;

                // Handle whether we want to selected nodes extending beyond the bounds.
                if(wrapped) node = this.getWrapped(x, y);
                else        node = this.getClipped(x, y);

                // Make sure we're not treating duplicates from the clip method.
                if(!neighbors.contains(node)) neighbors.add(node);
            }
        }

        return neighbors.toArray(new Node[neighbors.size()]);
    }

    // Get nodes in the same row and column from a given node in a set linear distance.
    Node[] getNeighborsLinear(int idx, int idy, int distance, boolean wrapped) {
        // Reserve the right amount of nodes in our neighbors collection.
        ArrayList<Node> neighbors = new ArrayList<Node>(4 * distance);

        // -- These two loops can probably be shortened --
        for(int x = idx - distance; x <= idx + distance; x++) {
            if(x == idx) continue; // Skip the root node.

            // Reserve the node as we will evaluate if it's the root or already present.
            Node node;

            // Handle whether we want to selected nodes extending beyond the bounds.
            if(wrapped) node = this.getWrapped(x, idy);
            else        node = this.getClipped(x, idy);

            // Make sure we're not treating duplicates from the clip method.
            if(!neighbors.contains(node)) neighbors.add(node);
        }

        for(int y = idy - distance; y <= idy + distance; y++) {
            if(y == idy) continue; // Skip the root node.

            // Reserve the node as we will evaluate if it's the root or already present.
            Node node;

            // Handle whether we want to selected nodes extending beyond the bounds.
            if(wrapped) node = this.getWrapped(idx, y);
            else        node = this.getClipped(idx, y);

            // Make sure we're not treating duplicates from the clip method.
            if(!neighbors.contains(node)) neighbors.add(node);
        }

        return neighbors.toArray(new Node[neighbors.size()]);
    }

    // Apply fixed rules to all nodes.
    void populate(int value, State state, Rule rule) {
        for(Node[] group : this.nodes) {
            for(Node node : group) {
                node.value = value;
                node.state = state;
                node.rule = rule;
            }
        }
    }

    // Apply fixed rules to a set amount of nodes.
    void scatter(int count, int value, State state, Rule rule){
        // Track nodes we have added from scattering.
        boolean[][] scatterFlags = new boolean[this.nodes.length][this.nodes[0].length];

        for(int i = 0; i < count; i++) {
            int idx;
            int idy;

            // Find a node that is not in our list of already scattered nodes.
            do {
                idx = int(random(0, this.nodes.length));
                idy = int(random(0, this.nodes[0].length));
            } while(scatterFlags[idx][idy] == true);

            Node selectedNode = this.nodes[idx][idy];
            selectedNode.value = value;
            selectedNode.state = state;
            selectedNode.rule = rule;

            scatterFlags[idx][idy] = true;
        }
    }

    private void updateActives() {
        // Iterate over all nodes and add new active and special ones if found.
        for(Node[] group : nodes) {
            for(Node node : group) {
                switch(node.state) {
                    case ACTIVE: case SPECIAL: // Add only relevant nodes.
                        activeNodes.add(node);

                        break;

                    default: // Ignore all other cases.
                        break;
                }
            }
        }
    }

    /*
    Begin iterating over nodes and execute their rules until no active nodes remain.

    Returns false if no further iterations are required and generation has been completed.
     */
    boolean iterate() {
        // Update our tracked collection of active nodes.
        this.updateActives();

        // Keep track of the amount of items since we will be reusing this value.
        int activeAmount = this.activeNodes.size();

        // Only process nodes if we have any active or special ones available.
        if(activeAmount > 0) {
            for(int id = 0; id < this.activeNodes.size(); id++) {
                Node node = this.activeNodes.get(id);

                switch(node.state) {
                    case ACTIVE: case SPECIAL: // Only run states that entail logic.
                        // Execute the rule and pass the grid and node as arguments.
                        node.rule.execute(this, node);

                        if(node.state != State.ACTIVE && node.state != State.SPECIAL) {
                            this.activeNodes.remove(id); // Remove the node if it's no longer active.
                        }

                        break;

                    default: // Ignore all other cases.
                        break;
                }
            }

            return true;
        }

        return false;
    }

    /*
    Pick a random non-inactive node and execute its rule. Store active nodes for
    optimization. Check their state after execution and remove them if they have
    become inactive.

    Returns false if no further iterations are required and generation has been completed.
     */
    boolean iterateStep(){
        // Make sure that all nodes have been cleared before rebuilding.
        if(activeNodes == null || activeNodes.size() == 0){
            this.updateActives();
        }

        // Keep track of the amount of items since we will be reusing this value.
        int activeAmount = this.activeNodes.size();

        // Avoid NullPointerReference issues.
        if(activeAmount > 0) {
            int id = int(random(activeAmount));

            Node node = this.activeNodes.get(id);
            node.rule.execute(this, node);

            if(node.state != State.ACTIVE && node.state != State.SPECIAL) {
                this.activeNodes.remove(id); // Remove the node if it's no longer active.
            }
        }

        return activeAmount != 0; // Do a sloppy inverse boolean conversion.
    }
}

// Global grid we'll draw and handle.
Grid grid;

void setup() {
    size(640, 480);
    frameRate(30);
    background(255, 255, 255);

    // Instantiate and assign the main grid object.
    grid = new Grid(8, 8, width, height, 16);
    grid.populate(0, State.INACTIVE, new EliminationRule());
    grid.scatter(16, 0, State.ACTIVE, new EliminationRule());
}

void draw() {
    fill(255, 255, 255, 25);
    rect(0, 0, width, height);
    fill(0, 0, 0);

    // Draw the grid. When completed, stop drawing and show text.
    if(!grid.iterate()) {
        textAlign(CENTER);
        text("Completed", grid.w / 2, grid.h / 2);

        noLoop();
    };
}
