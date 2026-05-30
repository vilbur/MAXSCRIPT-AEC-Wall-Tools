/* Description: ProBoolean Cut implementation for WallTools
Version: 0.01
*/

fn pressButtonPB theButton =
(
	local btn
	desktopChildrenHWNDs = UIAccessor.getChildWindows 0
	maxHWND = undefined
	max modify mode
	for i = 1 to desktopChildrenHWNDs.count do 
	(
		local windowTitle = UIAccessor.getWindowText desktopChildrenHWNDs[i]
		if (matchPattern windowTitle pattern:"Command Panel") then ( maxHWND = desktopChildrenHWNDs[i] )
	)
	
	for c in (windows.getChildrenHWND maxHWND) where c[5] == theButton do btn = c
	UIAccessor.PressButton btn[1]
	max create mode
)

------------------GET WALL FROM SELECTION
fn GetW objArray = 
(
	local TheWalls = #()
	if classof objArray == ObjectSet or classof objArray == NodeChildrenArray then objArray = for o in objArray collect o
	if classof objArray != array then objArray = #(objArray)
	TheWalls = for o in objArray where custAttributes.get o 1 != undefined and o.wType == "Wall" collect o
	TheWalls	
)

------------------GET OPERANDS FROM SELECTION
fn GetO objArray = 
(
	local TheOperands = #()
	if classof objArray == ObjectSet or classof objArray == NodeChildrenArray then objArray = for o in objArray collect o
	if classof objArray != array then objArray = #(objArray)
	TheOperands = for o in objArray where custAttributes.get o 1 != undefined and o.wType == "Operand" collect o	
	TheOperands	
)

fn CleanUp = 
(
	ObjArray = for o in objects where (custAttributes.get o 1) != undefined collect o
	-- Routine for orphaned operands and boolean states...
)