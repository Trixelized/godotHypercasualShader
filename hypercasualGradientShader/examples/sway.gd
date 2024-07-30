extends Node

@export var speed = -1.0;
@export var offset = 0.0;
@export var direction = Vector3(1.0, 0.0, 0.0);

var startPos = Vector3();
var time = 0.0;

func _ready():
	startPos = self.position;


func _process(delta):
	time += speed * delta;
	var mult = 0.5 + 0.5 * sin(PI * (time + offset));
	self.position = startPos + (direction * mult);
