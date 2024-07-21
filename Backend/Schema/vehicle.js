const mongoose = require('mongoose');

const vehicleSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  name: { type: String, required: true },
  size: { type: String, required: true },
});

const Vehicle = mongoose.model('Vehicle', vehicleSchema);
module.exports = Vehicle;