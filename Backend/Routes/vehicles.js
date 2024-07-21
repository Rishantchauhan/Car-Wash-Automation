const express = require('express');
const router = express.Router();
const Vehicle = require('../Schema/vehicle.js');
const authMiddleware = require('../Middleware/middleware.js');

router.post('/add', authMiddleware, async (req, res) => {
  const { name, size } = req.body;
  try {
    const vehicle = await Vehicle.create({ user: req.user.id, name, size });
    res.json(vehicle);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

router.get('/get', authMiddleware, async (req, res) => {
  try {
    const vehicles = await Vehicle.find({ user: req.user.id });
    res.json(vehicles);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

router.delete('/delete',async(req,res)=>{
     
     const {id}=req.body;
     try{
       const data=await Vehicle.findByIdAndDelete(id);
       if(data)
          res.send("Delete Success");
        else{
            res.send('Failed To delete');
        }

     }
    catch(error){
        res.send(error);
    } 

});
module.exports = router;
