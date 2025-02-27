const express = require('express');
const cors = require('cors');
const  connect  = require('./db/db.js');
const addTask =require("./routers/task.route.js")

const app=express()

app.use(cors({ origin: '*' }));

app.use(express.json())


// app.use("/",(req,res)=>{
//     res.send("Hello world")
// })

app.use("/api",addTask);



app.listen("5000",()=>{
    console.log("Server listen on port 5000");
    connect();
})

