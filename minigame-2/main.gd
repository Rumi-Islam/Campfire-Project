extends Node2D

var secretCode = [2,1,6,5]
var inputCode = [2,3,4,7]
var clicks = 0
var run = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.hide()
	$ColorRect2.hide()
	$ColorRect3.hide()
	
	randomize()
	var number1 = randi() % 9 + 1 
	var number2 = randi() % 9 + 1
	var number3 = randi() % 9 + 1
	var number4 = randi() % 9 + 1
	
	secretCode = [number1, number2, number3, number4]
	
	$ColorRect3/Label.text = "The code is: " + (str)(secretCode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if run:
		if clicks == 4:
		
			if secretCode == inputCode:
			
				print("ok")
				$ColorRect.show()
				run = false
					
			else:
				clicks = 0
				print("wrong")
				print("inputted code: " + (str)(inputCode))
				print("right code: " + (str)(secretCode))
				inputCode = [2,3,4,7]
				$ColorRect2.show()
				await get_tree().create_timer(2.0).timeout
				$ColorRect2.hide()
				
		



func _on_button_pressed() -> void:
	if clicks == 0:
		inputCode[0] = 1
		print("1 is " + (str)(inputCode[0]))
	elif clicks == 1:
		inputCode[1] = 1
		print("2 is " + (str)(inputCode[1]))
	elif clicks == 2:
		inputCode[2] = 1
		print("3 is " + (str)(inputCode[2]))
	elif clicks == 3:
		inputCode[3] = 1
		print("4 is " + (str)(inputCode[3]))

	print("pressed 1")
	clicks += 1



func _on_button_9_pressed() -> void:
	if clicks == 0:
		inputCode[0] = 9
		print("pressed 9")
	elif clicks == 1:
		inputCode[1] = 9
		print("pressed 9")
	elif clicks == 2:
		inputCode[2] = 9
		print("pressed 9")
	elif clicks == 3:
		inputCode[3] = 9
		print("pressed 9")

	clicks += 1


func _on_button_8_pressed() -> void:
	if clicks == 0:
		inputCode[0] = 8
	elif clicks == 1:
		inputCode[1] = 8
	elif clicks == 2:
		inputCode[2] = 8
	elif clicks == 3:
		inputCode[3] = 8

	print("pressed 8")
	clicks += 1

func _on_button_7_pressed() -> void:
	if clicks == 0:
		inputCode[0] = 7
	elif clicks == 1:
		inputCode[1] = 7
	elif clicks == 2:
		inputCode[2] = 7
	elif clicks == 3:
		inputCode[3] = 7

	print("pressed 7")
	clicks += 1

func _on_button_6_pressed() -> void:
	if clicks == 0:
		inputCode[0] = 6
	elif clicks == 1:
		inputCode[1] = 6
	elif clicks == 2:
		inputCode[2] = 6
	elif clicks == 3:
		inputCode[3] = 6

	print("pressed 6")
	clicks += 1

func _on_button_5_pressed() -> void:
	if clicks == 0:
		inputCode[0] = 5
	elif clicks == 1:
		inputCode[1] = 5
	elif clicks == 2:
		inputCode[2] = 5
	elif clicks == 3:
		inputCode[3] = 5

	print("pressed 5")
	clicks += 1


func _on_button_4_pressed() -> void:
	if clicks == 0:
		inputCode[0] = 4
	elif clicks == 1:
		inputCode[1] = 4
	elif clicks == 2:
		inputCode[2] = 4
	elif clicks == 3:
		inputCode[3] = 4

	print("pressed 4")
	clicks += 1

func _on_button_3_pressed() -> void:
	if clicks == 0:
		inputCode[0] = 3
	elif clicks == 1:
		inputCode[1] = 3
	elif clicks == 2:
		inputCode[2] = 3
	elif clicks == 3:
		inputCode[3] = 3

	print("pressed 3")
	clicks += 1
func _on_button_2_pressed() -> void:
	if clicks == 0:
		inputCode[0] = 2
	elif clicks == 1:
		inputCode[1] = 2
	elif clicks == 2:
		inputCode[2] = 2
	elif clicks == 3:
		inputCode[3] = 2


	print("pressed 2")

	clicks += 1

func _on_buttonclue_pressed() -> void:
	$ColorRect3.hide()


func _on_clue_pressed() -> void:
	$ColorRect3.show()
