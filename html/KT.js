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
var a = [-0.5, 1];
var b = [1, 1];

var P = 4;
var Q = 1/(1-1/P);

var orbitP = [a,b,minus(a),minus(b),a].map(curry(pnormalize, P));

var orbitQ = [];
for (var i = 0; i < 4; ++i) {
    orbitQ.push(pnormal(P, pnormalize(P, 
        minus( orbitP[i],orbitP[i+1] ))));
};
console.log(orbitQ);
orbitQ.push(orbitQ[0]);
var dual = convex(Q);
return style({'lineWidth': 0.003},
 ['setTransform', 200, 0, 0, -200, 400, 400],
 clear(-3,-3, 6, 6,
 style({'strokeStyle': 'grey'}, line(convex(P))),
 style({'strokeStyle': 'blue'},
   line(orbitP),
   style({'strokeStyle': 'purple'},
   orbitP.slice(1).map(function(dot, i) {
       var n = minus(dot, orbitP[i]);
       var m = scale(0.5, plus(dot, orbitP[i]));
       var marker = i == 2 ? 3 : 1;
       var r = [n[1]* 0.03*marker, -n[0] * 0.03*marker];
     return style({'lineWidth': 0.003*marker}, line([plus(m, r), 
                  plus(m, scale(0.03*marker, n)),
                  minus(m, r)]));
   }))
 ),
 orbitP.map(function(x) {
     var n = scale(0.6, pnormal(P, x));
     var n2 = [0.2*n[1], -0.2*n[0]];
     var toLocal = comp(curry(plus, x), curry(scale, 0.3));
     return style({'strokeStyle': '#003'}, 
        line([minus(x, n), plus(x, n)]),
        line([minus(x, n2), plus(x, n2)]),
        style({'strokeStyle': 'grey'}, 
                line(convex(Q).map(toLocal))),
        orbitQ.map(function(y) {
              var n = scale(0.2, pnormal(Q, y));
              var n2 = [0.5*n[1], -0.5*n[0]];
              var z = plus(x, scale(0.3, y));
              return style({'strokeStyle': '#6A6'}, 
                  line([minus(z, n), plus(z, n)]),
                  line([minus(z, n2), plus(z, n2)])
              )}),
        style({'strokeStyle': 'green'},
            line(orbitQ.map(toLocal))
        ),
        style({'strokeStyle': '#030'},
   orbitQ.slice(1).map(function(dot, i) {
       var n = minus(dot, orbitQ[i]);
       var m = scale(0.5, plus(dot, orbitQ[i]));
       var r = [n[1]* 0.07, -n[0] * 0.07];
     return line([plus(m, r), 
                  plus(m, scale(0.07, n)),
                  minus(m, r)].map(toLocal));
   }))
        
     )    
 }))
);
