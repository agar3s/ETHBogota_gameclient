extends Control

export(float) var speed = 0.8
onready var message_label = find_node('Message')
var base_message = ''
var counter = 0

func appear(message):
	show()
	base_message = message
	$AnimationPlayer.play("Appear")

func dissapear():
	$AnimationPlayer.play_backwards("Appear")
	yield($AnimationPlayer, "animation_finished")
	hide()

func _process(delta):
	if !visible: return
	counter += delta
	var points = int(counter / speed)
	message_label.text = '%s%s' % [base_message, '.'.repeat(points)]
	if counter >= speed*3:
		counter -= speed*3
