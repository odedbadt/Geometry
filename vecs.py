#!python
from sympy import *;

def normalize(va):
  return va / va.norm()
  
def line(va,vb):
  return normalize(va.cross(vb))

def project(va, vb):
  return vb * va.dot(normalize(vb))
  
def project_to_orthogonal_plane(va, vb):
  return va - vb * (normalize(vb).dot(va))

def base(va,vb,vc):
  return normalize(project_to_orthogonal_plane(va, line(vb,vc)));
  
v1 = Matrix(((Symbol('v11'),Symbol('v12'),Symbol('v13'))))
v2 = Matrix(((Symbol('v21'),Symbol('v22'),Symbol('v23'))))
v3 = Matrix(((Symbol('v31'),Symbol('v32'),Symbol('v33'))))

v11 = base(v1, v2, v3)
v22 = base(v2, v3, v1)
v33 = base(v3, v1, v2)

l11 = line(v22,v33)
l22 = line(v33,v11)
l33 = line(v11,v22)

ang1 = l11.dot(line(v1, v2))
ang2 = l22.dot(line(v1, v2))

pprint(ang1)
pprint(ang2)


