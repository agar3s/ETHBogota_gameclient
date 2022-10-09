extends Control
const ConnectedPlayer = preload("res://ConnectedPlayer.tscn")

onready var peer_list = find_node('Peers')

func _ready():
	# request connected users
	$Title.show()
	yield(get_tree().create_timer(1.0), 'timeout')
	load_peers()

func load_peers():
	$Title.hide()
	for child in peer_list.get_children():
		peer_list.remove_child(child)
		child.queue_free()
	
	var peers = [
		{ name='pepe el grillo', peer='45678', status=0 },
		{ name='pinoccio', peer='45678', status=1 },
		{ name='el elefante', peer='45678', status=2 }
	]
	for _peer in peers:
		print(_peer)
		var peer = ConnectedPlayer.instance()
		peer_list.add_child(peer)
		peer.player_name = _peer.name
		peer.set_player_peer_id(_peer.peer)
		peer.set_player_status(_peer.status)
