extends Control
const ConnectedPlayer = preload("res://ConnectedPlayer.tscn")

onready var peer_list = find_node('Peers')

func _ready():
	# request connected users
	GUI.popup.dissapear()
	$Title.show()
	Globals.request_peer_list()
	var peers = yield(Globals, "peers_loaded")
	load_peers(peers)
	Globals.connect("peers_matched", self, '_on_peers_matched')
	

func load_peers(_peers):
	$Title.hide()
	for child in peer_list.get_children():
		peer_list.remove_child(child)
		child.queue_free()
	
	for _peer in _peers:
		var peer = ConnectedPlayer.instance()
		peer_list.add_child(peer)
		peer.set_player_peer_id(_peer[0])
		peer.player_name = _peer[1]
		peer.set_player_status(_peer[2])

func _on_peers_matched():
	GUI.popup.appear('New challenge!')
	yield(get_tree().create_timer(1.5), 'timeout')
	get_tree().change_scene("res://Battle.tscn")

