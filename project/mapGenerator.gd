extends Node

const TARGET_END_DISTANCE = 40
const dx := [0, 1, 0, -1]   #NESW
const dy := [-1, 0, 1, 0]
const opposite := [2, 3, 0, 1]

var checkpoints = {}
var rooms = {}
var startPos = null
var endPos = null
var mapData = generate_maze(40, 40, 0.2, 0.1, 0.2, 0.4)

func generate_maze(
	width: int,
	height: int,
	carve_amount: float = 0.6,
	loop_scale: float = 0.2,
	carve_prob: float = 1.0,
	checkpoint_prob: float = 0.5
) -> Array:
	
	startPos = Vector2((int)(width / 2), (int)(height / 2))
	# Each cell: [north, east, south, west]  → true = passage/open
	var maze: Array = []
	maze.resize(height)
	for y in height:
		maze[y] = []
		maze[y].resize(width)
		for x in width:
			maze[y][x] = [false, false, false, false]
	
	var visited: Array = []
	visited.resize(height)
	for y in height:
		visited[y] = []
		visited[y].resize(width)
		for x in width:
			visited[y][x] = false
	
	# Heuristic minimum carves — tries to give roughly similar feel across sizes
	var min_carves := int((width * height * 0.4 + (width + height) * 2.4) * carve_amount)
	var total_carves := [0]
	
	# ── Recursive backtracking with probabilistic / minimum carve control ─────
	var carve_wrapper: Array[Callable] = [Callable.create(0, "skibidi")]
	carve_wrapper[0] = func(x: int, y: int):
		visited[y][x] = true
		var directions = [0, 1, 2, 3]
		directions.shuffle()

		for dir in directions:
			var nx = x + dx[dir]
			var ny = y + dy[dir]
			if (
				nx >= 0 && nx < width &&
				ny >= 0 && ny < height &&
				!visited[ny][nx] &&
				(randf() < carve_prob || total_carves[0] < min_carves)):
				total_carves[0] += 1
				maze[y][x][dir] = true
				maze[ny][nx][opposite[dir]] = true
				carve_wrapper[0].call(nx, ny)

	carve_wrapper[0].call(startPos.x, startPos.y)
	
	# ── Count visited cells and collect candidates for loops ─────────────────
	var visited_count := 0
	var candidates: Array[Vector2] = []
	
	for y in height:
		for x in width:
			var conn := 0
			for b in maze[y][x]:
				if b: conn += 1
			if conn >= 1:
				visited_count += 1
				candidates.append(Vector2(x, y))
	
	# ── Phase 2: add some loops (extra connections) ──────────────────────────
	if loop_scale > 0.0 and candidates.size() > 1:
		var target_extra := int(round(loop_scale * visited_count))
		var added := 0
		var max_attempts := target_extra * 30
		
		for i in max_attempts:
			if added >= target_extra:
				break
			
			var idx := randi() % candidates.size()
			var pos: Vector2 = candidates[idx]
			var x := pos.x
			var y := pos.y
			
			var dir := randi() % 4
			var nx = x + dx[dir]
			var ny = y + dy[dir]
			
			if nx < 0 or nx >= width or ny < 0 or ny >= height:
				continue
			if maze[y][x][dir]:
				continue
			
			# Only connect to another already carved cell
			var n_conn := 0
			for b in maze[ny][nx]:
				if b: n_conn += 1
			if n_conn == 0:
				continue
			
			# Open the passage / create loop
			maze[y][x][dir] = true
			maze[ny][nx][opposite[dir]] = true
			added += 1
			
	# ── Choose end position ─────────────────────────────────────────────────
	var far_candidates = []
	var max_dist_sq := 0
	var farthest = startPos
	
	for pos in candidates:
		var dist_sq = (pos - startPos).length_squared()
				
		if dist_sq > max_dist_sq:
			max_dist_sq = dist_sq
			farthest = pos
			
		# Manhattan distance check for "far enough"
		var manhattan = abs(pos.x - startPos.x) + abs(pos.y - startPos.y)
		if manhattan >= TARGET_END_DISTANCE:
			far_candidates.append(pos)
	
	if far_candidates.size() > 0:
		# Prefer random far-away point
		endPos = far_candidates[randi() % far_candidates.size()]
	else:
		# Fallback: the actual farthest point we found
		endPos = farthest
	
	for y in height:
		for x in width:
			var conn := 0
			
			checkpoints[Vector2(x, y)] = false
			
			for b in maze[y][x]:
				if b:
					conn += 1
				
			if conn > 2 || conn < 2:
				rooms[Vector2(x, y)] = true
				
				if randf() < checkpoint_prob:
					checkpoints[Vector2(x, y)] = true
			else:
				rooms[Vector2(x, y)] = false
				
	rooms[startPos] = true
	rooms[endPos] = true
	checkpoints[startPos] = true
	checkpoints[endPos] = true
	
	return maze
	
func getMapData():
	return mapData
