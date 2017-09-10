
identifyType = require "../utils/identifyType"
resolveType = require "../utils/resolveType"
wrongType = require "../utils/wrongType"
valido = require "../valido"

addons = valido._addons

validateEither = (value) ->
  return @optional if value is undefined
  return @nullable if value is null
  for type in @types
    result = type.validate value
    return result if result isnt false
  return false

assertEither = (value) ->
  for type in @types
    result = type.validate value
    return if result is true
    if typeof result is "string"
      return type.error.bind type, result
  return @error.bind this

validator =
  validate: validateEither
  assert: assertEither

validator.init = (types) ->

  unless Array.isArray types
    throw TypeError "Expected an array"

  if @optional = types[types.length - 1] is "?"
    types = types.slice 0, -1

  if @nullable = types[types.length - 1] is "null"
    types = types.slice 0, -1

  @types = types.map resolveType
  return

validator.error = (key) ->
  names = identifyType @types
  names.push "null" if @nullable
  return wrongType key, names

valido.add validator, Array.isArray

addons.Either = (types) ->
  inst = Object.create validator
  inst.init types
  return inst
