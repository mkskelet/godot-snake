extends Node2D

class_name SnakeWorld

var applePosition = Vector2(-1, -1)
var player : Player
var apple : Sprite
var gameOver = false
var rng : RandomNumberGenerator
var appleScene
var score : int

# Called when the node enters the scene tree for the first time.
func _ready():
	# Spawn first snake block
	var p = preload("res://Player.tscn")
	player = p.instance()
	add_child(player)
	player.connect("player_collided", self, "on_player_collided")
	player.connect("apple_eaten", self, "on_apple_eaten")
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	appleScene = preload("res://Apple.tscn")
	
	restart_game()
	#end

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gameOver and Input.is_action_pressed("ui_accept"):
		restart_game()
	elif not gameOver:
		if applePosition == Vector2(-1, -1):
			# Spawn apple
			var legitPosition = false
			while not legitPosition:
				var x = rng.randi_range(1, 17)
				var y = rng.randi_range(1, 10)
				applePosition = Vector2(x * player.step, y * player.step)
				legitPosition = not player.is_player_at(applePosition)
			
			apple = appleScene.instance()
			add_child(apple)
			apple.position = applePosition
			print("- Spawning apple at: ", applePosition)

func on_player_collided():
	player.canMove = false
	gameOver = true
	$GameOver.show()

func on_apple_eaten():
	update_score(score+1)
	apple.free()
	applePosition = Vector2(-1, -1)

func restart_game() -> void:
	update_score(0)
	$GameOver.hide()
	if not apple == null:
		apple.free()
	applePosition = Vector2(-1, -1)
	player.set_grid_position(Vector2(1, 1))
	player.reset()
	gameOver = false
	player.canMove = true

func update_score(var newScore : int) -> void:
	score = newScore
	$Score.text = score as String