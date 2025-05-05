const express = require('express');
const router = express.Router();
const schemas = require('../models/schemas');

// POST route for sending contact form
router.post('/contact/send', async (req, res) => {
  const { email, website, message } = req.body;

  // Validate all required fields
  if (!email) {
    return res.status(400).send('Email is required');
  }
  if (!website) {
    return res.status(400).send('Website is required');
  }
  if (!message) {
    return res.status(400).send('Message is required');
  }

  const contactData = { email, website, message };

  // Create a new contact entry in the database
  const newContact = new schemas.Contact(contactData);

  try {
    const savedContact = await newContact.save();
    if (savedContact) {
      return res.send('Message sent. Thank you.');
    } else {
      return res.send('Failed to send message.');
    }
  } catch (err) {
    console.error(err);
    return res.status(500).send('Error saving contact information.');
  }
});

// GET route for users (example data)
router.get('/users', async (req, res) => {
  const userData = [
    { "id": 1, "name": "Leanne Graham", "email": "Sincere@april.biz", "website": "hildegard.org" },
    { "id": 2, "name": "Ervin Howell", "email": "Shanna@melissa.tv", "website": "anastasia.net" },
    { "id": 3, "name": "Clementine Bauch", "email": "Nathan@yesenia.net", "website": "ramiro.info" }
  ];

  res.send(userData);
});

module.exports = router;

