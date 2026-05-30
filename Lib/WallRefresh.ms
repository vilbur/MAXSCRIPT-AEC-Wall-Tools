/*
	Description: Refresh Operations for WallTools
	Version: 0.01
*/

struct WallRefreshStruct
(
	fn Refresh_Operands srcObjs forceRefresh = 
	(
		local wallOperands = #()
		local wallSource = #()
		
		if srcObjs == undefined then 
		(
			srcObjs = getO ($ as array)
		)
		
		if classof srcObjs != array then 
		(
			srcObjs = #(srcObjs)
		)

		if srcObjs.count > 0 then
		(
			local theWall = srcObjs[1].parent	

			if theWall != undefined then
			(
				wallOperands = getO theWall.children
				wallSource = getS theWall.children

				local wallID = theWall.wID
				
				if wallOperands.count == wallSource.count then
				(	
					for idx = 1 to wallOperands.count do 
					(
						local opr = wallOperands[idx]
						local src = wallSource[idx]
					
						if opr.position != src.position or opr.rotation != src.rotation or opr.scale != src.scale or forceRefresh == true then
						(
							Bbox_Local #(opr) theWall
							
							local newOperand = Bboxes[1]
							local faceCount = (polyop.getNumFaces src)
							
							src.pivot = newOperand.pivot
							polyop.attach src newOperand
							polyop.deleteFaces src #{1..faceCount} delIsoVerts:true 
						)
					)
				)
			)
		)
		
		true -- return
	),

	fn Refresh_Wall = 
	(
		local theWall = selection[1]
		Refresh_Operands (getO theWall.children) false 
		
		true -- return
	),

	fn Wall_OnSectionCHangeFN =
	(	
		if selection.count > 0 then 
		(	
			local selObj = selection[1] 
			
			if (custAttributes.get selObj 1) != undefined and (custAttributes.get selObj 1).name == "objData" then
			(
				if selObj.wType == "Wall" then
				(				
					local savedValue = selObj.wH
					rollWallTools.spnExtrude.value = savedValue
					
					savedValue = selObj.wO
					rollWallTools.spnOutline.value = savedValue 
					
					if selObj.wState == "BooleanWall" then 
					(
						Refresh_Wall ()
					)
				)
				else
				(
					local wallOperandsArr = getO selection	
					
					if wallOperandsArr.count > 0 then 
					(
						local wObj = wallOperandsArr[1]
						
						local savedValueX = wObj.BbScaleX
						rollWallTools.BBScaleX.value = savedValueX
						
						local savedValueY = wObj.BbScaleY
						rollWallTools.BBScaleY.value = savedValueY
						
						local savedValueZ = wObj.BbScaleZ
						rollWallTools.BBScaleZ.value = savedValueZ

						Refresh_Operands wallOperandsArr false
					)
				)
			)
		)
		
		true -- return
	),

	fn Wall_selectedNodesPreDeleteFn DelSel =
	(
		local wallsArr = #()
		local operandsArr = #()
		
		wallsArr = getW DelSel
		operandsArr = getO DelSel
		
		callbacks.RemoveScripts #selectionSetChanged id:#Wall_OnSectionCHangeCallBack
		
		if wallsArr.count > 0 then 
		(
			for theWall in wallsArr where theWall.wOperands.count > 1 do 
			(
				ExtractSel theWall
			)
		)
		
		if operandsArr.count > 0 then 
		(
			for opr in operandsArr do 
			(
				if opr.wWalls.count > 0 then 
				(
					ExtractSel opr
				)
			)
		)
		
		callbacks.addScript #selectionSetChanged "Wall_OnSectionCHangeFN()" id:#Wall_OnSectionCHangeCallBack
		
		true -- return
	)
)

global WallRefresh = WallRefreshStruct()