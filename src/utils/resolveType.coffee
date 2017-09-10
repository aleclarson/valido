
registry = require "../registry"
valido = require "../valido"

addons = valido._addons

resolveType = (value) ->
  return resolveTag value if typeof value is "string"
  return value if addons.isValido value
  return resolveAddon value

module.exports = resolveType

#
# Helpers
#

resolveTag = (tag) ->
  if tag[tag.length - 1] is "?"
    return addons.Maybe tag.slice 0, -1
  if tag.indexOf("|") isnt -1
    return addons.Either tag.split "|"
  return registry.get tag

resolveAddon = (value) ->

  for addon in addons
    if addon.resolve value
      validator = Object.create addon
      validator.init? value
      return validator

  throw Error "Unsupported validator"
