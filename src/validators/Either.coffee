
wrongType = require "../wrongType"
registry = require "../registry"

# The `types` argument must be an array.
module.exports = (types) ->
  validator = {}

  if optional = types[types.length - 1] is "?"
    types = types.slice 0, -1

  if nullable = types[types.length - 1] is "null"
    types = types.slice 0, -1

  names = null
  error = (key) ->
    unless names
      names = types.reduce getName, []
      names.push "null" if nullable
    return wrongType key, names

  validator.test = (value) ->
    return optional if value is undefined
    return nullable if value is null
    for type in types

      if typeof type is "string"
        return yes if registry.get(type).test value

      else if typeof type is "function"
        return yes if value.constructor is type

      else if typeof type.test is "function"
        return yes if type.test value

      else throw Error "Malformed validator"

    return no

  validator.assert = (value) ->
    unless @test value
      return error

  return validator

getName = (names, type) ->
  if typeof type is "string"
    names.push type
  else if type.name
    names.push type.name
  return names
