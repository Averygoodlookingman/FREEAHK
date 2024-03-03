#NoEnv
SetWorkingDir %A_ScriptDir%
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1
CoordMode, mouse, Screen

start_script()
display := True

guiCount:=1
hoverColor := "Red"
SetTimer, hover, 1
return

1::
click_points(points1)
return

2::
click_points(points2)
return

3::
click_points(points3)
return

4::
click_points(points4)
return

^1::
hoverColor := "Red"
add_point(points1, "Red")
return

^2::
hoverColor := "Blue"
add_point(points2, "Blue")
return

^3::
hoverColor := "Green"
add_point(points3, "Green")
return

^4::
hoverColor := "Yellow"
add_point(points4, "Yellow")
return

!1::
clear_points(points1)
return

!2::
clear_points(points2)
return

!3::
clear_points(points3)
return

!4::
clear_points(points4)
return

F5::
display := !display
if (!display) {
	hide_gui()
} else {
	display_gui()
}
return

hover:
if (display) {
	MouseGetPos, currx, curry
	overlay_rect(currx, curry, width, height, 3, hoverColor, False)
}
return

F6::
ExitApp
return

clear_points(ByRef points) {
	For index, p In points
	{
		num := p.gui
		Gui %num%: Destroy
	}
	points := []
}

add_point(ByRef points, color) {
	global width, height, guiCount
	MouseGetPos, currx, curry
	num := overlay_rect(currx, curry, width, height, 3, color)
	;ToolTip, Added point,%currx%,%curry%
	x1 := currx - width/2
	x2 := currx + width/2
	y1 := curry - height/2
	y2 := curry + height/2
	points.push({"x1":x1,"y1":y1,"x2":x2,"y2":y2,"gui":num})
	
}

click_points(ByRef points) {
	MouseGetPos, currx, curry
	For index, p In points
	{
		click_box(p.x1, p.y1, p.x2, p.y2)
		Sleep, 50
	}
	MouseMove currx, curry
}

overlay_rect(X:=0, Y:=0, W:=0, H:=0, T:=3, cc:="Red", incr:=True) {
	global guiCount
	X -= W/2
	Y -= H/2
	w2:=W-T
	h2:=H-T
	txt := abs(mod(guiCount,99)+1)
	Gui %txt%: +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000 +E0x80020
	Gui %txt%: Color, %cc%
	;Gui %txt%: Font, s32
	;Gui %txt%: Add, Text, cLime, XXXXX YYYYY
	Gui %txt%: Show, w%W% h%H% x%X% y%Y% NA

	WinSet, Transparent, 150
	WinSet, Region, 0-0 %W%-0 %W%-%H% 0-%H% 0-0 %T%-%T% %w2%-%T% %w2%-%h2% %T%-%h2% %T%-%T%
	if (incr) {
		guiCount += 1  
	}
	return txt
}

hide_gui() {
	loop, 99 {
		Gui %A_Index%: Hide
	}
}

display_gui() {
	loop, 99 {
		Gui %A_Index%: +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000 +E0x80020
		Gui %A_Index%: Show
	}
}

start_script() {
	global width,height,points1,points2,points3,points4,pointsq,pointsw,pointse,pointsr
	points1 := []
	points2 := []
	points3 := []
	points4 := []
	SetTimer, RemoveToolTip, -23000
	ToolTip, Google Nom Scripts for his original scripts`nI removed his links because he released`na new free tier version of this script`nwith 2 color swaps that can only click 2 times`nit used to have 3 with unlimited clicks`nthis one allows 4 colors with unlimited clicks`nEdited by Mynameajeff`nCtrl+1/2/3/4 Add point`nAlt+1/2/3/4 Clear points`n1/2/3/4 Click points`nF6 to exit`nF5 toggle display,0,0
	width:=30
	height:=30
}

click_box(x1, y1, x2, y2) {
	ToolTip
	x += target_random(x1,(x1+x2)/2,x2)
	y += target_random(y1,(y1+y2)/2,y2)
	MouseMove, %x%, %y%, 0
	MouseClick, Left
}

rand_range(min, max) {
	Random, r, %min%, %max%
	return r
}

target_random(min, target, max){
	Random, lower, min, target
	Random, upper, target, max
	Random, weighted, lower, upper
	Return, weighted
}

RemoveToolTip:
ToolTip
return