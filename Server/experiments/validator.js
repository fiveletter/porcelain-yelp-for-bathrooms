var Validator = require('jsonschema').Validator;
var v = new Validator();
var instance = "";
var schema = {"type": "number"};
console.log(v.validate(instance, schema));