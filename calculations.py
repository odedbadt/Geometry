#!python
from sympy import *;

def cosine_law(a,b,c,A):
  return cos(c)*cos(b) + sin(c)*sin(b)*cos(A)

def cosine_square_law(a,b,c,A):
  return cos(c)**2*cos(b)**2 + cos(a)**2 - 2 * cos(a)*cos(b)*cos(c) - (1 - cos(c)**2) * (1 - cos(b)**2)*cos(A)**2
  
def angle_calcer(side1, side2, infront):
  x = Symbol('x');
  s1 = Symbol('s1');
  s2 = Symbol('s2');
  infr = Symbol('infr');
  return acos(solve(cosine_square_law(infr, s1, s2, x), cos(x))[0]).subs({s1:side1, s2:side2, infr:infront});
  
def infront_calcer(side1, side2, angle):
  x = Symbol('x');
  s1 = Symbol('s1');
  s2 = Symbol('s2');
  ang = Symbol('ang');
  return acos(solve(cosine_square_law(x, s1, s2, ang), cos(x))[0]).subs({s1:side1, s2:side2, ang:angle});

  
def vertex_to_height_base_equation(aa, bb, cc):  
  a = Symbol('a1');
  b = Symbol('b1');
  c = Symbol('c1');
  h = Symbol('h1');
  y = Symbol('y1');
  x = Symbol('x1');
  eq1 = cos(x)**2 + cos(h)**2 - cos(b)**2;
  eq2 = cos(y)**2 + cos(h)**2 - cos(c)**2;
  eq3 = (cos(a)**2 + cos(x)**2 + cos(y)**2 - 1)**2 - 4*cos(a)**2*cos(x)**2*cos(y)**2
    
    
  csy2 = solve(eq1 - eq2, cos(y))[0]**2;
  w = Symbol('w')
  eq4 = eq3.subs(cos(y)**2, w).subs(cos(y)**2, w).subs(w, csy2)
  
  
  eq5 = eq4.subs(cos(x)**2, w);
  
  return acos(sqrt(solve(eq5, w)[0].subs({a:aa,b:bb,c:cc})));
  
  
def reflection_angle(a,b,c):
  a1 = vertex_to_height_base_equation(a, b, c)
  b1 = vertex_to_height_base_equation(b, a, c)
  
  A = angle_calcer(a,b,c)
  k = infront_calcer(a1, b1, A);
  pprint(N(a1))
  pprint(N(k))
  pprint(N(b1))
  
  
  return angle_calcer(a1,k,b1)
  
def main():
  print()
  pprint(N(reflection_angle(pi/2,pi/2,pi/2)))
  
  
  #pprint(N(vertex_to_height_base_equation(0.8,0.8,0.8)))
  
main()



  
#def ang(ca,cb,cc):
  #cA = Symbol('cA');
  #cB = Symbol('cB');
  #cC = Symbol('cC');

  #tmp = Symbol('tmp');


  #def swap(exp,s1,s2):
    #return exp.subs({s1:tmp}).subs({s2:s1}).subs({tmp:s2});

  #cA2 = solve(cosine_law(ca,cb,cc,cA), cA)[1]**2;
  #cB2 = cA2.subs({ca:cb, cb:cc,cc:ca});
  #cC2 = cA2.subs({ca:cc, cb:ca,cc:cc});


  #cab = Symbol('cab');
  #cac = Symbol('cac');

  #cba = Symbol('cba');
  #cbc = Symbol('cbc');

  #cca = Symbol('cca');
  #ccb = Symbol('ccb');



  #cab2 = solve((ca*ca + cab * cab * cac * cac - 2 * ca * cab * cac - (1 - cab**2) * (1 - cac**2)).subs({cac: cab * cc/cb}), cab)[1]**2
  #cac2 = swap(cab2, cb, cc);

  #cba2 = swap(cab2, ca, cb);
  #cbc2 = swap(cac2, ca, cb);

  #ccb2 = swap(cab2, ca, cc);
  #cca2 = swap(cac2, ca, cc);


  #caA = Symbol('caA');
  #cx = Symbol('cx');
  
  #caA2 = solve(cosine_law(caA,cbc,ccb,caA), caA)[0] ** 2;

  #cx2 = solve(cosine_law(cx,ccb,caA,cbc), cx)[0] ** 2;
  
  #cx2_0 = cx2.subs({caA: sqrt(caA2)});
  #cx2_1 = simplify(cx2_0)
   
  #return cx2_1.subs({ccb:sqrt(ccb2), cbc:sqrt(cbc2)});
