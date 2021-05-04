/*
  Author: AlexKimov
  Version: 0.1
  Description:
*/

filein "lib/raw.ms"

struct heightmapObject
(
  hSize = 257,
  groundLevel = 10,
  hHeights,
  -- fn setHeights heights =
  -- (
    -- hHeights = heights 
  -- ),
  fn loadFromRawFile =
  (
    raw = rawFile()
    if raw.openFile("rb") then
    (      
      if raw.readFile() then
        hHeights = raw.heightArray
      else
        return false      
      
      raw.closeFile()
      return true
    )  
    
    return false
  )
)


struct heightmapUtils
(
  size = 257,
  uTile = 10,
  vTile = 10,
  /*
    face array starts with lower left corner (heightmap grid) with clockwise order
  */
  fn generateFaces hSize =
  (
    local faceIndex = 1
    local col = 0
    local faceArray = #()
    for i = 0 to hSize*(hSize - 2) do 
	(		
      append faceArray [faceIndex + 1, faceIndex + hSize, faceIndex]
      append faceArray [faceIndex + 1, faceIndex + hSize + 1, faceIndex + hSize]
      col += 1
      faceIndex += 1
      if col > (hSize - 2) then 
	  (
	    col = 0
        faceIndex += 1
      ) 
    )
    result = faceArray
  ),
  /*
    vertex array fills from back to top from left to right, to transform 
    coordinates into 3dsmax ones
  */  
  fn heightsToVertexes heightmap zCoeff cellWidth cellHeight =
  (
    local col = 0
    local row = heightmap.hSize - 1
    
    vertArray = #()
    
    for point in heightmap.hHeights do  
	(	
      append vertArray [(col*cellWidth as float), \
        ((heightmap.hSize - row - 1)*cellHeight as float), \
        (point*zCoeff as float)]                 
      col += 1 
      if col > (heightmap.hSize - 1) then 
	  (
        row -= 1
        col = 0 
      ) 
    ) 
    
    return vertArray    
  ),
  /*
    material ids: 
      1 - sand texture by default
      2 - rock texture by default
      3 - blended rock and sand textures
  */  
  fn generateIds vertArray faceArray isBlended groundLevel = 
  (
    local idArray = #()
    for i = 1 to faceArray.count do
    (
      local indexes = #()
      append indexes faceArray[i].x
      append indexes faceArray[i].y
      append indexes faceArray[i].z    
      Z = 0
      for index in indexes do
      (
        if Z < vertArray[index].z then 
          z = vertArray[index].z
      )

      if Z >= groundLevel then
      (
        if isBlended then
        (
          if Z < groundLevel + 0.1 then
            append idArray 3
          else          
            append idArray 2         
        )
        else
          append idArray 2 
      )    
      else
          append idArray 1        
    )        
    result = idArray  
  ),  
  /*
    UV coordinates
  */   
  fn generateTVerts uTile vTile size = 
  (
    local tvertArray = #()
    local u = (uTile/(size - 1) as float)
    local v = (vTile/(size - 1) as float) 
        
    for row = 0 to (size - 1) do
      for col = 0 to (size - 1) do 
        append tvertArray [(u*col as float), (v*row as float), 0]               
    result = tvertArray    
  ),
   /*
    water level in .raw is about (0.38..0.41)*height
  */  
  fn getWaterLevel height = 
  (
    result = 0.4*height
  )   
)

heightmaps = heightmapUtils()