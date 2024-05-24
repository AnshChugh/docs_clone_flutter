const express = require('express');
const mongoose = require('mongoose');
const {password} = require('./secure_credentials');
const {authRouter} = require('./routes/auth');
// idk what is this for
const cors = require('cors');

// socket server
const http = require('http');

const documentRouter = require('./routes/document');
const PORT = process.env.PORT | 3001;
const app = express();

var server = http.createServer(app);
var io = require('socket.io')(server);

// XML cross origin error solver?
app.use(cors());

app.use(express.json());
app.use(authRouter);
app.use(documentRouter);


const DB = `mongodb+srv://docs_clone_server:${password}@cluster1.olikbpb.mongodb.net/?retryWrites=true&w=majority&appName=Cluster1`;

mongoose.connect(DB).then(()=>{
    console.log('connection successful');
}).catch((err)=>{
    console.log(err);
});

io.on('connection', (stream)=>{
    stream.on('join', (documentId) =>{
        stream.join(documentId);
        console.log('socket connection successful');
    })
})

server.listen(PORT,"0.0.0.0", ()=>{
    console.log(`connected at port ${PORT}`);
})
