if(!settings.multipleView)
 settings.batchView=false;
settings.tex="pdflatex";
defaultfilename="summary-2";
if(settings.render < 0) settings.render=4;
settings.inlineimage=true;
settings.embed=true;
settings.outformat="";
settings.toolbar=false;
viewportmargin=(2,2);

import math;
import graph;
size (6cm);

pair hlinecenter(pair a, pair b)
{
  return (a*conj(a) - b*conj(b))/2/(xpart(a)-xpart(b));
}


import math;
import graph;
unitsize(0.5cm);
pair O = (0,0);
pair A = (0,3);
pair B = (0,9);
pair C = (4,5);

pair cAC = hlinecenter(A,C);
pair cBC = hlinecenter(B,C);
draw(arc(cAC, length(A-cAC), degrees(A-cAC), degrees(C-cAC), false));
draw(arc(cBC, length(B-cBC), degrees(B-cBC), degrees(C-cBC), false));
draw(arc(O, length(C), degrees(C), 90, true));

draw((-1,0)--(5,0));
draw((0,0)--(0,10));
viewportsize=(345.0pt,0);
