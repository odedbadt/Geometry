#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float norm(float p,  float x, float y) {
  return pow(pow(abs(y),p) + pow(abs(x),p), 1.0/p);
}
float norm(float p, vec2 point) {
  return norm(p, point.x, point.y);
}

vec2 normalize(float p, vec2 point) {
  return point / norm(p, point.x, point.y);
}
vec2 normal(float p, vec2 point) {
  vec2 npoint = normalize(p, point);
  return vec2(pow(abs(npoint.x), p - 1.0), pow(abs(npoint.y), p - 1.0)) * sign(point);
}
float cos2(vec2 u, vec2 v) {
  return (u.x * v.x + u.y * v.y) / (norm(2.0, u) * norm(2.0, v));
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
 
  float P = 4.0;

  P = min(max(P, 1.01), 100.0);
  float Q = 1.0 / (1.0 - 1.0/P);
  float PI = 3.141593;

  vec3 color = vec3(0.0,0.0,0.0);

  if (I >= 1.0 && I <= 2.0) {
    float alpha = x * PI;
    float beta = (x + y) * PI;
    float gamma = (x - y) * PI;

    vec2 a = normalize(P, vec2(cos(alpha), sin(alpha)));
    vec2 b = normalize(P, vec2(cos(beta), sin(beta)));
    vec2 c = normalize(P, vec2(cos(gamma), sin(gamma)));

    vec2 ab = -normal(P, b - a);
    vec2 bc = -normal(P, c - b);
    vec2 ca = -normal(P, a - c);

    float aa = pow(0.5 + 0.5 * cos2(a, normal(Q, ab - ca)), 40.0);
    float bb = pow(0.5 + 0.5 * cos2(a, normal(Q, bc - ab)), 1.0);
    float cc = pow(0.5 + 0.5 * cos2(a, normal(Q, ca - bc)), 1.0);

    if (I == 1.0 && J == 1.0) {
      color = vec3(aa,aa,aa);
    } else if (I == 1.0) {
      color = vec3(bb,bb,bb);
    } else if (J == 1.0) {
      color = vec3(cc,cc,cc);
    } else  {
      color = vec3(aa,bb,cc);
    }    
  }
  vec4 c1 = vec4( color, 1.0 );
  gl_FragColor = c1;
}