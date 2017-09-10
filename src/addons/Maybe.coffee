
registry = require "../registry"
valido = require "../valido"

addons = valido._addons

validateMaybe = (value) ->
  return true if value is undefined
  return @type.validate value

assertMaybe = (value) ->
  if value isnt undefined
    return @type.assert value

validator = valido
  validate: validateMaybe
  assert: assertMaybe

validator.init = (type) ->
  @type =
    if type.indexOf("|") isnt -1
    then addons.Either type.split "|"
    else registry.get type
  return

addons.Maybe = (type) ->
  inst = Object.create validator
  inst.init type
  return inst
