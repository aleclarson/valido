
wrongType = require "../wrongType"

expected = null
validator = {}

validator.test = (value) ->
  valid = value? and value.constructor is expected
  expected = null
  return valid

validator.assert = (value) ->

  if value? and value.constructor is expected
    expected = null
    return

  {name} = expected
  expected = null
  return (key) -> wrongType key, name

module.exports = (type) ->
  expected = type
  return validator
