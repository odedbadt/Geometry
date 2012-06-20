(let [
      
      sqrt (.-sqrt js/Math)
      cos (.-cos js/Math)
      sin (.-sin js/Math)  
      acos (.-acos js/Math)
      asin (.-asin js/Math)  
      atan (.-atan js/Math)
      atan2 (.-atan2 js/Math)
      minus (fn [[x1 y1] [x2 y2]] [(- x1 x2) (- y1 y2)])
      plus (fn [[x1 y1] [x2 y2]] [(+ x1 x2) (+ y1 y2)])
      pi 3.1415927
      scale 200
      cart (fn [[r a]] [(* r (cos a)) (* r (sin a))])      
      polar (fn [[x y]] [(sqrt (+ (* x x) (* y y))) (atan2 y x) ])      
      screen (fn [[x y]] [(+ (* x scale) 350) (- 350 (* y scale))])
      dscreen (fn [r] (* scale r))      
      pdisc {:cmd (concat ["arc"] (screen [0 0]) [(dscreen 1) 0 (* 2 pi) 0])}
      clear {:cmd ["clearRect" 0 0 1000 1000]}
      middle (fn [[x1 y1] [x2 y2]] [(/ (+ x1 x2) 2) (/ (+ y1 y2) 2)])      
      stroke (fn [cmd] [{:cmd ["beginPath"]} cmd {:cmd ["stroke"]}])
      fill (fn [cmd] [{:cmd ["beginPath"]} cmd {:cmd ["fill"]}])
      
      
      eline (fn [[r1 a1] [r2 a2]]
              [{:cmd (concat ["moveTo"] (screen (cart [r1 a1])))}
               {:cmd (concat ["lineTo"] (screen (cart [r2 a2])))}]
              
              )
      section (fn [[r1 a1] [r2 a2]] 
                 (let [g (- a1 a2)   
                       b (atan (/ (- (cos g) (/ (+ r2 (/ 1 r2))
                                                (+ r1 (/ 1 r1))))
                                  (sin g)))
                       a (+ b a1)
                       r (/ (+ 1 (* r1 r1)) (* 2 r1 (cos b)))                         
                       fa (- (apply atan2 (reverse (minus (cart [r1 a1]) (cart [r a])))))
                       ta (- (apply atan2 (reverse (minus (cart [r2 a2]) (cart [r a])))))
                      ]
                  (if (< r 100)
                    {:cmd (concat ["arc"] 
                                 (screen (cart [r a]))
                                 [(dscreen (sqrt (- (* r r) 1)))
                                    fa ta 
                                   (if (< (mod (+ pi pi (- fa ta)) (* 2 pi)) pi) 1 0) ]
                                 )}
                    (eline [r1 a1] [r2 a2])
                  )))
      hline (fn [[r1 a1] [r2 a2]] 
              (if (= 0 r2) 
                  [js/Infinity (+ (/ pi 2) a1)]
                  (if (= 0 r1) 
                    [js/Infinity (+ (/ pi 2) a2)]
                    (let [g (- a1 a2)   
                          b (atan (/ (- (cos g) (/ (+ r2 (/ 1 r2))
                                                (+ r1 (/ 1 r1))))
                                   (sin g)))
                          a (+ b a1)
                          r (/ (+ 1 (* r1 r1)) (* 2 r1 (cos b)))]
                    [r a]))))
      drawline (fn [[r a]] 
                 (if (< r 100)
                   {:cmd 
                       (concat ["arc"] 
                                 (screen (cart [r a]))
                                 [(dscreen (sqrt (- (* r r) 1))) 
                                  (- pi a (asin (/ 1 r)))
                                  (+ pi (- a) (asin (/ 1 r)))
                                  0]
                                 )}
                 [{:cmd (concat ["moveTo"] (screen (cart [1 (+ a (/ pi 2))])))}
                  {:cmd (concat ["lineTo"] (screen (cart [1 (- a (/ pi 2))])))}]                 
                 ))       
      mirror (fn [[rp ap :as point]
                  [rl al :as line]] 
               (if (< rl 100)
                 (let [
                     p (cart [rp ap])
                     lc (cart [rl al])
                     [dx dy] (minus p lc)
                     r1 (- (* rl rl) 1)
                     r2 (+ (* dx dx) (* dy dy))
                     rr (/ r1 r2)
                     dx2  (* dx rr)
                     dy2  (* dy rr)
                     p2 (plus lc [dx2 dy2])]
                  (polar p2))
                   [rp (+ (- ap) (* 2 al) pi)]
                 ))
      p1 [0 0]
      l1 [js/Infinity 0]
      l2 [js/Infinity (/ pi 8)]
      l3 [(sqrt (+ (sqrt 2) 1)) (/ pi 2)]
      m1 (fn [x] (mirror x l1))
      m2 (fn [x] (mirror x l2))
      m3 (fn [x] (mirror x l3))
      
      p2 (mirror p1 l3)
      p3 (mirror p2 l2)
      p4 (mirror p3 l1)
      t0 [p1 p2 p3]
      shapes [
          []
          [m1]
          [m2 m1]
          [m1 m2 m1]
          [m2 m1 m2 m1]
          [m1 m2 m1 m2 m1]
          [m2 m1 m2 m1 m2 m1]
          [m1 m2 m1 m2 m1 m2 m1]
          [m3 m2 m1]
          [m3 m1 m2 m1]
          [m3 m2 m1 m2 m1]
          [m3 m1 m2 m1 m2 m1]
          [m3 m2 m1 m2 m1 m2 m1]
          [m3 m1 m2 m1 m2 m1 m2 m1]
          [m3 m2 m1]
          [m2 m3 m1 m2 m1]
          [m2 m3 m2 m1 m2 m1]
          [m2 m3 m1 m2 m1 m2 m1]
          [m2 m3 m2 m1 m2 m1 m2 m1]
          [m2 m3 m1 m2 m1 m2 m1 m2 m1]
          [m1 m2 m3 m1 m2 m1]
          [m1 m2 m3 m2 m1 m2 m1]
          [m1 m2 m3 m1 m2 m1 m2 m1]
          [m1 m2 m3 m2 m1 m2 m1 m2 m1]
          [m1 m2 m3 m1 m2 m1 m2 m1 m2 m1]
          
          [m2 m1 m2 m3 m1 m2 m1]
          [m2 m1 m2 m3 m2 m1 m2 m1]
          [m2 m1 m2 m3 m1 m2 m1 m2 m1]
          [m2 m1 m2 m3 m2 m1 m2 m1 m2 m1]
          [m2 m1 m2 m3 m1 m2 m1 m2 m1 m2 m1]

          [m3 m2 m1 m2 m3 m1 m2 m1]
          [m3 m2 m1 m2 m3 m2 m1 m2 m1]
          [m3 m2 m1 m2 m3 m1 m2 m1 m2 m1]
          [m3 m2 m1 m2 m3 m2 m1 m2 m1 m2 m1]
          [m3 m2 m1 m2 m3 m1 m2 m1 m2 m1 m2 m1]
              
         ]      
      ]
(.log js/console (vec (map identity t0)))
(map :cmd (flatten [
         clear         
        {:cmd ["=lineWidth" 0.5]}
        (map (fn [shape] (let [
                   tri (vec (map (apply comp shape) t0))
                   color (if (= (mod (count (filter (fn [z] (= z m1)) shape)) 2) 0) "#FEE" "#FFE")
                   ]
                 (stroke [ {:cmd ["=strokeStyle" "grey"]}
                           (fill [{:cmd ["=fillStyle" color]}
                   (section (tri 0) (tri 1))
                   (section (tri 1) (tri 2))
                   (section (tri 2) (tri 0))])])))
             
              shapes)
        {:cmd ["=strokeStyle" "#333"]}
        (stroke pdisc)
        (stroke (drawline l1))
        (stroke (drawline l2))
        (stroke (drawline l3))
        {:cmd ["=strokeStyle" "red"]}
        (stroke (section ((comp m2 m1 m2 m3) p1) (m3 p1)))
        (stroke (section p1 ((comp m3 m1 m2 m1 m2 m3) p1)))
    	;(stroke (eline p1 p2))
        ])))
        
