
isObject = require "isObject"

wrongType = require "./utils/wrongType"
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

#
# Built-in primitives
#

{toString} = Object::

# Primitive types use `typeof` to validate.
["boolean", "function", "number", "string", "symbol"].forEach (type) ->
  valido.set type,
    test: (value) -> typeof value is type
    error: (key) -> wrongType key, type

valido.set "object",
  test: isObject
  error: (key) -> wrongType key, "object"

valido.set "array",
  test: Array.isArray
  error: (key) -> wrongType key, "array"

valido.set "null",
  test: (value) -> value is null
  error: (key) -> TypeError "`#{key}` must be null"

valido.set "date",
  test: (value) -> if value then (value.constructor is Date) else false
  error: (key) -> wrongType key, "date"

valido.set "error",
  test: (value) -> toString.call(value) is "[object Error]"
  error: (key) -> wrongType key, "error"

valido.set "regexp",
  test: (value) -> if value then (value.constructor is RegExp) else false
  error: (key) -> wrongType key, "regexp"

valido.set "promise",
  test: (value) -> if value then typeof value.then is "function" else false
  error: (key) -> wrongType key, "promise"

valido.set "any",
  test: (value) -> value isnt undefined
  error: (key) -> TypeError "`#{key}` must be defined"

if typeof process isnt "undefined"
  valido.set "buffer",
    test: Buffer.isBuffer
    error: (key) -> wrongType key, "buffer"
