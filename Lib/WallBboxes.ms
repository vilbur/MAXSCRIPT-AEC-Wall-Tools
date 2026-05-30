/*
	Description: BBoxes for WallTools
	Version: 0.01
*/

struct WallBboxesStruct
(

	fn Bbox_Local ScrObjects theWall = 
	(
		max create mode
		global Bboxes = #()

		for obj in ScrObjects do
		(
			WallAttributes.wSetAtt obj "Operand"

			local modMass = (MassFX_RBody ())
			addmodifier obj modMass
			
			modMass.meshType = 2
			modMass.SetRBMeshInflation 1 0.0
			modMass.SetRBMeshVertexLimit 1 32
			modMass.meshConvexStyle = 0
			
			local srcObj = undefined
			if isGroupMember obj then 
			(
				srcObj = obj.parent
			) 
			else 
			(
				srcObj = obj
			)
			
			local Xvalue = obj.BbScaleX
			local Yvalue = obj.BbScaleY
			local Zvalue = obj.BbScaleZ

			if Xvalue == 0 then 
			(
				Xvalue = 1
			)
			if Yvalue == 0 then 
			(
				Yvalue = 1
			)
			if Zvalue == 0 then 
			(
				Zvalue = 1
			)
			
			local newBox = box length:(modMass.meshwidth * Xvalue) width:(modMass.meshLength * Yvalue) height:(modMass.meshheight * Zvalue)
			deletemodifier obj obj.modifiers[#MassFX_Rigid_Body]
		)
		
		true -- return
	)
)

global WallBboxes = WallBboxesStruct()