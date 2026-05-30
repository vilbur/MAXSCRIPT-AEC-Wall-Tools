/*
	Description: Wall Edit Operations for WallTools
	Version: 0.01
*/

struct WallEditStruct
(
	fn Wall_InstanceTest selObj =
	(	
		local instancesArr = #()
		local finSelArr = #()
		
		if selObj != undefined then
		(
			local selNode = selObj
			local addModArr = #()
			local objInstance = undefined
			local testInst = (InstanceMgr.GetInstances selNode &objInstance)
			
			if testInst > 1 then 
			(
				join instancesArr objInstance	

				for inst in instancesArr do
				(
					appendifunique finSelArr inst 
				)
			)
			
			local idx = (finditem finSelArr selNode)
			
			if idx != 0 then 
			(
				deleteitem finSelArr idx
			)
		)
		
		finSelArr -- return
	),

	fn WallEdit = 
	(
		local wallInstancesArr = #()
		local theWallSrc = undefined
		local theWall = (getW $)[1]
		
		if theWall != undefined then 
		(
			max create mode
			
			local operandIDs = theWall.wOperands 
			local objInstance = undefined
			local testInst = (InstanceMgr.GetInstances theWall &objInstance)	
			
			if testInst > 1 then 
			(
				join wallInstancesArr objInstance	
				
				for wNode in wallInstancesArr where wNode.children.count > 0 do 
				(
					for opr in wNode.children do 
					(
						if opr.wID == theWall.wID then 
						(
							theWall = wNode
						)
					)
				)
			)
			
			local theWallBoolean = theWall
			local srcMods = #()
			local srcModsCount = #()

			ProBoolean.setOperandSel theWallBoolean 0 true 
			modPanel.setCurrentObject theWallBoolean.baseObject[1]

			theWall = theWallBoolean.baseObject[1]
			
			try
			(
				callbacks.RemoveScripts #postNodesCloned id:#Wall_SetID_copy
			)
			catch()

			copy theWallBoolean name:"theWallCopy"
					
			Wall_PostNodeCloned()

			local theWallCopy = getnodebyname "theWallCopy"

			local objDataAtt = custAttributes.get theWallBoolean 1	
			local oprsArr = theWallBoolean.woperands
			local wIDVal = theWallBoolean.wID
			
			convertTo theWallBoolean PolyMeshObject

			theWallBoolean.baseobject = theWallCopy.baseObject[1]
			delete theWallCopy
			wSetAtt theWallBoolean "Wall"

			local idx = 1
			while objDataAtt[idx] != undefined do 
			(
				idx += 1
			)
			
			theWallBoolean.woperands = oprsArr
			theWallBoolean.wID = wIDVal
			
			for chld in theWallBoolean.children where chld.wType == "ObjSrc" do 
			(
				delete chld
			)
		)
		
		max modify mode
		
		true -- return
	),

	fn WallEditExit = 
	(
		local wallInstancesArr = #()
		local operandIDs = #()
		local operandsObjArr = #()
		local theWall = (getW $)[1]
		
		if theWall != undefined then 
		(
			local objInstance = undefined
			local testInst = (InstanceMgr.GetInstances theWall &objInstance)
			
			if testInst > 1 then 
			(
				join wallInstancesArr objInstance
				for wNode in wallInstancesArr where wNode.children.count > 0 do 
				(
					theWall = wNode
				)
			)
			
			operandIDs = theWall.wOperands
			
			if operandIDs.count > 0 then 
			(
				local allObjArr = for obj in objects collect obj
				local wallOperandsArr = for opr in getO allObjArr where finditem operandIDs opr.wID > 0 collect opr
			)
		)
		
		true -- return
	)
)

global WallEdit = WallEditStruct()