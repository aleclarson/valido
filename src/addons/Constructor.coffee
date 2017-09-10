
wrongType = require "../utils/wrongType"
valido = require "../valido"

testConstructor = (value) ->
  return value? and value.constructor is @type

assertConstructor = (value) ->
  if !value? or value.constructor isnt @type
    return @error.bind this

validator =
  test: testConstructor
  assert: assertConstructor

validator.init = (type) ->
  @name = type.name
  @type = type
  return

validator.error = (key) ->
  return wrongType key, @name

valido.add validator, (value) ->
  typeof value is "function"
