/*
	Description: Main Macroscript loader
	Version: 0.01
*/

--macroscript Lazy_Wall
--	category:"_MainUI"
--	tooltip:"Lazy Wall"
--	buttontext:"Lazy Wall"
--(
	clearListener(); print("Cleared in: "+getSourceFileName())
	
	try
	(
		killCallbacks ()
	)
	catch()
	
	filein( getFilenamePath(getSourceFileName()) + "/Lib/WallAttributes.ms" )	--"./Lib/WallAttributes.ms"
	filein( getFilenamePath(getSourceFileName()) + "/Lib/WallBboxes.ms" )	--"./Lib/WallBboxes.ms"
	filein( getFilenamePath(getSourceFileName()) + "/Lib/WallCut.ms" )	--"./Lib/WallCut.ms"
	filein( getFilenamePath(getSourceFileName()) + "/Lib/WallSpline.ms" )	--"./Lib/WallSpline.ms"
	filein( getFilenamePath(getSourceFileName()) + "/Lib/WallEdit.ms" )	--"./Lib/WallEdit.ms"
	filein( getFilenamePath(getSourceFileName()) + "/Lib/WallRefresh.ms" )	--"./Lib/WallRefresh.ms"
	filein( getFilenamePath(getSourceFileName()) + "/Lib/WallSplineFloor.ms" )	--"./Lib/WallSplineFloor.ms"
	
	--
	/*
		Initialize main methods from initialized structs 
	*/
	
	--global WallRefresh = WallRefreshStruct()

	wSetAtt ( selection as Array ) "Wall"

	--CleanUpWall()
	--Wall_PostNodeCloned()
	--Wall_selectedNodesPreDelete()
	
	--WallRefresh.Wall_OnSectionCHangeCallBack()
	OnSectionChangeCallBackAdd()
	
--)