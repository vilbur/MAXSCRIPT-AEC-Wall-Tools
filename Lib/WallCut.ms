/*
	Description: Cut Operations for WallTools
	Version: 0.01
*/

struct WallCutStruct
(

	fn pressButtonPB theButton =
	(
		local btn = undefined
		local desktopChildrenHWNDs = UIAccessor.getChildWindows 0
		local maxHWND = undefined
		
		max modify mode

		for idx = 1 to desktopChildrenHWNDs.count do 
		(
			local windowTitle = UIAccessor.getWindowText desktopChildrenHWNDs[idx]
			if (matchPattern windowTitle pattern:"Command Panel") then 
			(
				maxHWND = desktopChildrenHWNDs[idx]
			)
		)

		for chld in (windows.getChildrenHWND maxHWND) where chld[5] == theButton do 
		(
			btn = chld
		)
		
		if btn != undefined then
		(
			UIAccessor.PressButton btn[1]
		)

		max create mode
		
		true -- return
	),

	fn GetW objArray = 
	(
		local TheWalls = #()
		
		if classof objArray == ObjectSet or classof objArray == NodeChildrenArray then 
		(
			objArray = for obj in objArray collect obj
		)
		
		if classof objArray != array then 
		(
			objArray = #(objArray)
		)

		TheWalls = for obj in objArray where custAttributes.get obj 1 != undefined and obj.wType == "Wall" collect obj
		
		TheWalls -- return
	),

	fn GetO objArray = 
	(
		local TheOperands = #()
		
		if classof objArray == ObjectSet or classof objArray == NodeChildrenArray then 
		(
			objArray = for obj in objArray collect obj
		)
		
		if classof objArray != array then 
		(
			objArray = #(objArray)
		)

		TheOperands = for obj in objArray where custAttributes.get obj 1 != undefined and obj.wType == "Operand" collect obj	
		
		TheOperands -- return
	)
)

global WallCut = WallCutStruct()