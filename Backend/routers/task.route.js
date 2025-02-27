const express = require('express')
const { addtask, deleteTask, getTask, updateTask } = require('../controllers/addUser.controller.js')

const router = express.Router()

router.post("/add", addtask);
router.get("/get", getTask);
router.put("/update", updateTask)
router.delete("/delete", deleteTask);

module.exports = router;