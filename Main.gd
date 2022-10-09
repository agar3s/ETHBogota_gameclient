extends Control

onready var connect_btn: Button = find_node('Connect')

func _ready():
	connect_btn.connect('button_down', self, '_on_connect')


func _on_connect():
	print('init connection')
	connect_btn.disabled = true
	GUI.popup.appear('connecting')
	Globals.request_connection()
	var peer_status = yield(Globals, 'player_connected')
	yield(get_tree().create_timer(0.1),'timeout')
	get_tree().change_scene("res://Lobby.tscn")
	connect_btn.disabled = false
	
