
registry = require "../registry"
Either = require "./Either"

expected = null
validator = {}

validator.test = (value) ->
  valid = value is undefined or getValidator().test value
  expected = null
  return valid

validator.assert = (value) ->

  if value is undefined
    expected = null
    return

  error = getValidator().assert value
  expected = null
  return error

getValidator = ->
  if 0 <= expected.indexOf "|"
    return Either expected.split "|"
  return registry.get expected

# The `type` argument must be a string.
module.exports = (type) ->
  expected = type
  return validator
