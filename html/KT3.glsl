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
vec2 normal(vec2 point, float p) {
  return vec2(pow(abs(point.x), p - 1.0), pow(abs(point.y), p - 1.0)) * sign(point);
}
float cos2(vec2 u, vec2 v) {
  return (u.x*v.x + u.y*v.y) / norm(u,2.0) / norm(v,2.0);
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
  float Q = 1.0 / (1.0 - 1.0/P);
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

    vec2 a = normalize(vec2(cos(alpha),sin(alpha)), P);
    vec2 b = normalize(vec2(cos(beta),sin(beta)), P);

    vec2 d1 = a - b;
    vec2 d2 = a + b;

   
    vec2 s = normal(normalize(d1, P), P);
    vec2 t = normal(normalize(d2, P), P);

    float f = pow(cos2(s - t, normal(b, P)), 400.0);
    float k = pow(cos2(s + t, normal(a, P)), 400.0);


    if (I == 1.0 && J == 1.0) {
      color = vec3(0.0,0.0, 0.0);
    } else if (I == 1.0) {
      color = vec3(f,f,f);
    } else if (J == 1.0) {
      color = vec3(k,k,k);
    } else  {
      color = vec3(f,k,0);
    }
    
  }

  vec4 c1 = vec4( color, 1.0 );
  gl_FragColor = c1;

}