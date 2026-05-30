/* Description: Floor Generation Logic for WallTools
Version: 0.01
*/

fn CreateFloor CreateType addMods =
(
	origSpline = (getW $)[1]
	Origstate = origSpline.wState
	if Origstate == "Wall" then Edit();origSpline = $ --Enter edit if wall is in proboolean state

	for ch in origSpline.children where ch.wType  == CreateType do delete ch		--delete old floors

	try(callbacks.RemoveScripts    #postNodesCloned  id:#SetID_copy)catch()
	copy origSpline name:"SplineFloorTmp"
	PostNodeCloned()
	
	SplineF = getnodebyname "SplineFloorTmp"
	SplineF.wID = (genClassID returnValue:true )[1]
	wSetAtt SplineF CreateType
	SplineF.name = origSpline.name + "_" + CreateType

	if addMods != 0 then
	(
		FloorToPoly = Turn_to_Poly ()
		addModifier SplineF FloorToPoly
		FloorToPoly.name = "FloorToPoly"
			
		FloorToPoly.keepConvex = on
		FloorToPoly.limitPolySize = on
		FloorToPoly.maxPolySize = 4
		FloorToPoly.removeMidEdgeVertices = off
		FloorToPoly.requirePlanar = off
		FloorToPoly.selectionConversion = 0
		FloorToPoly.selectionLevel = 0
		FloorToPoly.selectionConversion  = 1

		UVmap =  (Uvwmap ())
		addModifier SplineF UVmap
		UVmap.name = "FloorUV"	
		UVmap.axis = 2
		UVmap.realWorldMapSize = on

		HeightValue = origSpline.wH
		
		XformMod =  UVW_Xform ()
		addModifier SplineF XformMod
		XformMod.name = "FloorUVXform"
	)
)