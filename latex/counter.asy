if(!settings.multipleView)
 settings.batchView=false;
settings.tex="pdflatex";
defaultfilename="counter";
if(settings.render < 0) settings.render=4;
settings.inlineimage=true;
settings.embed=true;
settings.outformat="";
settings.toolbar=false;
viewportmargin=(2,2);

import math;
import hyperbolic_geometry;
import fontsize;

unitsize(5cm);
hyperbolic_point O = hyperbolic_point(0, 0);
hyperbolic_point A = hyperbolic_point(0.4, 90);
hyperbolic_point A1 = hyperbolic_point(0.4, 270);
hyperbolic_point B = hyperbolic_point(0.2, 270);
hyperbolic_point C = hyperbolic_point(0.2, 90);
hyperbolic_point D = hyperbolic_point(0.8, 0);
hyperbolic_point E = hyperbolic_point(0.8, 180);
hyperbolic_point F = hyperbolic_point(0.6, 180);
hyperbolic_point G = hyperbolic_point(0.6, 0);


hyperbolic_line l1 = hyperbolic_normal(hyperbolic_line(O, B), B);
hyperbolic_line l2 = hyperbolic_normal(hyperbolic_line(O, C), C);
hyperbolic_line l3 = hyperbolic_normal(hyperbolic_line(O, D), D);
hyperbolic_line l4 = hyperbolic_normal(hyperbolic_line(O, E), E);

hyperbolic_line l5 = mirror(l3, hyperbolic_normal(hyperbolic_line(O, F), F));
hyperbolic_line l6 = mirror(l4, hyperbolic_normal(hyperbolic_line(O, G), G));



draw(l1.to_path(), rgb(0.7,0.7,0.7));
draw(l2.to_path(), rgb(0.7,0.7,0.7));
draw(l3.to_path(), rgb(1,0,1));
draw(l5.to_path(), rgb(0.7,0.7,0.7));

draw(hyperbolic_circle(O, A).to_path(), rgb(0,0.5,0));
draw(mirror(l3, hyperbolic_circle(O, A)).to_path(), rgb(0,1,0));


hyperbolic_point[] U = {intersection(l1, l5), intersection(l2, l5), intersection(l2, l6), intersection(l1, l6)};

draw(hyperbolic_polygon(U).to_path(), rgb(0,0,1));

draw(hyperbolic_circle(O, B).to_path());

draw(hyperbolic_segment(B, C).to_path(), rgb(1,0,0));

draw(arc(O.get_euclidean(), 1, 0, 360));

path frame = (-2,-2)--(-2,2)--(2, 2)--(2,-2)--cycle;
clip(frame);
viewportsize=(345.0pt,0);