// Generated by CoffeeScript 1.12.4
var Constructor, Either, Optional, access, createShape, defaultTest, getName, isObject, isValidator, registry, setProto, validateShape, valido, wrongType;

setProto = require("setProto");

isObject = require("isObject");

wrongType = require("./wrongType");

registry = require("./registry");

Constructor = require("./validators/Constructor");

Optional = require("./validators/Optional");

Either = require("./validators/Either");

valido = function(name, validator) {
  if (typeof name !== "string") {
    validator = name;
    name = "";
  }
  if (Array.isArray(validator)) {
    validator = Either(validator);
  } else if (typeof validator === "function") {
    validator = {
      test: defaultTest,
      assert: validator
    };
  } else if (isObject(validator)) {
    if (!isValidator(validator)) {
      validator = createShape(validator);
    }
  } else {
    throw TypeError("Expected an object, function, or array");
  }
  validator.name = name;
  return setProto(validator, valido.prototype);
};

valido.get = function(type) {
  if (typeof type === "string") {
    if (type[type.length - 1] === "?") {
      return Optional(type.slice(0, -1));
    }
    if (0 <= type.indexOf("|")) {
      return Either(type.split("|"));
    }
    return registry.get(type);
  }
  if (type.constructor === valido) {
    return type;
  }
  if (typeof type === "function") {
    return Constructor(type);
  }
  if (isObject(type)) {
    return createShape(type);
  }
  if (Array.isArray(type)) {
    return Either(type);
  }
  throw Error("Unknown type: '" + type + "'");
};

valido.set = function(id, validator) {
  if (typeof id !== "string") {
    throw TypeError("`id` must be a string");
  }
  if (typeof validator === "function") {
    return registry.set(id, {
      test: defaultTest,
      assert: validator
    });
  }
  if (isObject(validator)) {
    if (!isValidator(validator)) {
      validator = createShape(validator);
    }
    return registry.set(id, validator);
  }
  throw TypeError("`validator` must be an object or function");
};

module.exports = valido;

access = function(obj, key) {
  return obj[key];
};

defaultTest = function(value) {
  return !this.assert(value);
};

isValidator = function(validator) {
  if (typeof validator.test !== "function") {
    if ((typeof validator.assert === "function") || (typeof validator.error === "function")) {
      throw Error("Validators must have a `test` function");
    }
    return false;
  }
  if (typeof validator.assert !== "function") {
    if (typeof validator.error !== "function") {
      throw Error("Validators must have an `assert` or `error` function");
    }
  } else if (typeof validator.error === "function") {
    throw Error("Validators cannot have both an `assert` and `error` function");
  }
  return true;
};

validateShape = function(values, types) {
  var key, result, type;
  if (!isObject(values)) {
    return false;
  }
  for (key in types) {
    type = types[key];
    result = isObject(type) ? validateShape(values[key], type) : valido.get(type).test(values[key]);
    if (result !== true) {
      if (result === false) {
        return key;
      }
      return key + "." + result;
    }
  }
  return true;
};

createShape = function(types) {
  return {
    test: function(values) {
      return validateShape(values, types) === true;
    },
    assert: function(values) {
      var result;
      result = validateShape(values, types);
      if (result === true) {
        return;
      }
      return function(key) {
        var type;
        if (result === false) {
          return registry.get("object").error(key);
        }
        key = key ? key + "." + result : result;
        type = result.split(".").reduce(access, types);
        if (typeof type === "string") {
          if (type[type.length - 1] === "?") {
            type = type.slice(0, -1);
          }
          if (0 <= type.indexOf("|")) {
            type = type.split("|");
          }
        } else if (Array.isArray(type)) {
          type = type.reduce(getName, []);
        } else if (isObject(type)) {
          type = "object";
        } else if (type.name) {
          type = type.name;
        } else {
          return TypeError("`" + key + "` is an invalid type");
        }
        return wrongType(key, type);
      };
    }
  };
};

getName = function(names, type) {
  if (typeof type === "string") {
    names.push(type);
  } else if (type.name) {
    names.push(type.name);
  }
  return names;
};
