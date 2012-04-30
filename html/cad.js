cad = {};


cad.state = {
	drawn: {},
	pending: {},
	countdown: 0
};

cad.pendingState = {};

cad.keyup = function(textarea) {
	cad.state.pending.commands = cad.state.editor.getSession().getValue();
	cad.state.countdown = 10;
};

cad.loop = function() {
	if (cad.state.countdown > 0) {
		cad.state.countdown = cad.state.countdown - 1;
	}
	if (cad.state.countdown == 0) {
		cad.flushPending();
		cad.state.countdown = -1;
	}
}

cad.flushPending = function() {
	if (cad.state.pending.commands != cad.state.drawn.commands) {
		cad.draw(cad.state.pending.commands);
		cad.save(cad.state.pending.commands);
	}
}

cad.ignite = function() {

	cad.state.editor = ace.edit("commands");
    cad.state.editor.getSession().setMode("ace/mode/javascript");
    cad.state.editor.setTheme("ace/theme/chrome");
	cad.state.editor.getSession().on('change', cad.keyup);
	cad.load();
	setInterval(cad.loop, 50);	
}

cad.draw = function(command) {
	var commandArray;
    document.getElementById('error').value = '';	
    document.getElementById('error').style['backgroundColor'] = '#FFE';	
    var states = ['Evaluating', 'Executing'];
    var state = 0;
	try {
		commandArray = (Function.apply(null, [keys(cad.helpers), command])).apply(null, values(cad.helpers));
		state = 1;
		canvas.execute(canvas.context(), commandArray)
	    document.getElementById('error').style['backgroundColor'] = 'white';	
	} catch(e) {
	  document.getElementById('error').style['backgroundColor'] = '#FEE';	
	  document.getElementById('error').value = states[state] + '\n' + e + '\n' + e.stack.toString();

	  if (commandArray) {
	  	console.log(commandArray);
	  }
	}
}

cad.save = function(commands) {
	window.localStorage.setItem('cad.commands', commands);
}
cad.load = function() {
	cad.state.pending.commands = window.localStorage.getItem('cad.commands');
	cad.state.countdown = 0;
	cad.state.editor.getSession().setValue(cad.state.pending.commands);
}

cad.helpers = {
	'alf': 105
}



cad.helpers.clear = function(x, y, w, h) {
    return [['clearRect', x, y, w, h]].concat(copyArgs(arguments, 4));
}
cad.helpers.line = function(segments) {
  var cmds = [];
  cmds.push(['beginPath']);

   if (arguments.length == 1) {
   	 cmds.push(['moveTo', segments[0][0], segments[0][1]]);
   	 for (var i = 1; i < segments.length; i++) {
 	   cmds.push(['lineTo', segments[i][0], segments[i][1]]);
   	 }
   } else {   	
   	 cmds.push(['moveTo', arguments[0], arguments[1]]);
   	 for (var i = 2; i < arguments.length; i+=2) {
 	   cmds.push(['lineTo', arguments[i], arguments[i+1]]);
   	 }
   }
   cmds.push(['stroke']);
   return cmds;
}

cad.helpers.rangeMap = function(f, n) {
  cmds = [];
  for (var i = 0; i < n; ++i) {
   	  cmds.push(f(i));
   }
   return cmds;
};

cad.helpers.group = function() {    
   return copyArgs(arguments);
};
cad.helpers.style = function(style) {	
   return [style, copyArgs(arguments, 1)];
};