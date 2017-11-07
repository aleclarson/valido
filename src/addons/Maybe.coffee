
registry = require "../registry"
valido = require "../valido"

addons = valido._addons

testMaybe = (value) ->
  return true if value is undefined
  return @type.test value

assertMaybe = (value) ->
  if value isnt undefined
    return @type.assert value

validator = valido
  test: testMaybe
  assert: assertMaybe

validator.init = (type) ->
  @type =
    if type.indexOf("|") isnt -1
    then addons.Either type.split "|"
    else registry.get type
  return

Object.defineProperty validator, "name",
  get: -> @type.name
  set: -> throw Error "`name` is not writable"

addons.Maybe = (type) ->
  inst = Object.create validator
  inst.init type
  return inst
