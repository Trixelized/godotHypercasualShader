extends Node

@export var speed = -1.0;
@export var offset = 0.0;
@export var addRotation = Vector3(1.0, 0.0, 0.0);

var startRot = Vector3();
var time = 0.0;

func _ready():
	startRot = self.rotation;


func _process(delta):
	time += speed * delta;
	var mult = 0.5 + 0.5 * sin(time + offset);
	self.rotation = startRot + (addRotation * deg_to_rad(mult));
