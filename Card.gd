tool
extends Control

export(String) var title = 'title' setget set_title
export(Texture) var image = preload("res://Assets/001 The Scuttler.png") setget set_image
export(int) var hp = 3 setget set_hp
export(String) var type = 'Poison' setget set_type
export(int) var damage = 2 setget set_damage
export(String) var description = 'makes 2 damage to new' setget set_description
export(int) var id = 23 setget set_id

export(bool) var locked = false
export(bool) var face_down = false setget set_face_down

signal card_selected

func _ready():
	connect("mouse_entered", self, '_on_hover')
	connect("mouse_exited", self, '_on_exit')


func _on_hover():
	if locked: return
	self.rect_scale = Vector2(1.2, 1.2)

func _on_exit():
	if locked: return
	self.rect_scale = Vector2(1, 1)

func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		print('pressed')
		if !locked:
			emit_signal('card_selected')
			locked = true

func copy_attrs(_card):
	set_title(_card.title)
	set_image(_card.image)
	set_hp(_card.hp)
	set_type(_card.type)
	set_damage(_card.damage)
	set_description(_card.description)
	set_id(_card.id)

func set_title(val):
	title = val
	$Container/Title.bbcode_text = '[center]%s[/center]' % title

func set_image(val: Texture):
	image = val
	$Container/Image/Texture.texture = image

func set_hp(val):
	hp = val
	$Container/Attributes/Hp.bbcode_text = '[center]%d/%d[/center]' % [hp, hp]

func set_type(val):
	type = val
	$Container/Image/Bg/Type.bbcode_text = '[center]%s[/center]' % type
	

func set_damage(val):
	damage = val
	$Container/Attributes/Damage.bbcode_text = '[center]%d[/center]' % [damage]

func set_description(val):
	description = val
	$Container/Description/Text.bbcode_text = description

func set_id(val):
	id = val
	$Container/Id.bbcode_text = ' #%d - glomons' % id

func set_face_down(val):
	face_down = val
	$FaceDown.visible = face_down

