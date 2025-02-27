const Task = require("../model/task.js");


const addtask = async (req, res) => {

    try {
        const { name } = req.body;
        const task = await Task.findOne({ name })
        if (task) {
            return res.json({ error: "Task Already Exists" })
        }
        const newTask = new Task({ name: name });
        await newTask.save();
        res.json({
            id: newTask.id,
            name
        });

    } catch (error) {
        console.error("Error adding Task", error.message)
    }
}



const getTask = async (req, res) => {

    try {
        const task = await Task.find()
        if (!task) {
            return res.json({ error: "No task exists" })
        }
        res.json(task);

    } catch (error) {
        console.error("Error Fetching Task", error.message)
    }
}

const updateTask = async (req, res) => {
    try {
        const { id } = req.query;
        const { name } = req.body;
        const task = await Task.findById(id);
        console.log(task)
        if (!task) {
            return res.json({ error: "No task exists" })
        }
        task.name = name
        const result = await task.save();
        return res.json(result)
    } catch (error) {
        console.error("Error Updating Task", error.message)
    }
}



const deleteTask = async (req, res) => {
    try {

        const { id } = req.query;
        const task = await Task.findById(id);
        console.log(task)
        if (!task) {
            return res.json({ error: "No task exists" })
        }
        await Task.findOneAndDelete(id);
        return res.json(task)
    } catch (error) {
        console.error("Error Deleting Task", error.message)
    }
}

module.exports = { addtask, deleteTask, getTask, updateTask };