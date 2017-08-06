var _ = require('lodash');
var express = require('express');
var app = express();
var data = require('./data/data.json');

app.use('/', express.static('dist'));
app.use('/node_modules', express.static('node_modules'));

app.get('/data', function (req, res) {
    var state = req.query.state;
    var city = req.query.city;
    res.send(_.filter(data, d => {
        return (!state || d.STATE === state)
            && (!city || d.CITY === city);
    }));
});

app.get('/filters', function (req, res) {
    var states = _.reduce(data, (acc, d) => {
        acc.push(d.STATE);
        return _.uniq(acc);
    }, []);
    var cities = _.reduce(data, (acc, d) => {
        if (acc.hasOwnProperty(d.STATE)) {
            var arr = acc[d.STATE];
            arr.push(d.CITY);
            acc[d.STATE] = _.uniq(arr);
        } else {
            acc[d.STATE] = [d.CITY];
        }
        return acc;
    }, {});
    _.each(cities, (values, city) => {
        values.sort();
    });
    res.send({ filters: { state: states.sort(), city: cities } });
});

app.listen(process.env.PORT || 3000);
