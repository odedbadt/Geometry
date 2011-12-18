

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
function line(d1, d2) {
  /*if (d1[1] == 1 && d2[1] == 1) {
    return [s1Middle(d1[0], d2[0]), 1 / Math.cos(s1Dist(d1[0], d2[0]) / 2)];
  }*/
  var u1 = point(d1);
  var u2 = point(d2);
  var m = middle(u1, u2);
  var v = J(minus(u2, u1));

  var delta = (norm2(u1) + 1 - 2*dot(m, u1)) / (2*dot(v, u1));
  var c0 = plus(m, scale(v, delta));
  return [atan2(c0[1], c0[0]), norm(c0)];
}
function point(a) {
  return scale([Math.cos(a[0]), Math.sin(a[0])], a[1]);
}
function lineAtInfinity(line) {
  var a = lineCircleAlpha(line);
  var R = lineCircleDistToCenter(line);
  return [[a - acos(1/R), 1], [a + acos(1/R), 1]];
}
function intersect(l1,l2) {
  var r1 = l1[1];
  var r2 = l2[1];
  var alpha = l2[0] - l1[0];

  var beta = atan(r2*sin(alpha), (r1 - r2 * cos(alpha)));

  var d2 = r1*r1 + r2*r2 - 2*r1*r2*cos(alpha);
  var gamma = acos()
  // (x-u1,x-u1) = r1*r1 - 1
  //(x-u2,x-u2) = r2*r2 - 1
  //
  // norm2(x)+norm2(u1)-2(x,u1) = r1*r1-1
  // norm2(x)+norm2(u2)-2(x,u2) = r2*r2-1
  //
  // norm2(u1)-norm2(u2)-2(x,u1)+2(x,u2) = r1*r1-r2*r2
  // (x,u2-u1) = (r1*r1-r2*r2) / (n2(u1) - n2(u2))
  //
  // norm2(x)+norm2(u2)-2(x,u2) = r2*r2-1


}
function perpendicular(dot, line) {
  if (dot[1] < 1){
    return null
  } else {
    var R = lineCircleDistToCenter(line);
    var a = lineCircleAlpha(line) - dot[0];
    var x = (1 - cos(a)*R) / (sin(a)*R);
    return [dot[0] + atan(x), Math.sqrt(1 + x*x)]
  }
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
    
    
    document.getElementById('main').appendChild(stylize(createArc(a, b, [sr, sr, 180 - s1Dist(ps[0][0], ps[1][0]) ,0 , 1]), 'none', color, 0.5,  1));
    
    document.getElementById('main').appendChild(stylize(createCircle(a[0],a[1],10), 'none', color, 0.5,  1));
    document.getElementById('main').appendChild(stylize(createCircle(b[0],b[1],10), 'none', color, 0.5,  1));
}


function ignite() {

  go(0);
}
function go(t) {
  var a = [0, 1];
  var b = [PI/2 + Math.sin(t*7/20)*2, 1];
  var c = [PI/3 + Math.sin(t*5/20)*3, 1];
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
  setTimeout(function() {go(t+0.3)}, 100);
  
}