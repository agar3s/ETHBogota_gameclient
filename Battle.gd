extends Control

onready var card_test = find_node('CardTest')

onready var my_card_1 = find_node('MyCard1')
onready var my_card_2 = find_node('MyCard2')
onready var my_card_3 = find_node('MyCard3')
onready var op_card_1 = find_node('OpponentCard1')
onready var op_card_2 = find_node('OpponentCard2')
onready var op_card_3 = find_node('OpponentCard3')
onready var main_card = $Overlay.find_node('Card')

onready var my_card_in_play = $Battleground/CardA.find_node('CardInPlay')
onready var opponent_card_in_play = $Battleground/CardB.find_node('CardInPlay')

onready var play_card_btn: Button = find_node('PlayCard')
onready var reject_card_btn: Button = find_node('RejectCard')

var selected_card = null

func _ready():
	#card_test.reveal()
	my_card_1.connect('card_selected', self, '_on_card_selected', [my_card_1])
	my_card_2.connect('card_selected', self, '_on_card_selected', [my_card_2])
	my_card_3.connect('card_selected', self, '_on_card_selected', [my_card_3])
	#yield(get_tree().create_timer(2), "timeout")
	play_card_btn.connect('button_down', self, '_on_card_played')
	reject_card_btn.connect('button_down', self, '_on_card_return')
	
	$Player/AnimationPlayer.play("Intro")
	yield($Player/AnimationPlayer, "animation_finished")


func _on_card_selected(card):
	selected_card = card
	print('animate cad')
	if selected_card == my_card_1:
		$Player/AnimationPlayer.play("ChooseCard0")
	if selected_card == my_card_2:
		$Player/AnimationPlayer.play("ChooseCard1")
	if selected_card == my_card_3:
		$Player/AnimationPlayer.play("ChooseCard2")
	#$Player/AnimationPlayer.play("darken")
	main_card.copy_attrs(selected_card)
	print(main_card)

func _on_card_played():
	$Player/AnimationPlayer.play("PlayCard")
	yield($Player/AnimationPlayer, 'animation_finished')
	my_card_in_play.set_card(selected_card)
	my_card_in_play.show()
	my_card_in_play.face_down()
	
	yield(get_tree().create_timer(2.0), "timeout")
	_on_opponent_play_card()
	yield(get_tree().create_timer(2.5), "timeout")
	_reveal_cards()

func _on_card_return():
	my_card_1.locked = false
	my_card_2.locked = false
	my_card_3.locked = false
	if selected_card == my_card_1:
		$Player/AnimationPlayer.play_backwards("ChooseCard0")
		yield($Player/AnimationPlayer, 'animation_finished')
	if selected_card == my_card_2:
		$Player/AnimationPlayer.play_backwards("ChooseCard1")
		yield($Player/AnimationPlayer, 'animation_finished')
	if selected_card == my_card_3:
		$Player/AnimationPlayer.play_backwards("ChooseCard2")
		yield($Player/AnimationPlayer, 'animation_finished')	
	selected_card.rect_scale = Vector2(1.0, 1.0)
	selected_card = null

func _on_opponent_play_card():
	randomize()
	var options = [op_card_1, op_card_2, op_card_3]
	var card = options[randi() % 3]
	var _original_pos = card.rect_position
	$Tween.interpolate_property(card, 'rect_position', _original_pos, Vector2(249, 190), 0.3)
	$Tween.interpolate_property(card, 'rect_scale', Vector2(1.0, 1.0), Vector2(1.1, 1.1), 0.3)
	$Tween.start()
	yield($Tween, "tween_completed")
	opponent_card_in_play.visible = true
	card.visible = false
	card.rect_position = _original_pos


func _reveal_cards():
	#opponent_card_in_play.reveal()
	#my_card_in_play.reveal()
	$Player/AnimationPlayer.play("Resolve")
	yield($Player/AnimationPlayer, "animation_finished")
	$Player/AnimationPlayer.play("win")
	yield($Player/AnimationPlayer, "animation_finished")
	yield(get_tree().create_timer(1.5), 'timeout')
	$Player/AnimationPlayer.play("endturn")

func _reset_arena():
	my_card_1.locked = false
	my_card_2.locked = false
	my_card_3.locked = false
	selected_card.rect_scale = Vector2(1.0, 1.0)
	op_card_1.show()
	op_card_1.rect_scale = Vector2(1.0, 1.0)
	op_card_2.show()
	op_card_2.rect_scale = Vector2(1.0, 1.0)
	op_card_3.show()
	op_card_3.rect_scale = Vector2(1.0, 1.0)
	selected_card.show()
	selected_card = null
	my_card_in_play.hide()
	my_card_in_play.face_down()
	$Overlay.hide()
	opponent_card_in_play.face_down()
	opponent_card_in_play.hide()
	$Overlay/Countdown.bbcode_text = ''
	
