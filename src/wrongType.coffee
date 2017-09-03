
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
  if Array.isArray type
    if type.length is 2
    then type.join " or "
    else type.slice(0, type.length - 1).join(", ") + ", or " + type[type.length - 1]
  else type
