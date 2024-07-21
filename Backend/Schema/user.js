const mongoose=require('mongoose');
const {Schema}=mongoose;
const UserSchema= new Schema(
    {
        name: { type: String, required: true },
        email: { type: String, required: true, unique: true },
        password: { type: String, required: true },
        wallet: { type: Number, default: 100 },
    }   
);

const user=mongoose.model('User',UserSchema);
module.exports=user;