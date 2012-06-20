
                                        
                                        
// An area light (creates soft shadows)
// WARNING: This special light can significantly slow down rendering times!
light_source {
  0*x                 // light's position (translated below)
  color rgb 1.0       // light's color  
  translate <0, 0, -40>   // <x y z> position of light  
  rotate <40,10,30>
}
                   
                   
// perspective (default) camera
camera {
  location  vrotate(<0.0, 0.0, -5.0>, <40,10,30>) * 0.9
  look_at   <0.0, 0.0,  0.0>
  right     x*image_width/image_height
}

plane {<0.0,0.0,5.0>, 5.0


  pigment{ color rgb<1,1,1>}
  finish {ambient 1.0}
  
  rotate <10,10,30>

}
union {
        #declare a1 = <0.32003,  -0.99307,   0.36080>;
        #declare a2 = <0.99419,  -0.35797,  -0.28520>;
        
        #declare d1 = <-0.79976,   0.74570,   0.72852>;
        #declare d2 = <0.77351, -0.76571,   0.73900>;
        
        
        #declare a0 = a1 + 2*d1;
        #declare a3 = a2 - 2*d2;
        
        
        union {               
          cylinder {
                a1,  a2,  0.01}
          
          cylinder {
                a1 + 20*d1,  a1,  0.01}
        
          cylinder {
                a2,  a2 - 20*d2,  0.01}
          
          pigment {color rgb<1,0,0>}
          no_shadow
          // open
        }
        
        triangle {
                a0 a1 a2
          pigment {
                color rgbt<0.7,0.7,1.0, 0.1>  
          
          }                                              
          finish {ambient 0.6}    
          no_shadow
        }
        triangle {
                a1 a2 a3
          pigment {
                color rgbt<0.7,1.0,0.7, 0.1>  
          
          }                                              
          finish {ambient 0.6}    
          no_shadow
        }      
                // create a isosurface object - the equipotential surface
        // of a 3D math function f(x, y, z)
        isosurface {
          function { pow(x,4) + pow(y,4) + pow(z,4) - 1 }          // function (can also contain declared functions
          //function { fn_X(x, y, z) }        // alternative declared function
          contained_by { box { -1.2, 1.2 } }  // container shape
          //threshold 0.0                     // optional threshold value for isosurface [0.0]
          accuracy 0.001                      // accuracy of calculation [0.001]
          max_gradient 5                      // maximum gradient the function can have [1.1]
          //evaluate 5, 1.2, 0.95             // evaluate the maximum gradient
          //max_trace 1                       // maybe increase for use in CSG [1]
          //all_intersections                 // alternative to 'max_trace'
          //open                              // remove visible container surface
          
          pigment {                 
                
                 function {min(1.0, pow(mod(abs(x*10+0.5),1)*2-1,4) + pow(mod(abs(y*10+0.5),1)*2-1,4) + pow(mod(abs(z*10+0.5),1)*2-1,4))}
                      color_map {
                        [0.1  color rgbt<1,1,1,0.6>]
                        [0.6  color rgbt<0.8,0.8,0.8,0.5>]
                        [1.0  color rgbt<0.7,0.7,0.7,0.4>]
                      }
          
          }
          finish {ambient 0.0}    
          no_shadow
        }
        rotate <0,clock*10,0>
}