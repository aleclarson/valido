
setProto = require "setProto"
isObject = require "isObject"

wrongType = require "./wrongType"
registry = require "./registry"

# Built-in validators
Constructor = require "./validators/Constructor"
Optional = require "./validators/Optional"
Either = require "./validators/Either"

# Create a validator that is not stored in the registry.
valido = (name, validator) ->

  if typeof name isnt "string"
    validator = name
    name = ""

  # Validate with an array of constructors/strings/validators.
  if Array.isArray validator
    validator = Either validator

  # Validate with a function that returns an error constructor.
  else if typeof validator is "function"
    validator = {test: defaultTest, assert: validator}

  # Validate with an object containing `test` and `error/assert` functions.
  else if isObject validator
    unless isValidator validator
      validator = createShape validator

  else throw TypeError "Expected an object, function, or array"

  validator.name = name
  return setProto validator, valido.prototype

# Resolve the given type into a validator.
valido.get = (type) ->

  if typeof type is "string"

    if type[type.length - 1] is "?"
      return Optional type.slice 0, -1

    if 0 <= type.indexOf "|"
      return Either type.split "|"

    return registry.get type

  if type.constructor is valido
    return type

  if typeof type is "function"
    return Constructor type

  if isObject type
    return createShape type

  if Array.isArray type
    return Either type

  throw Error "Unknown type: '#{type}'"

# Set a validator in the registry.
valido.set = (id, validator) ->

  if typeof id isnt "string"
    throw TypeError "`id` must be a string"

  if typeof validator is "function"
    return registry.set id, {test: defaultTest, assert: validator}

  if isObject validator
    unless isValidator validator
      validator = createShape validator
    return registry.set id, validator

  throw TypeError "`validator` must be an object or function"

module.exports = valido

#
# Helpers
#

access = (obj, key) ->
  return obj[key]

defaultTest = (value) ->
  return !@assert value

isValidator = (validator) ->

  if typeof validator.test isnt "function"

    if (typeof validator.assert is "function") or (typeof validator.error is "function")
      throw Error "Validators must have a `test` function"

    return false

  if typeof validator.assert isnt "function"
    if typeof validator.error isnt "function"
      throw Error "Validators must have an `assert` or `error` function"

  else if typeof validator.error is "function"
    throw Error "Validators cannot have both an `assert` and `error` function"

  return true

validateShape = (values, types) ->
  return false unless isObject values
  for key, type of types

    result =
      if isObject type
      then validateShape values[key], type
      else valido.get(type).test values[key]

    if result isnt true
      return key if result is false
      return key + "." + result

  return true

createShape = (types) ->
  test: (values) -> validateShape(values, types) is true
  assert: (values) ->
    result = validateShape values, types
    return if result is true
    return (key) ->

      if result is false
        return registry.get("object").error key

      key = if key then key + "." + result else result
      type = result.split(".").reduce access, types

      if typeof type is "string"

        if type[type.length - 1] is "?"
          type = type.slice 0, -1

        if 0 <= type.indexOf "|"
          type = type.split "|"

      else if Array.isArray type
        type = type.reduce getName, []

      else if isObject type
        type = "object"

      # Constructor or `valido` instance
      else if type.name
        type = type.name

      # Anonymous type
      else return TypeError "`#{key}` is an invalid type"

      return wrongType key, type

getName = (names, type) ->
  if typeof type is "string"
    names.push type
  else if type.name
    names.push type.name
  return names
