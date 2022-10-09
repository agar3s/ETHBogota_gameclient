extends Spatial

onready var card = find_node('Card')

func _ready():
	pass

func reveal():
	$AnimationPlayer.play("flip")

func face_down():
	$AnimationPlayer.play_backwards("flip")

func set_card(_card):
	card.copy_attrs(_card)
