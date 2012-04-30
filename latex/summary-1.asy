if(!settings.multipleView)
 settings.batchView=false;
settings.tex="pdflatex";
defaultfilename="summary-1";
if(settings.render < 0) settings.render=4;
settings.inlineimage=true;
settings.embed=true;
settings.outformat="";
settings.toolbar=false;
viewportmargin=(2,2);

size (3cm);
import math;
import hyperbolic_geometry;
import fontsize;

unitsize(3cm);
hyperbolic_point A = hyperbolic_point(2.7, 0);
hyperbolic_point B = hyperbolic_point(2.1, 100);
hyperbolic_point C = hyperbolic_point(1.2, 250);

draw(hyperbolic_segment(A,B));
draw(hyperbolic_segment(B,C));
draw(hyperbolic_segment(C,A));


pair EUA = A.get_euclidean();
pair EUB = B.get_euclidean();
pair EUC = C.get_euclidean();

pen p = fontsize(7.2);
label("$A$",EUA,E,p);
label("$\alpha$", (EUA.x - 0.22, EUA.y) , W, p);
label("$a$", (EUC + EUB)/2, W, p);
draw(arc(EUA, 0.35, 150, 210, true));

label("$B$",(EUB.x, EUB.y + 0.1), NW, p);
label("$\beta$", (EUB.x + 0.15, EUB.y - 0.32) , W, p);
label("$b$", (EUC + EUA)/2, SW, p);
draw(arc(EUB, 0.4, 260, 310, true));

label("$C$",(EUC.x, EUC.y - 0.05), SW, p);
label("$\gamma$", (EUC.x + 0.15, EUC.y + 0.17) , W, p);
label("$c$", (EUB + EUA)/2, SE, p);
draw(arc(EUC, 0.3, 30, 100, true));

path frame = (-1,-1)--(-1,2)--(1, 2)--(1,-1)--cycle;
clip(frame);
viewportsize=(345.0pt,0);
