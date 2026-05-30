/* Description: Instance Testing and Wall Editing
Version: 0.01
*/

fn InstanceTest selObj =
(	
	local instances = #()
	local finSel = #()

	if selObj != undefined then
	(
		local o = selObj
		local addmod = #()
		local obj_instance
		local testInst = (InstanceMgr.GetInstances o &obj_instance)
		
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
		return finSel -- return
	)
)

fn EditWall = 
(
	local Wallinstances = #()
	local Wall_Instances = #()
	local theWall_Src = undefined
	local theWall = (getW $)[1]
	
	if theWall != undefined then 
	(
		max create mode
		OperandIDs = theWall.wOperands 
		
		testInst = (InstanceMgr.GetInstances theWall &obj_instance)
		if testInst > 1 then Wall_Instances = obj_instance
		
		pressButtonPB "Remove Only Invisible"

		if Wall_Instances.count > 0 then 
		(	
			for o in Wall_Instances where o!=undefined do
			(
				callbacks.RemoveScripts #postNodesCloned id:#SetID_copy
				instance theWall name:"Tmp_Inst"
				newWall = getnodeByName "Tmp_Inst"
				
				newWall.transform = o.transform
				newWall.wirecolor = o.wirecolor
				newWall.name = o.name
				newWall.wID = o.wID
				layer = LayerManager.getLayerFromName o.layer.name
				layer.addnode newWall
				
				delete o
			)
		)
		
		callbacks.RemoveScripts #selectionSetChanged id:#OnSectionChangeCallBack  
		select theWall
		max modify mode
	)
)

fn WallEditExit = 	
(
-- 	o=$
-- 	$.wState
	Wallinstances = #()
	OperandIDs = #()
	OperandsObj = #()
	theWall = (getW $)[1]
-- 	if OutlinePrview != undefined then	(for o in theWall.children where getUserProp o "OutlinePreview" do delete o)

	if theWall != undefined then 
	(			
		testInst = (InstanceMgr.GetInstances theWall &obj_instance)				
		if testInst > 1 then 
		(
			join Wallinstances obj_instance	
			for w in Wallinstances where w.children.count > 0 do theWall = w
		)
	
		OperandIDs = theWall.wOperands
		if OperandIDs.count > 0 then
		(
			AllObj = for o in objects collect o
			WallOperands =	for o in getOperands AllObj where finditem OperandIDs o.wID > 0 collect o
-- 			OperandsObj[OperandsObj.count+1] = theWall
		)

-- 		Wall_Instances = Wall_InstanceTest theWall
		append WallOperands theWall
		Wall_Add WallOperands
		WallINIset WallID "ObjectState" "Wall"
		max create mode
		---------------- Prepar strng frm strng arry stord in us defined properties
-- 		WallID = getUserProp theWall "ID"
-- 		TheChangeHandlerID = "W" +	WallID as string
-- 		----------------Add CallBack
-- 		TheChangeHandler = (when select theWall changes id:#TheChangeHandlerID do print "Wall REGRESHED by WallEditExit") --Refresh_Wall())
-- 		append WallChangeHandlers WallID
-- 		append WallChangeHandlers TheChangeHandler
-- 		select theWall
-- 		max modify mode
-- 		Wall_Instances = #($)
		pressButtonPB "Remove Only Invisible"
-- 		print ("Wall_Instances----------d " + Wall_Instances as string)
-- 		o = Wall_Instances[1]

		if Wall_Instances.count > 0 then 
		(	
			for o in Wall_Instances where o!=undefined do
			(
			
-- 				maxOps.CloneNodes #(theWall)cloneType:#instance newNodes:testX=()
				callbacks.RemoveScripts    #postNodesCloned  id:#Wall_SetID_copy
				instance theWall name:"Tmp_Inst"
				newWall = getnodeByName "Tmp_Inst"
				
				newWall.transform = o.transform
				newWall.wirecolor = o.wirecolor
				newWall.name = o.name
				newWall.wID = o.wID
				layer = LayerManager.getLayerFromName o.layer.name
				layer.addnode newWall
				
-- 				o.baseObject = theWall.baseObject
				print ("reinstance----------d " + o as string)
-- 				WallINIdel (getUserProp o "ID") undefined undefined
				delete o
				
				Wall_PostNodeCloned()
	

			)
				-- 			Wall_ReInstancer Wall_Instances
		)
		
-- 	select 	theWall
	)
)