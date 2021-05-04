/*
  Author: AlexKimov
  Description: 
*/

struct typeConsts
(
  ERROR_NOT_INTEGER_TYPE = 1001,
  ERROR_NOT_BOOLEAN_TYPE = 1002
)

consts = typeConsts()

fn isBooleanType val = 
(
  result = isKindof val BooleanClass
)

fn isIntegerType val = 
(
  result = isKindof val Integer
)

struct strings
(
  items = #(),
  fn add str ignoreEmpty:true =
  (
    if not ignoreEmpty and trimLeft str == "" then 
      append this.items str
  ),
  fn itemsToStr multilined:false =
  (
    result = "" 
    for str in items where str != "" do
      result = result + str + (if multilined then "\n" else ", ")
  ),
  fn isEmpty =
  (
    if this.items.count > 0 then False else True
  ),
  fn release =
  (
    free this
  )
)