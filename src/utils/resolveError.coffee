
isObject = require "isObject"

identifyType = require "./identifyType"
wrongType = require "./wrongType"

# Create an error from the expected type.
resolveError = (key, type) ->

  if typeof type is "string"

    if type[type.length - 1] is "?"
      type = type.slice 0, -1

    if type.indexOf("|") isnt -1
      type = type.split "|"

    wrongType key, type

  else if Array.isArray type
    wrongType key, identifyType type

  else if isObject type
    wrongType key, "object"

  # Anonymous type
  else TypeError "`#{key}` is an invalid type"

module.exports = resolveError
