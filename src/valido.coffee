
isObject = require "isObject"

wrapAssert = require "./utils/wrapAssert"

validoTag = "valido_" + Math.random().toString(16).slice 2, 6
addons = []

addons.isValido = (value) ->
  value[validoTag] is true

valido = (config) ->

  if arguments.length > 1
    name = config
    config = arguments[1]

  if Array.isArray config
    return addons.Either config

  if typeof config is "function"
    config = {assert: config}

  else if isObject config
    unless isValidator config
      return addons.Shape config

  else throw TypeError "Expected an object, function, or array"

  if typeof config.assert isnt "function"
    config.assert = defaultAssert

  else if typeof config.test isnt "function"
    config.test = testAssert

  # All validators have their `validate` method wrapped.
  config.assert = wrapAssert config.assert

  # This is used for identifying validators.
  Object.defineProperty config, validoTag, {value: true}

  config.name = name if name
  return config

valido.add = (addon, resolve) ->
  addons.push valido addon
  addon.resolve = resolve
  return addon

Object.defineProperty valido, "_addons", {value: addons}

module.exports = valido

#
# Helpers
#

testAssert = (value) ->
  return @assert(value) is undefined

defaultAssert = (value) ->
  return @error unless @test value

isValidator = (config) ->

  if typeof config.assert is "function"
    return true

  if typeof config.test is "function"
    return true if typeof config.error is "function"
    return true if typeof config.assert is "function"
    throw Error "Validators must have an `assert` or `error` function"

  return false
