const app = require("./app");
const config = require("./app/config/config");
const MongoDB = require("./app/utils/mongodb.util");


async function startServer(){
    
    try {
        // ket noi mongodb
       
        await MongoDB.connect(config.db.uri);
        console.log("Connected to the database");


        //
        const PORT =  config.app.port;
        app.listen(PORT, () => {
            console.log(`Server in runnig on port ${PORT}.`);
        });

    }
    catch(err){
        console.log("Cannot connect to the database!", err);
        process.exit();
    }
}

startServer();

