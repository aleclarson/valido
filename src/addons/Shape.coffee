
isObject = require "isObject"

resolveError = require "../utils/resolveError"
resolveType = require "../utils/resolveType"
registry = require "../registry"
valido = require "../valido"

addons = valido._addons

assertShape = (values) ->

  unless isObject values
    return registry.get("object").error

  for key, type of @types
    return error if error = type.assert values[key], key

validator =
  assert: assertShape

validator.init = (shape) ->
  @types = {}
  for key, value of shape
    @types[key] = resolveType value
  return

valido.add validator, isObject

addons.Shape = (shape) ->
  inst = Object.create validator
  inst.init shape
  return inst
