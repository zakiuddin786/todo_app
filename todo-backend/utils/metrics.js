const promClient = require("prom-client")

const register = new promClient.Registry();
promClient.collectDefaultMetrics({ register })

const httpRequestDurationSeconds= new promClient.Histogram({
    name: "http_request_time_seconds",
    labelNames: ['method', 'route', 'status_code'],
    help: "duration of HTTP requests in seconds",
    buckets: [0.1, 0.5, 1, 2, 5]
})

const todoMetrics = {
    todoCount: new promClient.Gauge({
        name: "todo_items_total",
        help: "Total number of todo items"
    }),
    todoAddedTotal: new promClient.Counter({
        name: "todo_items_added_total",
        help: "Todo items added"
    })
}

register.registerMetric(httpRequestDurationSeconds)

Object.values(todoMetrics).forEach(metric => {
    console.log("registering metric", metric)
    register.registerMetric(metric)
});

module.exports = {
    httpRequestDurationSeconds,
    todoMetrics,
    register
}
