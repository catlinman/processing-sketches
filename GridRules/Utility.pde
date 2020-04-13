
// Simple math extention library.
static class Math {
    // True modulo calculator as apposed to the remainder version implemented by Processing.
    static int modulus(int a, int b) {
        return ((a % b) + b) % b;
    }

    // Upper and lower bound clipping of a value.
    static int clip(int a, int lower, int upper) {
        return min(max(a, lower), upper);
    }
}
