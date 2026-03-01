extends Node

const TURN_SPEED = 40.0
const LOOK_DOWN_ANGLE = 45.0

var mapData = null
var currentRoom = null
var currentMapPos = null
var cameraRot = 0.0
var cameraDown = 0.0
var currentTurnSpeed = 0.0
var roomsVisited = {}
var aimedDirection = 0
var canTravel = false
var travelling = false
var rooms = null

func minigameEnd(win):
	var movesleft = 20
	travelling = false
	currentTurnSpeed = 0.0
	cameraDown = 0.0
	cameraRot = -aimedDirection * 90
	currentMapPos = currentMapPos + Vector2(mapGenerator.dx[aimedDirection], mapGenerator.dy[aimedDirection])
	
	while !rooms[currentMapPos] && movesleft > 0:
		movesleft -= 1
		for i in range(mapData[currentMapPos.y][currentMapPos.x].size()):
				if mapData[currentMapPos.y][currentMapPos.x][i] && i != mapGenerator.opposite[aimedDirection]:
					currentMapPos = currentMapPos + Vector2(mapGenerator.dx[i], mapGenerator.dy[i])
					aimedDirection = i
					cameraRot = -aimedDirection * 90
					break
	get_tree().change_scene_to_file("res://main3d.tscn")

func _ready() -> void:
	mapData = mapGenerator.getMapData()
	currentMapPos = mapGenerator.startPos
	rooms = mapGenerator.rooms
	
func _input(event):
	var wantMove = false
	
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_W:
				wantMove = true
			KEY_UP:
				wantMove = true
	
	if wantMove && canTravel:
		travelling = true
		await get_tree().create_timer(1).timeout
		if randf() > 0.4:
			if randf() > 0.5:
				get_tree().change_scene_to_file("res://main.tscn")
			else:
				get_tree().change_scene_to_file("res://main.tscn")
		else:
			minigameEnd(true)


func _process(delta: float) -> void:
	currentRoom = mapData[currentMapPos.y][currentMapPos.x]
	var turn = 0.0
	var cameraDownTarget = 0.0
	
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		turn += 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		turn -= 1.0
		
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		cameraDownTarget = LOOK_DOWN_ANGLE
		
	currentTurnSpeed = lerp(currentTurnSpeed, turn, delta * 4)
	cameraDown = lerp(cameraDown, cameraDownTarget, delta * 4)
	cameraRot += delta * currentTurnSpeed * TURN_SPEED
	aimedDirection = (roundi(-cameraRot / 90) % 4 + 4) % 4
		
	if abs(cameraRot - round(cameraRot / 90) * 90) < 10 && currentRoom[aimedDirection]:
		canTravel = true
	else:
		canTravel = false
