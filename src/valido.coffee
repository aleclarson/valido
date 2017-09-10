
isObject = require "isObject"

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

  if typeof config.test isnt "function"

    if typeof config.validate is "function"
      config.test = testValidate

    else if typeof config.assert is "function"
      config.validate = defaultValidate
      config.test = testAssert

    else throw Error "Validators must have a `test`, `validate`, or `assert` function"

  else

    if typeof config.validate isnt "function"
      config.validate = defaultValidate

    if typeof config.assert isnt "function"
      config.assert = defaultAssert

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

testValidate = (value) ->
  return @validate(value) is true

testAssert = (value) ->
  return @assert(value) is undefined

defaultValidate = (value) ->
  return @test value

defaultAssert = (value) ->
  return @error unless @test value

isValidator = (config) ->

  if typeof config.test isnt "function"
    if typeof config.validate isnt "function"
      return false if typeof config.assert isnt "function"

  if typeof config.assert isnt "function"
    if typeof config.error isnt "function"
      throw Error "Validators must have an `assert` or `error` function"

  return true
