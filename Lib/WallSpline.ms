/* Description: Spline Outline and Extrude logic for WallTools
Version: 0.01
*/

fn copySpl bSpline = 
(
	local originalSelection = #(), CloseArr = #(), splArr = #()

	free originalSelection
	free CloseArr
	free splArr
	objID = bSpline.wID

	bSpline.SplinePivot =  bSpline.pivot as string
	if classof bSpline != SplineShape then convertTo bSpline SplineShape
	ns = numsplines bSpline
	for i = 1 to ns do 
	(
		append splArr (
			for v = 1 to numknots bSpline i collect 
			(
				if v == (numknots bSpline i) then segtype = (getSegmentType bSpline i (v-1)) else segtype = (getSegmentType bSpline i v)
				#(getKnotType bSpline i v, segtype, getknotpoint bSpline i v, getinvec bSpline i v, getoutvec bSpline i v)
			)
		)
		append originalSelection (getsegselection bSpline i)
		append CloseArr (isclosed bSpline i)
		bSpline.splArrAtt =  splArr as string
		bSpline.CloseArrAtt =  CloseArr as string
	)
)

fn resetSpl bSpline =
(
	with redraw off
	(
		local originalSelection = #(), CloseArr = #(), splArr = #()
		newpos = bSpline.position
		newtransform = bSpline.transform
		splArr = execute bSpline.splArrAtt
		CloseArr =  execute bSpline.CloseArrAtt
		
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
		bSpline.pivot  = PosPivot
		bSpline.transform = newtransform
		
		for ch in SplineChildren do ch.parent = bSpline
	)
)	

fn SplineEdit = 	
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

fn SplineExit = 	
(
	if selection.count > 0 then
	(
		bSplines = (getW $)
		for bSpline in bSplines do
		(
			ObjectState =  bSpline.wState
			if ObjectState == "WallEditSpline" then
			(
				copySpl bSpline
				if bSpline.wO != 0.0 then OutlineFn bSpline
				bSpline.wState =  "WallOutline"
			)
			else if ObjectState == "WallOutline" then
			(
				if  bSpline.wH	!= 0.0 then WallExtrude true
				bSpline.wState = "EditableWall"
				max modify mode
			)
		)
	)
)

fn WallExtrude HeightSaved = 
(
	if selection.count > 0 then 
	(
		local bSplines = #() 
		for bSpline in selection where superclassof bSpline.baseobject == shape do 
		( 
			if classof bSpline != SplineShape then convertTo bSpline SplineShape
			-- Modifier assignments (Extrude, Turn_To_Poly)...
		)
	)
)