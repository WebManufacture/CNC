JsonCompiler = {};

JsonCompiler.Compile = function (cnc, code, callback) {
    if (typeof code == "string") code = JSON.parse(code);
    return code;
}

RegisterCompiler('json', JsonCompiler);