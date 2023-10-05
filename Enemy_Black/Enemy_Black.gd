extends CharacterBody2D

var Bullet = load("res://Enemy_Black/enemy_black_bullet.tscn")
var health = 25
var y_positions = [100,125,190,490,550]
var initial_position = Vector2.ZERO
var direction = Vector2(2.0,0)
var wobble = 30.0


func _ready():
	initial_position.x = -90
	initial_position.y = y_positions[randi() % y_positions.size()]
	position = initial_position

func _physics_process(_delta):
	position += direction
	position.y = initial_position.y + sin(position.x/10)*wobble
	if position.x > Global.VP.x + 100:
		queue_free()


func _on_timer_timeout():
	var Player = get_node_or_null("/root/Game/Player_Container/Player")
	var Effects = get_node_or_null("/root/Game/Effects")
	if Player != null and Effects != null:
		var bullet = Bullet.instantiate()
		var d =global_position.angle_to_point(Player.global_position) + PI/2
		bullet.rotation = d
		bullet.global_position = global_position + Vector2(0,-80).rotated(d)
		Effects.add_child(bullet)

func damage(d):
	health -= d
	if health <= 0:
		Global.update_score(1000)
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		damage(250)
		body.damage(250)
