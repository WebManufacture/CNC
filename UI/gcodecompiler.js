GcodeCompiler = function (cnc) {
	this.cnc = cnc;
	this.x = lx;
	this.y = ly;
	this.z = lz;
	this.x = parseInt(this.x);
	this.y = parseInt(this.y);
	this.z = parseInt(this.z);
	this.speed = this.cnc.speed;
};


GcodeCompiler.Compile = function (cnc, text, callback) {
	var context = new GcodeCompiler(cnc);
	var code = context.Compile(text, callback);
	return code;
}

GcodeCompiler.prototype = {
	Compile: function (text, callback) {
	
		return code;
	}
	
}

RegisterCompiler('gcode', GcodeCompiler);