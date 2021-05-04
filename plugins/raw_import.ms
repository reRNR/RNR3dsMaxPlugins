/*
  Author: AlexKimov
  Version: 0.31
  Description: Hard Truck 2 heightmap (.raw) file importer
  Format: *.raw
  Game: Hard Truck 2 King of the Road 1.3 / Дальнобойщики 2 (8.x)
*/

filein "lib/ms.ms"
filein "lib/ini.ms"
filein "lib/max.ms"
filein "lib/utils.ms"
filein "lib/heightmap.ms"
filein "lib/terrain.ms"
filein "lib/settings.ms"
filein "lib/dialogs.ms"
filein "lib/types.ms"
filein "lib/events.ms"


struct importDialogSettings
(
  rolloutWidth = 200,
  rolloutPos = [100, 100],
  rolloutStyle = #(#style_toolwindow, #style_sysmenu, #style_resizing), 
  zCoeff = 0.1,
  cellWidth = 1, 
  cellHeight = 1,
  meshHeight = 30,
  meshWidth = 257, 
  meshLength = 257,  
  uTile  = 1,
  vTile  = 1,
  treeNumb = 30,
  bushNumb = 30,
  treeHeight = 0.1,  
  bushHeight = 0.1,
  waterLevel = 0.1,  
  isTexturedSurface = false,
  texBlendingOn = false,
  treesOn = false,
  bushesOn = false,
  waterOn = false,
  aiOn = false,  
  textures = #("sand_tex.bmp", "rock_tex.bmp", "tree_tex.bmp", "bush_tex.bmp", \
    "water_tex.bmp"), 
  texturesPath = "",  
  ignoreTexPath = false,
  errorNotIntegerString = "Field % must be of integer type.",
  errorNotBooleanString = "Field % must be of boolean type.",
  errorMustBeGreaterString = "Field % must be greater than %.",
  errorMustBeLessString = "Field % must be not greater than %.",
  fn loadFromIni filename =
  (
    local settings = settings(this)
    settings.loadFromIniFile filename "ImportRolloutDialog"
  ), 
  fn formatErrorString fieldName errorType value range: =
  (    
    result = stringStream  ""
    if valType == consts.ERROR_NOT_INTEGER_TYPE then 
      if not isIntegerType value then
        format this.errorNotIntegerString fieldName to:result 
      else   
        if range != unsupplied then
        ( 
          if value <= range[0]  then
            format this.errorMustBeGreaterString value to:result
          if value > range[1] then
            format this.errorMustBeLessString value to:result  
        )          
        
    if valType == consts.ERROR_NOT_BOOLEAN_TYPE then         
      if not isBooleanType value then
        format this.errorNotBooleanString fieldName to:result        
        
    return result as string   
  ),
  fn setAll isTexSurface: isTexBlended: showTrees: showBushes: showWater: aiOn: \
    zCoeff: cellWidth: cellHeight: textures: =
  (
    strs = strings()
    try 
    (
      if isTexSurface != unsupplied then
      (
        str = formatErrorString "isTexSurface" consts.ERROR_NOT_BOOLEAN_TYPE isTexSurface
        if str != "" then 
          strs.add(str) 
        else 
          this.isTexturedSurface = isTexSurface
      )        
      if isTexBlended != unsupplied then
        strs.add (formatErrorString "texBlendingOn" consts.ERROR_NOT_BOOLEAN_TYPE isTexBlended)        
      if showTrees != unsupplied then
        strs.add(formatErrorString "showTrees" consts.ERROR_NOT_BOOLEAN_TYPE showTrees)      
      if showBushes != unsupplied then  
        strs.add(formatErrorString "showBushes" consts.ERROR_NOT_BOOLEAN_TYPE showBushes)      
      if showWater != unsupplied then  
        strs.add(formatErrorString "showWater" consts.ERROR_NOT_BOOLEAN_TYPE showWater)
        
      if zCoeff != unsupplied then  
        strs.add(formatErrorString "zCoeff" consts.ERROR_NOT_INTEGER_TYPE \
          zCoeff range:[0, 1])           
      if cellWidth != unsupplied then  
        strs.add(formatErrorString "cellWidth" consts.ERROR_NOT_INTEGER_TYPE \
          cellWidth range:[0, 1000]) 
      if cellHeight != unsupplied then 
        strs.add(formatErrorString "cellHeight" consts.ERROR_NOT_INTEGER_TYPE \
          cellHeight range:[0, 1000])
          
      if cellHeight != unsupplied then
        this.textures = textures       
        
      if not strs.isEmpty() then
        throw "ERROR! " + "\n" + strs.itemsToStr multilined:true   
    )  
    catch
    (
      strs.release() 
      return false        
    )
    
    strs.release()
    return true
  )
)

struct importDialogStrings
(
  parametersRolloutTitle = "Mesh parameters",
  
  groupBoxMeshSizesTitle = "Dimensions",
  rolloutTitle = "Import .raw file", 
  heightCoeffspinnerTitle = "Height coeff.",
  cellWidthspinnerTitle = "Grid cell width",
  cellHeightspinnerTitle = "Grid cell length",

  spinnerMeshHeightspinnerTitle = "Height",
  spinnerMeshWidthspinnerTitle = "Width",
  spinnerMeshLengthspinnerTitle = "Length",  
  
  scatterGroupCaption = "Scatter",
  blendCheckBoxTitle = "Blend textures",  
  treeCopysspinnerTitle = "Number",
  bushCopysspinnerTitle = "Number",  
  heightspinnerTitle = "Height", 
  addObjectsRolloutTitle = "Objects",
  objectsGroupCaption = "Objects",
  levelspinnerTitle = "Level",
  texturesGroupCaption = " Texture List", 
  chooseButtonCaption = "Choose",   
  optionsButtonCaption = "options",
  addButtonCaption = "Add",  
  aiCheckBoxTitle  = "Ai paths",
  fnCheckBoxTitle = "filename:",
  triCheckBoxTitle = "triangles:",
  facesCheckBoxTitle = "faces:",
  sbCheckBoxTitle = "Add skybox",
  labelText = "click to open file",
  buttonCaption = "Import",
  buttonUpdateCaption = "Update",  
  texCheckBoxTitle  = "Add textures", 
  cantCreateDialog  = "Can't create ui dialog.",
  treesCheckBoxTitle = "Add trees", 
  bushesCheckBoxTitle = "Add bushes",
  waterCheckBoxTitle = "Add water",
  treeCopysspinnerText = "Copy",
  bushCopysspinnerText = "Bush",
  treeHeightspinnerText = "Height",
  imageLabelTxt = "Image",
  buttonChooseTexTitle = "Choose",
  buttonChooseTexTooltip = "Choose texture from file",
  heigthspinnerTitle = "height",
  importRolloutTitle = "Import",
  radiobuttonsSizeRelabel = #("Relative"),
  radiobuttonsSizeAbsLabel = #("Absolute"),
  addObjectsCheckBoxTitle = "add objects",
  texturePathChangeQuestion = "One of texture files not found. Do you want to change the path to texture files?",
  warningTitle = "warning",
  uCoordinateSpinnerTitle = "U",
  vCoordinateSpinnerTitle = "V",
  buttonPathToTexTooltip = "Set path to texture folder",
  buttonPathToTexturesCaption = "Set path",
  checkboxhmManuallyText = "Place mesh using mouse",
  fn loadFromIni filename =
  (
    local settings = settings(this)
    settings.loadFromIniFile filename "Strings"
  ) 
)

struct importDialog
(
  dialogSettings,
  dialogStrings,
  terMesh,
  event_timer,
  parametersRollout = 
  (
    rollout parametersRollout dialogStrings.parametersRolloutTitle rolledUp:false
    (
      local owner = if owner != undefined do owner
      local settings = if settings != undefined do settings 
      local strings = if strings != undefined do strings
      
      checkbox checkbox_placeMeshManually strings.checkboxhmManuallyText \
        pos:[10, 0] width:140 height:15 checked:settings.isTexturedSurface

      -- Mesh settings UI
      groupBox group_size strings.groupBoxMeshSizesTitle pos:[10, 20] \
        height:200 width: 160    

      radiobuttons rb_sizeTypeRelative \
        labels:strings.radiobuttonsSizeRelabel pos:[15, 40]        

	    spinner spinner_heightCoeffRel strings.heightCoeffspinnerTitle \
          pos:[59, 60] range:[0, 1, settings.zCoeff] width:90 height:22 type:#float
	    spinner spinner_cellWidthRel strings.cellWidthspinnerTitle \ 
          pos:[57, 82] width:92 height:22 range:[0, 257, settings.cellWidth] \
          type:#integer
	    spinner spinner_cellLengthRel strings.cellHeightspinnerTitle type:#integer \
          pos:[53,105] width:96 height:22 range:[0, 257, settings.cellHeight]             
         
      radiobuttons rb_sizeTypeAbs labels:strings.radiobuttonsSizeAbsLabel \
          pos:[15, 130] default:-1             

	    spinner spinner_heightCoeffAbs strings.spinnerMeshHeightspinnerTitle \
          pos:[79, 150] range:[0, 10000, settings.meshHeight] width:70 height:22 type:#float enabled:false 
	    spinner spinner_cellWidthAbs strings.spinnerMeshWidthspinnerTitle \ 
          pos:[77, 172] width:72 height:22 \
          range:[0, 10000, settings.meshWidth] type:#float enabled:false 
	    spinner spinner_cellLengthAbs strings.spinnerMeshLengthspinnerTitle type:#float pos:[73, 192] width:76 height:22 range:[0, 10000, settings.meshLength] enabled:false 
                 
    -- Textures settings UI  
	    checkbox checkbox_textured strings.texCheckBoxTitle pos:[10, 205] \
          width:70 height:30 checked:settings.isTexturedSurface
	    checkbox checkbox_texBlending strings.blendCheckBoxTitle \
          pos:[10, 232] width:90 height:20 checked:settings.texBlendingOn
	    listbox listbox_textures strings.texturesGroupCaption \
          pos:[10, 260] width:160 height:5  items: settings.textures 
          
	    spinner spinner_textureU strings.uCoordinateSpinnerTitle \ 
          pos:[110, 213] width:50 height:22 range:[0, 257, settings.uTile]      
	    spinner spinner_textureV strings.vCoordinateSpinnerTitle  \
          pos:[110, 235] width:50 height:22 \
          range:[0, 257, settings.vTile]           
          
      button button_changeTexture strings.buttonChooseTexTitle \
        tooltip:strings.buttonChooseTexTooltip width:70 pos:[10, 360] 
      button button_setPathToTextures strings.buttonPathToTexturesCaption \
        tooltip:strings.buttonPathToTexTooltip width:70 pos:[100, 360] 
      --
      on listbox_textures selected item do
      (
        listbox_textures.tooltip = settings.texturesPath + "\\" + listbox_textures.selected
      )

      on rb_sizeTypeAbs changed state do
      (
        rb_sizeTypeAbs.state = 1
        rb_sizeTypeRelative.state = 0

        owner.disableControls()     
      ) 

      on rb_sizeTypeRelative changed state do
      (
        rb_sizeTypeRelative.state = 1
        rb_sizeTypeAbs.state = 0 

        owner.disableControls allExceptCurrent:true         
      )   
      
      on checkbox_placeMeshManually changed theState do
      (
      owner.disableControls()
      )
           
      on button_changeTexture pressed do
      (     
        owner.changeSelectedTexture()
      )  
      
      on button_setPathToTextures pressed do
      (
        owner.setPathToTextures()
      ) 
        
    )  
  ),
  addObjectsRollout =
  ( 
    rollout addObjectsRollout dialogStrings.addObjectsRolloutTitle
    (
      local owner = if owner != undefined do owner
      local settings = if settings != undefined do settings 
      local strings = if strings != undefined do strings     
          
     -- additional objects UI         
	  checkbox checkbox_trees strings.treesCheckBoxTitle pos:[10, 5] \
          width:90 height:27 
	  checkbox checkbox_bushes strings.bushesCheckBoxTitle pos:[10, 65] \
          width:90 height:30 
	  checkbox checkbox_water strings.waterCheckBoxTitle pos:[10, 130] \
          width:90 height:22
	  checkbox checkbox_skybox strings.sbCheckBoxTitle pos:[10, 175] \
          width:90 height:11 enabled:false  
          
	  spinner spinner_waterLevel strings.levelspinnerTitle pos:[90, 151] \
          width:60 height:22 range:[0, 1, settings.waterLevel]                    
 	  spinner spinner_treeheight strings.heightspinnerTitle pos:[88, 50] \
          width:60 height:22 range:[0, 1000, settings.treeHeight] type:#integer
	  spinner spinner_bushheight strings.heightspinnerTitle pos:[90, 110] \
          width:60 height:22 range:[0, 1000, settings.bushHeight] type:#integer
          
      -- scatter settings     
	  spinner spinner_treecopys strings.treeCopysspinnerTitle pos:[80, 30] \
          width:70 height:22 range:[0, 1000, settings.treeNumb] 
	  spinner spinner_bushcopys strings.bushCopysspinnerTitle pos:[80, 91] \
          width:70 height:22 range:[0, 1000, settings.bushNumb] 
    )    
  ),
  importRollout =
  ( 
    rollout importRollout dialogStrings.importRolloutTitle
    (
      local owner = if owner != undefined do owner
      local settings = if settings != undefined do settings 
      local strings = if strings != undefined do strings 

        
	  button button_update strings.buttonUpdateCaption  \
          width:86 height:22 enabled:false toolTip:"Update" 
	  button button_import strings.buttonCaption \
          width:86 height:22   

      on button_update pressed do with undo off 
      (
        
      )
      
      on button_import pressed do with undo off 
      (   
        owner.loadHeightmapFormRawFile() 
      )          
    )      
  ),      
  dialog =
  (
    rollout dialog dialogStrings.rolloutTitle
    (
      subrollout subroll_container "container" height:630 width:196 pos:[2, 2]
      on dialog resized point do
      (
        subroll_container.height = dialog.height
      )  	   
    )  
  ),
  fn disableControls currentCtrl: =
  (
    for ctrl in this.parametersRollout.controls do
      if currentCtrl == unsupplied then
        if (classOf ctrl as string) == "SpinnerControl" and \
          ctrl.pos.y < 180 then
            ctrl.enabled = not ctrl.enabled  
      else   
        try 
        (
          if ctrl != currentCtrl then
            ctrl.enabled = not ctrl.enabled  
        ) 
        catch ()   
  ),
  fn setPathToTextures =
  (
    local path = dialogs.openFolder "Open folder" 
    if path != undefined then 
      dialogSettings.texturesPath = path
  ),
  fn getFormControlsData =
  (
    parRollout = dialog.subroll_container.parametersRollout
    addObjRollout = dialog.subroll_container.addObjectsRollout
    
    dimensionsType = dialog.subroll_container.parametersRollout.rb_sizeType.checked
    height = (if dimensionsType.state == 1 then parRollout.spinner_heightCoeff.text \
      else parRollout.spinner_spinnerMeshHeghtspinnerTitle.text)
    width = (if dimensionsType.state == 1 then parRollout.spinner_cellWidth.text \
      else parRollout.spinner_spinnerMeshWidthspinnerTitle.text)
    length = (if dimensionsType.state == 1 then parRollout.spinner_cellHeight.text \
      else parRollout.spinner_spinnerMeshLengthspinnerTitle.text)
    
    if not dialogSettings.setAll \
      isTexSurface:parRollout.checkbox_textured.checked \
      isTexBlended:parRollout.checkbox_texBlending.checked \
      showTrees:addObjRollout.checkbox_trees.checked \
      showBushes:addObjRollout.checkbox_bushes.checked \
      showWater:addObjRollout.checkbox_water.checked \
      zCoeff: height \
      cellWidth: width \
      cellHeight: length \
      textures:dialog.subroll_container.parametersRollout.listbox_textures.items
      then 
        return false

    return true        
  ),
  fn changeSelectedTexture =
  (
    local filename = getOpenFileName caption: "" types: ""
    if filename != undefined then 
    (
      texList = dialog.subroll_container.parametersRollout.listbox_textures
      texList.selected = filenameFromPath filename    
    )
  ),
  fn checkIfTextureFilesInPathExist = 
  (
    for tex in dialogSettings.textures do    
      if not fileUtils.isFileExist (dialogSettings.texturesPath + tex) then
      (
        if (yesNoCancelBox dialogStrings.texturePathChangeQuestion \
          title:dialogStrings.warningTitle) == #yes then
          dialogSettings.texturesPath = getSavePath "Open folder with texture files"
        
        return 0
      )        
  ),  
  fn loadHeightmapFormRawFile =
  (
    if getFormControlsData()then
    (    
      checkIfTextureFilesInPathExist()  
  
      local heightmap = heightmapObject()
      if heightmap.loadFromRawFile() then with redraw off() 
      (
        terMesh = terrainMesh()
        terMesh.settings.assign this.dialogSettings
        terMesh.createFromHeightmap heightmap
      )   
    )
  ),
  fn eventTimerProcedure s: e: =
  (
    (getMouseButtons())
    try 
    (
      if VMouse.MouseButtons() == 4 do 
      (
	  -- //print "stop..."    
	  -- this.event_timer.Stop()
      )  
    )
    catch
    (
     print "error"
    )    
  ),
  fn eventTimerInit =
  (
    this.event_timer = dotnetobject "Timer"
    this.event_timer.interval = 100
    
    -- add event handlers
    dotnet.addEventHandler this.event_timer "Tick" eventTimerProcedure
    
    this.event_timer.Start()    
  ),
  fn show =
  (
    result = createDialog dialog width:settings.rolloutwidth height:640 \
      pos:settings.rolloutPos style:settings.rolloutStyle lockWidth:true

	AddSubRollout dialog.subroll_container parametersRollout   
	AddSubRollout dialog.subroll_container addObjectsRollout rolledup:true    
	AddSubRollout dialog.subroll_container importRollout
    
    if not result then 
      dialogs.showMessage strings.cantCreateDialog   
  ),
  fn close = 
  (
    try (destroyDialog dialog) catch()
    try (this.event_timer.Dispose()) catch() 
  ),
  fn init = 
  (
    try (destroyDialog dialog) catch()
  
    if dialogSettings == undefined then
      dialogSettings = importDialogSettings()
    if dialogStrings == undefined then  
      dialogStrings = importDialogStrings()
      
    parametersRollout.owner = this
    parametersRollout.settings = dialogSettings
    parametersRollout.strings = dialogStrings  

    addObjectsRollout.owner = this
    addObjectsRollout.settings = dialogSettings
    addObjectsRollout.strings = dialogStrings 
    addObjectsRollout.placement = minimized    

    importRollout.owner = this
    importRollout.settings = dialogSettings
    importRollout.strings = dialogStrings 

    -- eventTimerInit()    
  ),
  on create do init()
)

fn main = 
(
  currrentPath = fileUtils.getCurrentPath(getThisScriptFilename())
  textureFolder = "textures\\"
  
  settings = importDialogSettings()
  -- iniFileName = "settings.ini"
  -- settings.loadFromIni(currrentPath + iniFileName)
  -- settings.texturesFolderName = textureFolder
  -- settings.path = currrentPath
  --strings = importDialogStrings()
  --iniFileName = "settings.ini"
  --strings.loadFromIni(currrentPath + iniFileName)
  
  importUI = importDialog()
  importUI.show()
)

main()