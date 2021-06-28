extends Node

var groundArray = []
var groundAssetArray = [
        "res://object scene/game/Ground1.tscn",
        "res://object scene/game/Ground2.tscn",
        "res://object scene/game/Ground3.tscn",
        "res://object scene/game/Ground4.tscn",
        "res://object scene/game/Ground5.tscn",
    ]
var groundSpeed = 350


func _ready():
    
    addGroundSegment(0, 0)
    $Background.material.set_shader_param("scroll_speed", 0.01)
    pass

func _physics_process(delta):
    
    moveEnvironment(groundSpeed, delta)
    pass




# ----------------------------------- MAIN FUNCTION ------------------------------------------

func addGroundSegment(PosX, assetIndex):
    
    var ground
    ground = load(groundAssetArray[assetIndex]).instance()
    ground.position.x = PosX
    ground.get_node("LeftDetector").position.x = PosX - 96
    ground.get_node("RightDetector").position.x = PosX + 856
    ground.position.y = 810
    groundArray.push_back(ground)
    add_child(ground)


func checkGroundRightDetectorPosition(lastSegment):
    
    var groundRightSidePos = lastSegment.get_node("RightDetector").position.x
    var rightScreenDetector = OS.get_real_window_size().x * 3
    var randomAssetIndex
    
    if groundArray.size() < 5:
        if groundRightSidePos < rightScreenDetector:
            randomAssetIndex = randi() % groundAssetArray.size()
            addGroundSegment(groundRightSidePos, randomAssetIndex)


func checkGroundLeftDetectorPosition(firstSegment):
    
    var groundLeftSidePos = firstSegment.get_node("RightDetector").position.x
    var leftScreenDetector = 0
    
    if groundArray.size() == 5:
        if groundLeftSidePos < leftScreenDetector:
            groundArray.pop_front().queue_free()


func moveEnvironment(speed, deltaTime):
    
    for groundSegment in groundArray:
        groundSegment.position.x -= speed * deltaTime
        groundSegment.get_node("LeftDetector").position.x -= speed * deltaTime
        groundSegment.get_node("RightDetector").position.x -= speed * deltaTime




# --------------------------------- SIGNAL ----------------------------------------------------

func on_LeftGroundCheckTimer_timeout():
    
    checkGroundLeftDetectorPosition(groundArray.front())
    pass


func on_RightGroundCheckTimer_timeout():
    
    checkGroundRightDetectorPosition(groundArray.back())
    pass


func on_Player_hit():
    
    $Player.queue_free()
    $Background.material.set_shader_param("scroll_speed", 0.00)
    groundSpeed = 0
    pass
