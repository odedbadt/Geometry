// Extension package for asymptote
// This package contains math and objects for hyperbolic geometry
// in the poincare unit disk model.
// Written by R. Bourquin in 2007, 2008, 2009
// This is version 0.82
// Licensed under GNU General Public License version 2 or later.

// Needed for high accuracy circle/arc drawing
import graph;

// Some special values:
real epsilon = 10.0^(-10);    // Zero for all practical purposes
real infinity = 10.0^10;      // Infinity for all practical purposes
pair origin = (0, 0);

// =============================================================================
// Euclidian helper functions
// =============================================================================
// These functions do not have parameter checks! They are feed with valid data
// from inside the hyperbolic code.

// Tests, if 3 points \in R^2 are colliniear
// IN: 3 points \in R^2
// OUT: boolean answer
// MATH:
// cross product of v1-v2 and v2-v3 is (0, 0, a)
// where v1 = (v1.x, v1.y, 0)
// a has to be zero for collinear points.
// or
// Matrix(col1 = v1, col2 = v2, col3 = v3) with det = 0
// where v1 = (v1.x, v1.y, 1)
bool are_collinear(pair v1, pair v2, pair v3) {
    return abs(v1.x*(v2.y-v3.y) - v1.y*(v2.x-v3.x) + v2.x*v3.y - v2.y*v3.x) <= epsilon;
}

// Standard vector cross product
// IN:  2 vectors \in R^2
// OUT: Cross procudt vector \in R^2
// MATH:
// Crossproduct between 2 vectors. This is only the z-part
// for vectors of the form (x, y, 0).
real cross_product(pair v1, pair v2) {
    return v1.x*v2.y-v1.y*v2.x;
}

// Chirality test for 2 vectors \in R^2
// IN:  2 vectors \in R^2
// OUT: true <=> v1,v2 right-handed
bool right_handed(pair v1, pair v2) {
    return cross_product(v1, v2) > 0;
}

// Chirality test for 3 points \in R^2
// IN:  3 points \in R^2
// OUT: true <=> (p2-p1),(p3-p2) right-handed
bool right_handed(pair a, pair b, pair c) {
    return cross_product(b-a, c-b) > 0;
}

// Should two pairs be considered identical
bool is_same_pair(pair p, pair q) {
    return length(p-q) <= epsilon;
}

// Tests if some given euclidic point is really inside the hyperbolic disk.
// IN:  Euclidic point (x, y)
// OUT: boolean answer
// MATH: abs(z) < 1 if z is inside the unit disk
bool is_inside_disk(pair p) {
    return (length(p) < 1);
}

// Mirror an euclidian point P at a given euclidian line
// IN:  Direction vector dir, point P
// OUT: Mirrored point Q
// MATH: Formula follows from householder matrices
pair mirror(pair d, pair p) {
    pair v = (-d.y, d.x);
    return (-p.x-2*v.y*(v.x*p.y-v.y*p.x)/(v.x^2+v.y^2) , p.y-2*v.y*(v.x*p.x+v.y*p.y)/(v.x^2+v.y^2));
}

// Invert a point at a circle.
// IN:  Euclidian circle given by center C and radius R, point P
// OUT: Point Q which is the inversion of P.
// MATH: CP*CQ = R^2
pair invert(pair center, real radius, pair point) {
    // MATH: Inversion of point p at circle c
    // direction vector pointing to the center of the euc. circle representing the line
    pair dir = center - point;
    // Distance of p from center c
    real len = length(dir);
    // Distance of the two mirror images
    real x = (radius^2-len^2) / len;
    // And the image point q of p
    return (center - (len+x)*unit(dir));
}

// Rotate a point around the origin
// IN:  Euclidian point, angle in degrees
// OUT: Euclidian point rotated by this angle
pair rotate(pair p, real angle) {
    // MATH: Use of common rotation matrices
    real a = radians(angle);
    return (cos(a)*p.x-sin(a)*p.y, sin(a)*p.x+cos(a)*p.y);
}

// =============================================================================
// Hyperbolic geometry objects and constructors
// =============================================================================

// Converts hyperbolic polar coordinates to euclidean cartesian coordinates
// IN:  Hyperbolic coordinates of point p (radius, angle)
// OUT: Euclidean coordinates of point p (x, y)
pair to_euclidean(real radius, real angle) {
    // Point is always inside open unit disk
    real euc_rad = sqrt((cosh(radius)-1)/(cosh(radius)+1));
    return (euc_rad*cos(radians(angle)), euc_rad*sin(radians(angle)));
}

// Converts euclidean cartesian coordinates to hyperbolic polar coordinates.
// IN:  Euclidean coordinates of point p (x, y)
// OUT: Hyperbolic coordinates of point p (radius, angle)
real[] to_hyperbolic(pair p) {
    real[] h_point;
    if ( !is_inside_disk(p) ) {
        write("Warning: Point not inside the open unit disk, transformation to hyperbolic coordinates failed!");
        // Return origin
        h_point[0]=0;
        h_point[1]=0;
    } else {
        // Offset because of atan2(y, x) and y<0
        real offset = p.y > 0 ? 0 : 360;
        h_point[1] = offset + degrees(atan2(p.y,p.x));
        h_point[0] = acosh(1+2*length(p)^2/(1-length(p)^2));
    }
    return h_point;
}

/** This struct represents a hyperbolic point.
 *  A point is constructed with the hyperbolic
 *  distance from the origin and the angle between
 *  OP and the x-axis
 */
struct hyperbolic_point {
    // Hyperbolic coordinates (angle, radius)
    private real[] h_point;
    // Euclidian coordinates (x, y)
    private pair e_point;
    // If a point can not be constructed, this is set to true
    private bool is_invalid;

    // New points are invalid by default
    void operator init() {
        is_invalid = true;
    }

    // Configure a point from euclidian coordinates
    void configure(pair ep) {
        e_point = ep;
        h_point = to_hyperbolic(ep);
        is_invalid = false;
    }

    // Configure a point from hyperbolic polar coordinates
    void configure(real radius, real angle) {
        h_point[0] = radius;
        h_point[1] = angle;
        e_point = to_euclidean(radius, angle);
        is_invalid = false;
    }

    pair get_euclidean() { return e_point; }
    real[] get_hyperbolic() { return h_point; }
    bool is_invalid() { return is_invalid; }
    void set_invalid() { is_invalid = true; }

    path to_path() { return e_point; }
}

hyperbolic_point hyperbolic_point(real radius, real angle) {
    hyperbolic_point P = hyperbolic_point();
    P.configure(radius, angle);
    return P;
}

hyperbolic_point hyperbolic_point(pair ep) {
    hyperbolic_point P = hyperbolic_point();
    if ( !is_inside_disk(ep) ) {
        write("Warning: Could not construct point outside of the unit disk!");
        return P;
    }
    P.configure(ep);
    return P;
}

/** Decide if three hyperbolic points are right handed.
 */
bool right_handed(hyperbolic_point P, hyperbolic_point Q, hyperbolic_point R) {
    // TODO: How to react if input points are invalid?
    return right_handed(P.get_euclidean(), Q.get_euclidean(), R.get_euclidean());
}

/** Calculate the hyperbolic distance of two hyperbolic points.
 *  IN:  Two hyperbolic points
 *  OUT: The distance, measured with the hyperbolic metric
 *  See also http://en.wikipedia.org/wiki/Poincaré_disc_model
 */
real hyperbolic_distance(hyperbolic_point A, hyperbolic_point B) {
    if ( A.is_invalid() || B.is_invalid() ) {
        write("Warning: Distance calculation failed. A point is invalid.");
        // Maybe check for the use of NaNs
        return infinity;
    }
    pair a = A.get_euclidean();
    pair b = B.get_euclidean();
    return acosh(1+2*length(a-b)^2/((1-length(a)^2)*(1-length(b)^2)));
}

/** Decide if two given points should be cosidered identical.
  */
bool is_same_point(hyperbolic_point A, hyperbolic_point B) {
    return !A.is_invalid() && !B.is_invalid() && hyperbolic_distance(A,B) <= epsilon;
}

/** Decide if three given points should be cosidered identical.
  */
bool is_same_point(hyperbolic_point A, hyperbolic_point B, hyperbolic_point C) {
    return ( is_same_point(A,B) && is_same_point(B,C) );
}

/** Decide if three given points should be cosidered all distinct.
  */
bool distinct(hyperbolic_point A, hyperbolic_point B, hyperbolic_point C) {
    return ( !is_same_point(A,B) && !is_same_point(B,C) && !is_same_point(C,A) );
}

/** Angle \angle(PQR) "between" three points P,Q,R
 */
real angle(hyperbolic_point P, hyperbolic_point Q, hyperbolic_point R) {
    real angle = 0.0;
    if (P.is_invalid() || Q.is_invalid() || R.is_invalid()) {
        write("Warning: Angle calculation failed! A point is invalid.");
        return angle;
    }
    if ( !distinct(P,Q,R) ) {
        write("Warning: Angle calculation failed! Points are to near to each other.");
        return angle;
    }
    // For the calculation we use the hyperbolic version of the law of cosines.
    // Note: This may be numericaly unstable, but should (hopefully) suffice for drawings.
    real a = hyperbolic_distance(P,Q);
    real b = hyperbolic_distance(R,Q);
    real c = hyperbolic_distance(P,R);

    angle = acos( (cosh(a)*cosh(b)-cosh(c))/(sinh(a)*sinh(b)) );
    return angle;
}

/** This structure represents a hyperbolic infinite line.
 *  A line can be a straight line or an arc with a finite center/radius.
 */
struct hyperbolic_line {
    // Data about the euclidean circle, that represents this line
    // Ever do a check for diameters before requesting these values!
    private real radius;
    private pair center;
    // If the hyperbolic line contains the origin it's not a circle anymore,
    // but a diameter. In this case the values center and radius have no meaning!
    private bool is_diam;
    // The two (infinit far) points on the unitcircle. These points are
    // NOT hyperbolic points! They are so called "ideal points"
    private pair first_end;
    private pair second_end;
    // If a line can not be constructed, this is set to true.
    private bool is_invalid;

    // New lines are invalid by default
    void operator init() {
        is_invalid = true;
    }

    // configure a line from center, radius and endpoints
    // A little bit ugly, but ok for internal use ...
    // Remenber to give 0 for diameters!
    void configure(pair c, real r, pair e1, pair e2) {
        is_diam = are_collinear(e1, e2, origin) ? true : false;
        center = c;
        radius = r;
        // and now the endpoints
        first_end = e1;
        second_end = e2;
        is_invalid = false;
    }

    // Configure a line only from given euclidean center
    // and radius and calculate the endpoints. This can only be used
    // for lines which are described by circles.
    void configure(pair c, real r) {
        is_diam = false;
        center = c;
        radius = r;
        // and now the endpoints
        real h = r / length(c);
        real q = sqrt(1-h^2);
        pair hv = (c.y, -c.x);
        first_end = q*unit(c) + h*unit(hv);
        second_end = q*unit(c) - h*unit(hv);
        is_invalid = false;
    }

    // Configure a line only from given endpoints
    void configure(pair e1, pair e2) {
        if ( are_collinear(e1,e2,origin) ) {
            is_diam = true;
            // Some more or less meaningfull values which should never be used
            center = origin;
            radius = -1;
        } else {
            is_diam = false;
            pair e = e1-e2;
            real d = sqrt(4.0/(4-length(e)^2));
            center = d*unit((-e.y, e.x));
            if ( right_handed(origin, e1, e2) != right_handed(origin,center, e2) ) {
                center = -center;
            }
            radius = length(center - e1);
        }
        // and now the endpoints, assure first_end = e1
        first_end = e1;
        second_end = e2;
        is_invalid = false;
    }

    // Used in the case we know that a already existing line is a diameter
    void reconfigure() {
        if ( are_collinear(first_end,second_end,origin) ) {
            is_diam = true;
            // Some more or less meaningfull values which should never be used
            center = origin;
            radius = -1;
        }
    }

    pair get_first_endpoint() { return first_end; }
    pair get_second_endpoint() { return second_end; }
    bool is_diameter() { return is_diam; }
    pair get_center() { return center; }
    real get_radius() { return radius; }
    bool is_invalid() { return is_invalid; }
    void set_invalid() { is_invalid = true; }

    path to_path() {
        if (is_diam == true) {
            // It's a straight line, but because of possible nummercial errors
            // we include the origin as point to get nicer images.
            return first_end--(0,0)--second_end;
        } else {
            // Some math to assure, we get the "shorter", inner arc.
            // If the points are a right-handed system, the arc has to be ccw.
            bool direction = right_handed(center-first_end, second_end-center) ? false : true;
            return Arc(center, first_end, second_end, direction);
        }
    }
}

/** Hyperbolic line through two given hyperbolic points.
 */
hyperbolic_line hyperbolic_line(hyperbolic_point A, hyperbolic_point B) {
    hyperbolic_line L = hyperbolic_line();
    if ( is_same_point(A,B) ) {
        write("Warning: Two points are to near to each other, no line possible!");
        return L;
    }

    pair a = A.get_euclidean();
    pair b = B.get_euclidean();
    if ( are_collinear(origin, a, b) ) {
        // The hyperbolic line is a diameter of the unit circle
        write("Info: Hyperbolic line is a diameter");
        // Calculate the endpoints.
        pair e1, e2;
        // E1 lies straight ahead af A
        e1 = unit(a-b);
        // E2 lies behind B
        e2 = -unit(a-b);
        L.configure(e1, e2);
    } else {
        // The hyperbolic line is a real euclidean circle
        pair sv = ((b.y-a.y), -(b.x-a.x));
        real t = (1-a.x*b.x-a.y*b.y) / (2*a.x*b.y-2*a.y*b.x);
        pair c = a + (b-a)/2 + t*sv;
        real r = length((b-a)/2 + t*sv);
        // And now the endpoints again. This time, it's a little bit more complicated
        real h = r / length(c);
        real q = sqrt(1-h^2);
        pair hv = (c.y, -c.x);
        pair e1 = q*unit(c) + h*unit(hv);
        pair e2 = q*unit(c) + -h*unit(hv);
        L.configure(c, r, e1, e2);
    }
    return L;
}

/** Test if two hyperbolic lines should be considered identical.
  */
bool is_same_line(hyperbolic_line K, hyperbolic_line L) {
    if ( K.is_invalid() || L.is_invalid() ) {
        write("Warning: is_same_line(...) test failed! A line is invalid.");
        return false;
    }
    pair EK1 = K.get_first_endpoint();
    pair EK2 = K.get_second_endpoint();
    pair EL1 = L.get_first_endpoint();
    pair EL2 = L.get_second_endpoint();
    // Same endpoints => same line
    return ( length(EK1-EL1) <= epsilon && length(EK2-EL2) <= epsilon ) ||
           ( length(EK1-EL2) <= epsilon && length(EK2-EL1) <= epsilon );
}

/** Tests if a hyperbolic point P lies on a given hyperbolic line L
 */
bool is_on_line(hyperbolic_line L, hyperbolic_point P) {
    if ( L.is_invalid() || P.is_invalid() ) {
        write("Warning: is_on_line(...) test failed! The line and/or point is invalid.");
        return false;
    }
    if ( L.is_diameter() ) {
        return are_collinear(L.get_first_endpoint(), L.get_second_endpoint(), P.get_euclidean());
    } else {
        // Yes, I know this is numerically unstable. Never subtract floats of same size.
        return abs(length(L.get_center()-P.get_euclidean()) - L.get_radius()) <= epsilon;
    }
}

/** Tests if two given hyperbolic lines do intersect.
 */
bool do_intersect(hyperbolic_line G, hyperbolic_line H) {
    if (G.is_invalid() || H.is_invalid()) {
        write("Warning: Intersection test failed! A line is invalid.");
        return false;
    }
    if ( is_same_line(G,H) ) {
        write("Info: Intersection test: lines are identical.");
        return true;
    }
    bool gid = G.is_diameter();
    bool hid = H.is_diameter();
    if ( gid && hid ) {
        // Always intersect at the origin
        return true;
    } if ( gid && !hid) {
        pair e1 = G.get_first_endpoint();
        pair e2 = G.get_second_endpoint();
        pair ch = H.get_center();
        real rh = H.get_radius();
        // Factor 2 is the length of e2-e1!
        return ( abs(cross_product(e2-e1, ch)) <= 2*rh ) ? true : false;
    } if ( !gid && hid ) {
        pair e1 = H.get_first_endpoint();
        pair e2 = H.get_second_endpoint();
        pair cg = G.get_center();
        real rg = G.get_radius();
        // Factor 2 is the length of e2-e1!
        return ( abs(cross_product(e2-e1, cg)) <= 2*rg ) ? true : false;
    } if ( !gid && !hid ) {
        pair cg = G.get_center();
        pair ch = H.get_center();
        real rg = G.get_radius();
        real rh = H.get_radius();
        // Circles are too far away from each other OR one circle lies completly inside the other one.
        return ( length(cg-ch) > rg + rh || length(cg-ch) < abs(rg - rh) ) ? false : true;
    }
    return false;
}

/** Calculate the angle between two hyperbolic lines.
 *  Note that the intersection angle is defined as the
 *  smaller one! There are no intersection angles > pi/2.
 */
real angle(hyperbolic_line G, hyperbolic_line H) {
    real angle = 0.0;
    if (G.is_invalid() || H.is_invalid()) {
        write("Warning: Intersection angle calculation failed! A line is invalid.");
        return angle;
    }
    if ( !do_intersect(G,H) ) {
        write("Warning: Intersection angle calculation failed! Lines do not intersect.");
        return angle;
    }

    pair u = G.get_first_endpoint();
    pair v = G.get_second_endpoint();
    pair s = H.get_first_endpoint();
    pair t = H.get_second_endpoint();

    real a = dot((u-v),(s-t))+dot(u,t)*dot(v,s)-dot(u,s)*dot(v,t);
    real b = (1-dot(u,v))^2;
    real c = (1-dot(s,t))^2;
    angle = acos(sqrt(a^2/(b*c)));
    return angle;
}

/** This structure represents a hyperbolic finite line segment.
 *  A segment can be a straight line or an arc with a finite center/radius.
 *  It's basically a wrapper for the line, with two additinal Points.
 */
struct hyperbolic_segment {
    // The hyperbolic line the segment is part of.
    private hyperbolic_line L;
    // The hyperbolic endpoints of the segment. These are real hyperbolic points.
    private hyperbolic_point P1;
    private hyperbolic_point P2;
    // If a segment can not be constructed, this is set to true.
    private bool is_invalid;

    // New segments are invalid by default
    void operator init() {
        is_invalid = true;
    }

    // Configure the segment from given data
    void configure(hyperbolic_line line, hyperbolic_point P, hyperbolic_point Q) {
        L = line;
        P1 = P;
        P2 = Q;
        is_invalid = false;
    }

    hyperbolic_point get_first_point() { return P1; }
    hyperbolic_point get_second_point() { return P2; }
    hyperbolic_line get_line() { return L; }
    bool is_invalid() { return is_invalid; }
    void set_invalid() { is_invalid = true; }

    real length() { return hyperbolic_distance(P1, P2); }

    path to_path() {
        if ( L.is_diameter() ) {
            return P1.get_euclidean()--P2.get_euclidean();
        } else {
            // Some math to assure, we get the "shorter", inner arc.
            // If the points are a right-handed system, the arc has to be ccw.
            bool direction = right_handed(L.get_center()-P1.get_euclidean(), P2.get_euclidean()-L.get_center()) ? false : true;
            return Arc(L.get_center(), P1.get_euclidean(), P2.get_euclidean(), direction);
        }
    }
}

/** Construct a hyperbolic segment from two given hyperbolic points
 */
hyperbolic_segment hyperbolic_segment(hyperbolic_point P, hyperbolic_point Q) {
    hyperbolic_segment S = hyperbolic_segment();
    if ( P.is_invalid() || Q.is_invalid() ) {
        write("Warning: Segment creation failed. A point is invalid.");
        return S;
    }
    if ( is_same_point(P,Q) ) {
        write("Warning: Segment creation failed. Points are identical.");
        return S;
    }

    hyperbolic_line L = hyperbolic_line(P, Q);
    if ( L.is_invalid() ) {
        write("Warning: Segment creation failed. Could not construct line.");
        return S;
    }

    S.configure(L, P, Q);
    return S;
}

/** Test if two given hyperbolic segments should be considered identical.
 */
bool is_same_segment(hyperbolic_segment S, hyperbolic_segment T) {
    if ( S.is_invalid() || T.is_invalid() ) {
        write("Warning: is_same_segment(...) failed. A segment is invalid.");
        return false;
    }
    hyperbolic_point S1 = S.get_first_point();
    hyperbolic_point S2 = S.get_second_point();
    hyperbolic_point T1 = T.get_first_point();
    hyperbolic_point T2 = T.get_second_point();
    // Check if the endpoints are identical.
    return ( is_same_point(S1,T1) && is_same_point(S2,T2) ) ||
           ( is_same_point(S1,T2) && is_same_point(S2,T1) );
}

/** Test if a given hyperbolic point is part of a given hyperbolic segment.
 */
bool is_on_segment(hyperbolic_segment S, hyperbolic_point P) {
    if ( S.is_invalid() || P.is_invalid() ) {
        write("Warning: is_on_segment(...) failed. The segment and/or the point is invalid.");
        return false;
    }
    // We add an epsilon to the following inequalities, but its questionable.
    // Do we rather like to give false positives or false negatives?
    // Currently, the code tries to ensure that segments which share an
    // endpoint do intersect in this point.
    return is_on_line(S.get_line(), P) && ( hyperbolic_distance(S.get_first_point(), P) <= S.length() + epsilon &&
                                            hyperbolic_distance(S.get_second_point(), P) <= S.length() + epsilon );
}

/** This structure represents a hyperbolic semifinit ray.
 *  A ray can be a straight line or an arc with a finite center/radius.
 *  It's basically a wrapper for the line, with one additinal Point
 *  and an endpoint (ideal point). The ray is given by two hyperbolic
 *  points P and Q. The ray starts at point P and follows the hyperbolic
 *  line PQ into the direction of Q, goes through Q and continues infinitely.
 */
struct hyperbolic_ray {
    // The hyperbolic line the ray is part of
    private hyperbolic_line L;
    // The hyperbolic point at which the ray starts
    private hyperbolic_point P;
    // The ideal point at which the ray ends
    private pair endpoint;
    // If a ray can not be constructed, this is set to true.
    private bool is_invalid;

    // New rays are invalid by default
    void operator init() {
        is_invalid = true;
    }

    // Configure a ray from given data
    void configure(hyperbolic_line line, hyperbolic_point X, pair e) {
        L = line;
        P = X;
        endpoint = e;
        is_invalid = false;
    }

    hyperbolic_point get_point() { return P; }
    hyperbolic_line get_line() { return L; }
    pair get_endpoint() { return endpoint; }
    bool is_invalid() { return is_invalid; }
    void set_invalid() { is_invalid = true; }

    path to_path() {
        if ( L.is_diameter() ) {
            // It's a straight line
            return P.get_euclidean()--endpoint;
        } else {
            // Some math to assure, we get the "shorter", inner arc.
            // If the points are a right-handed system, the arc has to be ccw.
            bool direction = right_handed(L.get_center()-P.get_euclidean(), endpoint-L.get_center()) ? false : true;
            return Arc(L.get_center(), P.get_euclidean(), endpoint, direction);
        }
    }
}

/** Construct a hyperbolic ray from two points. The first is the starting point
 *  and the second given the direction.
 */
hyperbolic_ray hyperbolic_ray(hyperbolic_point P, hyperbolic_point Q) {
    hyperbolic_ray R = hyperbolic_ray();
    if ( P.is_invalid() || Q.is_invalid() ) {
        write("Warning: Ray creation failed. A point is invalid.");
        return R;
    }
    if ( is_same_point(P,Q) ) {
        write("Warning: ray creation failed. Points are identical.");
        return R;
    }

    hyperbolic_line L = hyperbolic_line(P, Q);
    if ( L.is_invalid() ) {
        write("Warning: Ray creation failed. Could not construct line.");
        return R;
    }
    pair e;
    pair p = P.get_euclidean();
    pair q = Q.get_euclidean();

    // Now find the right ideal point
    if ( L.is_diameter() ) {
        e = unit(q-p);
    } else {
        pair c = L.get_center();
        if ( right_handed(p-c, q-p) == right_handed(q-c, L.get_first_endpoint()-q) ) {
            e = L.get_first_endpoint();
        } else {
            e = L.get_second_endpoint();
        }
    }
    R.configure(L, P, e);
    return R;
}

/** Test if two given rays should be considered identical.
 */
bool is_same_ray(hyperbolic_ray R, hyperbolic_ray S) {
    if ( R.is_invalid() || S.is_invalid() ) {
        write("Warning: is_same_ray(...) failed. A ray is invalid.");
        return false;
    }
    hyperbolic_point PR = R.get_point();
    hyperbolic_point PS = S.get_point();
    pair er = R.get_endpoint();
    pair es = S.get_endpoint();

    // Check if the hyperbolic startingpoint and the ideal endpoint are identical.
    return ( is_same_point(PR,PS) && is_same_pair(er,es) );
}

/** Test if a given point is part of a given ray.
 */
bool is_on_ray(hyperbolic_ray R, hyperbolic_point P) {
    if ( R.is_invalid() || P.is_invalid() ) {
        write("Warning: is_on_ray(...) failed. The ray and/or the point is invalid.");
        return false;
    }
    // We add an epsilon to the following inequalities, but its questionable.
    // Do we rather like to give false positives or false negatives?
    // Currently, the code tries to ensure that rays which share a
    // startpoint do intersect in this point.
    hyperbolic_line L = R.get_line();

    pair s = R.get_point().get_euclidean();
    pair e = R.get_endpoint();
    pair p = P.get_euclidean();

    if ( !L.is_diameter() ) {
        return ( is_on_line(R.get_line(), P) && ( right_handed(origin,s,e) == right_handed(origin,s,p) ||
                                                  is_same_point(R.get_point(),P) ) );
    } else {
        return ( is_on_line(R.get_line(), P) && (length(p-s) <= length(s-e) +epsilon &&
                                                 length(p-e) <= length(s-e) + epsilon ));
    }
}

/** This struct represents a hyperbolic circle.
 */
struct hyperbolic_circle {
    // Data about the euclidean circle that represents this hyperbolic circle.
    private real radius;
    private pair center;
    // The hyperbolic center point if known
    hyperbolic_point C;
    // The hyperbolic radius
    real rho;
    // If a circle can not be constructed, this is set to true.
    private bool is_invalid;

    // New circles are invalid by default
    void operator init() {
        is_invalid = true;
        C = hyperbolic_point();
        rho = 0.0;
    }

    // Configure a circle from given data
    // The circle is semi-invalid, as it does not have the information
    // about its hyperbolic center and radius !!
    void configure(pair c, real r) {
        center = c;
        radius = r;
        is_invalid = false;
    }

    // Configure a circle from given data
    void configure(pair c, real r, hyperbolic_point cen, real hypr) {
        center = c;
        radius = r;
        C = cen;
        rho = hypr;
        is_invalid = false;
    }

    pair get_center() { return center; }
    real get_radius() { return radius; }
    bool centerpoint_known() { return C.is_invalid(); }
    hyperbolic_point get_centerpoint() { return C; }
    bool is_invalid() { return is_invalid; }
    void set_invalid() { is_invalid = true; }
    real radius() { return rho; }
    real circumference() { return 2*pi*sinh(rho); }
    real area() { return 4*pi*sinh(rho/2)^2; }

    path to_path() {
        return Circle(center, radius);
    }
}

/** Construct a hyperbolic circle with given center an a point on the peripherie.
 */
hyperbolic_circle hyperbolic_circle(hyperbolic_point C, hyperbolic_point P) {
    hyperbolic_circle circle = hyperbolic_circle();
    if ( C.is_invalid() || P.is_invalid() ) {
        write("Warning: construction of hyperbolic circle failed! A point is invalid.");
        return circle;
    }
    if ( is_same_point(C,P) ) {
        write("Warning: construction of hyperbolic circle failed! Given points are to near to each other.");
        return circle;
    }

    // the hyperbolic radius
    real hyprad = hyperbolic_distance(C,P);

    pair c = C.get_euclidean();
    pair p = P.get_euclidean();
    if ( !are_collinear(origin, c, p) ) {
        // This is the general case. We use the common construction here.
        // This formula may be numericaly unstable for circles where
        // the euclidean circle representing line l is really big.
        hyperbolic_line l = hyperbolic_line(C,P);
        pair u = l.get_center();

        real lambda = (p.x*u.x+p.y*u.y-p.x^2-p.y^2) / (c.x*u.x+c.y*u.y-c.x*p.x-c.y*p.y);
        pair center = lambda * c;
        real radius = length(p-center);

        circle.configure(center, radius, C, hyprad);
    } else {
        write("Info: Circle calculation: given center, given point and origin are collinear.");
        // Not really a reason to worry, but this branch is not proofed to be correct.
        hyperbolic_point O = hyperbolic_point(0,0);

        if ( !is_same_point(O, C) ) {
            // Even if p is identical to either npo or npi, we recalculate it to avoid nasty chirality problems.
            real rhoo = hyperbolic_distance(O,C) + hyperbolic_distance(C,P);
            real rhoi = hyperbolic_distance(O,C) - hyperbolic_distance(C,P);
            real ro = (exp(rhoo)-1) / (exp(rhoo)+1);
            real ri = (exp(rhoi)-1) / (exp(rhoi)+1);
            pair npo = ro * unit(c);
            pair npi = ri * unit(c);

            pair center = (npo + npi) / 2;
            real radius = length(center - p);

            circle.configure(center, radius, C, hyprad);
        } else {
            // Circle with origin as center. This is an easy case
            // We need to separate this from above because scaling
            // the zero-vector does make any sense ...
            real radius = length(p);

            circle.configure(origin, radius, C, hyprad);
        }
    }
    return circle;
}

/** Test if a given point is part of a given circle.
 */
bool is_on_circle(hyperbolic_circle C, hyperbolic_point P) {
    if ( C.is_invalid() || P.is_invalid() ) {
        write("Warning: is_on_circle(...) failed. The circle and/or the point is invalid.");
        return false;
    }
    return abs(length(C.get_center()-P.get_euclidean()) - C.get_radius()) <= epsilon;
}

/** Test if a given point lies inside of a given circle.
 */
bool is_inside_circle(hyperbolic_circle C, hyperbolic_point P) {
    if ( C.is_invalid() || P.is_invalid() ) {
        write("Warning: is_inside_circle(...) failed. The circle and/or the point is invalid.");
        return false;
    }
    return length(C.get_center()-P.get_euclidean()) <= C.get_radius() + epsilon;
}

/** Test if two given circles are tangent.
 */
bool are_tangent(hyperbolic_circle C, hyperbolic_circle D) {
    if ( C.is_invalid() || D.is_invalid() ) {
        write("Warning: are_tangent(...) failed. A circle is invalid.");
        return false;
    }
    // The condition formulated in hyperbolic geometry:
    // hyperbolic_distance(C.get_centerpoint(), D.get_centerpoint()) - (C.radius() + D.radius()) < epsilon
    // But we can use the euclidian properties as well
    return abs(length(C.get_center() - D.get_center()) - (C.get_radius() + D.get_radius())) < epsilon;
}

/** Structure that represents a hyperbolic triangle.
 *  A triangle is defined by three hyperbolic points and
 *  every side is part of a hyperbolic line.
 */
struct hyperbolic_triangle {
    // The three hyperbolic corners points
    private hyperbolic_point A;
    private hyperbolic_point B;
    private hyperbolic_point C;
    // The three hyperbolic sides
    private hyperbolic_segment AB;
    private hyperbolic_segment BC;
    private hyperbolic_segment CA;
    // If a triangle can not be constructed, this is set to true.
    private bool is_invalid;

    // New triangles are invalid by default
    void operator init() {
        is_invalid = true;
    }

    // Configure a triangle from given data and assure all sides are valid.
    void configure(hyperbolic_point P1, hyperbolic_point P2, hyperbolic_point P3) {
        A = P1;
        B = P2;
        C = P3;
        AB = hyperbolic_segment(A,B);
        BC = hyperbolic_segment(B,C);
        CA = hyperbolic_segment(C,A);
        is_invalid = false;
        if ( AB.is_invalid() || BC.is_invalid() || CA.is_invalid() ) {
            write("Warning: Triangle construction failed. A side could not be constructed.");
            // Reason may be that all points are valid, but two are identical.
            is_invalid = true;
        }
    }

    bool is_invalid() { return is_invalid; }
    void set_invalid() { is_invalid = true; }
    hyperbolic_point A() { return A; }
    hyperbolic_point B() { return B; }
    hyperbolic_point C() { return C; }
    hyperbolic_segment AB() { return AB; }
    hyperbolic_segment BC() { return BC; }
    hyperbolic_segment CA() { return CA; }
    real a() { return BC.length(); }
    real b() { return CA.length(); }
    real c() { return AB.length(); }
    real alpha() { return angle(B,A,C); }
    real beta() { return angle(A,B,C); }
    real gamma() { return angle(B,C,A); }
    real area() { return pi - angle(B,A,C) - angle(A,B,C) - angle(B,C,A); }

    path to_path() { return AB.to_path()--BC.to_path()--CA.to_path()--cycle; }
}

/** Construct a hyperbolic triangle from three given hyperbolic points.
 */
hyperbolic_triangle hyperbolic_triangle(hyperbolic_point P1, hyperbolic_point P2, hyperbolic_point P3) {
    hyperbolic_triangle T = hyperbolic_triangle();
    if ( P1.is_invalid() || P2.is_invalid() || P3.is_invalid() ) {
        write("Warning: Triangle construction failed. A point is invalid.");
        return T;
    }
    T.configure(P1, P2, P3);
    return T;
}

/** This struct is for hyperbolic polygons. Hyperbolic polygons may
 *  contain arbitrary many corners.
 */
struct hyperbolic_polygon {
    // The points of the corners
    private hyperbolic_point[] corners;
    // The sides
    private hyperbolic_segment[] sides;
    // How many corners do we have
    private int num_corners;
    // If a polygon can not be constructed, this is set to true.
    private bool is_invalid;

    // New polygons are invalid by default
    void operator init() {
        is_invalid = true;
    }

    // Configure hyperbolic triangle from given data.
    void configure(hyperbolic_point[] Points) {
        // Assign the corners
        corners = Points;
        // And how many they are
        num_corners = Points.length;
        is_invalid = false;
        // Construct the sides as hyperbolic segments
        for (int i = 0; i < num_corners; ++i) {
            sides[i] = hyperbolic_segment(Points[i%Points.length], Points[(i+1)%Points.length]);
            if ( sides[i].is_invalid() ) {
                write("Warning: Polygon construction failed. A side could not be constructed.");
                // Reason may be that all points are valid, but two are identical.
                is_invalid = true;
                // We finish this loop anyway in case the user
                // wants deep access to the polygons data.
            }
        }
    }

    int get_num_corners() { return num_corners; }
    hyperbolic_point[] get_corners() { return corners; }
    hyperbolic_segment[] get_sides() { return sides; }
    bool is_invalid() { return is_invalid; }
    void set_invalid() { is_invalid = true; }

    path to_path() {
        path p;
        for (int i = 0; i < num_corners; ++i) {
            p = p--sides[i].to_path();
        }
        return p--cycle;
    }
}

/** Construct a hyperbolic polygon from an array of hyperbolic points.
 */
hyperbolic_polygon hyperbolic_polygon(hyperbolic_point[] Points) {
    hyperbolic_polygon P = hyperbolic_polygon();
    for (int i = 0; i < Points.length; ++i) {
        if ( Points[i].is_invalid() ) {
            write("Warning: Polygon construction failed. A point is invalid.");
            return P;
        }
    }
    P.configure(Points);
    return P;
}

/** Construct a hyperbolic polygon from a hyperbolic triangle.
 */
hyperbolic_polygon hyperbolic_polygon(hyperbolic_triangle triangle) {
    if ( triangle.is_invalid() ) {
        write("Warning: Hyperbolic triangle is invalid.");
        return hyperbolic_polygon();
    }
    hyperbolic_point[] P;
    P[0] = triangle.A();
    P[1] = triangle.B();
    P[2] = triangle.C();
    return hyperbolic_polygon(P);
}

// =============================================================================
// Intersection calculation routines
// =============================================================================

/** Calculate the intersection point of two hyperbolic lines.
 *  We have 4 different cases of which 3 require different
 *  calculations.
 */
hyperbolic_point intersection(hyperbolic_line K, hyperbolic_line L) {
    hyperbolic_point IP = hyperbolic_point();
    if (K.is_invalid() || L.is_invalid()) {
        write("Warning: Intersection calculation failed! A line is invalid.");
        return IP;
    }
    // Assure we are going to intersect different lines
    if ( is_same_line(K,L) ) {
        // This warning is also given when we try to intersect two segments or rays
        // which are part of the same line.
        write("Warning: Intersection calculation failed! Lines are identical.");
        return IP;
    }
    // Assure the lines really intersect!
    if ( !do_intersect(K,L) ) {
        write("Info: Intersection calculation failed! Lines do not intersect.");
        return IP;
    }
    if ( K.is_diameter() && L.is_diameter() ) {
        // Both lines are diameter, so the intersectionpoint
        // can only be the origin
        IP.configure(origin);
    } else if ( K.is_diameter() && !L.is_diameter() ) {
        pair r = unit(K.get_second_endpoint()-K.get_first_endpoint());
        pair c = L.get_center();
        real t = (r.x*c.x+r.y*c.y);
        pair l = t*unit(r);
        real s = L.get_radius()^2-length(l-c)^2;
        // if s < 0 there is no intersection point.
        // can not happen, because we assured the lines intersect.
        pair i = unit(l)*(length(l)-sqrt(s));
        IP.configure(i);
    } else if ( !K.is_diameter() && L.is_diameter() ) {
        pair r = unit(L.get_second_endpoint()-L.get_first_endpoint());
        pair c = K.get_center();
        real t = (r.x*c.x+r.y*c.y);
        pair l = t*unit(r);
        real s = K.get_radius()^2-length(l-c)^2;
        // if s < 0 there is no intersection point.
        // can not happen, because we assured the lines intersect.
        pair i = unit(l)*(length(l)-sqrt(s));
        IP.configure(i);
    } else {
        // !K.is_diameter() && !L.is_diameter()
        real ru = K.get_radius();
        real rv = L.get_radius();
        pair dv = L.get_center() - K.get_center();
        real d = length(dv);
        real qu = (ru^2+d^2-rv^2)/(2*d);
        // if ru^2-qu^2 < 0 there is no intersection point.
        // can not happen, because we assured the lines intersect.
        pair vv = K.get_center() + qu*unit(dv);
        pair i = vv - sqrt(ru^2-qu^2)*unit(vv);
        IP.configure(i);
    }
    return IP;
}

/** Find the intersection of two hyperbolic segments.
 */
hyperbolic_point intersection(hyperbolic_segment S, hyperbolic_segment T) {
    hyperbolic_point IP = hyperbolic_point();
    if (S.is_invalid() || T.is_invalid()) {
        write("Warning: Intersection calculation failed! A segemnt is invalid.");
        return IP;
    }
    // Assure we are going to intersect different segments
    if ( is_same_segment(S,T) ) {
        write("Warning: Intersection calculation failed! Segments are considered identical.");
        return IP;
    }
    // Intersect
    IP = intersection(S.get_line(), T.get_line());
    // Check if the intersection point belongs to both segments,
    // only then its really an intersection point.
    if ( !is_on_segment(S,IP) || !is_on_segment(T,IP) ) {
        IP.set_invalid();
    }
    return IP;
}

/** Find the intersection of a hyperbolic segment and a hyperbolic line.
 */
hyperbolic_point intersection(hyperbolic_line L, hyperbolic_segment S) {
    hyperbolic_point IP = hyperbolic_point();
    if (L.is_invalid() || S.is_invalid()) {
        write("Warning: Intersection calculation failed! The segment and/or the line is invalid.");
        return IP;
    }
    // Intersect
    IP = intersection(L, S.get_line());
    // Check if the intersection point belongs to the segment,
    // only then its really an intersection.
    if ( !is_on_segment(S,IP) ) {
        IP.set_invalid();
    }
    return IP;
}

// And the other way round:
hyperbolic_point intersection(hyperbolic_segment S, hyperbolic_line L) {
    return intersection(L,S);
}

/** Find the intersection of two hyperbolic rays.
 */
hyperbolic_point intersection(hyperbolic_ray R, hyperbolic_ray S) {
    hyperbolic_point IP = hyperbolic_point();
    if (R.is_invalid() || S.is_invalid()) {
        write("Warning: Intersection calculation failed! A ray is invalid.");
        return IP;
    }
    // Assure we are going to intersect different rays
    if ( is_same_ray(R,S) ) {
        write("Warning: Intersection calculation failed! Rays are considered identical.");
        return IP;
    }
    // Intersect
    IP = intersection(R.get_line(), S.get_line());
    // Check if the intersection point belongs to both rays,
    // only then its really an intersection point.
    if ( !is_on_ray(R,IP) || !is_on_ray(S,IP) ) {
        IP.set_invalid();
    }
    return IP;
}

/** Find the intersection of a hyperbolic ray with a hyperbolic line.
 */
hyperbolic_point intersection(hyperbolic_ray R, hyperbolic_line L) {
    hyperbolic_point IP = hyperbolic_point();
    if (R.is_invalid() || L.is_invalid()) {
        write("Warning: Intersection calculation failed! The ray and/or line is invalid.");
        return IP;
    }
    // Intersect
    IP = intersection(R.get_line(), L);
    // Check if the intersection point belongs to the ray,
    // only then its really an intersection point.
    if ( !is_on_ray(R,IP) ) {
        IP.set_invalid();
    }
    return IP;
}

// And the other way round:
hyperbolic_point intersection(hyperbolic_line L, hyperbolic_ray R) {
    return intersection(R,L);
}

/** Find the intersection of a hyperbolic ray with a hyperbolic line.
 */
hyperbolic_point intersection(hyperbolic_ray R, hyperbolic_segment S) {
    hyperbolic_point IP = hyperbolic_point();
    if (R.is_invalid() || S.is_invalid()) {
        write("Warning: Intersection calculation failed! The ray and/or segment is invalid.");
        return IP;
    }
    // Intersect
    IP = intersection(R.get_line(), S.get_line());
    // Check if the intersection point belongs to both, the ray and the segment.
    // Only then its really an intersection point.
    if ( !is_on_ray(R,IP) || !is_on_segment(S,IP) ) {
        IP.set_invalid();
    }
    return IP;
}

// And the other way round:
hyperbolic_point intersection(hyperbolic_segment S, hyperbolic_ray R) {
    return intersection(R,S);
}

/** Calculate the intersection points of two hyperbolic circles.
 *  The resulting points are sorted as right_handed(C1, C2, I1)
 */
hyperbolic_point[] intersection(hyperbolic_circle C1, hyperbolic_circle C2) {
    hyperbolic_point[] I;
    if ( C1.is_invalid() || C2.is_invalid() ) {
        write("Warning: Intersection calculation failed. A circle is invalid.");
        I[0] = hyperbolic_point();
        I[1] = hyperbolic_point();
        return I;
    }

    pair u1 = C1.get_center();
    real r1 = C1.get_radius();
    pair u2 = C2.get_center();
    real r2 = C2.get_radius();

    if ( are_tangent(C1, C2) ) {
        // Circles are tangent
        write("Info: Intersecting circles are tangent.");
        I[0] = hyperbolic_point(u1+r1*unit(u2-u1));
        I[1] = hyperbolic_point(u2+r2*unit(u1-u2));
    } else if ( (length(u2-u1) > r1+r2) || (length(u2-u1) < abs(r1-r2)) ) {
        // Circles do not intersect, thus there are no intersection points
        write("Info: Circles do not intersect.");
        I[0] = hyperbolic_point();
        I[1] = hyperbolic_point();
    } else {
        // Circles intersect in two points
        real d = length(u2-u1);
        real d1 = (d^2+r1^2-r2^2) / (2*d);
        real d2 = (d^2-r1^2+r2^2) / (2*d);
        pair p = u1 + d1*unit(u2-u1);

        real l = sqrt(-d^4+d^2*(2*r1^2+2*r2^2)-(r1+r2)^2*(r1-r2)^2) / (2*d);
        pair i1 = p + l*unit(((-u2.y,u2.x)-(-u1.y,u1.x)));
        pair i2 = p - l*unit(((-u2.y,u2.x)-(-u1.y,u1.x)));

        // Sorting of the points intersection points in the result
        // I1 stored in I[0] <=> right_handed(C1.center, C2.center, I1) == true
        if ( right_handed(u1,u2,i1) ) {
            I[0] = hyperbolic_point(i1);
            I[1] = hyperbolic_point(i2);
        } else {
            I[1] = hyperbolic_point(i1);
            I[0] = hyperbolic_point(i2);
        }
    }
    return I;
}

/** Calculate the intersection points between a hyperbolic circle
 *  and a hyperbolic line.
 */
hyperbolic_point[] intersection(hyperbolic_circle C, hyperbolic_line L) {
    hyperbolic_point[] I;
    I[0] = hyperbolic_point();
    I[1] = hyperbolic_point();
    if ( C.is_invalid() || L.is_invalid() ) {
        write("Warning: Intersection calculation failed. A circle or a line is invalid.");
        return I;
    }

    pair uc = C.get_center();
    real rc = C.get_radius();
    pair i1;
    pair i2;

    if ( L.is_diameter() ) {
        pair e1 = L.get_first_endpoint();
        pair e2 = L.get_second_endpoint();
        if ( abs(cross_product(e2-e1, uc)) <= 2*rc ) {
            // There are 1 or 2 intersection points

            real lh = (e1.y*uc.y+e1.x*uc.x) / (e1.x^2+e1.y^2);
            pair p = lh * unit(e1);
            real d = length(p-uc);
            real l = sqrt(rc^2-d^2);
            i1 = p + l*unit(e1);
            i2 = p - l*unit(e1);

            // Sorting of the points intersection points in the result
            // I1 stored in I[0] <=> right_handed(C.center, origin, I1) == true
            if ( right_handed(uc,origin,i1) ) {
                I[0] = hyperbolic_point(i1);
                I[1] = hyperbolic_point(i2);
            } else {
                I[1] = hyperbolic_point(i1);
                I[0] = hyperbolic_point(i2);
            }
        } else {
            // There is no intersection point
        }
    } else {
        pair ul = L.get_center();
        real rl = L.get_radius();

        // The line is not a diameter, thus it's a euclidean circle
        // Assure the two euclidean circles do really intersect
        if ( length(uc-ul) > rc+rl || length(uc-ul) < abs(rc-rl) ) {
            // No intersection points
        } else {
            real d = length(ul-uc);
            real d1 = (d^2+rc^2-rl^2) / (2*d);
            pair p = uc + d1*unit(ul-uc);
            real l = sqrt(-d^4+d^2*(2*rc^2+2*rl^2)-(rc+rl)^2*(rc-rl)^2) / (2*d);
            i1 = p + l*unit(((-ul.y,ul.x)-(-uc.y,uc.x)));
            i2 = p - l*unit(((-ul.y,ul.x)-(-uc.y,uc.x)));

            // Sorting of the points intersection points in the result
            // I1 stored in I[0] <=> right_handed(C1.center, C2.center, I1) == true
            if ( right_handed(uc,ul,i1) ) {
                I[0] = hyperbolic_point(i1);
                I[1] = hyperbolic_point(i2);
            } else {
                I[1] = hyperbolic_point(i1);
                I[0] = hyperbolic_point(i2);
            }
        }
    }
    return I;
}

// All argument orderings need to be supported
hyperbolic_point[] intersection(hyperbolic_line L, hyperbolic_circle C) {
    return  intersection(C, L);
}

/** Calculate the intersection points between a hyperbolic circle
 *  and a hyperbolic segment.
 */
hyperbolic_point[] intersection(hyperbolic_circle C, hyperbolic_segment S) {
    hyperbolic_point[] I;
    if ( C.is_invalid() || S.is_invalid() ) {
        write("Warning: Intersection calculation failed. The circle and/or the line is invalid.");
        I[0] = hyperbolic_point();
        I[1] = hyperbolic_point();
        return I;
    }
    // Intersect
    I = intersection(C,S.get_line());
    // Check for both points if the intersection point belongs to the segment.
    // Only then its really an intersection point.
    if ( !is_on_segment(S,I[0]) ) {
        I[0].set_invalid();
    }
    if ( !is_on_segment(S,I[1]) ) {
        I[1].set_invalid();
    }
    return I;
}

// And the other way round
hyperbolic_point[] intersection(hyperbolic_segment S, hyperbolic_circle C) {
    return intersection(C,S);
}

/** Calculate the intersection points between a hyperbolic circle
 *  and a hyperbolic ray.
 */
hyperbolic_point[] intersection(hyperbolic_circle C, hyperbolic_ray R) {
    hyperbolic_point[] I;
    if ( C.is_invalid() || R.is_invalid() ) {
        write("Warning: Intersection calculation failed. The circle and/or the ray is invalid.");
        I[0] = hyperbolic_point();
        I[1] = hyperbolic_point();
        return I;
    }
    // Intersect
    I = intersection(C,R.get_line());
    // Check for both points if the intersection point belongs to the ray.
    // Only then its really an intersection point.
    if ( !is_on_ray(R,I[0]) ) {
        I[0].set_invalid();
    }
    if ( !is_on_ray(R,I[1]) ) {
        I[1].set_invalid();
    }
    return I;
}

// And the other way round
hyperbolic_point[] intersection(hyperbolic_ray R, hyperbolic_circle C) {
    return intersection(C,R);
}

// =============================================================================
// Basic vectorization code
// =============================================================================

hyperbolic_line hyperbolic_line(hyperbolic_point[] P) {
    if (P.length > 2) {
        write("Warning: more than two points given for line construction. Will just use first 2.");
    }
    return hyperbolic_line(P[0], P[1]);
}

// =============================================================================
// Perpendicular calculation routines
// =============================================================================

/** Calculate the hyperbolic perpendicular on a given hyperbolic line and a point on it.
 */
hyperbolic_line hyperbolic_normal(hyperbolic_line L, hyperbolic_point P) {
    hyperbolic_line N = hyperbolic_line();
    if ( L.is_invalid() || P.is_invalid() ) {
        write("Warning: Perpendicular calculation failed! The line and/or point is invalid.");
        return N;
    }

    if ( is_on_line(L, P) ) {
        // P lies on the given line, things are easy
        // Maybe we can delete this legacy code some day and
        // merge the calculation for point in/off line.
        // Currently, this code given better results for points
        // that lie on the given line.
        if ( L.is_diameter() ) {
            write("Info: Normal on line which is a diameter");
            pair d = P.get_euclidean();
            // Take care of origin !!!
            if ( d == (0, 0) ) {
                pair z = (0, 0);
                real r = 0;
                pair e1 = L.get_first_endpoint();
                e1 = (-e1.y, e1.x);
                pair e2 = L.get_second_endpoint();
                e2 = (-e2.y, e2.x);
                N.configure(z, r, e1, e2);
            } else {
                real t = (d.x^2+d.y^2+1) / (2*d.x^2+2*d.y^2);
                pair z = t*d;
                real r = (t-1)*length(d);
                // And now the endpoints again.
                real h = r / length(z);
                real q = sqrt(1-h^2); // critical root
                pair hv = (z.y, -z.x);
                pair e1 = q*unit(z) + h*unit(hv);
                pair e2 = q*unit(z) + -h*unit(hv);
                N.configure(z, r, e1, e2);
            }
        } else {
            // Normal
            pair c = L.get_center();
            pair p = P.get_euclidean();
            pair d = (-(c.y-p.y)*(c.x*p.y-c.y*p.x), (c.x-p.x)*(c.x*p.y-c.y*p.x));
            real t = (-p.x^2-p.y^2+1) / (2*d.x*p.x+2*d.y*p.y);
            pair z = p + t*d;
            real r = t*length(d);
            // And now the endpoints again.
            real h = r / length(z);
            real q = sqrt(1-h^2); // critical root
            pair hv = (z.y, -z.x);
            pair e1 = q*unit(z) + h*unit(hv);
            pair e2 = q*unit(z) + -h*unit(hv);
            N.configure(z, r, e1, e2);
        }
    } else {
        // P lies not on the given line, things get more complicated
        pair p = P.get_euclidean();
        if ( L.is_diameter() ) {
            write("Info: Normal on line which is a diameter");
            pair e1 = L.get_first_endpoint();
            pair e2 = L.get_second_endpoint();
            pair dir = e2-e1;
            // Kind of scalarproduct. If it is zero, the resulting
            // perpendicular is also a diameter.
            real t = p.x*dir.x+p.y*dir.y;
            if ( abs(t) <= epsilon ) {
                N.configure(unit(p), -unit(p));
            } else {
                real l = (p.x^2+p.y^2+1) / (2*t);
                pair c = l*dir;
                real r = sqrt(c.x^2+c.y^2-1);
                N.configure(c, r);
            }
        } else {
            pair cl = L.get_center();
            real rl = L.get_radius();
            if( are_collinear(origin, p, cl) ) {
                // If the origin, the point and the euclidic center of the given line
                // are colliners, then the resulting perpendicular is a diameter
                pair dir = cl + p;
                N.configure(unit(dir), -unit(dir));
            } else {
                real t = 2*(p.y*cl.x-p.x*cl.y);
                real u = (p.y-p.y*rl^2+p.y*cl.x^2-cl.y-p.x^2*cl.y-p.y^2*cl.y+p.y*cl.y^2) / t;
                real v = (-p.x+p.x*rl^2+cl.x+p.x^2*cl.x+p.y^2*cl.x-p.x*cl.x^2-p.x*cl.y^2) / t;
                pair c = (u, v);
                real r = sqrt(c.x^2+c.y^2-1);
                N.configure(c, r);
            }
        }
    }
    return N;
}

/** Calculate the hyperbolic perpendicular on a given hyperbolic line and a point on it.
 */
hyperbolic_line hyperbolic_normal(hyperbolic_segment S, hyperbolic_point P) {
    if ( S.is_invalid() || P.is_invalid() ) {
        write("Warning: Perpendicular calculation failed! The segment and/or point is invalid.");
        return hyperbolic_line();
    }
    hyperbolic_line N = hyperbolic_normal(S.get_line(), P);
    // Assure the perpendicular does not miss the segment
    if ( is_on_segment(S, intersection(S.get_line(), N)) ) {
        return N;
    }
    return hyperbolic_line();
}

/** Calculate the hyperbolic perpendicular on a given hyperbolic line and a point on it.
 */
hyperbolic_line hyperbolic_normal(hyperbolic_ray R, hyperbolic_point P) {
    if ( R.is_invalid() || P.is_invalid() ) {
        write("Warning: Perpendicular calculation failed! The ray and/or point is invalid.");
        return hyperbolic_line();
    }
    hyperbolic_line N = hyperbolic_normal(R.get_line(), P);
    // Assure the perpendicular does not miss the ray
    if ( is_on_ray(R, intersection(R.get_line(), N)) ) {
        return N;
    }
    return hyperbolic_line();
}

/** Calculate the basepoint of a point and a hyperbolic line.
 *  The point is defined as the intersection point of the
 *  perpendicular from the given point to the line.
 */
hyperbolic_point basepoint(hyperbolic_line L, hyperbolic_point P) {
    if( L.is_invalid() || P.is_invalid() ) {
        write("Warning: basepoint calculation failed! The line is invalid.");
        return hyperbolic_point();
    }
    // TODO: Use the better mathematical calculation method
    hyperbolic_line N = hyperbolic_normal(L, P);
    return intersection(L, N);
}

/** Calculate the basepoint of a point and a hyperbolic segment.
 *  The point is defined as the intersection point of the
 *  perpendicular from the given point to the segment.
 */
hyperbolic_point basepoint(hyperbolic_segment S, hyperbolic_point P) {
    if( S.is_invalid() || P.is_invalid() ) {
        write("Warning: basepoint calculation failed! The segment is invalid.");
        return hyperbolic_point();
    }
    hyperbolic_point B = basepoint(S.get_line(), P);
    // Assure the point is part of the segment
    if ( is_on_segment(S,B) ) {
        return B;
    }
    return hyperbolic_point();
}

/** Calculate the basepoint of a point and a hyperbolic ray.
 *  The point is defined as the intersection point of the
 *  perpendicular from the given point to the ray.
 */
hyperbolic_point basepoint(hyperbolic_ray R, hyperbolic_point P) {
    if( R.is_invalid() || P.is_invalid() ) {
        write("Warning: basepoint calculation failed! The ray is invalid.");
        return hyperbolic_point();
    }
    hyperbolic_point B = basepoint(R.get_line(), P);
    // Assure the point is part of the ray
    if ( is_on_ray(R,B) ) {
        return B;
    }
    return hyperbolic_point();
}

/** Calculate the hyperbolic perpendicular common to two hyperbolic lines.
 *  The two lines are not allowed to intersect, otherwise there is no solution.
 */
hyperbolic_line common_perpendicular(hyperbolic_line G, hyperbolic_line H) {
    hyperbolic_line N = hyperbolic_line();
    if (G.is_invalid() || H.is_invalid()) {
        write("Warning: Common perpendicular calculation failed! A line is invalid.");
        return N;
    }
    if ( do_intersect(G, H) ) {
        // G and H do intersect!
        // No common perpendicular possible
        // proof: lines are not parallel!
        // This catches also the cases:
        // - where G and H are already orthogonal
        // - where both lines are diameters
        write("Warning: There is no common perpendicular because the two lines do intersect!");
        return N;
    }
    bool gid = G.is_diameter();
    bool hid = H.is_diameter();
    if( gid && !hid ) {
        // One of the two lines is a diameter
        pair d = G.get_second_endpoint() - G.get_first_endpoint();
        pair ch = H.get_center();
        real rh = H.get_radius();
        real t = (ch.x^2+ch.y^2-rh^2+1) / (2*(d.x*ch.x+d.y*ch.y));
        pair c = d*t;
        real r = sqrt(c.x^2+c.y^2-1);
        N.configure(c, r);
    } else if( !gid && hid ) {
        // One of the two lines is a diameter
        pair d = H.get_second_endpoint() - H.get_first_endpoint();
        pair cg = G.get_center();
        real rg = G.get_radius();
        real t = (cg.x^2+cg.y^2-rg^2+1) / (2*(d.x*cg.x+d.y*cg.y));
        pair c = d*t;
        real r = sqrt(c.x^2+c.y^2-1);
        N.configure(c, r);
    } else if( !gid && !hid ) {
        // None of the two lines is a diameter
        pair gc = G.get_center();
        pair hc = H.get_center();
        real gr = G.get_radius();
        real hr = H.get_radius();
        if ( are_collinear(origin, gc, hc) ) {
            // hc.x*gc.y-gc.x*hc.y < 0 => O, gc, hc are collinear!
            pair dir = gc+hc;
            pair e1 = unit(dir);
            pair e2 = -e1;
            N.configure(e1, e2);
        } else {
            // A common subexpression:
            real t = 2*(hc.x*gc.y-gc.x*hc.y);
            real u = (gc.y-hr^2*gc.y+hc.x^2*gc.y-hc.y+gr^2*hc.y-gc.x^2*hc.y-gc.y^2*hc.y+gc.y*hc.y^2) / t;
            real v = (-gc.x+hr^2*gc.x+hc.x-gr^2*hc.x+gc.x^2*hc.x-gc.x*hc.x^2+hc.x*gc.y^2-gc.x*hc.y^2) / t;
            pair c = (u, v);
            real r = sqrt(v^2+u^2-1);
            N.configure(c, r);
        }
    }
    return N;
}

/** Calculate the hyperbolic perpendicular common to two hyperbolic segments.
 *  The two lines the segments are part of are not allowed to intersect, otherwise
 *  there is no solution.
 */
hyperbolic_line common_perpendicular(hyperbolic_segment S, hyperbolic_segment T) {
    hyperbolic_line L = hyperbolic_line();
    if (S.is_invalid() || T.is_invalid()) {
        write("Warning: Common perpendicular calculation failed! A segment is invalid.");
        return L;
    }
    if ( is_same_segment(S,T) ) {
        write("Warning: Common perpendicular calculation failed! Segments are identical.");
        return L;
    }
    hyperbolic_line L = common_perpendicular(S.get_line(), T.get_line());

    // Check for both points if they belong to the segment.
    if ( intersection(S, L).is_invalid() || intersection(T, L).is_invalid() ) {
        write("Warning: Common perpendicular calculation failed! No common basepoints possible.");
        return hyperbolic_line();
    }
    return L;
}

/** Calculate the hyperbolic perpendicular common to two hyperbolic rays.
 *  The two lines the rays are part of are not allowed to intersect, otherwise
 *  there is no solution.
 */
hyperbolic_line common_perpendicular(hyperbolic_ray R, hyperbolic_ray S) {
    hyperbolic_line L = hyperbolic_line();
    if (R.is_invalid() || S.is_invalid()) {
        write("Warning: Common perpendicular calculation failed! A ray is invalid.");
        return L;
    }
    if ( is_same_ray(R,S) ) {
        write("Warning: Common perpendicular calculation failed! Rays are identical.");
        return L;
    }
    hyperbolic_line L = common_perpendicular(R.get_line(), S.get_line());
    // Check for both points if they belong to the ray.
    if ( intersection(R, L).is_invalid() || intersection(S, L).is_invalid() ) {
        write("Warning: Common perpendicular calculation failed! No common basepoints possible.");
        return hyperbolic_line();
    }
    return L;
}

/** Calculate the hyperbolic perpendicular common to a hyperbolic segment and a hyperbolic ray.
 *  The two lines the objects are part of are not allowed to intersect, otherwise
 *  there is no solution.
 */
hyperbolic_line common_perpendicular(hyperbolic_ray R, hyperbolic_segment S) {
    hyperbolic_line L = hyperbolic_line();
    if (R.is_invalid() || S.is_invalid()) {
        write("Warning: Common perpendicular calculation failed! The ray and/or segment is invalid.");
        return L;
    }
    // Test if segment is part of ray is not done
    // The common_perpendicular will throw an error anyway.

    hyperbolic_line L = common_perpendicular(R.get_line(), S.get_line());
    // Check for both points if they belong to the ray.
    if ( intersection(R, L).is_invalid() || intersection(S, L).is_invalid() ) {
        write("Warning: Common perpendicular calculation failed! No common basepoints possible.");
        return hyperbolic_line();
    }
    return L;
}

// And the other way round:
hyperbolic_line common_perpendicular(hyperbolic_segment S, hyperbolic_ray R) {
    return common_perpendicular(S, R);
}

/** Calculate the common basepoints of two hyperbolic lines.
 *  These are the points where the common perpendicular intersects
 *  the two given lines.
 */
hyperbolic_point[] common_basepoints(hyperbolic_line G, hyperbolic_line H) {
    hyperbolic_point[] P;
    P[0] = hyperbolic_point();
    P[1] = hyperbolic_point();
    if (G.is_invalid() || H.is_invalid()) {
        write("Warning: Common basepoints calculation failed! A line is invalid.");
        return P;
    }
    if ( is_same_line(G,H) ) {
        write("Warning: Common basepoints calculation failed! Lines are identical.");
        return P;
    }
    hyperbolic_line L = common_perpendicular(G, H);
    P[0] = intersection(G, L);
    P[1] = intersection(H, L);
    return P;
}

/** Calculate the common basepoints of two hyperbolic segments.
 *  These are the points where the common perpendicular intersects
 *  the two given segments.
 */
hyperbolic_point[] common_basepoints(hyperbolic_segment S, hyperbolic_segment T) {
    hyperbolic_point[] P;
    P[0] = hyperbolic_point();
    P[1] = hyperbolic_point();
    if (S.is_invalid() || T.is_invalid()) {
        write("Warning: Common basepoints calculation failed! A segment is invalid.");
        return P;
    }
    if ( is_same_segment(S,T) ) {
        write("Warning: Common basepoints calculation failed! Segments are identical.");
        return P;
    }
    hyperbolic_line L = common_perpendicular(S.get_line(), T.get_line());
    P[0] = intersection(S, L);
    P[1] = intersection(T, L);

    // Check for both points if they belong to the segment.
    if ( !is_on_segment(S,P[0]) || !is_on_segment(S,P[1]) ) {
        write("Warning: Common basepoints calculation failed! No common basepoints possible.");
        P[0].set_invalid();
        P[1].set_invalid();
    }
    return P;
}

/** Calculate the common basepoints of two hyperbolic rays.
 *  These are the points where the common perpendicular intersects
 *  the two given rays.
 */
hyperbolic_point[] common_basepoints(hyperbolic_ray R, hyperbolic_ray S) {
    hyperbolic_point[] P;
    P[0] = hyperbolic_point();
    P[1] = hyperbolic_point();
    if (R.is_invalid() || S.is_invalid()) {
        write("Warning: Common basepoints calculation failed! A ray is invalid.");
        return P;
    }
    if ( is_same_ray(R,S) ) {
        write("Warning: Common basepoints calculation failed! Rays are identical.");
        return P;
    }
    hyperbolic_line L = common_perpendicular(R.get_line(), S.get_line());
    P[0] = intersection(R, L);
    P[1] = intersection(S, L);

    // Check for both points if they belong to the ray.
    if ( !is_on_ray(S,P[0]) || !is_on_ray(S,P[1]) ) {
        write("Warning: Common basepoints calculation failed! No common basepoints possible.");
        P[0].set_invalid();
        P[1].set_invalid();
    }
    return P;
}

/** Calculate the common basepoints of a hyperbolic segments and a hyperbolic ray.
 *  These are the points where the common perpendicular intersects the two given objects.
 */
hyperbolic_point[] common_basepoints(hyperbolic_ray R, hyperbolic_segment S) {
    hyperbolic_point[] P;
    P[0] = hyperbolic_point();
    P[1] = hyperbolic_point();
    if (R.is_invalid() || S.is_invalid()) {
        write("Warning: Common basepoints calculation failed! The ray and/or segment is invalid.");
        return P;
    }
    // Test if segment is part of ray is not done
    // The common_perpendicular will throw an error anyway.

    hyperbolic_line L = common_perpendicular(R.get_line(), S.get_line());
    P[0] = intersection(R, L);
    P[1] = intersection(S, L);

    // Check for both points if they belong to the ray.
    if ( !is_on_ray(R,P[0]) || !is_on_segment(S,P[1]) ) {
        write("Warning: Common basepoints calculation failed! No common basepoints possible.");
        P[0].set_invalid();
        P[1].set_invalid();
    }
    return P;
}

// And the other way round:
hyperbolic_point[] common_basepoints(hyperbolic_segment S, hyperbolic_ray R) {
    return common_basepoints(S, R);
}

// =============================================================================
// Hyperbolic isometries
// =============================================================================

/** Mirror an hyperbolic point at an hyperbolic line.
 */
hyperbolic_point mirror(hyperbolic_line M, hyperbolic_point P) {
    hyperbolic_point Q = hyperbolic_point();
    if ( M.is_invalid() || P.is_invalid() ) {
        write("Warning: Mirroring point failed. The point and/or line is invalid.");
        return Q;
    }

    pair p = P.get_euclidean(); // the original point
    if ( M.is_diameter() ) {
        write("Info: Mirroring at hyperbolic line which is a diameter.");
        pair e = (M.get_second_endpoint() - M.get_first_endpoint());
        Q = hyperbolic_point(mirror(e,p));
    } else {
        pair c = M.get_center();
        real r = M.get_radius();
        Q = hyperbolic_point(invert(c,r,p));
    }
    return Q;
}

/** Mirror an hyperbolic line at another hyperbolic line
 */
hyperbolic_line mirror(hyperbolic_line M, hyperbolic_line L) {
    hyperbolic_line K = hyperbolic_line();
    if ( M.is_invalid() || L.is_invalid() ) {
        write("Warning: Mirroring line failed. A line is invalid.");
        return K;
    }

    if ( M.is_diameter() ) {
        // The line we mirror at is a diameter
        write("Info: Mirroring at hyperbolic line which is a diameter.");
        pair e = (M.get_second_endpoint() - M.get_first_endpoint());
        if ( L.is_diameter() ) {
            // The line we want to mirror is a diameter too
            pair f1 = mirror(e, L.get_first_endpoint());
            pair f2 = mirror(e, L.get_second_endpoint());
            K.configure(f2, f1);
        } else {
            // The line we want to mirror is a circle
            pair cl = L.get_center();
            real rl = L.get_radius();
            // Mirror image of center
            K.configure(mirror(e,cl), rl);
        }
    } else {
        // The line we mirror at is a circle
        pair icc = M.get_center();
        real icr = M.get_radius();
        if ( L.is_diameter() ) {
            // The line we mirror is a diameter
            pair f1 = invert(icc, icr, L.get_first_endpoint());
            pair f2 = invert(icc, icr, L.get_second_endpoint());
            K.configure(f1,f2);
        } else {
            // The line we mirror is a circle too
            pair cl = L.get_center();
            real rl = L.get_radius();
            // Two helper points that are part of the circle representing L
            pair u = cl - rl*unit(icc-cl);
            pair v = cl + rl*unit(icc-cl);
            // Invert these points at the circle representing M
            pair iu = invert(icc, icr, u);
            pair iv = invert(icc, icr, v);
            // Calculate center and radius of the circle representing K
            K.configure((iu+iv)/2, length(iu-iv)/2);
        }
    }
    // The case a line is mirrored to a diameter
    K.reconfigure();
    return K;
}

/** Mirror an hyperbolic segment at a hyperbolic line. This is an easy task
 *  we just mirror the two endpoints and construct a new segment.
 */
hyperbolic_segment mirror(hyperbolic_line M, hyperbolic_segment S) {
    hyperbolic_segment T = hyperbolic_segment();
    if ( M.is_invalid() || S.is_invalid() ) {
        write("Warning: Mirroring line failed. The line and/or segment is invalid.");
        return T;
    }

    // Mirror the two endpoints
    hyperbolic_point A = S.get_first_point();
    hyperbolic_point B = S.get_second_point();
    // and construct a new segment from these mirror images
    T = hyperbolic_segment(mirror(M, A), mirror(M, B));

    return T;
}

/** Mirror an hyperbolic ray at a hyperbolic line.
 */
hyperbolic_ray mirror(hyperbolic_line M, hyperbolic_ray R) {
    hyperbolic_ray S = hyperbolic_ray();
    if ( M.is_invalid() || R.is_invalid() ) {
        write("Warning: Mirroring ray failed. The line and/or ray is invalid.");
        return S;
    }

    // The point P the ray starts at.
    hyperbolic_point P = R.get_point();
    pair p = P.get_euclidean();
    pair er = R.get_endpoint();
    // The line L the ray is part of.
    hyperbolic_line L = R.get_line();
    // The image of P
    hyperbolic_point Q = mirror(M,P);
    // Image of the line R is part of.
    hyperbolic_line K = mirror(M,L);
    // The mirror image of er
    pair fr;

    if ( M.is_diameter() ) {
        fr = mirror(M.get_second_endpoint() - M.get_first_endpoint(), er);
    } else {
        fr = invert(M.get_center(), M.get_radius(), er);
    }
    S.configure(K, Q, fr);
    return S;
}

/** Mirror an hyperbolic circle at a given hyperbolic line
 */
hyperbolic_circle mirror(hyperbolic_line M, hyperbolic_circle C) {
    hyperbolic_circle D = hyperbolic_circle();
    if ( M.is_invalid() || C.is_invalid() ) {
        write("Warning: Mirroring line failed. The circle and/or the line is invalid.");
        return D;
    }

    hyperbolic_point P = mirror(M, C.get_centerpoint());

    pair cc = C.get_center();
    real rc = C.get_radius();
    if ( M.is_diameter() ) {
        // The line we mirror at is a diameter
        write("Info: Mirroring at hyperbolic line which is a diameter.");
        pair e = (M.get_second_endpoint() - M.get_first_endpoint());
        pair mcc = mirror(e, cc);
        D.configure(mcc, rc, P, C.radius());
    } else {
        // The line we want to mirror at is a circle
        pair icc = M.get_center();
        real icr = M.get_radius();
        // Two helper points that are part of the circle representing C
        pair u = cc - rc*unit(icc-cc);
        pair v = cc + rc*unit(icc-cc);
        // Invert these points at the circle representing M
        pair iu = invert(icc, icr, u);
        pair iv = invert(icc, icr, v);
        // Calculate center and radius of the circle representing K
        D.configure((iu+iv)/2, length(iu-iv)/2, P, C.radius());
    }
    return D;
}

/** Mirror hyperbolic triangle at hyperbolic line.
 */
hyperbolic_triangle mirror(hyperbolic_line M, hyperbolic_triangle T) {
    if ( M.is_invalid() || T.is_invalid() ) {
        write("Warning: Mirroring triangle failed. The circle and/or the line is invalid.");
        return hyperbolic_triangle();
    }
    hyperbolic_point AM = mirror(M, T.A());
    hyperbolic_point BM = mirror(M, T.B());
    hyperbolic_point CM = mirror(M, T.C());
    return hyperbolic_triangle(AM, BM, CM);
}

/** Mirror hyperbolic polygon at hyperbolic line.
 */
hyperbolic_polygon mirror(hyperbolic_line M, hyperbolic_polygon P) {
    if ( M.is_invalid() || P.is_invalid() ) {
        write("Warning: Mirroring polygon failed. The circle and/or the line is invalid.");
        return hyperbolic_polygon();
    }
    hyperbolic_point[] Q = P.get_corners();
    hyperbolic_point[] QM;
    for(int i = 0; i < P.get_num_corners(); ++i){
        QM[i] = mirror(M,Q[i]);
    }
    return hyperbolic_polygon(QM);
}

// Functions for mirroring at segments/rays are basically just wrappers
// nothing new down there.

/** Mirror hyperbolic point at hyperbolic segment.
 */
hyperbolic_point mirror(hyperbolic_segment S, hyperbolic_point P) {
    if (S.is_invalid()) {
        write("Warning: mirror point at segment failed: segment is invalid");
        // Just an arbitrary invalid point
        return hyperbolic_point();
    }
    return mirror(S.get_line(), P);
}

/** Mirror hyperbolic line at hyperbolic segment.
 */
hyperbolic_line mirror(hyperbolic_segment S, hyperbolic_line L) {
    if (S.is_invalid()) {
        write("Warning: mirror line at segment failed: segment is invalid");
        // Just an arbitrary invalid line
        return hyperbolic_line();
    }
    return mirror(S.get_line(), L);
}

/** Mirror hyperbolic segment at hyperbolic segment.
 */
hyperbolic_segment mirror(hyperbolic_segment S, hyperbolic_segment T) {
    if (S.is_invalid()) {
        write("Warning: mirror segment at segment failed: segment is invalid");
        // Just an arbitrary invalid segment
        return hyperbolic_segment();
    }
    return mirror(S.get_line(), T);
}

/** Mirror hyperbolic ray at hyperbolic segment.
 */
hyperbolic_ray mirror(hyperbolic_segment S, hyperbolic_ray R) {
    if (S.is_invalid()) {
        write("Warning: mirror ray at segment failed: segment is invalid");
        // Just an arbitrary invalid ray
        return hyperbolic_ray();
    }
    return mirror(S.get_line(), R);
}

/** Mirror hyperbolic circle at hyperbolic segment.
 */
hyperbolic_circle mirror(hyperbolic_segment S, hyperbolic_circle C) {
    if (S.is_invalid()) {
        write("Warning: mirror circle at segment failed: segment is invalid");
        // Just an arbitrary invalid circle
        return hyperbolic_circle();
    }
    return mirror(S.get_line(), C);
}

/** Mirror hyperbolic triangle at hyperbolic segment.
 */
hyperbolic_triangle mirror(hyperbolic_segment S, hyperbolic_triangle T) {
    if (S.is_invalid()) {
        write("Warning: mirror triangle at segment failed: segment is invalid");
        // Just an arbitrary invalid triangle
        return hyperbolic_triangle();
    }
    return mirror(S.get_line(), T);
}

/** Mirror hyperbolic polygon at hyperbolic segment.
 */
hyperbolic_polygon mirror(hyperbolic_segment S, hyperbolic_polygon P) {
    if (S.is_invalid()) {
        write("Warning: mirror polygon at segment failed: segment is invalid");
        // Just an arbitrary invalid polygon
        return hyperbolic_polygon();
    }
    return mirror(S.get_line(), P);
}

/** Mirror hyperbolic point at hyperbolic ray.
 */
hyperbolic_point mirror(hyperbolic_ray R, hyperbolic_point P) {
    if (R.is_invalid()) {
        write("Warning: mirror point at ray failed: ray is invalid");
        // Just an arbitrary invalid point
        return hyperbolic_point();
    }
    return mirror(R.get_line(), P);
}

/** Mirror hyperbolic line at hyperbolic ray.
 */
hyperbolic_line mirror(hyperbolic_ray R, hyperbolic_line L) {
    if (R.is_invalid()) {
        write("Warning: mirror line at ray failed: ray is invalid");
        // Just an arbitrary invalid line
        return hyperbolic_line();
    }
    return mirror(R.get_line(), L);
}

/** Mirror hyperbolic ray at hyperbolic ray.
 */
hyperbolic_segment mirror(hyperbolic_ray R, hyperbolic_segment S) {
    if (R.is_invalid()) {
        write("Warning: mirror segment at ray failed: ray is invalid");
        // Just an arbitrary invalid segment
        return hyperbolic_segment();
    }
    return mirror(R.get_line(), S);
}

/** Mirror hyperbolic ray at hyperbolic ray.
 */
hyperbolic_ray mirror(hyperbolic_ray R, hyperbolic_ray S) {
    if (R.is_invalid()) {
        write("Warning: mirror ray at ray failed: ray is invalid");
        // Just an arbitrary invalid ray
        return hyperbolic_ray();
    }
    return mirror(R.get_line(), S);
}

/** Mirror hyperbolic circle at hyperbolic ray.
 */
hyperbolic_circle mirror(hyperbolic_ray R, hyperbolic_circle C) {
    if (R.is_invalid()) {
        write("Warning: mirror circle at ray failed: ray is invalid");
        // Just an arbitrary invalid circle
        return hyperbolic_circle();
    }
    return mirror(R.get_line(), C);
}

/** Mirror hyperbolic triangle at hyperbolic ray.
 */
hyperbolic_triangle mirror(hyperbolic_ray R, hyperbolic_triangle T) {
    if (R.is_invalid()) {
        write("Warning: mirror triangle at ray failed: ray is invalid");
        // Just an arbitrary invalid triangle
        return hyperbolic_triangle();
    }
    return mirror(R.get_line(), T);
}

/** Mirror hyperbolic polygon at hyperbolic ray.
 */
hyperbolic_polygon mirror(hyperbolic_ray R, hyperbolic_polygon P) {
    if (R.is_invalid()) {
        write("Warning: mirror polygon at ray failed: ray is invalid");
        // Just an arbitrary invalid polygon
        return hyperbolic_polygon();
    }
    return mirror(R.get_line(), P);
}

/** Find the line at which a given point P needs to be mirrored
 *  to become identical to the origin.
 */
hyperbolic_line find_mirror_to_origin(hyperbolic_point P) {
    hyperbolic_line M = hyperbolic_line();
    if ( P.is_invalid() ) {
        write("Warning: could not calculate mirror to origin: point is invalid.");
        return M;
    }
    if ( is_same_point(hyperbolic_point(origin),P) ) {
        write("Warning: could not calculate mirror to origin: point is origin.");
        return M;
    }

    pair p = P.get_euclidean();
    real h = sqrt(1-length(p)^2);
    pair n = (-p.y, p.x);
    pair e1 = p+h*unit(n);
    pair e2 = p-h*unit(n);
    M.configure(e1, e2);
    return M;
}

/** Find the line at which a given point P needs to be mirrored
 *  to become identical to the given point Q.
 */
hyperbolic_line find_mirror(hyperbolic_point P, hyperbolic_point Q) {
    if ( P.is_invalid() || Q.is_invalid() ) {
        write("Warning: could not calculate mirror to point: a point is invalid.");
        return hyperbolic_line();
    }
    if ( is_same_point(P,Q) ) {
        write("Warning: could not calculate mirror to point: points are identical.");
        return hyperbolic_line();
    }

    // Special cases where one point is the origin
    hyperbolic_point O = hyperbolic_point(origin);
    if ( is_same_point(P,O) ) {
        return find_mirror_to_origin(Q);
    } else if ( is_same_point(Q,O) ) {
        return find_mirror_to_origin(P);
    }
    // General case where both points are different from the origin
    hyperbolic_line L = find_mirror_to_origin(P);
    hyperbolic_point Qs = mirror(L, Q);
    hyperbolic_line N = find_mirror_to_origin(Qs);
    return mirror(L, N);
}

/** Rotate a hyperbolic point around the origin with a given angle.
 */
hyperbolic_point rotate_around_origin(hyperbolic_point P, real angle) {
    if ( P.is_invalid() ) {
        write("Warning: could not rotate around origin: point is invalid.");
        return hyperbolic_point();
    }
    real[] h = P.get_hyperbolic();
    // Maybe better use rotation matrix on euclidean coordinates?
    return hyperbolic_point(h[0], h[1]+angle);
}

/** Rotate a hyperbolic point around an arbitrary other point.
 */
hyperbolic_point rotate(hyperbolic_point center, hyperbolic_point P, real angle) {
    if ( center.is_invalid() || P.is_invalid() ) {
        write("Warning: could not rotate around point: a point is invalid.");
        return hyperbolic_point();
    }
    if ( is_same_point(center, P) ) {
        write("Warning: do not rotate the center of rotation.");
        return P;
    }
    if ( is_same_point(hyperbolic_point(origin), center) ) {
        write("Info: Center of rotation is the origin.");
        // Call in the hope for better numerical results for some points.
        return rotate_around_origin(P, angle);
    }

    hyperbolic_line M = find_mirror_to_origin(center);
    return mirror(M, rotate_around_origin(mirror(M,P), angle));
}

/** Rotate a hyperbolic line around the origin with a given angle.
 */
hyperbolic_line rotate_around_origin(hyperbolic_line L, real angle) {
    if ( L.is_invalid() ) {
        write("Warning: could not rotate around origin: line is invalid.");
        return hyperbolic_line();
    }
    pair e1 = L.get_first_endpoint();
    pair e2 = L.get_second_endpoint();
    hyperbolic_line K = hyperbolic_line();
    K.configure(rotate(e1, angle), rotate(e2, angle));
    return K;
}

/** Rotate a hyperbolic line around an arbitrary point.
 */
hyperbolic_line rotate(hyperbolic_point center, hyperbolic_line L, real angle) {
    if ( center.is_invalid() || L.is_invalid() ) {
        write("Warning: could not rotate around point: The point and/or line is invalid.");
        return hyperbolic_line();
    }
    if ( is_same_point(hyperbolic_point(origin), center) ) {
        write("Info: Center of rotation is the origin.");
        // Call in the hope for better numerical results for some points.
        return rotate_around_origin(L, angle);
    }

    hyperbolic_line M = find_mirror_to_origin(center);
    return mirror(M, rotate_around_origin(mirror(M,L), angle));
}

/** Rotate a hyperbolic segment around the origin with a given angle.
 */
hyperbolic_segment rotate_around_origin(hyperbolic_segment S, real angle) {
    if ( S.is_invalid() ) {
        write("Warning: could not rotate around origin: segment is invalid.");
        return hyperbolic_segment();
    }
    hyperbolic_point P = rotate_around_origin(S.get_first_point(), angle);
    hyperbolic_point Q = rotate_around_origin(S.get_second_point(), angle);
    return hyperbolic_segment(P,Q);
}

/** Rotate a hyperbolic segment around an arbitrary point.
 */
hyperbolic_segment rotate(hyperbolic_point center, hyperbolic_segment S, real angle) {
    if ( center.is_invalid() || S.is_invalid() ) {
        write("Warning: could not rotate around point: The point and/or segment is invalid.");
        return hyperbolic_segment();
    }
    if ( is_same_point(hyperbolic_point(origin), center) ) {
        write("Info: Center of rotation is the origin.");
        // Call in the hope for better numerical results for some points.
        return rotate_around_origin(S, angle);
    }

    hyperbolic_line M = find_mirror_to_origin(center);
    return mirror(M, rotate_around_origin(mirror(M,S), angle));
}

/** Rotate a hyperbolic ray around the origin with a given angle.
 */
hyperbolic_ray rotate_around_origin(hyperbolic_ray R, real angle) {
    if ( R.is_invalid() ) {
        write("Warning: could not rotate around origin: ray is invalid.");
        return hyperbolic_ray();
    }

    hyperbolic_point P = rotate_around_origin(R.get_point(), angle);
    pair e = rotate(R.get_endpoint(), angle);
    hyperbolic_line L = rotate_around_origin(R.get_line(), angle);

    hyperbolic_ray S = hyperbolic_ray();
    S.configure(L, P, e);
    return S;
}

/** Rotate a hyperbolic ray around an arbitrary point.
 */
hyperbolic_ray rotate(hyperbolic_point center, hyperbolic_ray R, real angle) {
    if ( center.is_invalid() || R.is_invalid() ) {
        write("Warning: could not rotate around point: The point and/or ray is invalid.");
        return hyperbolic_ray();
    }
    if ( is_same_point(hyperbolic_point(origin), center) ) {
        write("Info: Center of rotation is the origin.");
        // Call in the hope for better numerical results for some points.
        return rotate_around_origin(R, angle);
    }

    hyperbolic_line M = find_mirror_to_origin(center);
    return mirror(M, rotate_around_origin(mirror(M,R), angle));
}

/** Rotate a hyperbolic circle around the origin with a given angle.
 */
hyperbolic_circle rotate_around_origin(hyperbolic_circle C, real angle) {
    if ( C.is_invalid() ) {
        write("Warning: could not rotate around origin: circle is invalid.");
        return hyperbolic_circle();
    }

    pair d = rotate(C.get_center(), angle);
    hyperbolic_point P = rotate_around_origin(C.get_centerpoint(), angle);
    hyperbolic_circle D = hyperbolic_circle();
    D.configure(d, C.get_radius(), P, C.radius());
    return D;
}

/** Rotate a hyperbolic circle around an arbitrary point.
 */
hyperbolic_circle rotate(hyperbolic_point center, hyperbolic_circle C, real angle) {
    if ( center.is_invalid() || C.is_invalid() ) {
        write("Warning: could not rotate around point: The point and/or circle is invalid.");
        return hyperbolic_circle();
    }
    if ( is_same_point(hyperbolic_point(origin), center) ) {
        write("Info: Center of rotation is the origin.");
        // Call in the hope for better numerical results for some points.
        return rotate_around_origin(C, angle);
    }
    if ( C.centerpoint_known() && is_same_point(center, C.get_centerpoint()) ) {
        write("Info: Center of rotation is the center of the circle.");
        // Call in the hope for better numerical results for some points.
        return C;
    }

    hyperbolic_line M = find_mirror_to_origin(center);
    return mirror(M, rotate_around_origin(mirror(M,C), angle));
}

/** Rotate a hyperbolic triangle around an arbitrary point.
 */
hyperbolic_triangle rotate(hyperbolic_point center, hyperbolic_triangle T, real angle) {
    if ( center.is_invalid() || T.is_invalid() ) {
        write("Warning: could not rotate around point: The point and/or triangle is invalid.");
        return hyperbolic_triangle();
    }
    hyperbolic_point D = rotate(center, T.A(), angle);
    hyperbolic_point E = rotate(center, T.B(), angle);
    hyperbolic_point F = rotate(center, T.C(), angle);
    return hyperbolic_triangle(D,E,F);
}

/** Rotate a hyperbolic polygon around an arbitrary point.
 */
hyperbolic_polygon rotate(hyperbolic_point center, hyperbolic_polygon P, real angle) {
    if ( center.is_invalid() || P.is_invalid() ) {
        write("Warning: could not rotate around point: The point and/or polygon is invalid.");
        return hyperbolic_polygon();
    }
    hyperbolic_point[] X = P.get_corners();
    hyperbolic_point[] Y;
    // TODO: Improve this by a vectorized version: rotate(center, point[], angle)
    for(int i = 0; i < P.get_num_corners(); ++i) {
        Y[i] = rotate(center, X[i], angle);
    }
    return hyperbolic_polygon(Y);
}

// =============================================================================
// Constructions of various geometric objects
// =============================================================================
// Maybe replace some of these methods by a better mathematical calculation
// instead of geometric constructions.

/** Construct the hyperbolic midpoint of two given points.
 */
hyperbolic_point midpoint(hyperbolic_point A, hyperbolic_point B) {
    if ( A.is_invalid() || B.is_invalid() ) {
        write("Warning: midpoint calculation failed. A point is invalid");
        return hyperbolic_point();
    }
    if ( is_same_point(A,B) ) {
        write("Warning: midpoint calculation failed. Points are identical.");
        return hyperbolic_point();
    }

    hyperbolic_circle C1 = hyperbolic_circle(A,B);
    hyperbolic_circle C2 = hyperbolic_circle(B,A);
    hyperbolic_point[] I = intersection(C1,C2);
    hyperbolic_line g = hyperbolic_line(I);
    return intersection(hyperbolic_line(A,B),g);
}

/** Construct the hyperbolic midline of two given points.
 */
hyperbolic_line midline(hyperbolic_point A, hyperbolic_point B) {
    if ( A.is_invalid() || B.is_invalid() ) {
        write("Warning: midline calculation failed. A point is invalid");
        return hyperbolic_line();
    }
    if ( is_same_point(A,B) ) {
        write("Warning: midline calculation failed. Points are identical.");
        return hyperbolic_line();
    }

    hyperbolic_circle C1 = hyperbolic_circle(A,B);
    hyperbolic_circle C2 = hyperbolic_circle(B,A);
    hyperbolic_point[] I = intersection(C1,C2);
    return hyperbolic_line(I);
}

/** Construct the hyperbolic angle bisector from three given points A,B,C.
 *  The bisector bisects the angle ABC.
 */
hyperbolic_line angle_bisector(hyperbolic_point A, hyperbolic_point B, hyperbolic_point C) {
    if ( A.is_invalid() || B.is_invalid() || C.is_invalid() ) {
        write("Warning: angle bisector calculation failed. A point is invalid");
        return hyperbolic_line();
    }
    if ( !distinct(A,B,C) ) {
        write("Warning: angle bisector calculation failed. Some points are identical.");
        return hyperbolic_line();
    }

    hyperbolic_ray R1 = hyperbolic_ray(B,A);
    hyperbolic_ray R2 = hyperbolic_ray(B,C);
    hyperbolic_circle C = hyperbolic_circle(B, A);
    hyperbolic_point[] res = intersection(R1, C);
    hyperbolic_point I = res[0].is_invalid() ? res[1] : res[0];
    res = intersection(R2, C);
    hyperbolic_point J = res[0].is_invalid() ? res[1] : res[0];
    hyperbolic_circle C1 = hyperbolic_circle(I, J);
    hyperbolic_circle C2 = hyperbolic_circle(J, I);
    res = intersection(C1, C2);
    return hyperbolic_line(res[0], res[1]);
}

/** Construct both hyperbolic angle bisectors from two given lines G,H.
 */
hyperbolic_line[] angle_bisector(hyperbolic_line G, hyperbolic_line H) {
    hyperbolic_line[] bis;
    bis[0] = hyperbolic_line();
    bis[1] = hyperbolic_line();
    if ( G.is_invalid() || H.is_invalid() ) {
        write("Warning: angle bisector calculation failed. A line is invalid.");
        return bis;
    }
    if ( is_same_line(G,H) ) {
        write("Warning: angle bisector calculation failed. Lines are identical.");
        return bis;
    }
    if ( !do_intersect(G,H) ) {
        write("Warning: angle bisector calculation failed. Lines do not intersect.");
        return bis;
    }

    hyperbolic_point P = intersection(G,H);

    // Hack: construct a hyperbolic circle with center P and arbitrary radius
    // Assure its entirely in the unit disk
    pair p = P.get_euclidean();
    real radius = 1-length(p)-epsilon;
    hyperbolic_circle C;
    C.configure(p, radius);
    // The circle is strictely invalid, as it does not have the information
    // about its hyperbolic center and radius !!
    // </hack>

    hyperbolic_point[] I = intersection(C, G);
    hyperbolic_point[] J = intersection(C, H);

    bis[0] = angle_bisector(I[0], P, J[0]);
    bis[1] = angle_bisector(I[0], P, J[1]);
    return bis;
}


/** Construct a hyperbolic circle through three given points.
 */
hyperbolic_circle hyperbolic_circle(hyperbolic_point P, hyperbolic_point Q, hyperbolic_point R) {
    if ( P.is_invalid() || Q.is_invalid() || R.is_invalid() ) {
        write("Warning: construction of hyperbolic circle failed! A point is invalid.");
        return hyperbolic_circle();
    }
    if ( !distinct(P,Q,R) ) {
        write("Warning: construction of hyperbolic circle failed! Given points are to near to each other.");
        return hyperbolic_circle();
    }

    hyperbolic_line MPQ = midline(P,Q);
    hyperbolic_line MQR = midline(Q,R);
    hyperbolic_line MRP = midline(R,P);

    hyperbolic_point M1 = intersection(MPQ, MQR);
    hyperbolic_point M2 = intersection(MQR, MRP);
    hyperbolic_point M3 = intersection(MRP, MPQ);

    if ( M1.is_invalid() || M2.is_invalid() || M3.is_invalid() ) {
        write("Warning: construction of hyperbolic circle failed! A intersection point does not exist.");
        return hyperbolic_circle();
    }
    if ( distinct(M1,M2,M3) ) {
        write("Warning: construction of a hyperbolic circle: questionable accuracy!");
    }

    return hyperbolic_circle(M1, P);
}

/** Construct the circumcircle of a hyperbolic triangle.
 */
// Question: do all triangles have a circumcircle?
// This construction fails sometimes.
hyperbolic_circle circumcircle(hyperbolic_triangle T) {
    if ( T.is_invalid() ) {
        write("Warning: Circumcircle construction failed: triangle is invalid.");
        return hyperbolic_circle();
    }
    return hyperbolic_circle(T.A(),T.B(),T.C());
}

/** Construct the incircle of a hyperbolic triangle. All hyperbolic triangles
 *  do have an incircle.
 */
hyperbolic_circle incircle(hyperbolic_triangle T) {
    if ( T.is_invalid() ) {
        write("Warning: Circumcircle construction failed: triangle is invalid.");
        return hyperbolic_circle();
    }

    hyperbolic_line bisAB = angle_bisector(T.A(), T.C(), T.B());
    hyperbolic_line bisBC = angle_bisector(T.B(), T.A(), T.C());
    hyperbolic_line bisCA = angle_bisector(T.C(), T.B(), T.A());
    hyperbolic_point M1 = intersection(bisAB, bisBC);
    hyperbolic_point M2 = intersection(bisBC, bisCA);
    hyperbolic_point M3 = intersection(bisCA, bisAB);

    if ( M1.is_invalid() || M2.is_invalid() || M3.is_invalid() ) {
        write("Warning: construction of incircle failed! A intersection point does not exist.");
        return hyperbolic_circle();
    }
    if ( distinct(M1,M2,M3) ) {
        write("Warning: construction of a hyperbolic circle: questionable accuracy!");
    }

    hyperbolic_point Q = basepoint(T.AB().get_line(), M1);
    return hyperbolic_circle(M1, Q);
}

/** Construct tangent to a hyperbolic circle through a given point which has to
 *  lie on the circle.
 */
hyperbolic_line tangent(hyperbolic_circle C, hyperbolic_point P) {
    if ( C.is_invalid() || P.is_invalid() ) {
        write("Warning: Tangent construction failed. The circle and/or the point is invalid.");
        return hyperbolic_line();
    }
    if ( !is_on_circle(C,P) ) {
        write("Warning: Tangent construction failed. The the point lies not on the circle.");
        return hyperbolic_line();
    }

    hyperbolic_point center = C.get_centerpoint();
    hyperbolic_line R = hyperbolic_line(center, P);
    return hyperbolic_normal(R,P);
}

/** Construct the points where the tangents to a hyperbolic circle through an arbitrary
 *  given point meet the circle.
 */
hyperbolic_point[] tangentpoints(hyperbolic_circle C, hyperbolic_point P) {
    hyperbolic_point[] tanps;
    tanps[0] = hyperbolic_point();
    tanps[1] = hyperbolic_point();

    if ( C.is_invalid() || P.is_invalid() ) {
        write("Warning: Tangent construction failed. The circle and/or the point is invalid.");
        return tanps;
    }

    if ( is_inside_circle(C,P) ) {
        write("Warning: Tangentpoints construction failed. The the point lies inside of the circle.");
    } else if ( is_on_circle(C,P) ) {
        write("Info: Tangentpoints are identical to P. The the point P lies on the circle.");
        tanps[0] = P;
        tanps[1] = P;
    } else {
        // Point lies outside of the circle
        if ( is_same_point(P, hyperbolic_point(origin)) ) {
            pair center = C.get_center();
            real rk = C.get_radius();
            real d = length(center);
            real h = rk*sqrt(d^2-rk^2)/d;
            real q = -(rk^2-d^2)/d;
            pair x = q*unit(center);
            pair p1 = x + h*unit((-center.y, center.x));
            pair p2 = x - h*unit((-center.y, center.x));

            tanps[0] = hyperbolic_point(p1);
            tanps[1] = hyperbolic_point(p2);
        } else {
            hyperbolic_line M = find_mirror_to_origin(P);
            hyperbolic_circle K = mirror(M, C);

            pair center = K.get_center();
            real rk = K.get_radius();
            real d = length(center);
            real h = rk*sqrt(d^2-rk^2)/d;
            real q = -(rk^2-d^2)/d;
            pair x = q*unit(center);
            pair p1 = x + h*unit((-center.y, center.x));
            pair p2 = x - h*unit((-center.y, center.x));

            tanps[0] = mirror(M, hyperbolic_point(p1));
            tanps[1] = mirror(M, hyperbolic_point(p2));
        }
    }
    return tanps;
}

/** Construct tangents to a hyperbolic circle through an arbitrary given point.
 */
hyperbolic_line[] tangents(hyperbolic_circle C, hyperbolic_point P) {
    hyperbolic_line[] tans;
    tans[0] = hyperbolic_line();
    tans[1] = hyperbolic_line();

    if ( C.is_invalid() || P.is_invalid() ) {
        write("Warning: Tangent construction failed. The circle and/or the point is invalid.");
        return tans;
    }

    if ( is_inside_circle(C,P) ) {
        write("Warning: Tangent construction failed. The the point lies inside of the circle.");
    } else if ( is_on_circle(C,P) ) {
        write("Info: Tangents are identical. The the point lies on the circle.");
        tans[0] = tangent(C,P);
        tans[1] = tans[0];
    } else {
        // Point lies outside of the circle
        hyperbolic_point[] Pi = tangentpoints(C, P);
        tans[0] = hyperbolic_line(P, Pi[0]);
        tans[1] = hyperbolic_line(P, Pi[1]);
    }
    return tans;
}

/** Construct a hyperbolic regular polygon with n sides from a given center
 *  and one given point.
 */
hyperbolic_polygon hyperbolic_regular_ngon(hyperbolic_point center, hyperbolic_point P, int n) {
    if ( center.is_invalid() || P.is_invalid() ) {
        write("Warning: could not construct hyperbolic regular ngon: a point is invalid.");
        return hyperbolic_polygon();
    }
    if ( is_same_point(center, P) ) {
        write("Warning: could not construct hyperbolic regular ngon: center and point are identical");
        return hyperbolic_polygon();
    }
    if ( n<=2 ) {
        write("Warning: Can not construct hyperbolic regular ngon with less than 3 sides.");
        return hyperbolic_polygon();
    }

    hyperbolic_point[] E;
    E[0] = P;
    for(int i = 1; i < n; ++i) {
        E[i] = rotate(center, P, i*360/n);
    }
    return hyperbolic_polygon(E);
}

/** Construct a hyperbolic triangle with given interior angles.
 */
hyperbolic_triangle hyperbolic_triangle(real alpha, real beta, real gamma) {
    if (alpha <= 0 || beta <= 0 || gamma <= 0) {
        write("Warning: Angle is non-positive");
        return hyperbolic_triangle();
    }
    if ( alpha + beta + gamma >= 180) {
        write("Warning: Interior angles sum up to more than pi.");
        return hyperbolic_triangle();
    }

    // Calculate the euclidian angles from hyperbolic ones
    real rho = radians(alpha + beta + gamma) / 2;
    real ealpha = radians(alpha);
    real ebeta = radians(beta) + pi/2 - rho;
    real egamma = radians(gamma) + pi/2 - rho;

    // Calculate euclidian sides from law of sines
    real c = 1.0;
    real b = c*sin(ebeta)/sin(egamma);
    real a = c*sin(ealpha)/sin(egamma);

    // The euclidian corners of the helper triangle
    pair A = (0,0);
    pair B = (1,0);
    pair C = (b*cos(ealpha), b*sin(ealpha));

    // Rescale
    pair d = C-B;
    pair center = (B+C)/2+a/2*tan(rho)*unit(-(-d.y, d.x));
    real scale = sqrt(length(center)^2-length(center-B)^2);

    return hyperbolic_triangle(hyperbolic_point(A), hyperbolic_point(1/scale*B), hyperbolic_point(1/scale*C));
}

/** Construct a hyperbolic polygon with n sides and given interior angles.
 */
hyperbolic_polygon hyperbolic_regular_ngon(int n, real angle) {
    if (angle <= 0) {
        write("Warning: Angle is non-positive");
        return hyperbolic_polygon();
    }
    if ( angle >= (n-2)/n*180 ) {
        write("Warning: Interior angle is too big.");
        return hyperbolic_polygon();
    }

    // Do not convert angle to radians, hyperbolic_triangle(a,b,c) expects degrees.
    hyperbolic_triangle T = hyperbolic_triangle(360/n, angle/2, angle/2);
    return hyperbolic_regular_ngon(hyperbolic_point(origin), T.B(), n);
}

// =============================================================================
// Code for drawing all those objects
// =============================================================================

// Overloading dot(...) to easily draw hyperbolic points
void dot(picture pic=currentpicture, hyperbolic_point p, pen pe=currentpen) {
    if (p.is_invalid()) {
        write("Warning: not drawing invalid point!");
        return;
    }
    dot(pic, p.get_euclidean(), pe);
}

// Overloading dot(...) to easily draw arrays of hyperbolic points
void dot(picture pic=currentpicture, hyperbolic_point[] points, pen pe=currentpen) {
    for (int i = 0; i < points.length; ++i) {
        dot(pic, points[i], pe);
    }
}

// Overloading draw(...) to easily draw hyperbolic points
void draw(picture pic=currentpicture, Label L="", hyperbolic_point p,
    align align=NoAlign, pen pe=currentpen,
    arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
    Label legend="", marker marker=nomarker) {
    if (p.is_invalid()) {
        write("Warning: not drawing invalid point!");
        return;
    }
    draw(pic, L, p.to_path(), align, pe, arrow, bar, margin, legend, marker);
}

// Overloading draw(...) to easily draw arrays of hyperbolic points
void draw(picture pic=currentpicture, Label L="", hyperbolic_point[] points,
    align align=NoAlign, pen pe=currentpen,
    arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
    Label legend="", marker marker=nomarker) {
    for (int i = 0; i < points.length; ++i) {
        draw(pic, L, points[i], align, pe, arrow, bar, margin, legend, marker);
    }
}

// Overloading draw(...) to easily draw hyperbolic lines
void draw(picture pic=currentpicture, Label L="", hyperbolic_line line,
          align align=NoAlign, pen pe=currentpen,
          arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
          Label legend="", marker marker=nomarker) {
    if (line.is_invalid()) {
        write("Warning: not drawing invalid line!");
        return;
    }
    draw(pic, L, line.to_path(), align, pe, arrow, bar, margin, legend, marker);
}

// Overloading draw(...) to easily draw arrays of hyperbolic lines
void draw(picture pic=currentpicture, Label L="", hyperbolic_line[] lines,
    align align=NoAlign, pen pe=currentpen,
    arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
    Label legend="", marker marker=nomarker) {
    for (int i = 0; i < lines.length; ++i) {
        draw(pic, L, lines[i], align, pe, arrow, bar, margin, legend, marker);
    }
}

// Overload draw(...) for drawing hyperbolic segments.
void draw(picture pic=currentpicture, Label L="", hyperbolic_segment seg,
          align align=NoAlign, pen pe=currentpen,
          arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
          Label legend="", marker marker=nomarker) {
    if (seg.is_invalid()) {
        write("Warning: not drawing invalid segment!");
        return;
    }
    draw(pic, L, seg.to_path(), align, pe, arrow, bar, margin, legend, marker);
}

// Overloading draw(...) to easily draw arrays of hyperbolic segments
void draw(picture pic=currentpicture, Label L="", hyperbolic_segment[] segs,
    align align=NoAlign, pen pe=currentpen,
    arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
    Label legend="", marker marker=nomarker) {
    for (int i = 0; i < segs.length; ++i) {
        draw(pic, L, segs[i], align, pe, arrow, bar, margin, legend, marker);
    }
}

// Overloading draw(...) for drawing hyperbolic rays
void draw(picture pic=currentpicture, Label L="", hyperbolic_ray ray,
          align align=NoAlign, pen pe=currentpen,
          arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
          Label legend="", marker marker=nomarker) {
    if (ray.is_invalid()) {
        write("Warning: not drawing invalid ray!");
        return;
    }
    draw(pic, L, ray.to_path(), align, pe, arrow, bar, margin, legend, marker);
}

// Overloading draw(...) to easily draw arrays of hyperbolic rays
void draw(picture pic=currentpicture, Label L="", hyperbolic_ray[] rays,
    align align=NoAlign, pen pe=currentpen,
    arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
    Label legend="", marker marker=nomarker) {
    for (int i = 0; i < rays.length; ++i) {
        draw(pic, L, rays[i], align, pe, arrow, bar, margin, legend, marker);
    }
}

// Overloading dot(...) to easily draw centers of hyperbolic circles
void dot(picture pic=currentpicture, hyperbolic_circle circle, pen pe=currentpen) {
    if (circle.is_invalid()) {
        write("Warning: not dot(...) invalid circle!");
        return;
    }
    // Center may be invalid, then dot(hyp point) will throw a warning
    dot(pic, circle.get_centerpoint(), pe);
}

// Overloading dot(...) to easily draw centers of arrays of hyperbolic circles
void dot(picture pic=currentpicture, hyperbolic_circle[] circles, pen pe=currentpen) {
    for (int i = 0; i < circles.length; ++i) {
        dot(pic, circles[i], pe);
    }
}

// Overload draw(...) for drawing of hyperbolic circles
void draw(picture pic=currentpicture, Label L="", hyperbolic_circle circle,
          align align=NoAlign, pen pe=currentpen,
          arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
          Label legend="", marker marker=nomarker) {
    if (circle.is_invalid()) {
        write("Warning: not drawing invalid circle!");
        return;
    }
    draw(pic, L, circle.to_path(), align, pe, arrow, bar, margin, legend, marker);
}

// Overloading draw(...) to easily draw arrays of hyperbolic circles
void draw(picture pic=currentpicture, Label L="", hyperbolic_circle[] circles,
    align align=NoAlign, pen pe=currentpen,
    arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
    Label legend="", marker marker=nomarker) {
    for (int i = 0; i < circles.length; ++i) {
        draw(pic, L, circles[i], align, pe, arrow, bar, margin, legend, marker);
    }
}

// Overloading fill(...) to easily fill hyperbolic circles
void fill(picture pic=currentpicture, hyperbolic_circle circle, pen p=currentpen) {
    if (circle.is_invalid()) {
        write("Warning: not filling invalid circle.");
        return;
    }
    fill(pic, circle.to_path(), p);
}

// Overloading fill(...) to easily fill arrays of hyperbolic circles
void fill(picture pic=currentpicture, hyperbolic_circle[] circles, pen pe=currentpen) {
    for (int i = 0; i < circles.length; ++i) {
        fill(pic, circles[i], pe);
    }
}

// Overloading dot(...) to easily dot-ing hyperbolic triangles
void dot(picture pic=currentpicture, hyperbolic_triangle triangle, pen pe=currentpen) {
    if (triangle.is_invalid()) {
        write("Warning: not dot(...)-ing invalid triangle.");
        return;
    }
    dot(pic, triangle.A(), pe);
    dot(pic, triangle.B(), pe);
    dot(pic, triangle.C(), pe);
}

// Overloading draw(...) to easily draw hyperbolic triangles
void draw(picture pic=currentpicture, Label L="", hyperbolic_triangle triangle,
          align align=NoAlign, pen pe=currentpen,
          arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
          Label legend="", marker marker=nomarker) {
    if (triangle.is_invalid()) {
        write("Warning: not drawing invalid triangle.");
        return;
    }
    draw(pic, L, triangle.to_path(), align, pe, arrow, bar, margin, legend, marker);
}

// Overloading fill(...) to easily fill hyperbolic triangles
void fill(picture pic=currentpicture, hyperbolic_triangle triangle, pen p=currentpen) {
    if (triangle.is_invalid()) {
        write("Warning: not filling invalid triangle.");
        return;
    }
    fill(pic, triangle.to_path(), p);
}

// Overloading dot(...) to easily dot-ing arrays of hyperbolic triangles
void dot(picture pic=currentpicture, hyperbolic_triangle[] triangles, pen pe=currentpen) {
    for (int i = 0; i < triangles.length; ++i) {
        dot(pic, triangles[i], pe);
    }
}

// Overloading draw(...) to easily draw arrays of hyperbolic triangles
void draw(picture pic=currentpicture, Label L="", hyperbolic_triangle[] triangles,
    align align=NoAlign, pen pe=currentpen,
    arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
    Label legend="", marker marker=nomarker) {
    for (int i = 0; i < triangles.length; ++i) {
        draw(pic, L, triangles[i], align, pe, arrow, bar, margin, legend, marker);
    }
}

// Overloading fill(...) to easily fill arrays of hyperbolic triangles
void fill(picture pic=currentpicture, hyperbolic_triangle[] triangles, pen pe=currentpen) {
    for (int i = 0; i < triangles.length; ++i) {
        fill(pic, triangles[i], pe);
    }
}

// Overloading dot(...) to easily dot-ing hyperbolic polygons
// This draws a dot for all corner points.
void dot(picture pic=currentpicture, hyperbolic_polygon polygon, pen pe=currentpen) {
    if (polygon.is_invalid()) {
        write("Warning: not dot(...)-ing invalid polygon.");
        return;
    }
    hyperbolic_point[] corners = polygon.get_corners();
    for (int i = 0; i < corners.length; ++i) {
        dot(pic, corners[i], pe);
    }
}

// Overloading draw(...) to easily draw hyperbolic polygons
// This draws the lines of the polygon.
void draw(picture pic=currentpicture, Label L="", hyperbolic_polygon polygon,
          align align=NoAlign, pen pe=currentpen,
          arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
          Label legend="", marker marker=nomarker) {
    if (polygon.is_invalid()) {
        write("Warning: not drawing invalid polygon.");
        return;
    }
    draw(pic, L, polygon.to_path(), align, pe, arrow, bar, margin, legend, marker);
}

// Overloading fill(...) to easily fill hyperbolic polygons
// This fills the area of the polygon.
void fill(picture pic=currentpicture, hyperbolic_polygon polygon, pen p=currentpen) {
    if (polygon.is_invalid()) {
        write("Warning: not filling invalid polygon.");
        return;
    }
    fill(pic, polygon.to_path(), p);
}

// Overloading dot(...) to easily dot-ing arrays of hyperbolic polygons
void dot(picture pic=currentpicture, hyperbolic_polygon[] polygons, pen pe=currentpen) {
    for (int i = 0; i < polygons.length; ++i) {
        dot(pic, polygons[i], pe);
    }
}

// Overloading draw(...) to easily draw arrays of hyperbolic polygons
void draw(picture pic=currentpicture, Label L="", hyperbolic_polygon[] polygons,
    align align=NoAlign, pen pe=currentpen,
    arrowbar arrow=None, arrowbar bar=None, margin margin=NoMargin,
    Label legend="", marker marker=nomarker) {
    for (int i = 0; i < polygons.length; ++i) {
        draw(pic, L, polygons[i], align, pe, arrow, bar, margin, legend, marker);
    }
}

// Overloading fill(...) to easily fill arrays of hyperbolic polygons
void fill(picture pic=currentpicture, hyperbolic_polygon[] polygons, pen pe=currentpen) {
    for (int i = 0; i < polygons.length; ++i) {
        fill(pic, polygons[i], pe);
    }
}

// =============================================================================
// Some rather unfinished and buggy things below here
// =============================================================================


// EOF
