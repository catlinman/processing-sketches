
// Main interface that other rules implement.
interface Rule {
    void execute(Grid g, Node n);
}

// Rule without any logic. When active set themselves inactive.
class PlaceholderRule implements Rule {
    void execute(Grid g, Node n) {
        n.state = State.INACTIVE;
    }
}

// Nodes place a circle in their center and are set inactive.
class DotRule implements Rule {
    void execute(Grid g, Node n) {
        circle(n.x, n.y, g.spacing);

        n.state = State.INACTIVE;
    }
}

// Nodes generate a grid and are set inactive.
class GridRule implements Rule {
    void execute(Grid g, Node n) {
        Node t1 = g.getWrapped(n.idx + 1, n.idy);
        line(n.x, n.y, t1.x, t1.y);

        Node t2 = g.getWrapped(n.idx, n.idy + 1);
        line(n.x, n.y, t2.x, t2.y);

        n.state = State.INACTIVE;
    }
}

// Node randomly picks a neighbor and travels. Two nodes picking the same node are eliminated.
class EliminationRule implements Rule {
    void execute(Grid g, Node n) {
        // Disable the current node. We will be jumping to another.
        n.state = State.INACTIVE;

        // Fill in our now inactive node.
        fill(255, 255, 255);
        circle(n.x, n.y, g.spacing);

        // Get all neighboring nodes.
        Node[] neighbors = g.getNeighborsLinear(n.idx, n.idy, 1, false);

        // Pick a target from the neighbors.
        Node target = neighbors[(int) random(neighbors.length)];

        // Tell the grid to update the target node.
        target.state = State.ACTIVE;

        // Draw in the new node.
        fill(0, 0, 0);
        circle(target.x, target.y, g.spacing);
    }
}

// TODO: Expands from active node to neighbors.
class ExplosionRule implements Rule {
    void execute(Grid g, Node n) {
        n.state = State.INACTIVE;

        fill(255, 255, 255);
    }
}

class CircuitRule implements Rule {
    void execute(Grid g, Node n) {

    }
}
