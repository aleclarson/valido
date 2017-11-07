
keys = []

wrapAssert = (assert) -> (value, key) ->
  if error = assert.call this, value
    if key then keys.unshift key
    else if keys.length is 0
      return error
    return bindError error

module.exports = wrapAssert

#
# Helpers
#

bindError = (createError) ->
  path = keys; keys = []
  bound = (key) -> createError formatPath key, path
  bound.path = path
  return bound

formatPath = (key, path) ->
  if key then path.unshift key
  else if path.length is 0
    return null
  return path.join "."
