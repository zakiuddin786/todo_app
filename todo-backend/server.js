const express = require("express")
const cors = require("cors")
const bodyParser = require("body-parser")
const dotenv = require("dotenv")
const connectDB = require("./db")
const todoRoutes = require("./routes/todoRoutes")
const path = require("path")
dotenv.config()

const app = express();
app.use(cors())
app.use(bodyParser.json())
app.use(express.json())
app.use('/api', todoRoutes)

connectDB()

app.use(express.static(path.join(__dirname, "../todo-frontend/build")))

app.get("*", (req, res) =>{
    res.sendFile(path.join(__dirname, "../todo-frontend/build", "index.html"))
})
module.exports = app;
// app.use()