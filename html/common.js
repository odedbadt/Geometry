function plus(a,b) {
	return a.map(function(x,i) { return x + b[i];})
}
function minus(a,b) {
	if (b) {
		return a.map(function(x,i) { return x - b[i]})		
	} else {
		return a.map(function(x) { return -x})		
	}
}
function mul(a,b) {
	return a.map(function(x,i) { return x * b[i];})
}
function div(p,a) {
	return p.map(function(x) {return x/a});
}
function scale(p,a) {
	return p.map(function(x) {return x*a});
}
function scalarplus(a,b) {
	return a + b;
}
function normalize(p) {
	return div(p, norm(p));
}
function norm2(p) {
	return dot(p,p);
}
function norm(p) {
  return Math.sqrt(norm2(p));
}
function cos(a) {
  return Math.cos(a);
}
function sin(a) {
  return Math.sin(a);
}
function acos(a) {
  return Math.acos(a);
}
function asin(a) {
  return Math.asin(a);
}
function atan(a) {
  return Math.atan(a);
}
function atan2(a, b) {
  return Math.atan2(a, b);
}
function tan(a) {
  return Math.tan(a);
}
function sqrt(a) {
  return Math.sqrt(a);
}
function log(a) {
  return Math.log(a);
}
function asinh(x) {
	return log(x + sqrt(x*x+1))
}
function acosh(x) {
	return log(x + sqrt(x*x-1))
}
function dist(v1, v2) {
  return norm(minus(v1,v2));
}
function dist2(v1, v2) {
  return norm2(minus(v1,v2));
}
function dot(p1,p2) {
	return mul(p1,p2).reduce(scalarplus);
}

function nxt(i) {
	return (i + 1) % 3;
}
function prv(i) {
	return (3 + i - 1) % 3;
}
function cross(p1,p2) {
	return p1.map(function(x,i) {return  p1[nxt(i)] * p2[prv(i)] - p1[prv(i)] * p2[nxt(i)]});
}
function normalize(p) {
	return div(p, norm(p));
}
function cameraproject(focal, p) {
	return [300 + p[0] * 300 * focal / (p[2] - focal), 300 + p[1] * 300 * focal / (p[2] - focal)];
}
function project(v, a) {
	return scale(a, dot(v,a)/dot(a,a));
}
function projectToPlane(v, a) {
	return minus(v, project(v, a))
}
function J(p) {	
	return [p[1], -p[0]];
}

function convexSum(v1, v2, a) {
	return v1.map(function(x,i) {return x*(1-a) + v2[i]* a});
}
function middle(v1, v2) {
	return convexSum(v1 ,v2, 0.5);
}
function range(n) {
  return {
      map:function(f) {
        var res = [];
        for (var i = 0; i < n; ++i) {
          res[i] = f(i);
        }
        return res;
      }
      
  }
}

PI = Math.PI
