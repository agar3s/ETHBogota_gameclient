extends Control

onready var connect_btn: Button = find_node('Connect')

func _ready():
	connect_btn.connect('button_down', self, '_on_connect')


func _on_connect():
	print('init connection')
	connect_btn.disabled = true
	GUI.popup.appear('connecting')
	yield(get_tree().create_timer(5), 'timeout')
	get_tree().change_scene("res://Lobby.tscn")
	yield(GUI.popup.dissapear(), 'completed')
	connect_btn.disabled = false
	
