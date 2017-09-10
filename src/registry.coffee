
registry = Object.create null

exports.get = (tag) ->
  return validator if validator = registry[tag]
  throw Error "Unknown type: '#{tag}'"

exports.set = (tag, validator) ->
  registry[tag] = validator
  return validator
