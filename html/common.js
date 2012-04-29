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
function div(a,p) {
	return p.map(function(x) {return x/a});
}
function scale(a,p) {
	return p.map(function(x) {return x*a});
}
function scalarplus(a,b) {
	return (a || 0) + b;
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
function pow(a, b) {
  return Math.pow(a, b);
}
function abs(a) {
  return Math.abs(a);
}
function sign(a) {
  return a == 0 ? 0 : (a > 0 ? 1 : -1);
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
function toCartesian(alpha, r) {
	return [cos(alpha)*r, sin(alpha)*r];
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
function comp() {
	var funcs = copyArgs(arguments);
	return function(x) {
		var v = x;
		for (var i = funcs.length-1; i >= 0; --i) {
			v = (funcs[i])(v);
		}
		return v;
	}
}
function curry(f1) {
	var curried = copyArgs(arguments, 1);
	return function() {
		return f1.apply(null, curried.concat( copyArgs(arguments) ));
	}
}

function rcurry(f1) {
	var curried = copyArgs(arguments, 1);
	return function() {
		return f1.apply(null, copyArgs(arguments).concat(curried));
	}
}

function map(fun, array) {
	return array.map(fun);
}
function reduce(fun, start, array) {
	return array.reduce(fun, start);
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


function get(obj, key, dflt) {
	if (key.constructor != Array) {
		return get(obj, key.split('.'), dflt);
	}
	var val = obj[key];
	return val == undefined ? dflt : val;
}

function cget(objs, key) {
	for (var i = 0; i < objs.length; ++i) {
		if (objs[i][key] != undefined) {
			return objs[i][key];
		}
	}
	return undefined;
}

function keys(obj) {
	var keys = [];
	for (var key in obj) {
		keys.push(key);
	};
	return keys;
}
function values(obj) {
	var values = [];
	for (var key in obj) { values.push(obj[key])};
	return values;
}
function copyArgs(argsObject, from) {
	var res = [];
	for (var i = (from || 0); i < argsObject.length; ++i) {
		res.push(argsObject[i]);
	}
	return res;
}
PI = Math.PI
