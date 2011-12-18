function generateSVGElement(name) {
  return document.createElementNS("http://www.w3.org/2000/svg", name);
}
function createCircle(x, y, r) {
	var circle = generateSVGElement('circle');
	circle.setAttribute('cx', tos(x));
	circle.setAttribute('cy', tos(y));
	circle.setAttribute('r', tos(r));
	return circle;
}
function stylize(element, fill, color, strokeWidth, opacity) {
	element.setAttribute('opacity', opacity);
	element.setAttribute('stroke-width', strokeWidth);
	element.setAttribute('stroke', color);
	element.setAttribute('fill', fill);
	return element;
}
function createPath(points) {
	var path = generateSVGElement('path');
	path.setAttribute('d', 'M' + points.map(function(p){return tos(p[0])+','+tos(p[1])}).join('L'))
	return path;
}

function createArc(from, to, rest) {
  var path = generateSVGElement('path');
  path.setAttribute('d', 'M' + from.map(tos).join(',') + 'A' + rest.map(tos).join(',') + ',' + to.map(tos).join(','));
  return path;
}

function tos(d) {
	return Math.round(d*100) / 100;
}

function clear(d) {
  while (d.firstChild) {
    d.removeChild(d.firstChild);
  }
}