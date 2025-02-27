const mongoose = require("mongoose");

const connect =async() =>{
    try {
      await mongoose.connect("mongodb://localhost:27017/task_app");
      console.log("Connected to DB");
        
    } catch (error) {
        console.log("Error while conecting to DB ",error.message);
        
    }
}

module.exports = connect;