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



  vec2 pos = ( gl_FragCoord.xy / vec2(resolution.y, resolution.y) * 4.0 + vec2(0.5,0));
  vec2 npos = ( (gl_FragCoord.xy + (1.0,1.0))/ vec2(resolution.y, resolution.y) * 4.0 + vec2(0.5,0));

  float x = mod(pos.x, 2.0)- 1.0;
  float nx = mod(npos.x, 2.0)- 1.0;

  float I = floor(pos.x / 2.0);
  float J = floor(pos.y / 2.0);

  float y = mod(pos.y, 2.0) - 1.0;
  float ny = mod(npos.y, 2.0)- 1.0;
 
  float P = max(1.0, 10.0*mouse.x+1.1);

  P = min(max(P, 1.01), 100.0);

  float PI = 3.141593;

  vec3 color;


  if (I == 0.0) {
    float v = (y + 1.0) * 2.0;
    color = vec3(v, v, v);
  } else if (I == 3.0) {
    float v = norm(vec2(x, y), P);
    color = cos(vec3(v,v*4.0,v*40.0) - 2.0);
  } else {
    float alpha = x * PI;
    float beta = y * PI;

    float nalpha = nx * PI;
    float nbeta = ny * PI;

    vec2 nu = normalize(vec2(cos(nalpha),sin(nalpha)), P);
    vec2 u = normalize(vec2(cos(alpha),sin(alpha)), P);

    vec2 v = normalize(vec2(cos(beta),sin(beta)), P);
    vec2 nv = normalize(vec2(cos(nbeta),sin(nbeta)), P);
   
    float f = (norm(u - v, P) + norm(u + v, P));
    float fnx = (norm(nu - v, P) + norm(nu + v, P));
    float fny = (norm(u - nv, P) + norm(u + nv, P));
    float dx = atan(500.0 * (fnx - f)) / PI / 2.0 + 0.5;
    float dy = atan(500.0 * (fny - f)) / PI / 2.0 + 0.5;

    if (I == 1.0 && J == 1.0) {
      color = cos(vec3(f,f*4.0,f*40.0) - 2.0);
    } else if (J == 1.0) {
      color = vec3(dx, 1.0, 0.0);
    } else if (I == 1.0) {
      color = vec3(1.0, dy, 0.0);
    } else {
      color = vec3(dx, dy, 0.0);
    }
    
  }

  vec4 c1 = vec4( color, 1.0 );
  gl_FragColor = c1;

}