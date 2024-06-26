const { MongoClient,ServerApiVersion } = require("mongodb");

class MongoDB {
    static connect =  async (uri) => {
        if(this.client) return this.client;
        this.client = await new MongoClient(uri, {
            serverApi: {
              version: ServerApiVersion.v1,
              strict: true,
              deprecationErrors: true,
            }
          }).connect();
    }
}

module.exports = MongoDB;