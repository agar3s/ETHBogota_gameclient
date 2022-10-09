tool
extends Control

export(String) var player_name = 'The overlord' setget set_player_name
export(String) var player_peer_id = '554asd5a4sd65' setget set_player_peer_id
export(int) var player_status = 0 setget set_player_status
var connecting = false setget set_connecting

onready var challenge_btn: Button = find_node('Challenge')
onready var player_label: RichTextLabel = find_node('Player')
onready var status_icon: TextureRect = find_node('Status')

func _ready():
	challenge_btn.connect('button_down', self, '_on_challenge')
	set_player_name(player_name)


func set_player_name(val):
	player_name = val
	if player_label:
		player_label.bbcode_text = val

func set_player_peer_id(val):
	player_peer_id = val

func set_player_status(val):
	player_status = val
	if not status_icon: return
	match val:
		'0': status_icon.modulate = Color.red
		'1': status_icon.modulate = Color.green
		'2': status_icon.modulate = Color.yellow
	challenge_btn.disabled = player_status != '1'
	
func set_connecting(val):
	connecting = val

func _on_challenge():
	connecting = true
	GUI.popup.appear('sending challenge')
	Globals.request_match(player_peer_id)
	
