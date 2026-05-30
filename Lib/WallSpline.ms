/* Description: Spline Outline and Extrude logic
Version: 0.01
*/

function copySpl bSpline = 
(
	local originalSelection = #()
	local CloseArr = #()
	local splArr = #()

	free originalSelection
	free CloseArr
	free splArr
	objID = bSpline.wID

	bSpline.SplinePivot = bSpline.pivot as string

	if classof bSpline != SplineShape then convertTo bSpline SplineShape
	ns = numsplines bSpline
	for i = 1 to ns do 
	(
		append splArr (
			for v = 1 to numknots bSpline i collect 
			(
				if v == (numknots bSpline i) then segtype = (getSegmentType bSpline i (v-1)) else segtype = (getSegmentType bSpline i v)
				#(getKnotType bSpline i v, segtype, getknotpoint bSpline i v, getinvec bSpline i v, getOperandsutvec bSpline i v)
			)
		)
		append originalSelection (getsegselection bSpline i)
		append CloseArr (isclosed bSpline i)
		bSpline.splArrAtt = splArr as string
		bSpline.CloseArrAtt = CloseArr as string
	)
)

function resetSpl bSpline =
(
	with redraw off
	(
		local originalSelection = #()
		local CloseArr = #()
		local splArr = #()

		newpos = bSpline.position
		newtransform = bSpline.transform

		splArr = execute bSpline.splArrAtt
		CloseArr = execute bSpline.CloseArrAtt
		
		while numsplines bSpline > 0 do deletespline bSpline 1
		for i = 1 to splArr.count do
		(
			splID = addnewSpline bSpline
			for j in splArr[i] do
			(
				addknot bSpline splID j[1] j[2] j[3] j[4] j[5]
			)
			if CloseArr[i] == true do close bSpline splID
			updateshape bSpline
		)
		updateshape bSpline
		
		SplineChildren = bSpline.children
		for ch in SplineChildren do ch.parent = undefined
		PosPivot = execute bSpline.SplinePivot
		bSpline.pivot = PosPivot
		bSpline.transform = newtransform
		
		for ch in SplineChildren do ch.parent = bSpline
	)
)	

function SplineEdit = 	
(
	if selection.count > 0 then
	(
		bSpline = (getW $)[1]

		if bSpline != undefined then
		(
			max create mode		
			splArrSaved = execute bSpline.splArrAtt
			WallUV = bSpline.modifiers[#WallUV]		
			WallToPoly = bSpline.modifiers[#WallToPoly]
			WallHeight = bSpline.modifiers[#WallHeight]

			if WallUV != undefined then deleteModifier bSpline WallUV
			if WallToPoly != undefined then deleteModifier bSpline WallToPoly	
			if WallHeight != undefined then deleteModifier bSpline WallHeight	

			ObjectState = bSpline.wState
			if ObjectState == "WallOutline" then	
			(
				resetSpl bSpline
				bSpline.wState = "WallEditSpline"	
			)
			else
			(
				bSpline.wState = "WallOutline"	
			)
			select bSpline
			clearselection () 
			select bSpline
		)		
	)
)

function SplineExit = 	
(
	if selection.count > 0 then
	(
		bSplines = (getW $)
		for bSpline in bSplines do
		(
			ObjectState = bSpline.wState
			if ObjectState == "WallEditSpline" then
			(
				copySpl bSpline
				if bSpline.wO != 0.0 then OutlineFn bSpline
				bSpline.wState = "WallOutline"
			)
			else if ObjectState == "WallOutline" then
			(
				if bSpline.wH != 0.0 then WallExtrude true
				bSpline.wState = "EditableWall"
				max modify mode
			)
		)
	)
)

function WallExtrude HeightSaved = 
(
	if selection.count > 0 then 
	(
		local bSplines = #() 
		for bSpline in selection where superclassof bSpline.baseobject == shape do 
		( 
			if classof bSpline != SplineShape then convertTo bSpline SplineShape
			
			WallHeightMod = bSpline.modifiers[#WallHeight]
			HeightValue = rollLazyWall.spnExtrude.value

			if WallHeightMod == undefined then 
			(
				WallHeightMod = Extrude ()
				addModifier bSpline WallHeightMod
				WallHeightMod.name = "WallHeight"
				WallHeightMod.mapcoords = on
				WallHeightMod.capType = 0
				WallHeightMod.realWorldMapSize = on
				WallHeightMod.useShapeIDs = off
				WallHeightMod.amount = HeightValue
			)
			else 
			(
				WallHeightMod.amount = HeightValue
			)
			
			bSpline.wH = HeightValue
			bSpline.wState = "EditableWall"			

			CapStart = bSpline.wCapStart
			CapEnd = bSpline.wCapEnd

			WallHeightMod.capStart = CapStart
			WallHeightMod.capEnd = CapEnd	
						
			if bSpline.modifiers[#WallToPoly] == undefined then 
			(	
				WallToPoly = Turn_to_Poly ()
				addModifier bSpline WallToPoly
				WallToPoly.name = "WallToPoly"
					
				WallToPoly.keepConvex = on
				WallToPoly.limitPolySize = on
				WallToPoly.maxPolySize = 4
				WallToPoly.removeMidEdgeVertices = off
				WallToPoly.requirePlanar = off
				WallToPoly.selectionConversion = 0
				WallToPoly.selectionLevel = 0
				WallToPoly.selectionConversion = 1
			)
			
			if bSpline.modifiers[#WallUV] == undefined then 
			(	
				UVmap = (Uvwmap ())
				addModifier bSpline UVmap
				UVmap.name = "WallUV"	
				UVmap.axis = 2
				UVmap.realWorldMapSize = on
			)
		)
	)
)

function OutlineFn bSPlines  = --start
(
/* 	
	OutlineFn $
	bSplines= for o in selection  collect o
	bSplines=$
	bSpline=$
	bSpline=bSplines[1]
	o=$
	$.wID
	$.wState
	NewValue = 100
*/
	if classof bSplines != array then bSplines = #(bSplines)
	if bSPlines.count > 0 then
	(
 		for o in bSPlines where superclassof o.baseobject != shape and classof o.baseobject != ProBoolean do deleteitem bSPlines (finditem bSPlines o)
		for o in bSPlines  where classof o != SplineShape do convertTo o SplineShape

		if bSplines.count != 0 then
		(	
			for bSpline in bSplines do
			(
-- 				$.wID
				if custAttributes.get bSpline 1 == undefined then wSetAtt bSpline "Wall"					
-- 				if bSpline.wState == "BooleanWall" then 
-- 				(
-- 					deleteitem  bSplines (finditem bSplines bSpline)
-- 					WallEdit()
-- 					bSpline = selection[1]

-- 					append bSplines bSpline
					ObjectState = "WallEditSpline"
-- 				)
				
-- 				if  ObjectState == "EditableWall" then 
-- 				(
-- 										
-- 					WallSplineEdit()
-- 					bSpline = selection[1]

-- 					append bSplines bSpline
-- 					ObjectState = "WallEditSpline"					
-- 				)	
				
				if  bSpline.wState == undefined then bSpline.wState = "WallEditSpline"

				max create mode	
				if classof bSpline != SplineShape then convertTo bSpline SplineShape
		-- for o in bSpline.children where
		-- 		objID = 0					
-- 				OutlinePrview  = (for ch in bSpline.children where ch.wPreview != undefined collect ch)[1]				
				NewValue = rollLazyWall.spnOutline.value	
				
		-- 		NewValue=-20
-- 				if classof splArr != array then splArrSaved = #()
			
				if OutlinePrview == undefined then
				(
-- 					if  splArr.count == 0 then copySpl bSpline
					if bSpline.splArrAtt == undefined then copySpl bSpline

					WallUV = bSpline.modifiers[#WallUV]		
					WallToPoly = bSpline.modifiers[#WallToPoly]
					WallHeight = bSpline.modifiers[#WallHeight]
					if WallUV != undefined then deleteModifier bSpline WallUV
					if WallToPoly != undefined then deleteModifier bSpline WallToPoly
					if WallHeight != undefined then deleteModifier bSpline WallHeight
					
					resetSpl bSpline
					applyOffset bSpline	NewValue
					if WallHeight != undefined then addmodifier bSpline WallHeight
					if WallToPoly != undefined then addmodifier bSpline WallToPoly
					if WallUV != undefined then addmodifier bSpline WallUV
	
					bSpline.wState =  "WallOutline"
-- 					WallINIset objID "WallOutline" NewValue
-- 					select bSpline
				)
				else
				(
					resetSpl OutlinePrview
					applyOffset OutlinePrview NewValue
				)
				
	-- 			if ObjectState == "BooleanWall" then
	-- 			(
	-- 				WallINIset objID "ObjectState" "EditableWall"
	-- 				WallEditExit()
	-- 			)	
				
				bSpline.wO =  NewValue
			)			
		)
		select bSplines
	)

)--end

function OutlinePreview_v mode = 
(	
	if selection.count > 0 then
	(	
/* 	
		mode = 1 	-- enter
		mode != 1		--exit
		mode = 2
		OutlinePreview 2
*/

		if  WallINIget objID  "ObjectState" == "WallEditSpline" then
		(
			outlineValue = (WallINIget objID "WallOutline") as float
			outlinePrev = (for o in bSpline.children where getUserProp o "OutlinePreview" == true collect  o)[1]		
			if mode == 1 and outlinePrev == undefined then
			(	
				
				resetSpl bSpline
				callbacks.RemoveScripts    #postNodesCloned  id:#Wall_SetID_copy
				copy bSpline name:"OutlineTmp"
				Wall_PostNodeCloned()
				OutlinePreview = getnodebyname "OutlineTmp"
				OutlinePreview.name = bSpline.name + "Preview"
			
				setUserProp OutlinePreview "ID"  (getUserProp bSpline "ID")

				
				layer = LayerManager.getLayerFromName bSpline.layer.name
				layer.addnode OutlinePreview	
				OutlinePreview.wirecolor = color 225 88 199

				
		-- 		copySpl OutlinePreview
				
				applyOffset  OutlinePreview outlineValue

				OutlinePreview.parent = bSpline

				freeze OutlinePreview
				snapState = snapMode.toFrozen	
				snapMode.toFrozen = true
				setUserProp OutlinePreview "snapMode" snapState
				setUserProp OutlinePreview "OutlinePreview" true
				
			)
			else if  mode == 0 then
			(
				for o in bSpline.children where getUserProp o "OutlinePreview" == true do delete o
				applyOffset  bSpline outlineValue
				select bSpline
			)
			else
			(
				for o in bSpline.children where getUserProp o "OutlinePreview"  == true  do delete o
				applyOffset  bSpline outlineValue
				select bSpline	
			)
		)
	)
)
