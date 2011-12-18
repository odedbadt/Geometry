voronoi = {};

voronoi.engine = function(mode, numberOfPoints, isBucketing, isMoving) {
  this.mode = mode || 'canvas';
  this.numberOfPoints = numberOfPoints;
  this.isBucketing = isBucketing;
  this.isMoving = isMoving;
  this.buckets = [];
  this.discoveredMouse = [];
  this.svgNS = 'http://www.w3.org/2000/svg';
  this.useEventHandlers = true;
}


voronoi.engine.prototype.go = function() {
  this.points = [];
  for (var i = 0; i < this.numberOfPoints; ++i) {
    this.points[i] = [Math.random(), Math.random(), Math.random() / 60 + 1 / 60,
                      Math.random() - 0.5, Math.random() - 0.5, (Math.random() - 0.5) / 5]; 

    if (this.isBucketing) {
      var b = this.getBucketIndices(this.points[i][0], this.points[i][1]);
      bucketIndex = b[0] * 10 + b[1];
      this.buckets[bucketIndex] = this.buckets[bucketIndex] || [];
      this.buckets[bucketIndex].push(i);
    }
  }
  this.selection = [];
  this.plot();
  var zis = this;
  this.lastRedraw = (new Date()).getTime();
  this.lastPertubation = (new Date()).getTime();
  this.tick = 0;
  this.profiling = {};
  window.setInterval(function() {
    zis.frame();
  }, 10);
}

voronoi.engine.prototype.plot = function() {
  this.lastRedraw = (new Date()).getTime();  
  if (this.mode == 'canvas') {
    var canvas = document.getElementById('content');
    var context = canvas.getContext('2d');    
    context.clearRect(0, 0, 600, 600);
  } else {
    var canvas = document.getElementById('canvas');
    while (canvas.hasChildNodes()) {
      canvas.removeChild(canvas.firstChild);
    }
  }
  for (var i = 0; i < this.numberOfPoints; ++i) {
    var color;
    if (this.selection[i]) {
      color = "hsl(" + (i % 256) + ",50%,50%)";        
    } else {
      color = "rgba(0,0,0,0.2)";        
    }
    var r = this.points[i][2] * 600;
    var px = this.points[i][0] * 600;
    var py = this.points[i][1] * 600;
    if (this.mode == 'canvas') {
      context.fillStyle = color;
      context.beginPath();
      context.arc(px - r / 2, py - r / 2, r, 0, Math.PI * 2, true);
      context.closePath();
      context.fill();
    } else {
      var newCircle = document.createElementNS(this.svgNS, 'circle');
      newCircle.setAttribute('cx', px);
      newCircle.setAttribute('cy', py);
      newCircle.setAttribute('r', r);
      newCircle.setAttribute('fill', color); 
      if (this.useEventHandlers) {
        console.log(i);
        newCircle.onmouseover = function() {console.log(1);}
        newCircle.onmouseout = function() {console.log(1);}
      }
      canvas.appendChild(newCircle);
    }
  }
}


voronoi.engine.prototype.eventHandlerForCircle = function(index, isOver) {
  var zis = this;
  if (isOver) {
    return function() {
      zis.selection[index] = 1;
      zis.plotSelection()
    }
  } else {
    return function() {
      delete(zis.selection[index]);
      zis.plotSelection()
    }    
  }
}


voronoi.engine.prototype.plotSelection = function() {
  if (this.mode == 'canvas') {
    var canvas = document.getElementById('content');
    var context = canvas.getContext('2d');    
  } else {
    var canvas = document.getElementById('canvas');
  }
  if (this.mode == 'canvas') {
    this.plot();
  } else {    
    for (var i in this.plottedSelection) {
      canvas.childNodes[i].setAttribute('fill', "rgba(0,0,0,0.2)");
    }
    for (var i in this.selection) {
      canvas.childNodes[i].setAttribute('fill', "hsl(" + (i % 256) + ",50%,50%)");
    }
    this.plottedSelection = this.selection;
  }
}

voronoi.engine.prototype.timeToPerturb = function() {
  return ((new Date()).getTime() - this.lastPertubation) > 100;
}

voronoi.engine.prototype.frame = function() {
  if (this.isMoving && this.timeToPerturb()) {
    this.pertub();
    this.discoverSelection();
    this.plot();
  } else if (this.x != this.discoveredMouse[0] || this.y != this.discoveredMouse[1]) {
    this.discoverSelection();
    this.plotSelection();    
  }
  this.tick = this.tick + 1;
}

voronoi.engine.prototype.getBucketIndices = function(x, y) {
  var i = Math.floor(x * 10);
  var j = Math.floor(y * 10);
  return [i, j]; 
}

voronoi.engine.prototype.pertub = function() {
  this.lastPertubation = (new Date()).getTime();
  this.buckets = [];
  for (var i = 0; i < this.numberOfPoints; ++i) {
    this.points[i][0] += this.points[i][3] / 100;
    this.points[i][3] *= (this.points[i][0] < 0 || this.points[i][0] > 1) ? -1 : 1;
    this.points[i][1] += this.points[i][4] / 100;
    this.points[i][4] *= (this.points[i][1] < 0 || this.points[i][1] > 1) ? -1 : 1;    
    this.points[i][2] += this.points[i][5] / 100;
    this.points[i][5] *= (this.points[i][2] < 1 / 60 || this.points[i][2] > 1 / 30) ? -1 : 1;    
    this.points[i][2] = Math.abs(this.points[i][2]);
    if (this.isBucketing) {
      var b = this.getBucketIndices(this.points[i][0], this.points[i][1]);
      bucketIndex = b[0] * 10 + b[1];
      this.buckets[bucketIndex] = this.buckets[bucketIndex] || [];
      this.buckets[bucketIndex].push(i);
    }
  }
  this.discoverSelection();
  this.plot();
}


voronoi.engine.prototype.mousemove = function(x, y) {
  this.x = x / 600;
  this.y = y / 600;
};


voronoi.engine.prototype.click = function(x, y) {
  this.isMoving = !(this.isMoving);
};


voronoi.engine.prototype.isCircleHovered = function(i, x, y) {
  return voronoi.distance2(this.points[i], [x, y]) < this.points[i][2] * this.points[i][2];
};


voronoi.engine.prototype.discoverSelection = function() {
  this.discoveredMouse = [this.x, this.y];
  if (this.mode == 'svg' && this.useEventHandlers) {
    return;
  }
  this.selection = {};
  if (this.isBucketing) {
    var b = this.getBucketIndices(this.x, this.y);
    for (i = Math.max(0, b[0] - 1); i < Math.min(10, b[0] + 2); ++i) {
      for (j = Math.max(0, b[1] - 1); j < Math.min(10, b[1] + 2); ++j) {
        var bucket = this.buckets[i * 10 + j];
        if (bucket != undefined) {          
          for (var k = 0; k < bucket.length; ++k) {           
            if (this.isCircleHovered(bucket[k], this.x, this.y)) {
              this.selection[bucket[k]] = 1; 
            }
          }
        }
      }        
    }
  } else {
    for (var i = 0; i < this.numberOfPoints; ++i) {
      if (this.isCircleHovered(i, this.x, this.y)) {
        this.selection[i] = 1; 
      }
    }
  }
};


voronoi.distance2 = function(p1, p2) {
  return (p1[0] - p2[0]) * (p1[0] - p2[0]) + (p1[1] - p2[1]) * (p1[1] - p2[1]);
};


voronoi.init = function(mode) {
  var url = window.location.href;
  var count = (url.match(/[?&]count=(\d+)/) || [])[1] || 1000
  var isBucketing = (url.match(/[?&]bucket=(\d)/) || [])[1] || 0;
  voronoi.instance = new voronoi.engine(mode, count, 0);
  voronoi.instance.go();
};


voronoi.mousemove = function(e) {
  voronoi.instance.mousemove(e.clientX, e.clientY);
};


voronoi.click = function(e) {
  console.log(2);
  voronoi.instance.click(e.clientX, e.clientY);
};