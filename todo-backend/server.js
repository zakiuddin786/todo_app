const express = require("express")
const cors = require("cors")
const bodyParser = require("body-parser")
const dotenv = require("dotenv")
const connectDB = require("./db")
const todoRoutes = require("./routes/todoRoutes")
dotenv.config()
const { register, httpRequestDurationSeconds } = require("./utils/metrics")
const context = require("./utils/context")
const logger = require("./utils/logger")
const { v4: uuidv4 } = require("uuid")

const app = express();
app.use(cors())
app.use(bodyParser.json())
app.use(express.json())

app.use((req, res, next) => {
    const start = Date.now();
    const requestId = uuidv4();

    context.run(()=>{
        context.set("requestId", requestId)
        res.set("X-Request-ID", requestId)

        logger.info(`Incoming ${req.method} request to ${req.path}`, {
            method: req.method,
            path: req.path,
            query: req.query,
            requestId
        })

        res.on('finish', () => {
            const duration = (Date.now() - start) / 1000;            
            httpRequestDurationSeconds
                .labels(req.method, req.path, res.statusCode)
                .observe(duration);
                logger.info(`Request completed`, {
                method: req.method,
                path: req.path,
                statusCode: res.statusCode,
                duration,
                requestId
            });
        });
        next();
    })
});

app.use('/api', todoRoutes)

connectDB()

app.get('/metrics', async(req,res) =>{
    res.set('Content-Type', register.contentType)
    res.end(await register.metrics())
})

module.exports = app;
// app.use()