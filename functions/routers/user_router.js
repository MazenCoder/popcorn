const express = require('express');
const router = express.Router();
const joiSchemaValidation = require('../middleware/joiSchemaValidation');
const userController = require('../controllers/user_controller');
const joiUserSchema = require('../database/schemas/joi_user_schema');


//! Get user by id
router.get('/get/:uid',
    userController.getUser
);


router.post('/create',
    joiSchemaValidation.validateBody(joiUserSchema.create),
    userController.create
);

router.put('/update/:uid',
    joiSchemaValidation.validateBody(joiUserSchema.update),
    userController.update
);

router.get('/check/:uid',
    userController.check
);

router.put('/check-create/:uid',
    joiSchemaValidation.validateBody(joiUserSchema.create),
    userController.checkCreate
);

router.post('/update-token',
    joiSchemaValidation.validateBody(joiUserSchema.updateToken),
    userController.updateToken
);

router.post('/search',
    joiSchemaValidation.validateBody(joiUserSchema.search),
    userController.search
);


module.exports = router;