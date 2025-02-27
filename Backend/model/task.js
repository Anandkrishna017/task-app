const mongoose = require("mongoose")

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    }
}, { timestamps: true });

const Task = mongoose.model("Task", userSchema);

module.exports=Task;