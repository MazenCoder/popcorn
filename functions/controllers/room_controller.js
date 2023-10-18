const roomService = require('../service/room_service');



module.exports.getRoom = async (req, res) => {
  let response = {};
  try {
    const { id } = req.params;
    const roomForm = await roomService.getRoom(id);
    if (roomForm) {
      response.status = 200;
      response.message = 'Successful';
      response.room = roomForm;
    } else {
      response.status = 401;
      response.message = `Cannot find any room with ID ${id}`;
      response.room = {};
    }
  } catch (error) {
    console.error(error.message);
    response.status = 400;
    response.message = error.message;
    response.room = {};
  }
  return res.status(response.status).json(response);
}


module.exports.getRoomByAuthorId = async (req, res) => {
  let response = {};
  try {
    const { uid } = req.params;
    const roomForm = await roomService.getRoomByAuthorId(uid);
    if (roomForm) {
      response.status = 200;
      response.message = 'Successful';
      response.room = roomForm;
    } else {
      response.status = 401;
      response.message = `Cannot find any room with UID ${uid}`;
      response.room = {};
    }
  } catch (error) {
    console.error(error.message);
    response.status = 400;
    response.message = error.message;
    response.room = {};
  }
  return res.status(response.status).json(response);
}


module.exports.create = async (req, res) => {
  let response = {};
  try {
    const roomForm = await roomService.createRoom(req.body);
    response.status = 200;
    response.message = 'Successful';
    response.room = roomForm;
  } catch (error) {
    console.log(error.message);
    response.status = 401;
    response.message = error.message;
    response.room = {};
  }
  return res.status(response.status).json(response);
}


module.exports.update = async (req, res) => {
  let response = {};
  try {
    const { id } = req.params;
    const roomForm = await roomService.updateRoom(id, req.body);
    if (roomForm) {
      response.status = 200;
      response.message = 'Successful';
      response.room = roomForm;
    } else {
      response.status = 401;
      response.message = `Cannot find any room with ID ${id}`;
      response.room = {};
    }

  } catch (error) {
    console.log(error.message);
    response.status = 400;
    response.message = error.message;
    response.user = {};
  }
  return res.status(response.status).json(response);
}


module.exports.updateToken = async (req, res) => {
  let response = {};
  try {
    const { id, token } = req.body;
    const roomForm = await roomService.updateToken(id, token);
    if (roomForm) {
      response.status = 200;
      response.message = 'Successful';
      response.room = roomForm;
    } else {
      response.status = 401;
      response.message = `Cannot find any room with ID ${id}`;
      response.room = {};
    }

  } catch (error) {
    console.log(error.message);
    response.status = 400;
    response.message = error.message;
    response.user = {};
  }
  return res.status(response.status).json(response);
}


module.exports.search = async (req, res) => {
  let response = {};
  try {
    const { uid, name, status, page = 1, limit = 1 } = req.body;
    const formatName = name.replace(/[-[\]{}()*+?.,\\/^$|#\s]/g, "\\$&");
    const query = { name: { $regex: formatName, $options: "i" }, status: parseInt(status)};
    const roomsForm = await roomService.search(query, page, limit);
    if (roomsForm) {
      response.status = 200;
      response.message = 'Successful';
      response.rooms = roomsForm;
    } else {
      response.status = 401;
      response.message = 'No results found';
      response.rooms = [];
    }
  } catch (error) {
    console.log(error.message);
    response.status = 401;
    response.message = error.message;
    response.rooms = [];
  }
  return res.status(response.status).json(response);
}


module.exports.fetch = async (req, res) => {
  let response = {};
  try {
    const { uid, status, page = 1, limit = 10 } = req.body;
    const query = { author: {$ne: uid}, status: parseInt(status)};
    const roomsForm = await roomService.fetch(query, page, limit);
    if (roomsForm) {
      response.status = 200;
      response.message = 'Successful';
      response.rooms = roomsForm;
    } else {
      response.status = 401;
      response.message = 'No results found';
      response.rooms = [];
    }
  } catch (error) {
    console.log(error.message);
    response.status = 401;
    response.message = error.message;
    response.rooms = [];
  }
  return res.status(response.status).json(response);
}