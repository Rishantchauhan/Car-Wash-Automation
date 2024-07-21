const express = require('express');
const router = express.Router();
const User = require('../Schema/user.js');
const jwt = require('jsonwebtoken');
const bcrypt=require('bcrypt');

router.post('/signup', async (req, res) => {
  const {name, email, password } = req.body;
  try {
    const usercheck = await User.findOne({ email });
    if(usercheck===null){
    const salt=await bcrypt.genSalt(10);
    const SecPass=await bcrypt.hash(password,salt);
    const user = await User.create({ name, email, password:SecPass });
    const token = jwt.sign({ id: user._id }, 'secret',);
    res.json({ token });
    }
    else 
    {
        res.send("A User with Same Email Already Exists");
    }
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user || !(await bcrypt.compare(password,user.password))) {
      throw new Error('Invalid credentials');
    }
    const token = jwt.sign({ id: user._id }, 'secret');
    res.json({ token });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

router.put('/changepass',async(req,res)=>{
    const {email,password}=req.body;
    try{
      const user=await User.findOne({email});
      if(!user)
          {
              res.send("No User Found");
          }
      else{
          const salt=await bcrypt.genSalt(10);
          const SecPass=await bcrypt.hash(password,salt);
          user.password=SecPass;
          user.save();
          res.send("Password Updated");
      }    
    }
   catch(error){
      res.send("Some Error Occured"+error);
   } 
});

router.get('/getdetails',async(req,res)=>{
     const token=req.header('Authorization');
     const decoded=jwt.verify(token,'secret');
     
     try{
       const user=await User.findById(decoded.id).select('-password');
       res.json(user);
     }
     catch(error)
       {
         res.send('Error');
       }
     
});
module.exports = router;
