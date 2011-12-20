

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
  return point(l)
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
function toPolar(a) {
  return [atan2(a[1], a[0]), norm(a)];
}
function lineAtInfinity(line) {
  var a = lineCircleAlpha(line);
  var R = lineCircleDistToCenter(line);
  return [[a - acos(1/R), 1], [a + acos(1/R), 1]];
}
function intersect(l1,l2) {
 
  var u = point(l1);
  var v = point(l2);
  var rU2 = l1[1]*l1[1] - 1;
  var rV2 = l2[1]*l2[1] - 1;
  var d2 = dist2(u, v);
  var d = sqrt(d2);
  
  var a = (rU2 - rV2 + d2) / (2*d);
  var b = sqrt(rU2 - a*a);  
  var p0 = convexSum(u, v, a / d);
  var w = scale(normalize(J(minus(v,u))), b);
  return [plus(p0, w), minus(p0, w)].map(toPolar).filter(function(x) { return x[1] <= 1});
}

function hdist(p1, p2) {
    var u = point(p1);
    var v = point(p2);
    var d1 = dist(u, v);
    var d2 = dist([1,0], point([p1[0]-p2[0], p1[1]*p2[1]]));
    
    return log((d1 + d2) / (d2 - d1));
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
function drawLine(color, l) {
		var c = lineCircleCenter(l);
		var r = lineCircleRadius(l);
		var sc = toscreen(c)
		var sr = toscreenLength(r)
    var ps = lineAtInfinity(l);
    var a = toscreen(point(ps[0]))
    var b = toscreen(point(ps[1]))
    
//		document.getElementById('main').appendChild(stylize(createCircle(sc[0],sc[1],sr), 'none', color, 0.5,  1));
    
    
    document.getElementById('main').appendChild(stylize(createArc(a, b, [sr, sr, 180 - s1Dist(ps[0][0], ps[1][0]) ,0 , 1]), 'none', color, 0.5,  1));
    
}
function drawDot(color, dot) {
  color = color || 'black';
  var a = toscreen(point(dot));
  document.getElementById('main').appendChild(stylize(createCircle(a[0],a[1],4), 'none', color, 0.5,  1));
}

function ignite() {
  var bst = findBest();
  //document.body.write('Hello');
  clear(document.getElementById('main'));
    var center = toscreen([0,0])
    var radius = toscreenLength(1)
  document.getElementById('main').appendChild(stylize(createCircle(center[0],center[1],radius), 'none', 'black', 0.5,  1));
  plot(bst[0],bst[1]);
  plot(bst[2],bst[3]);
  console.log(bst[4], bst[5]);
}

function plot(t1, t2) {
   var a = [0, 1];
    var b = [PI/100*t1*2, 1];
    var c = [PI/100*t2*2, 1];
   


    var lbc = line(b, c);
    var lab = line(a, b);
    var lca = line(c, a);
    
    var pts = [a,b,c];
    var lines = [lbc, lca, lab];
    lines.forEach(drawLine.bind(null, ['blue']));
    var perpendiculars = pts.map(function(x,i) { return perpendicular(x, lines[i])});
    perpendiculars.forEach(drawLine.bind(null, ['red']));
    
    var intersections = lines.map(function(l, i) {return intersect(l, perpendiculars[i])[0]});

    if (!intersections[0] || !intersections[1] || !intersections[2]) {
      return null
    }

    intersections.forEach(drawDot.bind(null, ['black']));

    connectors = intersections.map(function(isec, i) { return line(isec, intersections[nxt(i)])})
    
    connectors.forEach(drawLine.bind(null, ['green']));
}
function calcPerimiter(t1, t2) {
   var a = [0, 1];
    var b = [PI/100*t1*2, 1];
    var c = [PI/100*t2*2, 1];
    

    var center = toscreen([0,0])
    var radius = toscreenLength(1)

    var lbc = line(b, c);
    var lab = line(a, b);
    var lca = line(c, a);
    
    var pts = [a,b,c];
    var lines = [lbc, lca, lab];
    var perpendiculars = pts.map(function(x,i) { return perpendicular(x, lines[i])});
    
    var intersections = lines.map(function(l, i) {return intersect(l, perpendiculars[i])[0]});
    if (!intersections[0] || !intersections[1] || !intersections[2]) {
      return null
    }

    connectors = intersections.map(function(isec, i) { return line(isec, intersections[nxt(i)])})
    distances = intersections.map(function(isec, i) { return hdist(isec, intersections[nxt(i)])})
    
    
    var perimiter = distances.reduce(scalarplus);
    return perimiter;
}
function findBest() {
  var t1 = 1;
  var t2 = 2;
  var min = Infinity;
  var mn1 = null;
  var mn2 = null;
  var max = 0;
  var mx1 = null;
  var mx2 = null;
  
  while (true) {
   
    var perimiter = calcPerimiter(t1, t2);
    
    
    if (perimiter && perimiter < min) {
      min = perimiter;
      mn1 = t1;
      mn2 = t2;
    }
    if (perimiter && perimiter > max) {
      max = perimiter;
      mx1 = t1;
      mx2 = t2;
    }  
    
    t2 = t2 + 1;
    if (t2 > 100) {
      t1 = t1 + 1;
      t2 = t1 + 1;
    }
    if (t2 >= 100) {
      return [mn1, mn2, mx1,mx2, min, max];
    }
  }
}

function score(a,b,c) {
  
}

function mousemove(e) {
  
}