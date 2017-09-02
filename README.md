
# valido v1.0.1 

> npm install aleclarson/valido#1.0.1

```js
const valido = require('valido')

valido.get('number').test(0)  // => true
valido.get('number?').test(undefined)  // => true
valido.get('number|string?').test('hello world')  // => true
valido.get({ x: 'number', y: 'number' }).test({ x: 1, y: 0 })  // => true
valido.get(Promise).test(Promise.resolve())  // => true
valido.get([ Array, Object ]).test(null)  // => false
```

Check out [`isValid`](https://github.com/aleclarson/isValid) and [`assertValid`](https://github.com/aleclarson/assertValid), which wrap `valido` with a friendlier interface.

### Available types

The built-in types include:
- `any` (where undefined is invalid)
- `array`
- `boolean`
- `buffer` (NodeJS only)
- `date`
- `error`
- `function`
- `number`
- `null`
- `object` (where null is invalid)
- `promise` (supports thenables)
- `regexp`
- `string`
- `symbol`

#### Custom types

Call `valido.set` to add a custom type:

```js
// Add a validator that returns an error constructor.
valido.set('email', (value) => {
  if (value.indexOf('@') === -1) {
    return (key) => Error(key + ' must have an @ sign')
  }
})

// Add a validator with both its `test` and `assert/error` functions.
valido.set('int', {
  test: (value) => Math.round(value) === value,
  error: (key) => TypeError(key + ' cannot have decimals'),
})
```

Your custom types can be used like the built-in types:

```js
valido.get('int|string').test(1.5)  // => false
valido.get('email?').test(undefined)  // => true
```

#### Tips
- The `test` function must return a boolean.
- The `error` function is most useful when the value isn't needed to create an error message.
- Your `error` and `assert` functions should support a `key` string argument and zero arguments. 
- You cannot define both an `error` and `assert` function.

### Wrappers

The [`isValid`](https://github.com/aleclarson/isValid) and [`assertValid`](https://github.com/aleclarson/assertValid) libraries wrap `valido` with a friendlier interface.

```js
const isValid = require('isValid')
const assertValid = require('assertValid')

// This always returns a boolean.
isValid(0, 'string?')        // => false
isValid(0, 'number|string')  // => true

// This will throw for invalid values.
assertValid(0, 'string?')       // => TypeError('Expected a string')
assertValid(0, 'number|string') // => undefined
```

### Validator instances

Call `valido` to create a validator that can be passed to `test` and `assert` functions.

Validators created this way are **not** stored in the registry.

```js
// Create a shape validator that can be reused.
const User = valido('user', {name: 'string', age: 'number'})

// Create a validator by passing its `assert` function.
const Email = valido('email', (value) => {
  if (value.indexOf('@') === -1) {
    return () => Error('Emails must have an @ sign')
  }
})

// Create a validator by passing both `test` and `error/assert` functions.
const Integer = valido('integer', {
  test: (value) => Math.round(value) === value,
  error: (key) => TypeError(key + ' must be integer'), 
})

// Create a validator that supports multiple types.
const FloatArray = valido([ Float32Array, Float64Array, 'array', '?' ])
```

