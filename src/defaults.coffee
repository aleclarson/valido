
wrongType = require "./wrongType"

{toString} = Object::

# Primitive types use `typeof` to validate.
["boolean", "function", "number", "string", "symbol"].forEach (type) ->
  exports[type] =
    test: (value) -> typeof value is type
    error: (key) -> wrongType key, type

exports.object =
  test: require "isObject"
  error: (key) -> wrongType key, "object"

exports.array =
  test: Array.isArray
  error: (key) -> wrongType key, "array"

exports.null =
  test: (value) -> value is null
  error: (key) -> TypeError "`#{key}` must be null"

exports.date =
  test: (value) -> if value then (value.constructor is Date) else false
  error: (key) -> wrongType key, "date"

exports.error =
  test: (value) -> toString.call(value) is "[object Error]"
  error: (key) -> wrongType key, "error"

exports.regexp =
  test: (value) -> if value then (value.constructor is RegExp) else false
  error: (key) -> wrongType key, "regexp"

exports.promise =
  test: (value) -> if value then typeof value.then is "function" else false
  error: (key) -> wrongType key, "promise"

exports.any =
  test: (value) -> value isnt undefined
  error: (key) -> TypeError "`#{key}` must be defined"
