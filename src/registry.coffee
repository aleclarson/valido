
defaults = require "./defaults"

registry = Object.create null

exports.get = (id) ->
  return validator if validator = registry[id]
  throw Error "Unknown type: '#{id}'"

exports.set = (id, validator) ->
  if typeof validator.assert isnt "function"
    validator.assert = defaultAssert
  registry[id] = validator
  return

defaultAssert = (value) ->
  return @error unless @test value

Object.keys(defaults).forEach (id) ->
  exports.set id, defaults[id]
