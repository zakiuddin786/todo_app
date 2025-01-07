const Todo = require("../models/todoModel")
const logger  = require("../utils/logger")

exports.getTodos = async(req,res)=>{
    logger.info("Fetching the todos from DB")
    try {
        const todos = await Todo.find();
        logger.info(`fetched all the todos ${JSON.stringify(todos)}`)
        res.status(200).json(todos)

    } catch (error) {
        logger.error("Error while fetching the todos", error)
        res.status(500).json({message: "something went wrong, please try later"})
    }
}

exports.addTodo =  async (req,res)=>{
    try {
        const title  = req.body.title;
        // console.log("Adding a new todo", req.body)
        logger.info(`Adding a new todo ${title}`)
        const newTodo = new Todo({
            title: title
        })

        logger.info("Adding the todo to DB ", newTodo)
        const savedTodo = await newTodo.save()
        logger.info("Added the todo to DB ", savedTodo)

        res.status(200).json(savedTodo)
    } catch (error) {
        logger.error("Error while Adding the todos", error)
        res.status(500).json({message: "something went wrong, please try later"})
    }
    
}