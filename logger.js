
const { createLogger, format, transports, config } = require('winston');

const echoLogger = createLogger({
    transports: [
        new transports.Console()
    ]
});

module.exports = {
    echoLogger: echoLogger
};
