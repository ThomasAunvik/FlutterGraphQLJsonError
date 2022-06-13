import express from "express";
import { graphqlHTTP } from 'express-graphql';
import { buildSchema } from 'graphql';
import cors from 'cors';

// Construct a schema, using GraphQL schema language
var schema = buildSchema(`
"""
The GenericScalar scalar type represents a generic
GraphQL scalar value that could be:
String, Boolean, Int, Float, List or Object.
"""
scalar GenericScalar

type Stats {
    data: GenericScalar
}

type User {
    id: String
    name: String
    stats: Stats
}

type Query {
    user(id: String): User
}
`);

// The rootValue provides a resolver function for each API endpoint
var root = {
    user: () => {
        return {
            "id": "1",
            "name": "Test User",
            "stats": {
                "data": {
                    "speed": 12,
                    "distance": 100
                },
            },
        };
    },
};

var allowlist = ['http://localhost:3000']
var corsOptionsDelegate = function (req, callback) {
    var corsOptions;
    if (allowlist.indexOf(req.header('Origin')) !== -1) {
        corsOptions = { origin: true }
    } else {
        corsOptions = { origin: false }
    }
    callback(null, corsOptions)
}

var app = express();

app.use(cors(corsOptionsDelegate))

app.use('/graphql', graphqlHTTP({
    schema: schema,
    rootValue: root,
    graphiql: true,
}));

app.get("/", (req, res) => {
    res.send('Hello Test!')
})

app.listen(4000, () => {
    console.log("Express is now listening on port 4000");
});