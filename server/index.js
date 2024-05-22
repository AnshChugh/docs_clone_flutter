const express = require('express');
const mongoose = require('mongoose');
const {password} = require('./secure_credentials');
const PORT = process.env.PORT | 3001;
const app = express();


const DB = `mongodb+srv://docs_clone_server:${password}@cluster1.olikbpb.mongodb.net/?retryWrites=true&w=majority&appName=Cluster1`;

mongoose.connect(DB).then(()=>{
    console.log('connection successful');
}).catch((err)=>{
    console.log(err);
});


app.listen(PORT,"0.0.0.0", ()=>{
    console.log(`connected at port ${PORT}`);
})