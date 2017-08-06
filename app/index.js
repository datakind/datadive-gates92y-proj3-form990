var _ = require('lodash');
var express = require('express');
var app = express();
var data = require('./data/data.json');
var ntee = require('./data/ntee.json');

app.use('/', express.static('dist'));
app.use('/node_modules', express.static('node_modules'));

app.get('/data', function (req, res) {
    var state = req.query.state;
    var city = req.query.city;
    var ntee = req.query.ntee;
    var nteeSub = req.query.nteeSub;
    res.send(_.filter(data, d => {
        return (!state || d.STATE === state)
            && (!city || d.CITY === city)
            && (!nteeSub || d.NteeFinal === nteeSub)
            && (!ntee || d.NteeFinal.charAt(0) === ntee);
    }));
});

app.get('/filters', function (req, res) {
    var locations = require('./data/locations.json');
    res.send({ filters: { locations, ntee } });
});

app.listen(process.env.PORT || 3000);
