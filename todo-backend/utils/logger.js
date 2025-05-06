const winston = require('winston');
const context = require("./context")
const LokiTransport = require("winston-loki");
const path = require("path")
const moment = require("moment")
const os = require("os")

const requestIdFormat = winston.format((info) =>{
  const requestId = context.get("requestId") || "no-request-id";
  info.requestId = requestId;
  return info;
})

const customFormat = winston.format.combine(
  requestIdFormat(),
  winston.format.timestamp(),
  winston.format.metadata({
    fillWith: ["requestId", "service", "environment", "instance"]
  }),
  winston.format.json()
)

const getLogDirectory = () =>{
  const isProd = process.env.NODE_ENV === "production";
  return isProd ? "/var/log/todo-app" : path.join(process.cwd(), "logs");
}

const getLogFileName = () =>{
  const timestamp = moment().format("YYYY-MM-DD-HH");
  const instanceName = process.env.NODE_ENV === "production"
    ? (process.env.EC2_HOSTNAME || os.hostname())
    : "local" 
    console.log("log directory is", getLogDirectory())
    return path.join(getLogDirectory(), `${instanceName}-${timestamp}-application.log`)
}

class DynamicFileTransport extends winston.transports.File {
  constructor (opts = {}) {
    super({
      ...opts,
      filename: getLogFileName()
    });

    const setHourlyInterval = () =>{
      const now = new Date();
      const nextHour = new Date(now);
      nextHour.setHours(nextHour.getHours()+ 1);
      nextHour.setMinutes(0);
      nextHour.setSeconds(0);
      nextHour.setMilliseconds(0);

      const msUntilNextHour = nextHour - now;
      console.log("ms until next hour is", msUntilNextHour);

      setTimeout(()=>{
        const newFilename = getLogFileName();
        if(this.filename !== newFilename){
            this.filename = newFilename
        }
  
        setInterval(() =>{
          const newFilename = getLogFileName();
          if(this.filename !== newFilename){
              this.filename = newFilename
          }
        }, 60 * 60 * 1000)
  
      }, msUntilNextHour)

    }

    setHourlyInterval();
  }
}

const getTransports = () =>{
  const transports = [
      new winston.transports.Console({}),
      new DynamicFileTransport({
        format: customFormat,
        //  we can add maxsize, maxFiles etc options here
      })
    ]
  if(process.env.NODE_ENV === "production"){
    transports.push(
      new LokiTransport({
        host: process.env.LOKI_URL || "http://localhost:3100",
        json: true,
        labels: {
            app: "todo-app",
            environment: process.env.NODE_ENV,
            instance: process.env.EC2_HOSTNAME || os.hostname()
        },
        format: customFormat,
        batching: true,
        interval: 5,
        replaceTimestamp: true,
        onConnectionError: (err) =>{ 
          console.error("Loki Connection error: err")
        } 
      })
    )
  }
  return transports;
}

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: customFormat,
  defaultMeta: { service: 'todo-app' , environment: process.env.NODE_ENV || "development"},
  transports: getTransports()
});

logger.transports.forEach(transport =>{
  if(transport instanceof winston.transports.File){
    transport.on("error", (error) =>{
      console.error("Error in file transport", error)
    })
  }
})

module.exports = logger;
