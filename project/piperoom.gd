extends Node3D

const TURN_SPEED = 40.0
const LOOK_DOWN_ANGLE = 45.0

var mapDisplay = null
var mapData = null
var startMapPos = null
var endMapPos = null
var currentMapPos = null
var mapUnitSize = null
var currentPos = null
var currentRoom = null
var checkpoints = null
var rooms = null

func drawMapRect(pos, size, color, name = null, pivot = null):
	var rect = ColorRect.new()
	
	if name:
		rect.name = name
	
	rect.color = color
	rect.size = Vector2(size.x * mapUnitSize.x, size.y * mapUnitSize.y)
	rect.position = Vector2(mapUnitSize.x * (pos.x - size.x * 0.5) + mapDisplay.size.x * 0.5, mapUnitSize.y * (pos.y - size.y * 0.5) + mapDisplay.size.y * 0.5)
	mapDisplay.add_child(rect)
	
	if pivot:
		rect.pivot_offset = rect.size * 0.5 + pivot * mapUnitSize

func _ready() -> void:
	mapDisplay = get_node("Player").get_node("Map").get_node("SubViewport").get_node("Control").get_node("Display")
	mapData = mapGenerator.getMapData()
	currentMapPos = mapTraveller.currentMapPos
	startMapPos = mapGenerator.startPos
	endMapPos = mapGenerator.endPos
	checkpoints = mapGenerator.checkpoints
	rooms = mapGenerator.rooms
	mapUnitSize = Vector2(50, 50)
	currentRoom = mapData[currentMapPos.y][currentMapPos.x]
	get_node("PipeN").visible = false
	get_node("PipeS").visible = false
	get_node("PipeE").visible = false
	get_node("PipeW").visible = false
	
	if currentRoom[0]:
		get_node("PipeN").visible = true
	if currentRoom[1]:
		get_node("PipeE").visible = true
	if currentRoom[2]:
		get_node("PipeS").visible = true
	if currentRoom[3]:
		get_node("PipeW").visible = true
		
	
	for y in mapData.size():
		for x in mapData[0].size():
			var hasNorth = mapData[y][x][0]
			var hasSouth = mapData[y][x][2]
			var hasEast = mapData[y][x][1]
			var hasWest = mapData[y][x][3]
			
			if hasNorth or hasSouth or hasEast or hasWest:
				var sectionColor = Color(0.15, 0.15, 0.15)
				var drawX = x - currentMapPos.x
				var drawY = y - currentMapPos.y
						
				if rooms[Vector2(x, y)]:
					sectionColor = Color(0.1, 0.2, 0.3)
					
				if Vector2(x, y) == startMapPos:
					sectionColor = Color(0.0, 0.2, 1.0)
				if Vector2(x, y) == endMapPos:
					sectionColor = Color(0.0, 1.0, 0.4)
				
				if hasNorth:
					drawMapRect(Vector2(drawX, drawY - 0.25), Vector2(0.2, 0.5), sectionColor)
				if hasSouth:
					drawMapRect(Vector2(drawX, drawY + 0.25), Vector2(0.2, 0.5), sectionColor)
				if hasEast:
					drawMapRect(Vector2(drawX + 0.25, drawY), Vector2(0.5, 0.2), sectionColor)
				if hasWest:
					drawMapRect(Vector2(drawX - 0.25, drawY), Vector2(0.5, 0.2), sectionColor)
					
				#if checkpoints[Vector2(x, y)] && Vector2(x, y) != startMapPos && Vector2(x, y) != endMapPos:
				#	drawMapRect(Vector2(drawX, drawY), Vector2(0.5, 0.5), Color(0.5, 0.4, 0.2))
				#else:
				drawMapRect(Vector2(drawX, drawY), Vector2(0.4, 0.4), sectionColor)
	drawMapRect(Vector2(0, -0.2), Vector2(0.2, 0.6), Color(1.0, 0.0, 0.0), "PlayerIndicator", Vector2(0.0, 0.2))
			

func _process(delta: float) -> void:
	mapDisplay.get_node("PlayerIndicator").rotation = deg_to_rad(-mapTraveller.cameraRot)
	get_node("Player").rotation = Vector3(0, deg_to_rad(mapTraveller.cameraRot), 0)
	get_node("Player").get_node("Camera").rotation = Vector3(deg_to_rad(-mapTraveller.cameraDown), 0, 0)
	
	if mapTraveller.canTravel:
		get_node("Player").get_node("TravelIndicator").visible = true
	else:
		get_node("Player").get_node("TravelIndicator").visible = false
	if mapTraveller.travelling:
		get_node("Player").get_node("Camera").position = Vector3(0, 6, -4.5)
		get_node("Player").rotation = Vector3(0, 0, 0)
		get_node("Player").get_node("Camera").rotation = Vector3(0, 0, 0)
