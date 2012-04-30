#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float norm(float x, float y, float p) {
  return pow(pow(y,p) + pow(x,p), 1.0/p);
}
float norm(vec2 point, float p) {
  return norm(point.x, point.y, p);
}

vec2 normalize(vec2 point, float p) {
  return point / norm(point.x, point.y, p);
}

void main( void ) {
  vec2 pos = ( gl_FragCoord.xy / resolution.xy );
  vec2 mpos =  mouse;

  float p = 4.0 / 3.0;
  float q = 1.0 / (1.0 - 1.0/p);

  float x = (mod(pos.x, 0.5) - 0.25)*7.5*1.3;
  float y = (mod(pos.y, 0.5) - 0.25)*4.0*1.3;

  float mx = (mod(mpos.x, 0.5) - 0.25)*7.5*1.3;
  float my = (mod(mpos.y, 0.5) - 0.25)*4.0*1.3;


  vec2 p1 = vec2(x, y);
  vec2 p2 = normalize(vec2(mx, my), q);

  float c1 = norm(p1 - p2,p); 
  float c2 = norm(p1 + p2,p);

  float indicator1 = 1.0-exp(-5000.0*pow(norm(p1, q) - 1.0, 2.0))-5.0*exp(-50.0*norm(p1 - p2, 2.0));



  vec4 cc = vec4( (vec3(0.8-0.2* pow ( cos(40.0*c1), 30.0), 0.8-0.2* pow (cos(40.0*c2), 30.0), 0.5 )) * (indicator1)*(0.8+0.2*pow(cos(20.0*(c1+c2)),30.0)), 1.0 );
  gl_FragColor = cc;
  if (gl_FragCoord.x < p && gl_FragCoord.x+1.0 >= p) {
    gl_FragColor = vec4( vec3(1,0,1) * (c1+c2), 1.0 );
  }
} 