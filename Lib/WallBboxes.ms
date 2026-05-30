/* Description: Bounding Boxes Logic for WallTools
Version: 0.01
*/

fn Bbox_Local ScrObjects theWall = --start
(
	/*
	mode = 2 		-- box
	mode = 4 		--convex
	*/
	max create mode
	global Bboxes = #()

	for i in ScrObjects do
	(
		wSetAtt i "Operand"

		m = (MassFX_RBody ())
		addmodifier i m
		m.meshType = 2
		m.SetRBMeshInflation 1 0.0
		m.SetRBMeshVertexLimit 1 32
		m.meshConvexStyle = 0
		if isGroupMember i then (s = i.parent) else (s =i)

		Xvalue = i.BbScaleX
		Yvalue = i.BbScaleY
		Zvalue = i.BbScaleZ

		if Xvalue == 0 then Xvalue = 1
		if Yvalue == 0 then Yvalue = 1
		if Zvalue == 0 then Zvalue = 1
		
		-- [Implementation for box generation based on MassFx bounds...]
	)
)

fn BBScale axisValue val =
(	
	Operands = getO selection
	for o in Operands where o.wWalls.count > 0  do 
	(
		case axisValue of
		(	
			"Xvalue":(o.BbScaleX = val)	
			"Yvalue":(o.BbScaleY = val)		
			"Zvalue":(o.BbScaleZ = val)	
		)
		Refresh_Operands o true
	)
)