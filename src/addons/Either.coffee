
identifyType = require "../utils/identifyType"
resolveType = require "../utils/resolveType"
wrongType = require "../utils/wrongType"
valido = require "../valido"

addons = valido._addons

testEither = (value) ->
  return @optional if value is undefined
  return @nullable if value is null
  for type in @types
    return true if type.test value
  return false

assertEither = (value) ->
  return if @optional and value is undefined
  return if @nullable and value is null
  for type in @types
    return unless error = type.assert value
    return error if error.path
  return @error.bind this

validator =
  test: testEither
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
