function saveInt(arr, index, value)
{
    arr[index] =  (value >> 24);
    arr[index + 1] = (value >> 16);
    arr[index + 2] = (value >> 8);
    arr[index + 3] = (value);
    return Math.round(value);
}

function saveShort(arr, index, value)
{
    arr[index] = (value >> 8);
    arr[index + 1] = (value);
    return Math.round(value);
}

function loadInt(arr, index)
{
    return Math.round(arr[index] * 16777216 + arr[index + 1] * 65536 + arr[index + 2] * 256 + arr[index + 3]);
}

function loadShort(arr, index)
{
    return Math.round(arr[index] * 256 + arr[index + 1]);
}

MotorPacket = function(command, address){
    this.address = address;
    this.command = command;
    this.line = 0;
    this.value = 0;
    this.speed = 0;
    this.paramA = 0;
    this.paramB = 0;
}


MotorPacket.parse = function(data){
    if (data == null) return null;
    var obj = new MotorPacket(data[2], loadShort(data[0]));
    obj.date = new Date();
    obj.value = loadInt(data, 3);
    obj.limit = loadInt(data, 7);
    obj.state = loadShort(data, 11);
    obj.paramA = data[13];
    obj.paramB = data[14];
    return obj;
};

MotorPacket.prototype.serialize = function(){
    var bytes = [];
    bytes[0] = this.command;
    saveInt(bytes, 1, this.value);
    saveShort(bytes, 5, this.speed);
    bytes[7] = this.paramA;
    bytes[8] = this.paramB;
    return bytes;
};

MotorPacket.Commands =
    {
        Null: 0,
        Go: 1,
        Rebase: 2,
        Stop: 3,
        State: 0,
        Move: 5,
        Pause: 6,
        Resume: 7,
        Spindle1: 8,
        Spindle2: 9,
        Error: 16
    }

MotorPacket.Symbols = ['N', 'G', 'B', 'S', 'I', 'M', 'P', 'R','S','S'];

module.exports = MotorPacket;

