/*
	Description: Attributes for WallTools
	Version: 0.01
*/

struct WallAttributesStruct
(

	fn wSetAtt objArray wObjType = 
	(
		if classof objArray != array then 
		(
			objArray = #(objArray)
		)

		objArray = for obj in objArray where (custAttributes.get obj 1) == undefined collect obj

		for obj in objArray do 
		(
			local objData = undefined
			
			if objData == undefined then 
			(
				if wObjType == "Wall" or wObjType == "Floor" or wObjType == "Ceil" then
				(
					objData = attributes "objData"
					(
						parameters prmID rollout:rollObjData
						(
							wID type:#integer
							wType type:#string 
							wState type:#string 
							splArrAtt type:#string  
							CloseArrAtt type:#string  
							SplinePivot type:#string  
							wO type:#float  
							wH type:#float  
							wcapStart type:#boolean default:true
							wcapEnd type:#boolean default:true
							wOperands type:#intTab tabSizeVariable:true
						)
						rollout rollObjData "LazzyWall"
						(			
							checkbox cbxcapStart "capStart" state:true pos:[0,2]
							checkbox cbxCapEnd "CapEnd" state:true pos:[80,2]
						)
					)
					custAttributes.add obj objData
				)
				else if wObjType == "Operand" then
				(
					objData = attributes "objData"
					(
						parameters prmID
						(
							wID type:#integer
							wType type:#string 
							wWalls type:#intTab tabSizeVariable:true
							BbScaleX type:#float default:1.0
							BbScaleY type:#float default:1.0
							BbScaleZ type:#float default:1.0
						)
					)
					custAttributes.add obj objData
				)
			)
		)
		
		true -- return
	)
)

global WallAttributes = WallAttributesStruct()