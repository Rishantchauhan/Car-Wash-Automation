const express=require('express');
const ConnectToMongoose=require('./Db/db.js');
const cors = require('cors');

const port=3000;
 
const app=express();

app.use(cors());
app.use(express.json());
app.use('/api/auth',require('./Routes/Auth.js'));
app.use('/api/vehicle',require('./Routes/vehicles.js'));
app.use('/api/booking',require('./Routes/booking.js'));
ConnectToMongoose();
app.listen(port,()=>{
    console.log('App is Listening at the given port: '+ port);
});

module.exports=app;