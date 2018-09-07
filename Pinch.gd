extends Node

signal pinch

export (int) var percision = 10

var first_distance =0
var events={}
var last_distance

func _ready():
    set_process_unhandled_input(true)

func is_zooming():
    return events.size()>1

func get_distance(p1, p2):
    return sqrt(pow(p1.x + p2.x, 2) + pow(p1.y + p2.y, 2))

func dist():
    var first_event = null
    var result 
    for index in events:
        if first_event != null:
            result = events[index].position.distance_to(first_event.position)
            break
        first_event = events[index]
    return result

func get_center(p1, p2):
    return Vector2((p1.x + p2.x) / 2, (p1.y + p2.y) / 2)

func _input(event):
    if event is InputEventScreenTouch and event.pressed:
        events[event.index]=event

        if events.size() > 1:
            first_distance = dist()
            center = center()

    elif event is InputEventScreenTouch and not event.pressed:
        last_distance = null
        events.erase(event.index)

    elif event is InputEventScreenDrag:
        events[event.index] = event

        if events.size() > 1:
            var pos1 = events[0].position
            var pos2 = events[1].position
            var second_distance = dist()

            if last_distance != null and abs(first_distance - second_distance) > percision:

                if last_distance > second_distance:
                    emit_signal('pinch', get_center(pos1, pos2), last_distance - second_distance, pos1, pos2)

            last_distance = pos1.distance_to(pos2)