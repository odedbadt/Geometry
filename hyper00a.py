#!python
import re as regexp;
from sympy import *;
import math;

def norm2(A):
  return re(A)**2 + im(A)**2;

def dist2(A,B):
  return norm2(A - B);

def hdist(A,B):
  return acosh(1 + dist2(A,B) / (2  * im(A) * im(B)) )

  
  
def validateEqualNumerically(E1, E2S, sym, label):
  for i in range(len(E2S)):
    E2 = E2S[i];
    NULLIFIER = E1-E2S[i]
    for j in range(5):
      x = float(j)/5*pi/2l
      if i == len(E2S)-1 and j == 2:
        print x
        print N(NULLIFIER.subs(sym, x))
        print N(E1.subs(sym, x))
        print N(E2.subs(sym, x))
      dff = N(NULLIFIER.subs(sym, x))
      if abs(dff) > 0.00001:
        print("Warning: " + label + "[" + str(i) + "] evaluates to different numbers for input " + str(x) + ", diff: " + str(dff));
        break;
  
  
def lineEquations(A):
  c = Symbol('c');
  r = Symbol('r');
  return im(A)**2 + (re(A) - c)**2 - r**2

def lineEquation(A, B):
  c = Symbol('c');
  c = solve(lineEquations(A) - lineEquations(B), c)[0];
  x = Symbol('x');
  y = Symbol('y');
  return (x - c)**2 + y ** 2 - (x - A)**2
  
def ltx(exp):
  return regexp.sub('\\\operatorname\{(\w+)\}', "\g<1>", latex(exp))
def main():    
 
  a = Symbol('alpha');
      
  BB = 1 + I;  
  AA = sqrt(2 + 2 * cos(a)) * I;
  CC = (1 + cos(a)) * (1 + I);  

  print("\\documentclass[a4paper,10pt]{article}\n\\title{}\n\\author{}\n\\begin{document}\n\\maketitle\n\\begin{abstract}\n\\end{abstract}\n\\section{}");
  
  print('a =');
  print(ltx(AA));
  print("\n");
  
  print('b =');
  print(ltx(BB));
  print("\n");
  
  print('c =');
  print(ltx(CC));
  print("\n");
  
  A1 = Symbol('a');
  B1 = Symbol('b');
  C1 = Symbol('c');
  
  
  distAABB = [
    acosh(1 + dist2(A1, B1) / (2  * sqrt(2 + 2 * cos(a)) * 1) ),
#    acosh(1 + dist2(AA,BB) / (2  * sqrt(2 + 2 * cos(a)) * 1) ),
    acosh(1 + (1 + (1 - sqrt(2 + 2 * cos(a)) )**2) / (2  * sqrt(2 + 2 * cos(a)))),
    acosh(1 + (1 + 1 - 2*sqrt(2 + 2 * cos(a)) + (2 + 2 * cos(a))) / (2  * sqrt(2 + 2 * cos(a)))),
    acosh((2  + (2 + 2 * cos(a))) / (2  * sqrt(2 + 2 * cos(a)))),
    acosh((2 + cos(a)) / sqrt(2 + 2 * cos(a))),    
  ];
  distAACC = [
    acosh(1 + dist2(C1,A1) / (2 * (1 + cos(a)) * sqrt(2 + 2 * cos(a)))),
 #   acosh(1 + dist2(AA,CC) / (2 * (1 + cos(a)) * sqrt(2 + 2 * cos(a)))),
    acosh(1 + ( (1 + cos(a))**2 + ((1 + cos(a)) -  sqrt(2 + 2 * cos(a))) ** 2    ) / (2 * (1 + cos(a)) * sqrt(2 + 2 * cos(a)))),
    acosh(1 + ( 1 + 2*cos(a) + cos(a)**2 + ((1 + cos(a)) ** 2 - 2*(1+cos(a)) * sqrt(2 + 2 * cos(a)))  + 2 + 2 * cos(a)    ) / (2 * (1 + cos(a)) * sqrt(2 + 2 * cos(a)))),
    acosh(1 + ( 1 + 2*cos(a) + cos(a)**2 + 1 + cos(a) ** 2 +2*cos(a) - (2*(1+cos(a))) ** 1.5  + 2 + 2 * cos(a)    ) / (2 * (1 + cos(a)) * sqrt(2 + 2 * cos(a)))),
    acosh(1 + ( 4 + 6*cos(a) + 2*cos(a)**2 - (2*(1+cos(a))) ** 1.5 ) / (2 * (1 + cos(a)) * sqrt(2 + 2 * cos(a)))),
    acosh(1 + ( 4 + 6*cos(a) + 2*cos(a)**2 - (2*(1+cos(a))) ** 1.5 ) / (2 * (1 + cos(a))) **1.5),
    acosh(( 4 + 6*cos(a) + 2*cos(a)**2) / (2 * (1 + cos(a))) **1.5),    
    acosh(sqrt(Rational(2))*(2 + 3*cos(a) + cos(a)**2) / (1 + cos(a)) ** 1.5),
    acosh(1/sqrt(2)*(2 + 3*cos(a) + cos(a)**2) / (1 + cos(a)) ** 1.5),
    acosh((2 + cos(a)) / sqrt(2 + 2*cos(a))),
  ];
  distCCBB = [
    acosh(1 + dist2(B1,C1) / (2  * (1 + cos(a)))), 
    acosh(1 + (cos(a)**2 + cos(a)**2) / (2  * (1 + cos(a)))), 
    acosh(1 + cos(a)**2 / (1 + cos(a))), 
    acosh((1 + cos(a) + cos(a)**2) / (1 + cos(a))), 
  ];  
  print('d(a, b)');
  for eq in distAABB:
    print(' = ');
    print ltx(eq)
  print("\n");
  print('d(b, c)');
  for eq in distCCBB:
    print(' = ');
    print ltx(eq)
  print("\n");  
  print('d(c, a)');
  for eq in distAACC:
    print(' = ');
    print ltx(eq)
  print(' = ');
  print('d(a, b)');
  
  print("\n");
  
  diffDist1 = [
    ((2 + cos(a)) ** 2 / (2 + 2*cos(a))   - 1) ** -0.5 * (        (2 + cos(a)) * -0.5*(2 + 2*cos(a)) ** -1.5 * -2*sin(a)  + (-sin(a))*(2+2*cos(a))**-0.5     ),
    sqrt((2 + 2*cos(a)) / (2 + 2*cos(a) + cos(a)**2)) * (        (2 + cos(a)) * -0.5*(2 + 2*cos(a)) ** -1.5 * -2*sin(a)  + (-sin(a))*(2+2*cos(a))**-0.5     ),
    sqrt((2 + 2*cos(a)) / (2 + 2*cos(a) + cos(a)**2)) * sin(a) * (        (2 + cos(a)) / (2 + 2*cos(a))  - 1     ) / sqrt((2+2*cos(a))),
    -sqrt((2 + 2*cos(a)) / (2 + 2*cos(a) + cos(a)**2)) * sin(a) * cos(a) / (2 + 2*cos(a)) / sqrt((2+2*cos(a))),
    -sqrt((2 + 2*cos(a)) / (2 + 2*cos(a) + cos(a)**2) / (2 + 2*cos(a))**3) * sin(a) * cos(a),
    -sin(a) * cos(a) / sqrt((2 + 2*cos(a) + cos(a)**2)) / (2 + 2*cos(a)),
  ];
  diffDist2 = [
      (((1 + cos(a) + cos(a)**2) / (1 + cos(a))) ** 2 - 1)**-0.5 * (2*cos(a)*-sin(a) * (1 + cos(a)) - cos(a)**2 * -sin(a))/ (1 + cos(a))**2,
      ((( 1 + cos(a)**2/(1 + cos(a))) ** 2) - 1 )**-0.5 * (2*cos(a)*-sin(a) * (1 + cos(a)) - cos(a)**2 * -sin(a))/ (1 + cos(a))**2,  
      (2*cos(a)**2/(1 + cos(a)) + cos(a)**4/(1 + cos(a))**2)**-0.5 * (2*cos(a)*-sin(a) * (1 + cos(a)) - cos(a)**2 * -sin(a))/ (1 + cos(a))**2,
      ((2*(1 + cos(a)) + cos(a)**2)/(1 + cos(a))**2)**-0.5 /cos(a)* (2*cos(a)*-sin(a) * (1 + cos(a)) - cos(a)**2 * -sin(a))/ (1 + cos(a))**2,
      (1 + cos(a)) / sqrt((2 + 2*cos(a)) + cos(a)**2) / cos(a) * (2*cos(a)*-sin(a) * (1 + cos(a)) - cos(a)**2 * -sin(a))/ (1 + cos(a))**2,
      (1 + cos(a)) / sqrt((2 + 2*cos(a)) + cos(a)**2) / cos(a) * (2*cos(a)*-sin(a) * (1 + cos(a)) - cos(a)**2 * -sin(a))/ (1 + cos(a))**2,
      1 / sqrt((2 + 2*cos(a)) + cos(a)**2) / cos(a) * sin(a) * (cos(a)**2 - (1 + cos(a))*2*cos(a))/ (1 + cos(a)),
      -sin(a) * (cos(a) + 2) / ((1 + cos(a)) * sqrt(2 + 2*cos(a) + cos(a)**2)) ,
  ]
  totalDistDiff = [
      -sin(a) * (cos(a) + 2) / ((1 + cos(a)) * sqrt(2 + 2*cos(a) + cos(a)**2)) +  2* -sin(a) * cos(a) / sqrt((2 + 2*cos(a) + cos(a)**2)) / (2 + 2*cos(a)),
      (-sin(a) * (cos(a) + 2) - sin(a) * cos(a))/ ((1 + cos(a)) * sqrt(2 + 2*cos(a) + cos(a)**2)),
      -2*sin(a) * (1 +  cos(a))/ ((1 + cos(a)) * sqrt(2 + 2*cos(a) + cos(a)**2)),
      -2*sin(a) / sqrt(2 + 2*cos(a) + cos(a)**2),    
  ]
  print("\n");  
  
  for i in range(max(len(diffDist1), len(diffDist2))):
    print ltx((2*diffDist2[min(i, len(diffDist2)-1)]) + (diffDist1[min(i, len(diffDist1)-1)]))
    print("=");
  print("\n"); 
  
  
  print("d(b, c)");
  for eq in diffDist1:
    print(' = ');
    print ltx(eq)
    
  print("d(a, b) = d(c, a) =");
  for eq in diffDist2:
    print(' = ');
    print ltx(eq)

  print('$\\frac{d}{d\\alpha}(d(a, b) + d(b, c) + d(c, a)) = $');
    
  for eq in totalDistDiff:
    print(' = ');
    print ltx(eq)
  
  cAABB = (abs(AA)**2 - abs(BB)**2) / (2 * (re(AA) - re(BB)));
  cBBCC = (abs(BB)**2 - abs(CC)**2) / (2 * (re(BB) - re(CC)));
  cCCAA = (abs(CC)**2 - abs(AA)**2) / (2 * (re(CC) - re(AA)));
    
 
  centerAABB = [(2 + 2 * cos(a) - 2) / (2 * (0 - 1)),
    -cos(a)];
  
  centerBBCC = [(2 - 2*(1+ cos(a))**2) / (2*(1 - 1 -  cos(a))), 
    cos(a) + 2];

  centerCCAA = [(2*(1+ cos(a))**2 - (2 + 2 * cos(a))) / (2*(1+cos(a))),
    (2 + 2*cos(a)**2 + 4*cos(a) - 2 - 2*cos(a)) / (2 + 2*cos(a)),
    (    2*cos(a)**2 + 2*cos(a)) / (2 + 2*cos(a)),
    (cos(a)**2 + cos(a)) / (1 + cos(a)),
    cos(a)];

  x = Symbol('x');
  y = Symbol('y');
  
  diffEqAABB = -(x + cos(a)) / y
  diffEqBBCC = -(x - cos(a) - 2) / y
  diffEqCCAA = -(x - cos(a)) / y  
  
  a1 = -(cos(a)) /  sqrt(2 + 2 * cos(a))
  a2 =  (cos(a)) /  sqrt(2 + 2 * cos(a))
  
  b1 = -(1 + cos(a))
  b2 = -(- cos(a) - 1)
  
  c1 = -(1) / (1 + cos(a))
  c2 = -(1) / (1 + cos(a))
  print("\\end{document}");
  # dist = 2*diffDist1 + dissDist2
  
  #validateEqualNumerically(hdist(AA,BB), distAABB, a, 'AA-BB')
  #validateEqualNumerically(hdist(AA,CC), distAACC, a, 'AA-CC')
  #validateEqualNumerically(hdist(CC,BB), distCCBB, a, 'BB-CC')
  
  
  #validateEqualNumerically(diff(distAABB[-1], a), diffDist1, a, "(AA-BB)'")
  #validateEqualNumerically(diff(distAACC[-1], a), diffDist1, a, "(AA-CC)'")
  #validateEqualNumerically(diff(distCCBB[-1], a), diffDist2, a, "(BB-CC)'")
  
  
  #validateEqualNumerically(diff(distAABB[-1] + distAACC[-1] + distCCBB[-1], a), totalDistDiff, a, "(AA->BB->CC)'")
  
  #print(totalDistDiff[-2]);
  #print(totalDistDiff[-1]);
  
  #print(N(AA.subs('alpha', 1)));
  #print(N(BB.subs('alpha', 1)));
  #print(N(CC.subs('alpha', 1)));
  #print(N(totalDist.subs('alpha', 1)));
  #print(totalDist);
  
  #Fangano
  # BB = 1 + I;  
  # AA = sqrt(2 + 2 * cos(a)) * I;
  # CC = (1 + cos(a)) * (1 + I);  
  #validateEqualNumerically(diffEqAABB.subs(x, re(AA)).subs(y, im(AA)), [-diffEqCCAA.subs(x, re(AA)).subs(y, im(AA))], a, 'a');
  #validateEqualNumerically(diffEqBBCC.subs(x, re(BB)).subs(y, im(BB)), [-diffEqAABB.subs(x, re(BB)).subs(y, im(BB))], a, 'b');
  #validateEqualNumerically(diffEqCCAA.subs(x, re(CC)).subs(y, im(CC)), [-diffEqBBCC.subs(x, re(CC)).subs(y, im(CC))], a, 'c');
  
  #validateEqualNumerically(cAABB, centerAABB, a, 'centerAABB');
  #validateEqualNumerically(cBBCC, centerBBCC, a, 'centerBBCC');
  #validateEqualNumerically(cCCAA, centerCCAA, a, 'centerCCAA');
    

main();