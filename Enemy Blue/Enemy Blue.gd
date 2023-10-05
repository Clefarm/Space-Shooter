extends CharacterBody2D

var Bullet = load("res://Enemy_Blue/enemy_blue_bullet.gd")
var health = 15
var y_positions = [110,160,250,510,555]
var initial_position = Vector2.ZERO
var direction = Vector2(1.7,0)
var wobble = 40.0


func _ready():
	initial_position.x = -200
	initial_position.y = y_positions[randi() % y_positions.size()]
	position = initial_position

func _physics_process(_delta):
	position += direction
	position.y = initial_position.y + sin(position.x/30)*wobble
	if position.x > Global.VP.x + 200:
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
		Global.update_score(500)
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		damage(100)
		body.damage(100)

