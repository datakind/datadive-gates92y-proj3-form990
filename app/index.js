var _ = require('lodash');
var express = require('express');
var app = express();
var data = require('./data/data_sm.json');
var ntee = require('./data/ntee.json');

app.use('/', express.static('dist'));
app.use('/node_modules', express.static('node_modules'));

app.get('/data', function (req, res) {
    var state = req.query.state;
    var city = req.query.city.toLowerCase();
    var ntee = req.query.ntee;
    var nteeSub = req.query.nteeSub;
    var minBudget = req.query.minBudget;
    var maxBudget = req.query.maxBudget;
    res.send(_.filter(data, d => {
        return (!state || d.STATE === state)
            && (!city || d.CITY.toLowerCase() === city)
            && (!nteeSub || d.NteeFinal === nteeSub)
            && (!ntee || d.NteeFinal.charAt(0) === ntee)
            && (!minBudget || d.GROSSRECEIPTS >= minBudget)
            && (!maxBudget || d.GROSSRECEIPTS <= maxBudget);;
    }));
});

app.get('/filters', function (req, res) {
    var locations = require('./data/locations.json');
    res.send({ filters: { locations, ntee } });
});

app.listen(process.env.PORT || 3000);
