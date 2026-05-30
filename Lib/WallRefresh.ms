/* Description: Refresh logic for Operands and UI
Version: 0.01
*/

fn Refresh_Operands srcObjs forceRefresh = 	
(
	local WallOperands = #()
	local WallSource = #()
	
	if srcObjs == undefined then srcObjs = getO ($ as array)
	if classof srcObjs != array then srcObjs = #(srcObjs)

	if srcObjs.count > 0 then
	(
		theWall = srcObjs[1].parent	

		if theWall != undefined then
		(
			WallOperands = getO theWall.children
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

fn Refresh_Wall = 
(
	format "\n" 
	print "Refresh.Refresh_Wall()"

	theWall = selection[1]
	Refresh_Operands (getO theWall.children) false 
	print "\n-------------------------	WALL REFRESHED	-------------------------"
)
	
fn OnSectionChangeFN =
(	
	format "\n"
	print "Refresh.OnSectionChangeFN()"

	if selection.count > 0 then 
	(	
		obj = selection[1] 
		if (custAttributes.get obj 1) != undefined and (custAttributes.get obj 1).name == "objData" then
		(
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
				wallOperands = getO selection	
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

fn selectedNodesPreDeleteFn DelSel =
(
	local Walls = #()
	local Operands = #()
		
	Walls = getW DelSel
	Operands = getO DelSel
	callbacks.RemoveScripts #selectionSetChanged id:#OnSectionChangeCallBack  

	if walls.count > 0 then
	(
		for theWall in walls where theWall.wOperands.count > 1 do ExtractSel theWall
	)
	
	if Operands.count > 0 then (for o in Operands do if o.wWalls.count > 0 then ExtractSel o)
)

fn OnSectionChangeCallBack =
(
	callbacks.RemoveScripts #selectionSetChanged id:#OnSectionChangeCallBack  
	callbacks.addScript #selectionSetChanged "OnSectionChangeFN()" id:#OnSectionChangeCallBack      
)

fn PostNodeCloned =
(
	callbacks.RemoveScripts #postNodesCloned id:#SetID_copy
)

fn selectedNodesPreDelete =
(
	callbacks.RemoveScripts #selectedNodesPreDelete id:#selectedNodesPreDelete  
	callbacks.addScript #selectedNodesPreDelete "(DelSel = callbacks.notificationParam() \n selectedNodesPreDeleteFn DelSel )" id:#selectedNodesPreDelete      
)

fn killCallbacks =
(
	callbacks.RemoveScripts    #selectionSetChanged  id:#Wall_OnSectionCHangeCallBack  
	callbacks.RemoveScripts    #postNodesCloned  id:#Wall_SetID_copy
	callbacks.RemoveScripts    #selectedNodesPreDelete  id:#Wall_selectedNodesPreDelete  
	Print "CallBacks ara KILLEEEEEEED !!!!!!"
)
