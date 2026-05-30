/*
	Description: Floor Creation Operations for WallTools
	Version: 0.01
*/

struct WallSplineFloorStruct
(
	fn CreateFloor CreateType addMods =
	(
		local origSpline = (getW $)[1]
		local origState = origSpline.wState
		
		if origState == "Wall" then 
		(
			WallEdit()
			origSpline = $
		)

		for chld in origSpline.children where chld.wType == CreateType do 
		(
			delete chld
		)
		
		try
		(
			callbacks.RemoveScripts #postNodesCloned id:#Wall_SetID_copy
		)
		catch()
		
		copy origSpline name:"SplineFloorTmp"
		Wall_PostNodeCloned()
		
		local splineFloor = getnodebyname "SplineFloorTmp"
		splineFloor.wID = (genClassID returnValue:true )[1]
		wSetAtt splineFloor CreateType
		
		splineFloor.name = origSpline.name + "_" + CreateType

		splineFloor.CloseArrAtt = origSpline.CloseArrAtt 
		splineFloor.splArrAtt = origSpline.splArrAtt 
		splineFloor.SplinePivot = origSpline.SplinePivot
		
		for modIdx = 1 to splineFloor.modifiers.count do 
		(
			deleteModifier splineFloor (splineFloor.modifiers[1])
		)
		
		resetSpl splineFloor
		local splinesNum = numSplines splineFloor
		local splIdx = 1
		
		while splIdx < splinesNum do 
		(
			if not isClosed splineFloor splIdx then 
			(
				deleteSpline splineFloor splIdx
				splinesNum = numSplines splineFloor
				splIdx -= 1
			)
			splIdx += 1
		)
		
		updateShape splineFloor
		copySpl splineFloor
		applyOffset splineFloor origSpline.wO
		
		splinesNum = numSplines splineFloor
		local firstSplinesNum = splinesNum / 2
		
		if firstSplinesNum > 0 then 
		(
			for delIdx = firstSplinesNum + 1 to splinesNum do 
			(
				deleteSpline splineFloor 1
			)
		)
		updateShape splineFloor
		
		if addMods != 0 then 
		(
			local floorToPolyMod = Turn_to_Poly ()
			addModifier splineFloor floorToPolyMod
			floorToPolyMod.name = "FloorToPoly"
				
			floorToPolyMod.keepConvex = on
			floorToPolyMod.limitPolySize = on
			floorToPolyMod.maxPolySize = 4
			floorToPolyMod.removeMidEdgeVertices = off
			floorToPolyMod.requirePlanar = off
			floorToPolyMod.selectionConversion = 0
			floorToPolyMod.selectionLevel = 0
			floorToPolyMod.selectionConversion = 1
		)
		
		true -- return
	)
)

global WallSplineFloor = WallSplineFloorStruct()