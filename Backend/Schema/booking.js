const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  vehicle_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Vehicle', required: true },
  washQuality: { type: String, required: true },
  price: { type: Number, required: true },
  date: { type: Date, default: Date.now },
  vehicle:{type:String, required: true}
});

const Booking = mongoose.model('Booking', bookingSchema);
module.exports = Booking;