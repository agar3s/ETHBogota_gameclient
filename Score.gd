extends HBoxContainer

export(int) var current_score = 0 setget set_score

func _ready():
	pass

func set_score(_score):
	if _score == current_score or _score > 3: return
	current_score = _score
	if _score == 0:
		$Point1.modulate = Color('838383')
		$Point2.modulate = Color('838383')
		$Point3.modulate = Color('838383')
		return
	var child = get_child(_score - 1)
	$Tween.interpolate_property(child, 'modulate', Color('838383'), Color.green, 0.15)
	$Tween.interpolate_property(child, 'modulate', Color.green, Color('838383'), 0.15, 0, 2, 0.15)
	$Tween.interpolate_property(child, 'modulate', Color('838383'), Color.green, 0.15, 0, 2, 0.3)
	$Tween.interpolate_property(child, 'modulate', Color.green, Color('838383'), 0.15, 0, 2, 0.45)
	$Tween.interpolate_property(child, 'modulate', Color('838383'), Color.green, 0.15, 0, 2, 0.6)
	$Tween.start()


