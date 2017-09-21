
isObject = require "isObject"

resolveError = require "../utils/resolveError"
resolveType = require "../utils/resolveType"
registry = require "../registry"
valido = require "../valido"

addons = valido._addons

validateShape = (values) ->
  return false unless isObject values

  for key, type of @types
    result = type.validate values[key]
    if result isnt true
      return key if result is false
      return key + "." + result

  return true

assertShape = (values) ->
  result = validateShape values, @types
  if result isnt true
    if result is false
    then registry.get("object").error
    else @error.bind this, result

validator =
  validate: validateShape
  assert: assertShape

validator.init = (shape) ->
  @shape = shape
  @types = types = {}
  for key, value of shape
    types[key] = resolveType value
  return

validator.error = (key, parent) ->
  type = key.split(".").reduce access, @shape
  key = parent + "." + key if parent
  return resolveError key, type

# Used to reduce a key path.
access = (obj, key) -> obj[key]

valido.add validator, isObject

addons.Shape = (shape) ->
  inst = Object.create validator
  inst.init shape
  return inst
