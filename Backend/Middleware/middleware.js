const jwt = require('jsonwebtoken');
const User = require('../Schema/user');

const authMiddleware = async (req, res, next) => {
  const token = req.header('Authorization');

  if (!token) return res.status(401).json({ error: 'No token, authorization denied' });
  // console.log(token);
  try {
    const decoded = jwt.verify(token, 'secret');
    req.user = await User.findById(decoded.id).select('-password');
    next();
  } catch (err) {
    res.status(401).json({ error: 'Token is not valid' });
  }
};

module.exports = authMiddleware;
