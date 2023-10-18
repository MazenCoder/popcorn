const express = require('express');
const router = express.Router();
const joiSchemaValidation = require('../middleware/joiSchemaValidation');
const roomController = require('../controllers/room_controller');
const joiRoomSchema = require('../database/schemas/joi_room_schema');


//! Get user by id
router.get('/get/:id',
    roomController.getRoom
);


router.get('/get-author/:uid',
    roomController.getRoomByAuthorId
);


router.post('/create',
    joiSchemaValidation.validateBody(joiRoomSchema.create),
    roomController.create
);

router.put('/update/:id',
    joiSchemaValidation.validateBody(joiRoomSchema.update),
    roomController.update
);

router.post('/update-token',
    joiSchemaValidation.validateBody(joiRoomSchema.updateToken),
    roomController.updateToken
);

router.post('/search',
    joiSchemaValidation.validateBody(joiRoomSchema.search),
    roomController.search
);


router.post('/fetch',
    joiSchemaValidation.validateBody(joiRoomSchema.fetch),
    roomController.fetch
);

module.exports = router;