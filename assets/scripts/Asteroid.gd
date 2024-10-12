extends Area2D

var direction: Vector2
var speed: float
var mass: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = Vector2( (2.0 * randf() - 1.0) , randf() )
	speed = 16.0 * randf() + 16.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
