PcbCompiler = function (cnc) {
	this.cnc = cnc;
	this.x = lx;
	this.y = ly;
	this.z = lz;
	this.x = parseInt(this.x);
	this.y = parseInt(this.y);
	this.z = parseInt(this.z);
	this.speed = this.cnc.speed;
};

PcbCompiler.Compile = function (cnc, text, callback) {
	var context = new PcbCompiler(cnc);
	var code = context.Compile(text, callback);
	return code;
}

PcbCompiler.prototype = {

    
	Compile: function (text, callback) {
	    var code = [];
		try{
    		var svg = DOM.div(".svg-codes");
    		svg.innerHTML = text;
    		svg = svg.get("svg");
    		if (!svg) return;
    		svg = WS.ExtendElement(svg);
    		var svgWidth = svg.attr("width");
    		var svgHeight = svg.attr("height");
    		var xRatio = svg.attr("x-ratio");
    		var yRatio = svg.attr("y-ratio");
    		this.speed = parseFloat(svg.attr("speed"));
    		if (isNaN(this.speed)){
    		   this.speed = cnc.Settings.speed;
    		}
    		this.freeSpeed = parseFloat(svg.attr("freeSpeed"));
    		if (isNaN(this.freeSpeed)){
    		   this.freeSpeed = this.speed;
    		   if (cnc.Settings.freeSpeed){
    		      this.freeSpeed = cnc.Settings.freeSpeed; 
    		   }
    		}
    		if (!xRatio || !yRatio){
    		   xRatio = yRatio = 1; 
    		   if (svgWidth && svgHeight){
    		       if (svgWidth.endsWith("mm")) svgWidth = svgWidth.replace("mm", '');
    		       if (svgHeight.endsWith("mm")) svgHeight = svgHeight.replace("mm", '');
    		      xRatio = parseFloat(svgWidth) / 130;
    		      yRatio = parseFloat(svgHeight) / 98;
    		   } 
    		} 
    		xRatio = parseFloat(xRatio);
    		yRatio = parseFloat(yRatio);
    		this.nx = this.cnc.mmCoefX * xRatio;
    		this.ny = this.cnc.mmCoefY * yRatio;
    		this.zg = this.cnc.zGValue;
    		if (!this.zg) this.zg = 1;
    		var paths = svg.all("path,circle,rect");
    		var i = 0;
    		this.lx = this.x;
    		this.ly = this.y;
    		this.lz = this.z;
    		this.subX = this.lx;
    		this.subY = this.ly;
    		this.averageX = 0;
    		this.averageY = 0;
            this.maxX = 0;
    		this.maxY = 0;
    		this.minX = 0;
    		this.minY = 0;
    		this.xThreshold = 10;
    		this.yThreshold = 10;
    		this.xStart =svg.attr("x-start");
    		this.yStart = svg.attr("y-start");
    		var startDef = true;
    		this.xStart = Math.round(parseFloat(this.xStart) * this.nx);
    		if (isNaN(this.xStart)){
    			startDef = false;
    			this.xStart = this.lx;
    		}				
    		this.yStart = Math.round(parseFloat(this.yStart) * this.ny);
    		if (isNaN(this.yStart)){
    			startDef = false;
    			this.yStart = this.ly;	
    		}
    		//this.addLine(code, CNC.GCommands.G, this.xStart, this.yStart, this.z);
    		for (var j = 0; j < paths.length; j++) {
    			var path = WS.ExtendElement(paths[j]);
    			if (path.tagName.toLowerCase() == "path") {
    				var res = this.processPath(path, paths[j]);
    				if (res){
    					code = code.concat(res);	
    				}
    			}			
    			//this.followStart(code);
    		}
    		this.followStart(code);
		}
		catch(error){
		    console.log("Pcb parser error:");
		    console.error(error);
		}
		return code;
	},
	
	processPath : function(elem){
		var code = [];
		var coords = elem.attr("d");
		if (!coords) {
			return null;
		}
		this.frun = true;
		var regex = "[mlcaMLCA](?:\\s*\\-?\\d+(?:[.]\\d+)?(?:e-\\d)?,\\s*\\-?\\d+(?:[.]\\d+)?(?:e-\\d)?)+|[zZ]";
		this.command = CNC.GCommands.G;
		var matches = coords.match(new RegExp(regex, 'g'));
		for (var k = 0; k < matches.length; k++) {
			var parse = matches[k]; //.match(new RegExp(regex));
			var sc = parse[0];
			if ("MLCZA".indexOf(sc) >= 0){
				this.absolute = true;
				this.command = CNC.GCommands.G;
			}
			if ("mlcza".indexOf(sc) >= 0){
				this.absolute = false;
				this.command = CNC.GCommands.M;
			}
			if (sc == 'Z' || sc == 'z'){
				this.CloseCommand(code);
				continue;
			}			
			parse = parse.substr(1);
			parse = parse.split(' ');
			var pcoords = [];
			for (var pcounter = 0; pcounter < parse.length; pcounter++){
				if (parse != ""){
					if (parse[pcounter].indexOf(",") <= 0){
						continue;
					}
					var coord = parse[pcounter].split(",");
					if (coord.length != 2){
						continue;
					}
					var x = parseFloat(coord[0]);
					var y = parseFloat(coord[1]);
					if (isNaN(x) || isNaN(y)) {
						continue;	
					}
					x = Math.round(x * this.nx);
					y = Math.round(y * this.ny);
					pcoords.push({x : x, y : y});
				}
			}
			if (sc == 'M' || sc == 'm'){
				this.MoveCommand(code, pcoords);
			}
			if (sc == 'L' || sc == 'l'){
				this.LineCommand(code, pcoords);
			}
			if (sc == 'C' || sc == 'c'){
				this.CurveCommand(code, pcoords);
			}			
		}
		return code;
	},
	
	MoveCommand : function(code, coords){
		var coord = coords[0];
		if (this.absolute){
			coord.x += this.xStart;	
			coord.y += this.yStart;	
			coord.z = this.z;
		}
		else{
			coord.z = 0;
		}
		this.addLine(code, this.command, coord.x, coord.y, coord.z, false);
		this.subX = this.x;
		this.subY = this.y;
		if (coords.length > 1){
			coords.shift();
			this.LineCommand(code, coords);
		}
	},
	
	LineCommand : function(code, coords){
		for (var pcounter = 0; pcounter < coords.length; pcounter++){
			var coord = coords[pcounter];
			if (this.absolute){
				coord.x += this.xStart;	
				coord.y += this.yStart;	
				coord.z = this.z;
			}
			else{
				coord.z = 0;
			}
			this.addLine(code, this.command, coord.x, coord.y, coord.z, true);
		}
	},
	
	CurveCommand : function(code, coords){
		var csteps = 10;
		var c0 = { x: this.x, y : this.y };
		var c1 = coords[0];
		var c2 = coords[1];
		var c3 = coords[2];
		if (this.absolute){
			c1.x += this.xStart;	
			c1.y += this.yStart;	
			c2.x += this.xStart;	
			c2.y += this.yStart;	
			c3.x += this.xStart;	
			c3.y += this.yStart;			
		}
		else{
			c1.x += c0.x;	
			c1.y += c0.y;
			c2.x += c0.x;	
			c2.y += c0.y;	
			c3.x += c0.x;	
			c3.y += c0.y;
		}
		for (var i = 1/csteps; i <= 1; i += 1/csteps){
			var o1 = {x : (c1.x - c0.x) * i + c0.x, y : (c1.y - c0.y) * i + c0.y};
			var o2 = {x : (c2.x - c1.x) * i + c1.x, y : (c2.y - c1.y) * i + c1.y};
			var o3 = {x : (c3.x - c2.x) * i + c2.x, y : (c3.y - c2.y) * i + c2.y};
			var t1 = {x : (o2.x - o1.x) * i + o1.x, y : (o2.y - o1.y) * i + o1.y};
			var t2 = {x : (o3.x - o2.x) * i + o2.x, y : (o3.y - o2.y) * i + o2.y};
			var coord = {x : (t2.x - t1.x) * i + t1.x, y : (t2.y - t1.y) * i + t1.y};
			this.addLine(code, CNC.GCommands.G, Math.round(coord.x), Math.round(coord.y), this.z, true);
		}
	},
	
	CloseCommand : function(code, coords){
	    
	},
	
	closePath : function(code){
		if (this.absolute){
			return this.addLine(code, CNC.GCommands.G, this.subX, this.subY, this.z, true);
		}
		else{
			return this.addLine(code, CNC.GCommands.M, this.subX - this.x, this.subY - this.y, this.z, true);
		}
	},
	
	followStart : function(code){
	    var xStart = 0;
	    var yStart = 0;
		var lastLine = this.addLine(code, CNC.GCommands.G, this.xStart, this.yStart, this.z, false);
	    if (this.minX < this.xStart){
	        xStart = this.xStart - this.minX;
	    }
	    if (this.minY < this.yStart){
	        yStart = this.yStart - this.minY;
	    }
	    code.unshift({ command:  CNC.GCommands.M, x: xStart, y: yStart, z: 0, speed: this.speed });
	    return lastLine;
	},
	
	addLine : function(code, command, x, y, z, spindle){
	    x = parseInt(x);
	    y = parseInt(y);
	    z = parseInt(z);
		var line = code[code.length - 1];
		if (this.frun){
			if (command == CNC.GCommands.M){
				x = x - (this.x - this.xStart);
				y = y - (this.y - this.yStart);
			}
			this.frun = false;
		}
		if (line && line.command == command){
			if (line.z == z && line.x == x && line.y == y){
				if (command == CNC.GCommands.M){
					line.x += x;
					line.y += y;
					line.z += z;
					this.x += x;
					this.y += y;
					this.z += z;	
				}
				return line;
			}
			if (command == CNC.GCommands.M){
				if (line.x == x && line.y == y) {
					line.z += z;
					this.z += z;	
					return line;
				}
				if (line.x == x && line.z == z) {
					line.y += y;
					this.y += y;	
					return line;
				}
				if (line.z == z && line.y == y) {
					line.x += x;
					this.x += x;	
					return line;
				}
			}
		}
		if (x == 0 && y == 0 && z == 0 && command == CNC.GCommands.M){
			return line;	
		}
		var newline = { command: command, x: x, y: y, z: z };
		if (command == CNC.GCommands.G){
		   newline.command = CNC.GCommands.M;
		   newline.x = newline.x - this.x;
		   newline.y = newline.y - this.y;
		   newline.z = newline.z - this.z;
		}
		if (spindle !== undefined) {
		    newline.spindleOn = spindle;
		    newline.speed = newline.spindleOn ? this.speed : this.freeSpeed;
		}
		else{
		    
		}
		if (newline.command == CNC.GCommands.M){
    		this.maxX = (this.maxX < x) ? x : this.maxX;
    		this.maxY = (this.maxY < y) ? y : this.maxY;
    		
		    if (this.maxX && code.length > 100){
    		    if (this.maxX*100 < Math.abs(x)){
    		        console.log(newline);
    		        throw "Error in line " + code.length;
    		    }
    		}
    		if (this.maxY && code.length > 100){
    		    if (this.maxY*100 < Math.abs(y)){
    		        console.log(newline);
    		        throw "Error in line " + code.length;
    		    }
    		}
		    this.x += newline.x;
			this.y += newline.y;
			this.z += newline.z;
			if (this.x < this.minX){
			    this.minX = this.x;
			}
			if (this.y < this.minY){
			    this.minY = this.y;
			}
    		this.averageX = (this.averageX * (code.length-1) + Math.abs(x)) / code.length;
    		this.averageY = (this.averageY * (code.length-1) + Math.abs(y)) / code.length;
    		
		    if (line && line.command == CNC.GCommands.M && line.spindleOn == newline.spindleOn && newline.z == line.z &&
		        Math.abs(line.x - newline.x) < this.xThreshold && 
		        Math.abs(line.y - newline.y) < this.yThreshold 
		    ){
		        line.x += newline.x;
		        line.y += newline.y;
		        line.z += newline.z;
		        console.log("line duplicate at " + code.length);
		        return line;   
		    }
		}
		if (line && line.spindleOn != newline.spindleOn){
		    code.push({ command:  CNC.GCommands.S1, x: 0, y: 0, z: 0, speed: newline.spindleOn ? 255 : 0 });
		}
		//this.speed = line.speed;
		code.push(newline);
		return newline;
	},
}

RegisterCompiler('pcb', PcbCompiler);