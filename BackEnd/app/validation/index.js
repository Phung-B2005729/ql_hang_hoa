const Joi = require('joi');

const passwordSchema = Joi.string()
  .min(8)
  .required();

const sdtSchema = Joi.string().regex(/^(0?)(3[2-9]|5[6|8|9]|7[0|6-9]|8[0-6|8|9]|9[0-4|6-9])[0-9]{7}$/).required();
const emailSchema = Joi.string().regex(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/).required();

const registerSchema = Joi.object({
  user_name: Joi.string().required(),
  password: passwordSchema,
  phan_quyen: Joi.string().required(),
});

const loginSchema = Joi.object({
  user_name: Joi.string().required(),
  password: Joi.string().required(),
});

module.exports = { registerSchema, loginSchema, passwordSchema, sdtSchema, emailSchema };
