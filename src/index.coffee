
isObject = require "isObject"

registry = require "./registry"

valido = require "./valido"

valido.get = require "./utils/resolveType"

valido.set = (tag, config) ->

  if typeof tag isnt "string"
    throw TypeError "`tag` must be a string"

  if typeof config is "function"
    validator = valido {assert: config}

  else if isObject config
    validator = valido config

  else throw TypeError "Expected an object or function"

  validator.name = tag
  return registry.set tag, validator

module.exports = valido

