/*
  Author: AlexKimov
  Version: 0.1
  Description: 
*/

filein "max.ms"
filein "heightmap.ms" 

struct terrainSettings
(
  isTextured = false,
  texBlending = false,
  trees = false,
  bushes = false,
  water = false,
  textures = #(),
  zCoeff = 0.1,
  cellWidth = 1, 
  cellHeight = 1,
  uTile = 1,
  vTile = 1, 
  fn assign settings =
  (  
    this.isTextured = settings.isTexturedSurface
    this.texBlending = settings.texBlendingOn
    this.trees = settings.treesOn
    this.bushes = settings.bushesOn
    this.water = settings.waterOn
    this.textures  = settings.textures 
    this.zCoeff = settings.zCoeff
    this.cellWidth = settings.cellWidth
    this.cellHeight = settings.cellHeight
    this.uTile = settings.uTile
    this.vTile = settings.vTile  
  ),
  path = "",
  texturesFolderName = ""  
)

struct position
(
  coord = [0, 0, 0],
  rot = (EulerAngles 0 0 90) 
)

struct scatterOptions
(
  type = 1, -- scatter by height
  heightMax = 0,
  heightMin = 0
)

struct terrainMesh
(
  settings,
  heightmapMesh,
  treeMesh,
  bushMesh,
  waterMesh,
  fn setTextures tx = 
  (
    
  ),
  fn createHeightmapMesh heightmap nme:"heightmap" =
  (
    local vertexArray = heightmapUtils.heightsToVertexes heightmap \
      settings.zCoeff settings.cellWidth settings.cellHeight
    local faceArray = heightmapUtils.generateFaces (heightmap.hSize)
    
    if settings.isTextured then
    (   
      local materialIDs = heightmapUtils.generateIds vertexArray faceArray \
        isTexBlended heightmap.groundLevel
      local tverts = heightmapUtils.generateTVerts (settings.uTile) (settings.vTile) (heightmap.hSize)
      return max.createTexturedMesh vertexArray faceArray materialIDs tverts nme     
    ) else
      return max.createMesh vertexArray faceArray nme      
  ),
  fn createObjectMesh size pos bmap nme =
  (
    msh = max.createPlaneMesh size pos.coord nme
    if msh != undefined then 
    (
      max.addBitmapToMesh msh bmap
      max.rotateMesh msh pos.angle
      result = msh 
    )    
  ),
  fn scatterObjectOverMsh msh distribMesh settings duplicates:30 =
  (
    if settings == unsupplied then
      settings = scatterOptions()
    local newNodeArr = #()
    dimensions = max.distribMesh msh
    local vertexArray = max.getMeshVerts msh
    local vArray = for vertex in vertexArray where vertex.z <= settings.height \
      collect vertex    
    for i = 1 to duplicates do
    (
      --if settings.type == 1 then            
      local newPos = getVert vArray (random 1 vArray.numVerts)     
      max.cloneMesh msh newPos &newNodeArr 
      local newInst = newNodeArr[1]				
      local scaleRand = (random 0.01 1.0)
      newInst.scale = [scaleRand, scaleRand, scaleRand]         
    )
  ),       
  fn addTrees =
  (
    local treeBitmap = max.openBitmapFromFile (texturesPath + settings.texture[3])
    if treeBitmap != undefined then
    (
      local pos = position()
      pos.coord = [0, 0] 
      pos.rot = (EulerAngles 0 0 90)        
      treeMesh = createObjectMesh [0.1, 0.1] pos treeBitmap "tree" 
      op = scatterOptions()
      op.heightMax = 10 
      op.heightMin = 10            
      scatterObjectOverMsh treeMesh msh options:op
    )     
  ),
  fn addBushes =
  (
    local bushBitmap = max.openBitmapFromFile (texturesPath + settings.texture[4]) 
    if bushBitmap != undefined then 
    (    
      local pos = position()
      pos.coord = [0, 0] 
      pos.rot = (EulerAngles 0 0 90)             
      bushMesh = createObjectMesh [0.1, 0.1] pos bushBitmap "bush" 
      op = scatterOptions()
      op.heightMax = 10 
      op.heightMin = 10             
      scatterMesh bushMesh msh options:op         
    )       
  ),  
  fn addWater = 
  (
    local waterBitmap = max.openBitmapFromFile (texturesPath + settings.texture[5])             
    dimensions = max.getMeshDimension msh     
    local size = [dimensions[1], dimensions[2]]
    local pos = position()
    pos.coord = [msh.pos.x, msh.pos.y, raw.getWaterLevel()]        
    waterMesh = createObjectMesh size pos waterBitmap "water"  
  ),
  fn addTexturesToMesh msh =
  (
    local sandTexture = max.openBitmapFromFile (texturesPath + settings.texture[1])
    local rockTexture = max.openBitmapFromFile (texturesPath + settings.texture[2])

    if sandTexture != undefined and rockTexture != undefined then
    (     
      local textureBitmap = #()             
      append textureBitmap sandTexture      
      append textureBitmap rockTexture
      progressUpdate 75          
      local terrainMaterial = max.createBitmapMultiMaterial textureBitmap \
        texBlending
      max.addMaterialToMesh (msh) (terrainMaterial)             
    )   
  ),
  fn createFromHeightmap heightmap =
  (
    progressStart "creating meshes"  
           
    msh = createHeightmapMesh heightmap
    progressUpdate 30 
    -- progressUpdate 45
    -- if msh != undefined then
    -- (
      -- if settings.isTextured then      
        -- addTexturesToMesh()

      -- progressUpdate 80   
        
      -- if settings.treesOn then
        -- addTrees()
        
      -- progressUpdate 85  
        
      -- if settings.bushesOn then
        -- addBushes()
        
      -- progressUpdate 90 
      
      -- if settings.waterOn then
        -- addWater()
        
      -- progressUpdate 95             
    -- )            
    
    -- progressUpdate 100    
    
    if msh != undefined then 
      redrawViews()
      
    progressEnd()   
  ),
  fn init =
  (
    settings = terrainSettings()
  ),
  on create do init()  
)