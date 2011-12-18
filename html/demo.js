function generateSVGElement(name) {
	return document.createElementNS("http://www.w3.org/2000/svg", name);
}
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
function norm(p) {
	return Math.sqrt(norm2(p));
}
function norm2(p) {
	return dot(p,p);
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
function createCircle(x, y, r) {
	var circle = generateSVGElement('circle');
	circle.setAttribute('cx', x);
	circle.setAttribute('cy', y);
	circle.setAttribute('r', r);
	return circle;
}
function convexSum(v1, v2, a) {
		
}
function tos(d) {
	return Math.round(d*100) / 100;
}
function createPath(points) {
	var path = generateSVGElement('path');
	path.setAttribute('d', 'M' + points.map(function(p){return tos(p[0])+','+tos(p[1])}).join('L'))
	return path;
}
function stylize(element, fill, color, strokeWidth, opacity) {
	element.setAttribute('opacity', opacity);
	element.setAttribute('stroke-width', strokeWidth);
	element.setAttribute('stroke', color);
	element.setAttribute('fill', fill);
	return element;
}
function cycle(N, d, n) {
	return (n + N + d) % N;
}
function dottedpath(v1, v2) {
	var res =[];

	var N = Math.ceil(Math.acos(dot(normalize(v1), normalize(v2))) * 10);
	for (var i = 0; i <= N; ++i) {
		v = normalize(plus(scale(v1, 1-i/N), scale(v2, i/N)));
		res.push(v);
	}
	return res;
}

function closedpath(vs) {
	var res = [];
	res.push(vs[0]);
	for (var i = 0; i < vs.length; ++i) {
		res = res.concat(dottedpath(vs[i], vs[(i+1) % vs.length]))
	}
	return res;
}

function ellipse2d(p1,p2,p3,p4) {
	
}

function ignite() {
	
	var vs = [normalize([Math.random()-0.5, Math.random()-0.5, Math.random()+0.5]),
			  normalize([Math.random()-0.5, Math.random()-0.5, Math.random()+0.5]),
			  normalize([Math.random()-0.5, Math.random()-0.5, Math.random()+0.5])];


	var bases = vs.map(function(x,i) {
		return normalize(projectToPlane(x, cross(vs[(i+1) % 3], vs[(i+2) % 3])))
	})

	var points = closedpath(vs).map(cameraproject.bind(null, [10]))
	document.getElementById('main').appendChild(stylize(createPath(points), 'none', 'black', 0.5,  1));

	var points = closedpath(bases).map(cameraproject.bind(null, [10]))
	document.getElementById('main').appendChild(stylize(createPath(points), 'none', 'red', 0.5,  1));

	vs.forEach(function(v,i) {
		var height = dottedpath(vs[i], bases[i]).map(cameraproject.bind(null, [10]));
		document.getElementById('main').appendChild(stylize(createPath(height), 'none', 'blue', 0.5,  1));
	})
}