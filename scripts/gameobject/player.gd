extends KinematicBody2D

export(float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3

signal hit
const gravity = 500

var jump_speed = 350
var is_game_start
var is_slide
var is_jump
var player_position = Vector2()
var swipe_startPos = Vector2()
var body_type = [
    {
        "body_size_x": 35,
        "body_size_y": 90,
        "body_position_x": 12,
        "body_position_y": 6,
    },
    {
        "body_size_x": 62,
        "body_size_y": 62,
        "body_position_x": 0,
        "body_position_y": 12,
    },
   ]

func _input(event):
    
    if not event is InputEventScreenTouch:
        return
    
    if event.is_pressed():
        start_detection(event.position)
    elif not $SwipeTimer.is_stopped():
        end_detection(event.position)

func _ready():
    
    is_game_start = false
    is_slide = false
    is_jump = false
    set_player_body(0)
    pass

func _process(delta):
    
    player_position.y += gravity * delta
    
    move_and_slide(player_position, Vector2(0, -1))
    for i in get_slide_count():
        var collision = get_slide_collision(i)
        if collision.collider.name == "Bird":
            print("Hit Bird")
            emit_signal("hit")
        if collision.collider.name == "Stone(S)":
            print("Hit Small Stone")
            emit_signal("hit")
        if collision.collider.name == "Stone(L)":
            print("Hit Large Stone")
            emit_signal("hit")
        if collision.collider.name == "Trunk":
            print("Hit Tree Trunk")
            emit_signal("hit")
        
    if is_game_start == true:
        $AnimatedSprite.playing = true
    
    if is_on_floor():
        is_game_start = true
        if is_slide == true:
            $AnimatedSprite.animation = "slide"
            set_player_body(1)
            yield($AnimatedSprite, "animation_finished")
            is_slide = false
            set_player_body(0)
        else:
            $AnimatedSprite.animation = "run"
    
    if is_jump == true:
        $AnimatedSprite.animation = "jump"
        is_jump = false


func set_player_body(i):
    
    $CollisionShape2D.get_shape().set_extents(Vector2(body_type[i].body_size_x, body_type[i].body_size_y))
    $CollisionShape2D.position.x = body_type[i].body_position_x
    $CollisionShape2D.position.y = body_type[i].body_position_y


func start_detection(position):
    
    swipe_startPos = position
    $SwipeTimer.start()

func end_detection(position):
    
    $SwipeTimer.stop()
    var direction = (position - swipe_startPos).normalized()
    
    if abs(direction.x) + abs(direction.y) >= MAX_DIAGONAL_SLOPE:
        return
    
    if abs(direction.y) > abs(direction.x):
        if direction.y < 0 && ((position.y - swipe_startPos.y) < -100):
            if is_on_floor():
                is_slide = false
                is_jump = true
                player_position.y = -jump_speed
        elif direction.y > 0 && ((position.y - swipe_startPos.y) > 100):
            if is_on_floor():
                is_slide = true
                is_jump = false
    else:
#		$AnimatedSprite.animation = "move"
#		if direction.x > 0 && ((position.x - swipe_startPos.x) > 80):
#			game_start = true
#			$AnimatedSprite.flip_h = false
#		elif direction.x < 0 && ((position.x - swipe_startPos.x) < -80):
#			game_start = true
#			$AnimatedSprite.flip_h = true
#		else:
#			pass
        pass
