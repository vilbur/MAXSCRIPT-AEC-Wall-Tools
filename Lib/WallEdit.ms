/* Description: Instance Testing and Wall Editing for WallTools
Version: 0.01
*/

fn InstanceTest selObj =
(	
	instances = #()
	finSel = #()
	
	if selObj != undefined then
	(
		o = selObj
		addmod = #()
		obj_instance
		testInst = (InstanceMgr.GetInstances o &obj_instance)
		
		if testInst > 1 then 
		(
			join instances obj_instance	

			for inst in instances do
			(
				print inst
				appendifunique finSel inst 
			)
		)
		index = (finditem finSel o)
		if index != 0 then deleteitem finSel index
		finSel
	)
)

fn Edit = 
(
	Wallinstances = #()
	Instances = #()
	theWall_Src = undefined
	theWall = (getW $)[1]
	
	if theWall != undefined then 
	(
		max create mode
		----------------Get Object ID in Operands
		OperandIDs = theWall.wOperands 
		
		pressButtonPB "Remove Only Invisible"

		if Instances.count > 0 then 
		(	
			for o in Instances where o!=undefined do
			(
				callbacks.RemoveScripts    #postNodesCloned  id:#SetID_copy
				instance theWall name:"Tmp_Inst"
				newWall = getnodeByName "Tmp_Inst"
				
				newWall.transform = o.transform
				newWall.wirecolor = o.wirecolor
				newWall.name = o.name
				newWall.wID = o.wID
				layer = LayerManager.getLayerFromName o.layer.name
			)
		)
	)
)