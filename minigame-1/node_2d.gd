extends Node2D




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ProgressBar.value = $Valve/ProgressBar.value + $Valve2/ProgressBar.value + $Valve3/ProgressBar.value
