extends Control

const VARIATIONS = 20
const UPPER_ROW = "2/Enigmas/UpperRow"
const LOWER_ROW = "2/Enigmas/LowerRow"
const UPPER_SELECT = "3/Answers/UpperSelect"
const LOWER_SELECT = "3/Answers/LowerSelect"

var screensize

func _input(event):
    var Upper = get_node(UPPER_SELECT)
    var Lower = get_node(LOWER_SELECT)

    if event.is_action_pressed("ui_left"):
        if $Data.selecting_upper:
            Upper.move_child(Upper.get_child(0), Upper.get_child_count() - 1)
        else:
            Lower.move_child(Lower.get_child(0), Lower.get_child_count() - 1)

    if event.is_action_pressed("ui_right"):
        if $Data.selecting_upper:
            Upper.move_child(Upper.get_child(Upper.get_child_count() - 1), 0)
        else:
            Lower.move_child(Lower.get_child(Lower.get_child_count() - 1), 0)

    if event.is_action_pressed("ui_up"):
        $Data.selecting_upper = true

    if event.is_action_pressed("ui_down"):
        $Data.selecting_upper = false

    if event.is_action_pressed("ui_accept"):
        check_selection()

func _process(delta):
    $"1/ProgressBar".value = int($Timeleft.time_left) % 15

# Check the center selection against the current level
func check_selection():
    var up_ok = int(get_node(UPPER_SELECT).get_child(4).name) == $Data.upper_row[$Data.level]
    var down_ok = int(get_node(LOWER_SELECT).get_child(4).name) == $Data.lower_row[$Data.level]

    if up_ok and down_ok:
        $Data.level += 1
        $Timeleft.start()
        print($Data.level)
    else:
        print("WRONG")

# --- Timers ---

func _on_Timeleft_timeout():
    print("rip")