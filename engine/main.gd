extends Node

onready var player = get_node('player')
var GAME_OVER = false
var score = 0

var difficulty = 0

var MAX_SPIDERS = 25 
var MAX_SPAWNER_HEALTH = 20.0
var MAX_SPAWNER_HEALTH_RECOVERY = 0.5

var MAX_SPIDER_SPEED = 100
var MAX_SPIDER_DAMAGE = 2.0
var MAX_SPIDER_HEALTH = 3.0

onready var plants_graph = {}

func increaseScore():
	score += 1
	difficulty = int(score/500)
	MAX_SPIDERS = 10 + difficulty
	MAX_SPAWNER_HEALTH = 20.0 + (0.5 * difficulty)
	MAX_SPAWNER_HEALTH_RECOVERY = 0.5 + (0.1 * difficulty)

	MAX_SPIDER_SPEED = 100 + (10 * difficulty)
	MAX_SPIDER_DAMAGE = 2.0 + (0.1 * difficulty)
	MAX_SPIDER_HEALTH = 3.0 + (0.25 * difficulty)

func addNode(source, dest):
	var source_id = source.get_instance_id()
	var dest_id = dest.get_instance_id()
	if source_id in plants_graph:
		plants_graph[source_id][dest_id] = dest
	else:
		plants_graph[source_id] = { dest_id: dest }

func removeNode(node):
	var node_id = node.get_instance_id()
	for id in plants_graph:
		if node_id in plants_graph[id]:
			plants_graph[id].erase(node_id)
	plants_graph.erase(node_id)

func removeIfDetached(node):
	var node_id = node.get_instance_id()
	var queue = [node]
	var visited = { node_id: true }
 
	while queue:
		var current = queue.pop_front()
		var current_id = current.get_instance_id()

		if current == player.current_plant:
			return

		for id in plants_graph[current_id]:
			if not id in visited:
				queue.append(plants_graph[current_id][id])
				visited[id] = true

	node.destroy()

func getNeighbors(node):
	var node_id = node.get_instance_id()
	return plants_graph[node_id].values() if node_id in plants_graph else []

func gameOver():
	print('game over')
	GAME_OVER = true
	player.queue_free()

func _ready():
	randomize()
