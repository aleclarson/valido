// Generated by CoffeeScript 1.12.4
var addons, assertEither, identifyType, resolveType, validateEither, validator, valido, wrongType;

identifyType = require("../utils/identifyType");

resolveType = require("../utils/resolveType");

wrongType = require("../utils/wrongType");

valido = require("../valido");

addons = valido._addons;

validateEither = function(value) {
  var i, len, ref, result, type;
  if (value === void 0) {
    return this.optional;
  }
  if (value === null) {
    return this.nullable;
  }
  ref = this.types;
  for (i = 0, len = ref.length; i < len; i++) {
    type = ref[i];
    result = type.validate(value);
    if (result !== false) {
      return result;
    }
  }
  return false;
};

assertEither = function(value) {
  var i, len, ref, result, type;
  ref = this.types;
  for (i = 0, len = ref.length; i < len; i++) {
    type = ref[i];
    result = type.validate(value);
    if (result === true) {
      return;
    }
    if (typeof result === "string") {
      return type.error.bind(type, result);
    }
  }
  return this.error.bind(this);
};

validator = {
  validate: validateEither,
  assert: assertEither
};

validator.init = function(types) {
  if (!Array.isArray(types)) {
    throw TypeError("Expected an array");
  }
  if (this.optional = types[types.length - 1] === "?") {
    types = types.slice(0, -1);
  }
  if (this.nullable = types[types.length - 1] === "null") {
    types = types.slice(0, -1);
  }
  this.types = types.map(resolveType);
};

validator.error = function(key) {
  var names;
  names = identifyType(this.types);
  if (this.nullable) {
    names.push("null");
  }
  return wrongType(key, names);
};

valido.add(validator, Array.isArray);

addons.Either = function(types) {
  var inst;
  inst = Object.create(validator);
  inst.init(types);
  return inst;
};