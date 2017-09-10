
# `type` must be a string or array of strings.
wrongType = (key, type) ->
  reason = if key then "`#{key}` must be " else "Expected "
  reason += prependArticle formatType type
  return TypeError reason

module.exports = wrongType

#
# Helpers
#

prependArticle = do ->
  vowels = /^(a|e|i|o|u)/
  return (string) ->
    if vowels.test string
    then "an " + string
    else "a " + string

formatType = (type) ->
  return type unless Array.isArray type
  switch type.length
    when 0 then "nothing"
    when 1 then type[0]
    when 2 then type.join " or "
    else type.slice(0, type.length - 1).join(", ") + ", or " + type[type.length - 1]
