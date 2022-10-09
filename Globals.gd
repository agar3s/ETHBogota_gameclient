extends Node

signal player_challenged

signal player_connected(status)
signal peers_loaded(peers)
signal peers_matched()
signal opponent_played()
signal game_revealed(action)

const REQUEST_TYPE = {
	NONE = 0,
	REGISTER_CONNECTION = 1,
	LIST_PEERS = 2,
	START_MATCH = 3,
	WAIT_FOR_CHALLENGE = 4,
	LISTEN_ACTION = 5
}

var _current_request = REQUEST_TYPE.NONE
const POOL_INTERVAL = 0.3
var _time = 0
var _cached_opponent = '{"played":false,"action":"","revealed":false}'

func request_connection():
	JavaScript.eval('startPeer()')
	_current_request = REQUEST_TYPE.REGISTER_CONNECTION

func request_peer_list():
	JavaScript.eval('requestPeerList()')
	_current_request = REQUEST_TYPE.LIST_PEERS

func request_match(_peer_id):
	JavaScript.eval('connectToPeer("%s")' % _peer_id)
	_cached_opponent = '{"played":false,"action":"","revealed":false}'
	_current_request = REQUEST_TYPE.START_MATCH

func request_new_round():
	JavaScript.eval('startNewRound()')
	_current_request = REQUEST_TYPE.LISTEN_ACTION

func send_action(action):
	JavaScript.eval('sendAction("%s")' % action)
	_current_request = REQUEST_TYPE.LISTEN_ACTION

func sync_data():
	if _current_request == REQUEST_TYPE.NONE:
		return
	
	if _current_request == REQUEST_TYPE.REGISTER_CONNECTION:
		var _peer_status = JavaScript.eval('getPeerStatus()')
		if _peer_status == 1:
			print('connecting')
		if _peer_status == 2:
			print('connected!')
			emit_signal("player_connected", _peer_status)
			_current_request = REQUEST_TYPE.NONE
		return
		
	if _current_request == REQUEST_TYPE.LIST_PEERS:
		var _json_response = JavaScript.eval('getPeerListo()')
		var _peer_list = JSON.parse(_json_response).result
		if _peer_list.loaded:
			emit_signal('peers_loaded', _peer_list.peers)
			_current_request = REQUEST_TYPE.WAIT_FOR_CHALLENGE
		return
	
	if _current_request == REQUEST_TYPE.START_MATCH or _current_request == REQUEST_TYPE.WAIT_FOR_CHALLENGE:
		var connected = JavaScript.eval('getMatchConnection()')
		if connected:
			emit_signal('peers_matched')
			_current_request = REQUEST_TYPE.NONE
	
	if _current_request == REQUEST_TYPE.LISTEN_ACTION:
		var _json_response =  JavaScript.eval('getOpponent()')
		print(_json_response)
		if _json_response == _cached_opponent: return
		var _opponent = JSON.parse(_json_response).result
		var _prev_state = JSON.parse(_cached_opponent).result
		_cached_opponent = _json_response
		if _opponent.played and _opponent.played != _prev_state.played:
			emit_signal('opponent_played')
		if _opponent.revealed and _opponent.revealed != _prev_state.revealed:
			emit_signal('game_revealed', _opponent.action)
			_current_request = REQUEST_TYPE.NONE

func _process(_delta):
	_time += _delta
	if _time >= POOL_INTERVAL:
		_time -= POOL_INTERVAL
		sync_data()

