canvas = {};

canvas.context = function() {
    return document.getElementById('canvas').getContext('2d');
}

canvas.execute = function(ctx, commands) {
	if (!commands) {
		return;
	}
	if (typeof(commands[0]) == 'string') {
        var pf = ctx[commands[0]];
        pf.apply(ctx, commands.slice(1));		
		return;
	}
	if (typeof(commands[0]) == 'string') {
        var pf = ctx[commands[0]];
        pf.apply(ctx, commands.slice(1));		
		return;
	}
	var style = {};
    commands.forEach(function(p, i) {
		if (p instanceof Array) {
			canvas.execute(ctx, p);
			return;
		}
		for (var key in p) {
			if (!style[key]) {
				style[key] = ctx[key];
			}
			ctx[key] = p[key];
		}    	
    });
	for (var key in style) {
		ctx[key] = style[key];
	}
}





 