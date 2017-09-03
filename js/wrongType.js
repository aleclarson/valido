// Generated by CoffeeScript 1.12.4
var formatType, prependArticle, wrongType;

wrongType = function(key, type) {
  var reason;
  reason = key ? "`" + key + "` must be " : "Expected ";
  reason += prependArticle(formatType(type));
  return TypeError(reason);
};

module.exports = wrongType;

prependArticle = (function() {
  var vowels;
  vowels = /^(a|e|i|o|u)/;
  return function(string) {
    if (vowels.test(string)) {
      return "an " + string;
    } else {
      return "a " + string;
    }
  };
})();

formatType = function(type) {
  if (Array.isArray(type)) {
    if (type.length === 2) {
      return type.join(" or ");
    } else {
      return type.slice(0, type.length - 1).join(", ") + ", or " + type[type.length - 1];
    }
  } else {
    return type;
  }
};
