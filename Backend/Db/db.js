const mongoose=require('mongoose');
const url="mongodb://localhost:27017/WashApp";
const ConnectToMongoose=async()=>{
     await mongoose.connect(url);
     console.log('Connected With Database');
    };

module.exports=ConnectToMongoose;

