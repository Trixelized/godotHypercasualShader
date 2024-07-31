extends Node

@export var speed = -1.0;
@export var offset = 0.0;

var time = 0.0;

func _process(delta):
	time += speed * delta;
	self.rotation.y = PI * (time + offset);
