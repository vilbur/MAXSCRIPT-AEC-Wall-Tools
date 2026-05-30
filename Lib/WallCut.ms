/* Description: ProBoolean Cut implementation
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
	return TheWalls	-- return
)

------------------GET OPERANDS FROM SELECTION
fn GetO objArray = 
(
	local TheOperands = #()
	if classof objArray == ObjectSet or classof objArray == NodeChildrenArray then objArray = for o in objArray collect o
	if classof objArray != array then objArray = #(objArray)
	TheOperands = for o in objArray where custAttributes.get o 1 != undefined and o.wType == "Operand" collect o	
	return TheOperands	-- return
)

------------------GET COLLISION OBJECT FROM SELECTION
fn GetS objArray = 
(
	local TheSrcObj = #()
	if classof objArray == ObjectSet or classof objArray == NodeChildrenArray then objArray = for o in objArray collect o
	if classof objArray != array then objArray = #(objArray)

	TheSrcObj = for o in objArray where custAttributes.get o 1 != undefined and o.wType == "ObjSrc"  collect o	
	return TheSrcObj -- return
)

fn CleanUpWall = 
(
	local ObjArray = #()
	ObjArray = for o in objects where (custAttributes.get o 1) != undefined collect o
	ObjArray = for o in ObjArray where (custAttributes.get o 1).name == "objData" collect o
		
	TheWalls = GetW ObjArray
	TheOperands = GetO ObjArray
	TheSource = GetS ObjArray
	
	if TheWalls.count > 0 then 
	(
		for w in TheWalls  do 
		(
			if w.wOperands.count == 0 then custAttributes.delete w (custAttributes.getDef w 1)
			else
			(
				wOperands = for ch in w.children where (custAttributes.get ch 1) != undefined collect o
				wOperands = for o in wOperands where (custAttributes.get o 1).name == "objData" collect o				
				if wOperands.count > 0 then (for ch in wOperands where finditem w.wOperands ch.wID == 0 do custAttributes.delete ch (custAttributes.getDef ch 1))
			)
		)
	)	
	
	if TheOperands.count > 0 then (for o in TheOperands where o.wWalls.count == 0 do custAttributes.delete o (custAttributes.getDef o 1)) 

	for o in ObjArray where o.layer.name == "~wallCollisions" and o.parent == undefined do delete o
)

fn ExtractSel selToExtract = 
(
	selOperands = #()
	WallOeprndsIDs = #()
	ScrGroups = #()
	selOperands = GetO selToExtract
	
	if selOperands.count > 0 then
	(
		theWall = selOperands[1].wWalls[1]
		if theWall != undefined then
		(
			theWall = getnodebyname theWall

			WallOeprndsIDs = theWall.wOperands
			for i=1 to WallOeprndsIDs.count do 
			(
				ProBoolean.setOperandSel theWall i false 
			)

			for o in selOperands do 
			(
				OperandID = o.wID
				Operands = for o in theWall.children where o.wType == "ObjSrc" collect o
				Operand = (for Operand in Operands where Operand.wID == OperandID collect Operand)[1]
				ComponentIndex = finditem WallOeprndsIDs OperandID
				if ComponentIndex != 0 then 
				(
					ProBoolean.setOperandSel theWall ComponentIndex true
					deleteitem WallOeprndsIDs ComponentIndex
					
					sceneObjs = for o in objects collect o
					pressButtonPB "Extract Selected"
					newOperands = for o in objects where (finditem sceneObjs o) == 0 collect o
					
					for newOperand in newOperands do
					(
						newOperand.name = o.name + "_Extracted"
						newOperand.wirecolor = o.wirecolor
						newOperand.parent = undefined
						o.parent = undefined
						custAttributes.delete newOperand (custAttributes.getDef newOperand 1)
					)
					
					try(for o in objects where (finditem sceneObjs o) == 0 do delete o)catch()
					o.parent = undefined
				)
			)
			theWall.wOperands = WallOeprndsIDs
			LayerManager.deleteLayerByName "~wallCollisions"
			select selToExtract
		)
	)
	CleanUpWall()	
)