const mongoose = require("mongoose")
const logger = require("./utils/logger")
const connectDB = async () =>{
    try{
        await mongoose.connect(process.env.MONGODB_URI)
        logger.info("Mongo DB connected!")
    } catch(error){
        logger.error("MongoDB connecton failed", error)
    }
} 
 
module.exports = connectDB;