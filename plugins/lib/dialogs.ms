/*
  Author: AlexKimov
  Version: 0.1
  Description:
*/

filein "utils.ms"

struct dialogs
(
  caption = "",
  types = "",
  filename = "",
  fn isValue txt message: =
  (
    if txt != "" then
    (
      try
      (
        val = execute txt
        result = true
      )
      catch 
      (
        if message == unsupplied then
          messageBox "ERROR. Not a number: " + txt + "."
        else 
          messageBox "ERROR. Not a number: " + txt + ". " + message        
        result = false
      )
    )  
    else 
      result = false        
  ),
  fn isNonNegativeValue txt =
  (
    value = converter.stringToInteger txt
    if value <= 0 then 
    (
      messageBox ("Error. Value: " + txt + " must be greater than or equal to zero.")
      result = false
    )  
    else
      result = true  
  ),  
  fn checkInputValue txt checkType =
  (  
    result = false
    if isValue txt then  
      result = isnNonNegativeValue txt         
  ),  
  fn openFileDialog mode =
  (
  	if filename == "" then
      filename = 
      (      
	    if mode == "rb" then 
          getOpenFileName caption: caption types: types
	    else
          getSaveFileName caption: caption types: types
      )  
	if filename != undefined then
      filestream = fopen filename mode  
  ), 
  fn saveFile =
  (
  
  ),   
  fn openFolder caption =
  (
    getSavePath caption: caption
  ),
  fn showMessage caption =
  (
    messageBox caption
  )  
)

dialogs = dialogs()

struct openDialog
(
  private
  filestream,
  caption,
  types,
  public
  fn open mode =
  (
  	if this.filestream == undefined then
      filename = 
      (      
	    if mode == "rb" then 
          getOpenFileName caption: this.caption types: this.types
	    else
          getSaveFileName caption: this.caption types: this.types
      )  
    
    this.filestream = fopen filename mode 
    
    if this.filestream == undefined then
      return false
      
    return true
  ),
  fn setCaption caption =
  (
    this.caption = caption
  ),
  fn getFilename =
  ( 
    return this.filename
  ),
  fn getFilestream =
  ( 
    return this.filestream
  ),  
  fn setTypes types =
  ( 
    return this.types = types
  )   
)