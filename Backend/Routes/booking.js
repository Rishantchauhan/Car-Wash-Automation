const express = require('express');
const router = express.Router();
const Booking = require('../Schema/booking.js');
const Vehicle = require('../Schema/vehicle.js');
const authMiddleware = require('../Middleware/middleware.js');

router.post('/', authMiddleware, async (req, res) => {
  const { vehicleId, washQuality, price,vehiclename } = req.body;
  try {
    const vehicle = await Vehicle.findById(vehicleId);
    if (!vehicle) throw new Error('Vehicle not found');

    const user = req.user;
    if (user.wallet < price) throw new Error('Insufficient balance');

    user.wallet -= price;
    await user.save();
    try{
    const booking = await Booking.create({ user: req.user.id, vehicle_id: vehicleId, washQuality, price ,vehicle:vehiclename});
    res.json(booking);
    }
    catch(error){
        user.wallet += price;
        await user.save();
        res.status(400).json({error: err.message});
    }
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});
router.get('/get',authMiddleware,async(req,res)=>{
   try{
     
     const user=await Booking.find({user:req.user.id});
     if(user)
        {
            res.json(user);
        }
      else {
         res.send("No User Found");
      }  
   }
  catch(error){
     res.send(error);
  } 

});
module.exports = router;
