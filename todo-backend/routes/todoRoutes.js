const express = require("express")
const {getTodos, addTodo} = require("../contollers/todoController")

const router = express.Router()

router.get("/get-todos", getTodos)

router.post("/add-todo",addTodo)

module.exports = router;
