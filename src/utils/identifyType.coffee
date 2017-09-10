
isObject = require "isObject"

valido = require "../valido"

addons = valido._addons

identifyType = (type) ->
  return type if typeof type is "string"
  unless isObject(type) and not addons.isValido(type)
    return type.name if typeof type.name is "string"

reducer = (array, type) ->
  array.push name if name = identifyType type
  return array

module.exports = (type) ->
  if Array.isArray type
  then type.reduce reducer, []
  else identifyType type
