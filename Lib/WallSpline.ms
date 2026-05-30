/*
	Description: Spline Operations for WallTools
	Version: 0.01
*/

struct WallSplineStruct
(

	fn copySpl bSpline = 
	(
		local originalSelection = #()
		local CloseArr = #()
		local splArr = #()

		free originalSelection
		free CloseArr
		free splArr
		
		local objID = bSpline.wID
		bSpline.SplinePivot = bSpline.pivot as string

		if classof bSpline != SplineShape then 
		(
			convertTo bSpline SplineShape
		)

		local numSpl = numsplines bSpline

		for idx = 1 to numSpl do 
		(
			append splArr (
				for vtx = 1 to numknots bSpline idx collect 
				(
					local segtype = undefined
					if vtx == (numknots bSpline idx) then 
					(
						segtype = (getSegmentType bSpline idx (vtx-1))
					)
					else 
					(
						segtype = (getSegmentType bSpline idx vtx)
					)
					#(getKnotType bSpline idx vtx, segtype, getknotpoint bSpline idx vtx, getinvec bSpline idx vtx, getoutvec bSpline idx vtx)
				)
			)
			append originalSelection (getsegselection bSpline idx)
			append CloseArr (isclosed bSpline idx)
			bSpline.splArrAtt = splArr as string
			bSpline.CloseArrAtt = CloseArr as string
		)
		
		true -- return
	)
)

global WallSpline = WallSplineStruct()