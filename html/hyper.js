


function toscreen(p) {
	return [300 + p[0]*200, 300 - p[1]*200];
}
function toscreenLength(p) {
	o = toscreen([0, 0])
	p1 = toscreen([p, 0])

	return Math.abs(p1[0] - o[0]);
}

function lineCircleAlpha(line) {
  return line[0];
}
function lineCircleDistToCenter(line) {
  return line[1];
}
function lineCircleRadius(line) {
  return Math.sqrt(line[1]*line[1] - 1)
}
function lineCircleCenter(l) {
  return scale([Math.cos(l[0]), Math.sin(l[0])], l[1]);
}
function s1Middle(a1, a2) {
  var a = ((a1 + a2) / 2) % (PI*2);
  return (s1Dist(a, a1) < PI/2) ? a : (a + PI) % (PI*2);
}
function s1Dist(a1, a2) {
  var d = (2*PI + a2 - a1) % (2*PI);
  return d > PI ? 2*PI - d : d;
}
function line(a1, a2) {
	return [s1Middle(a1, a2), 1 / Math.cos(s1Dist(a1, a2) / 2)];
}
function point(a) {
  return [Math.cos(a), Math.sin(a)];
}
function lineAtInfinity(line) {
  var a = lineCircleAlpha(line);
  var R = lineCircleDistToCenter(line);
  return [a - acos(1/R), a + acos(1/R)];
}

function perpendicular(dot, line) {
    var R = lineCircleDistToCenter(line);
    var a = lineCircleAlpha(line) - dot;
    var x = (1 - cos(a)*R) / (sin(a)*R);
    return [dot + Math.atan(x), Math.sqrt(1 + x*x)]
}
function drawLine(l, color) {
		var c = lineCircleCenter(l);
		var r = lineCircleRadius(l);
		var sc = toscreen(c)
		var sr = toscreenLength(r)
    var ps = lineAtInfinity(l);
    var a = toscreen(point(ps[0]))
    var b = toscreen(point(ps[1]))
    
//		document.getElementById('main').appendChild(stylize(createCircle(sc[0],sc[1],sr), 'none', color, 0.5,  1));
    
    
    document.getElementById('main').appendChild(stylize(createArc(a, b, [sr, sr, 180 - s1Dist(ps[0], ps[1]) ,0 , 1]), 'none', color, 0.5,  1));
    
    document.getElementById('main').appendChild(stylize(createCircle(a[0],a[1],10), 'none', color, 0.5,  1));
    document.getElementById('main').appendChild(stylize(createCircle(b[0],b[1],10), 'none', color, 0.5,  1));
}


function ignite() {

  go(0);
}
function go(t) {
  var a = PI / 4 + Math.sin(t*3/20);
  var b = PI + Math.sin(t*7/20);
  var c = PI * 1.75 + Math.sin(t*5/20);
/*	var v1 = [1, 0];

	var v2 = [Math.cos(a), Math.sin(a)];
	var v3 = [Math.cos(b), Math.sin(b)];*/


	var center = toscreen([0,0])
	var radius = toscreenLength(1)

  clear(document.getElementById('main'));
	document.getElementById('main').appendChild(stylize(createCircle(center[0],center[1],radius), 'none', 'black', 0.5,  1));

//	drawLine(0, PI/2)
	[[a,b],[b,c],[c,a]].forEach(function(x) {
		drawLine(line(x[0], x[1]), 'blue')
	});
  drawLine(perpendicular(a, line(b,c)), 'red')
  drawLine(perpendicular(b, line(c,a)), 'red')
  drawLine(perpendicular(c, line(a,b)), 'red')
  //setTimeout(function() {go(t+0.1)}, 100);
  
}