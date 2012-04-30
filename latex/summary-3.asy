if(!settings.multipleView)
 settings.batchView=false;
settings.tex="pdflatex";
defaultfilename="summary-3";
if(settings.render < 0) settings.render=4;
settings.inlineimage=true;
settings.embed=true;
settings.outformat="";
settings.toolbar=false;
viewportmargin=(2,2);

size (3cm);
import math;
import hyperbolic_geometry;
unitsize(3cm);
hyperbolic_point O = hyperbolic_point(0, 0);
hyperbolic_point A = hyperbolic_point(2.7, 0);
hyperbolic_point B = hyperbolic_point(2.7, 120);
hyperbolic_point C = hyperbolic_point(2.7, 240);


hyperbolic_point D = basepoint(hyperbolic_line(B,C), A);
hyperbolic_point hE = basepoint(hyperbolic_line(C,A), B);
hyperbolic_point F = basepoint(hyperbolic_line(A,B), C);
hyperbolic_point J = intersection(hyperbolic_line(hE,F), hyperbolic_line(A,D));


draw(unitcircle);
draw(hyperbolic_segment(A,D));
draw(hyperbolic_segment(A,B));
draw(hyperbolic_segment(A,C));
draw(hyperbolic_segment(B,C));
draw(hyperbolic_segment(F,hE));
draw(hyperbolic_segment(D,hE));
draw(hyperbolic_segment(F,D));
pen p = fontsize(1);
label("$J$",J.get_euclidean(),NE,p);
label("$A$",A.get_euclidean(),E,p);
label("$B$",B.get_euclidean(),NW,p);
label("$C$",C.get_euclidean(),SW,p);
label("$D$",D.get_euclidean(),W,p);
label("$E$",hE.get_euclidean(),SE,p);
label("$F$",F.get_euclidean(),NE,p);
path frame = (-1,-1)--(-1,1)--(1, 1)--(1,-1)--cycle;
clip(frame);
viewportsize=(345.0pt,0);
