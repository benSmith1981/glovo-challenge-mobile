const express = require('express')
const mongoose = require('mongoose')

// Database

mongoose.connect('mongodb://glovo:challenge@ds219130.mlab.com:19130/glovo_challenge')

const Country = mongoose.model('countries', new mongoose.Schema({
    code: String,
    name: String
}))

const City = mongoose.model('cities', new mongoose.Schema({
    code: String,
    name: String,
    country_code: String,
    currency: String,
    enabled: Boolean,
    busy: Boolean,
    time_zone: String,
    language_code: String,
    working_area: [String]
}))

// App

const app = express()

app.get('/api/countries', function(req, res) {
  Country.find({}, '-_id' , function(err, data) {
    if (err) throw err
    res.json(data)
  })
})

app.get('/api/cities', function(req, res) {
  City.find({}, '-_id code name country_code working_area', function(err, data) {
    if (err) throw err
    res.json(data)
  })
})

app.get('/api/cities/:city_code', function(req, res) {
  City.findOne({'code': req.params.city_code}, '-_id', function(err, data) {
    if (err) throw err
    res.json(data)
  })
})

var port = process.env.PORT || 3000;
// var basic = auth.basic({
//         realm: "Web."
//     }, function (username, password, callback) { // Custom authentication method.
//         callback(username === "23232ededDE" && password === "sdsd3432d8n8");
//     }
// )
// app.use('/api', auth.connect(basic),  router);

app.listen(port)
