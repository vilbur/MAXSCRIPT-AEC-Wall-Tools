/* Description: Refresh logic for Operands and UI in WallTools
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
			WallOperands =  getO theWall.children
			WallSource =  getS theWall.children
			
			print ("\n!!!--------------------------WallOperands.count: " + WallOperands.count as string)
			print ("\n!!!--------------------------WallSource.count: " + WallSource.count as string)

			WallID = theWall.wID
			
			if WallOperands.count == WallSource.count then
			(	
				for i=1 to WallOperands.count do 
				(
					o = WallOperands[i]
					-- Parameter re-evaluation logic...
				)
			)
		)
	)
)

fn PostNodeCloned =
(
	callbacks.RemoveScripts    #postNodesCloned  id:#SetID_copy
)

fn selectedNodesPreDelete =
(
	callbacks.RemoveScripts    #selectedNodesPreDelete  id:#selectedNodesPreDelete  
	callbacks.addScript    #selectedNodesPreDelete  "(DelSel = callbacks.notificationParam();selectedNodesPreDeleteFn  DelSel )"	id:#selectedNodesPreDelete      
)