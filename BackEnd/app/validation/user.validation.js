const Joi = require('joi');

const passwordSchema = Joi.string()
  .min(8)
  .required();

const registerSchema = Joi.object({
  username: Joi.string().required(),
  password: passwordSchema,
  phanquyen: Joi.string().required(),
});

const loginSchema = Joi.object({
  username: Joi.string().required(),
  password: Joi.string().required(),
});

module.exports = { registerSchema, loginSchema };
