var pnorm = function(p, v) {
  return pow(
      v.map(comp(rcurry(pow, p), abs)).reduce(scalarplus),
      1/p);
}

var pnormalize = function(p, v) {
  var nrm  = pnorm(p, v);
  return scale(1/nrm, v);
}

var pnormal = function(p, v) {
    return v.map(function(x) {
        return pow(abs(x), p - 1) * sign(x);
    });
}
N = 50
var convex = function(p){
  return range(N+1).map(function(i) {
     return pnormalize(p, toCartesian(i/N * PI * 2, 1));
  });
};
  

var toscreen = comp(curry(plus, [300,300]),
                    curry(scale, 150));
var a = 0*PI;
var b = 0.7*PI;

var c = 0.2*PI;
var d = 0.6*PI;

var P = 3;
var Q = 1/(1-1/P);

var orbitP = [a,b,a+PI,b+PI,a].map(
    comp(curry(pnormalize, P), rcurry(toCartesian, 1)));

var orbitQ = [];
for (var i = 0; i < 4; ++i) {
    orbitQ.push(pnormal(P, pnormalize(P, 
        minus( orbitP[i],orbitP[i+1] ))));
};
orbitQ.push(orbitQ[0]);
var dual = convex(Q);
return clear(600,600,
 style({'strokeStyle': 'grey'}, line(convex(P).map(toscreen))),
 style({'strokeStyle': 'grey'}, line(convex(Q).map(toscreen))),
 style({'strokeStyle': 'blue'}, line(orbitP.map(toscreen))),
 /*orbit.map(
     comp(line,
         function(x) { return dual.map(
            function(y) {
                return toscreen(plus(x, scale(0.2,y)))
            })}
     )),*/
 orbitP.map(function(x) {
     return style({'strokeStyle': 'blue'}, 
        line([x, plus(x, scale(0.2, minus(pnormal(P, x))))].map(toscreen))
     )    
 }),
 orbitQ.map(function(x) {
     return style({'strokeStyle': 'green'}, 
        line([x, plus(x, scale(0.2, minus(pnormal(Q, x))))].map(toscreen))
     )    
 }),
 style({'strokeStyle': 'green'},
    line(orbitQ.map(toscreen))
 )
);
