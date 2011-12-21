

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
  if (delta > 100) {
    return [atan2(v[1], v[0]), Infinity];
  } else {
    var c0 = plus(m, scale(v, delta));
    return [atan2(c0[1], c0[0]), norm(c0)];
  }
}
function point(a) {
  return scale([Math.cos(a[0]), Math.sin(a[0])], a[1]);
}
function angle(l1,l2) {
  if (l1[1] > 10 && l2[1] > 10) {
    return s1Dist(l1[0], l2[0]);
  }
  if (l2[1] > 10) {
    return angle(l2, l1);
  }
  if (l1[1] > 10) {
    return asin(sin(PI/2 - l1[0] + l2[0]) * l2[1] / sqrt(l2[1]*l2[1]-1)) + PI/2;
  }
  var c1 = point(l1);
  var c2 = point(l2);
  var d2 = dist2(c1, c2);
  var r1 = sqrt(l1[1]*l1[1] - 1);
  var r2 = sqrt(l2[1]*l2[1] - 1);

  return acos((r1*r1 + r2*r2 - d2) / (2*r1*r2));
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
  if (l1[1] > 100 && l2[1] > 100) {
    return [0,0];
  }
  if (l2[1] > 100) {
    return intersect(l2,l1);
  }
  if (l1[1] > 100) {
    var angle = l1[0] + ((sin(l2[0] - l1[0])) > 0 ? 1 : -1)*PI/2;
    var R = l2[1];
    var r2 = R*R - 1;
      var cs = R*cos(l2[0] - l1[0]);
    if (cs*cs > r2) {
      return null;
    }
    var radius = Math.abs(R*sin(l2[0] - l1[0])) - sqrt(r2-cs*cs);
    return [angle, radius]
  }

  var u = point(l1);
  var v = point(l2);
  var rU2 = l1[1]*l1[1] - 1;
  var rV2 = l2[1]*l2[1] - 1;
  var d2 = dist2(u, v);
  var d = sqrt(d2);
  
  var a = (rU2 - rV2 + d2) / (2*d);
  if (rU2 < a*a) {
    return null;
  }
  var b = sqrt(rU2 - a*a);  
  var p0 = convexSum(u, v, a / d);
  var w = scale(normalize(J(minus(v,u))), b);
  return [plus(p0, w), minus(p0, w)].map(toPolar).filter(function(x) { return x[1] <= 1})[0];
}

function hdist(p1, p2) {
    var u = point(p1);
    var v = point(p2);
    var d1 = dist(u, v);
    var d2 = dist([1,0], point([p1[0]-p2[0], p1[1]*p2[1]]));
    
    return log((d1 + d2) / (d2 - d1));
}

function perpendicular(dot, line) {
  var R = line[1];
  var a = line[0] - dot[0];
  if (R > 10) {    
    return [line[0] - PI/2 * (sin(a) > 0 ? 1 : -1), dot[1]/Math.abs(sin(a))];
  }
  if (dot[1] < 1) {
    var p0 = perpendicular([dot[0], 1], [line[0], line[1]*dot[1]]);
    return [p0[0], p0[1]/dot[1]];
  }
  var x = (1 - cos(a)*R) / (sin(a)*R);
  return [dot[0] + atan(x), Math.sqrt(1 + x*x)];
}
function drawLine(color, l) {
		var c = lineCircleCenter(l);

		var sc = toscreen(c)
    var ps = lineAtInfinity(l);
    var a = toscreen(point(ps[0]))
    var b = toscreen(point(ps[1]))
    
//		document.getElementById('plot').appendChild(stylize(createCircle(sc[0],sc[1],sr), 'none', color, 0.5,  1));
    
    var r = lineCircleRadius(l);
    if (isFinite(r) && r < 100) {
      var sr = toscreenLength(r)  
      document.getElementById('plot').appendChild(stylize(createArc(a, b, [sr, sr, 180 - s1Dist(ps[0][0], ps[1][0]) ,0 , 1]), 'none', color, 0.5,  1));
    } else {
      document.getElementById('plot').appendChild(stylize(createPath([a, b]), 'none', color, 0.5,  1));               
    }
}
function drawDot(color, dot) {
  color = color || 'black';
  var a = toscreen(point(dot));
  document.getElementById('plot').appendChild(stylize(createCircle(a[0],a[1],4), 'none', color, 0.5,  1));
}

function ignite() {
  //var bst = findBest();
  //document.body.write('Hello');
  clear(document.getElementById('plot'));
    var center = toscreen([0,0])
    var radius = toscreenLength(1)
  document.getElementById('plot').appendChild(stylize(createCircle(center[0],center[1],radius), 'none', 'black', 0.5,  1));
  //plot([0, 1], [0.5,1],  [0.7,1]);
  //plot([0, 1], [1.7419,1],  [3.4837,1]);

  var ps =[
         [0,    0.1866,    3.2349],
         [0,    0.3110,    3.2971],
         [0,    0.3733,    0.7465],
         [0,    0.4355,    3.3593],
         [0,    0.6843,    3.4837],
         [0,    0.9331,    3.6082],
         [0,    1.7419,    3.4837],
         [0,    1.8663,    3.7326],
         [0,    1.9285,    4.1058],
         [0,    1.9907,    3.9814],
         [0,    2.0529,    4.1058],
         [0,    2.0529,    4.1681],
         [0,    2.1773,    4.2303],
         [0,    2.3018,    4.2925],
         [0,    2.9239,    5.8477],
         [0,    3.0483,    6.0966],
         [0,    3.1727,    4.7279],
         [0,    3.2971,    4.7902],
         [0 ,   4.4169 ,   5.3500]];
  go(ps, 0,PI/2, PI)
}

function go(ps, a,b,c) {
  refreshfrominputs();
  //setTimeout(function() {go(ps, a+(Math.random()-0.5)/4, b+(Math.random()-0.5)/4, c+(Math.random()-0.5)/4)}, 1000)
  
}
function refreshfrominputs() {
  clear(document.getElementById('plot'));
  var center = toscreen([0,0])
  var radius = toscreenLength(1)
  document.getElementById('plot').appendChild(stylize(createCircle(center[0],center[1],radius), 'none', 'black', 0.5,  1));
    var a = parseFloat(document.getElementById('a').value);
    var b = parseFloat(document.getElementById('b').value);
    var c = parseFloat(document.getElementById('c').value);
    plot([a,0.6],[b,1],[c,1]);
}
function plot(a, b, c) {
   


    var lbc = line(b, c);
    var lab = line(a, b);
    var lca = line(c, a);
    
    var pts = [a,b,c];
    var lines = [lbc, lca, lab];
    lines.forEach(drawLine.bind(null, ['blue']));


    var perpendiculars = pts.map(function(x,i) { return perpendicular(x, lines[i])});
    perpendiculars.forEach(drawLine.bind(null, ['red']));
    
    var intersections = lines.map(function(l, i) {return intersect(l, perpendiculars[i])});

    if (!intersections[0] || !intersections[1] || !intersections[2]) {
      return null
    }

    intersections.forEach(drawDot.bind(null, ['black']));

    var connectors = intersections.map(function(isec, i) { return line(isec, intersections[nxt(i)])})
    
    connectors.forEach(drawLine.bind(null, ['green']));

    var distances = intersections.map(function(isec, i) { return hdist(isec, intersections[nxt(i)])})
        
    var perimiter = distances.reduce(scalarplus);
    
    var angles = connectors.map(function(l, i) {return angle(l, connectors[nxt(i)]) }).map(function(x) { return Math.min(x, PI-x)});
    var dists = angles.map(function(a,i,as) {
        var a = a;
        var b = as[nxt(i)];
        var g = as[nxt(nxt(i))];

        return acosh((cos(b)*cos(g) + cos(a)) / (sin(b)*sin(g)));
    });


    document.getElementById('message').innerHTML = 'Perimiter: ' + tos(perimiter) + '<br>Anlges:' + angles.map(tos).join(',') + '<br>Dists:' + dists.map(tos).join(',');
    return perimiter;
}
function calcPerimiter(a, b, c) {
    

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
    var a = [0, 1];
    var b = [PI/100*t1*2, 1];
    var c = [PI/100*t2*2, 1];

    var perimiter = calcPerimiter(a, b, c);
    
    
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