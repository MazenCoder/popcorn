const userService = require('../service/user_service');



module.exports.getUser = async (req, res) => {
  let response = {};
  try {
    console.log(req.params);
    const { uid } = req.params;
    const userForm = await userService.getUser(uid);
    if (userForm) {
      response.status = 200;
      response.message = 'Successful';
      response.user = userForm;
    } else {
      response.status = 401;
      response.message = `Cannot find any user with ID ${uid}`;
      response.user = {};
    }
  } catch (error) {
    console.error(error.message);
    response.status = 400;
    response.message = error.message;
    response.user = {};
  }
  return res.status(response.status).json(response);
}


module.exports.check = async (req, res) => {
  let response = {};
  try {
    console.log(req.params);
    const { uid } = req.params;
    const checkUser = await userService.checkExists(uid);
    if (checkUser) {
      response.status = 200;
      response.message = 'Successful';
      response.user = checkUser;
    } else {
      response.status = 401;
      response.message = `Cannot find any user with ID ${uid}`;
      response.user = checkUser;
    }
  } catch (error) {
    console.error(error.message);
    response.status = 400;
    response.message = error.message;
    response.user = {};
  }
  return res.status(response.status).json(response);
}


module.exports.create = async (req, res) => {
  let response = {};
  try {
    console.log(req.body);
    const userForm = await userService.createUser(req.body);
    response.status = 200;
    response.message = 'Successful';
    response.user = userForm;
  } catch (error) {
    console.log(error.message);
    response.status = 401;
    response.message = error.message;
    response.user = {};
  }
  return res.status(response.status).json(response);
}


module.exports.update = async (req, res) => {
  let response = {};
  try {
    console.log(req.body);
    const { uid } = req.params;
    const userForm = await userService.updateUser(uid, req.body);
    if (userForm) {
      response.status = 200;
      response.message = 'Successful';
      response.user = userForm;
    } else {
      response.status = 401;
      response.message = `Cannot find any user with ID ${uid}`;
      response.user = {};
    }

  } catch (error) {
    console.log(error.message);
    response.status = 400;
    response.message = error.message;
    response.user = {};
  }
  return res.status(response.status).json(response);
}


module.exports.checkCreate = async (req, res) => {
  let response = {};
  try {
    console.log(req.body);
    const { uid } = req.params;
    const userForm = await userService.checkCreate(uid, req.body);
    if (userForm) {
      response.status = 200;
      response.message = 'Successful';
      response.user = userForm;
    } else {
      response.status = 401;
      response.message = `Cannot find any user with ID ${uid}`;
      response.user = {};
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
    console.log(req.body);
    const { uid, token, lastSeen } = req.body;
    const userForm = await userService.updateToken(uid, token, lastSeen);
    if (userForm) {
      response.status = 200;
      response.message = 'Successful';
      response.user = userForm;
    } else {
      response.status = 401;
      response.message = `Cannot find any user with ID ${uid}`;
      response.user = {};
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
    const { limit = 10, isBanned, uid, name } = req.body;
    const formatName = name.replace(/[-[\]{}()*+?.,\\/^$|#\s]/g, "\\$&");
    const query = { _id: {$ne: uid}, displayName: { $regex: formatName, $options: "i" }, isBanned: isBanned };
    console.log('query: ', query);
    const usersForm = await userService.search(query, limit);
    if (usersForm) {
      response.status = 200;
      response.message = 'Successful';
      response.users = usersForm;
    } else {
      response.status = 401;
      response.message = 'No results found';
      response.users = [];
    }
  } catch (error) {
    console.log(error.message);
    response.status = 401;
    response.message = error.message;
    response.users = [];
  }
  return res.status(response.status).json(response);
}
