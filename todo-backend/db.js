const mongoose = require("mongoose")
const logger = require("./utils/logger")
const connectDB = async () =>{
    try{
        await mongoose.connect(process.env.MONGO_URI)
        logger.debug("Mongo DB connected!")
    } catch(error){
        logger.error("MongoDB connecton failed", error)
    }
} 
 
module.exports = connectDB;