/* Description: Refresh logic for Operands and UI
Version: 0.01
*/

function Refresh_Operands srcObjs forceRefresh = 	
(
	local WallOperands = #()
	local WallSource = #()
	
	if srcObjs == undefined then srcObjs = getOperands ($ as array)
	if classof srcObjs != array then srcObjs = #(srcObjs)

	if srcObjs.count > 0 then
	(
		theWall = srcObjs[1].parent	

		if theWall != undefined then
		(
			WallOperands = getOperands theWall.children
			WallSource = getS theWall.children
			
			print ("\n!!!--------------------------WallOperands.count: " + WallOperands.count as string)
			print ("\n!!!--------------------------WallSource.count: " + WallSource.count as string)

			WallID = theWall.wID
			
			if WallOperands.count == WallSource.count then
			(	
				for i=1 to WallOperands.count do 
				(
					o = WallOperands[i]
					s = WallSource[i]
				
					if o.position != s.position or o.rotation != s.rotation or o.scale != s.scale or forceRefresh == true then
					(
						print ("\n!!!--------------------------!!!OBJECT REFRESED :" + o.name as string)
						
						Bbox_Local #(o) theWall
						NewOperand = Bboxes[1]
						faceCount = (polyop.getNumFaces s)
						s.pivot = NewOperand.pivot
						polyop.attach s NewOperand
						polyop.deleteFaces s #{1..faceCount} delIsoVerts:true
					)
				)
			)
		)
	)
)

function Refresh_Wall = 
(
	format "\n" 
	print "Refresh.Refresh_Wall()"

	theWall = selection[1]
	Refresh_Operands (getOperands theWall.children) false 
	print "\n-------------------------	WALL REFRESHED	-------------------------"
)
	
function OnSectionChangeFN =
(	
	format "\n"; print "Refresh.OnSectionChangeFN()"

	if selection.count > 0 then 
	(	
		obj = selection[1]
		
		format "obj: %\n" obj
		
		if (custAttributes.get obj 1) != undefined and (custAttributes.get obj 1).name == "objData" then
		(
			format "obj.wType: %\n" obj.wType
			
			if obj.wType == "Wall" then
			(				
				savedValue = obj.wH
				rollLazyWall.spnExtrude.value  = savedValue
				
				savedValue = obj.wO
				rollLazyWall.spnOutline.value  = savedValue 
				
				if obj.wState == "BooleanWall" then Refresh_Wall()
			)
			else
			(
				wallOperands = getOperands selection	
				if wallOperands.count > 0 then 
				(
					obj = wallOperands[1]
					
					savedValue = obj.BbScaleX
					rollLazyWall.BBScaleX.value = savedValue
					
					savedValue = obj.BbScaleY
					rollLazyWall.BBScaleY.value = savedValue
					
					savedValue = obj.BbScaleZ
					rollLazyWall.BBScaleZ.value = savedValue
					
					Refresh_Operands wallOperands false
				)
			)
		)
	)
)

function selectedNodesPreDeleteFn DelSel =
(
	local Walls = #()
	local Operands = #()
		
	Walls = getW DelSel
	Operands = getOperands DelSel
	callbacks.RemoveScripts #selectionSetChanged id:#OnSectionChangeCallBackAdd  

	if walls.count > 0 then
	(
		for theWall in walls where theWall.wOperands.count > 1 do ExtractSel theWall
	)
	
	if Operands.count > 0 then (for o in Operands do if o.wWalls.count > 0 then ExtractSel o)
)

function OnSectionChangeCallBackAdd =
(
	callbacks.RemoveScripts #selectionSetChanged id:#OnSectionChangeCallBackAdd  
	callbacks.addScript #selectionSetChanged "OnSectionChangeFN()" id:#OnSectionChangeCallBackAdd      
)

function PostNodeCloned =
(
	callbacks.RemoveScripts #postNodesCloned id:#SetID_copy
)

function selectedNodesPreDelete =
(
	callbacks.RemoveScripts #selectedNodesPreDelete id:#selectedNodesPreDelete  
	callbacks.addScript #selectedNodesPreDelete "(DelSel = callbacks.notificationParam() \n selectedNodesPreDeleteFn DelSel )" id:#selectedNodesPreDelete      
)

function killCallbacks =
(
	callbacks.RemoveScripts    #selectionSetChanged  id:#Wall_OnSectionCHangeCallBack  
	callbacks.RemoveScripts    #postNodesCloned  id:#Wall_SetID_copy
	callbacks.RemoveScripts    #selectedNodesPreDelete  id:#Wall_selectedNodesPreDelete  
	Print "CallBacks ara KILLEEEEEEED !!!!!!"
)
