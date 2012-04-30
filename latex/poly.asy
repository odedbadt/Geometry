if(!settings.multipleView)
 settings.batchView=false;
settings.tex="pdflatex";
defaultfilename="poly";
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
hyperbolic_point A = hyperbolic_point(2, 0);
real d = hyperbolic_distance(O, A);


pen p = rgb(0.7,0.7,0.7);
pen darkblue = rgb(0.1,0.1,0.3);


hyperbolic_circle C = hyperbolic_circle(O, A);

real da = 180/pi * 2 * asin(1/sqrt(2)/cosh(d));

hyperbolic_point P2;

for (int i = 0; i < 360 / da; ++i)
{

	hyperbolic_point P1 = hyperbolic_point(2, (i-1)*da);
	hyperbolic_point P2 = hyperbolic_point(2, i*da);
	hyperbolic_point P3 = hyperbolic_point(2, (i+1)*da);
	
	hyperbolic_line t1 = tangent(C, P1);
	hyperbolic_line t2 = tangent(C, P2);
	hyperbolic_line t3 = tangent(C, P3);

	draw(hyperbolic_segment(O, P2), p);
	if (i > 0) {
		draw(hyperbolic_segment(O, intersection(t1,t2)), rgb(0.9,0.9,0.9));
	}

	draw(t2.to_path(), rgb(0.7,0.7,0.7));
	if (i == 2) {
		draw(hyperbolic_segment(intersection(t1,t2), intersection(t2,t3)), rgb(1,0,1));
		draw(hyperbolic_segment(O, intersection(t1,t2)), rgb(1,0.7,0.7));
		draw(hyperbolic_segment(O, P2), rgb(0,1,0));
	} else {
		draw(hyperbolic_segment(intersection(t1,t2), intersection(t2,t3)), rgb(0,0,1));
	}
}

draw(C.to_path(), p);

draw(arc(O.get_euclidean(), 1, 0, 360));

path frame = (-2,-2)--(-2,2)--(2, 2)--(2,-2)--cycle;
clip(frame);
viewportsize=(345.0pt,0);