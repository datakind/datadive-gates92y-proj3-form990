const fs = require('fs');

var headers = ["", "EIN", "GROSSRECEIPTS", "TOTEMPLOYEE", "TOTVOLUNTEERS", "CITY", "STATE", "FISYR", "TOTALPROGSERVEXP", "FORMTYPE", "FORMYEAR", "NAME", "DBA", "ADDRESS", "ZIP", "WEBSITE", "URL", "NteeFinal", "MISSION", "DISCOPS", "CONTRIBCURRENT", "PSRCURRENT", "INVINCCURRENT", "OTHERREVCURRENT", "TOTALREVCURRENT", "MEMBERDUES", "GROSSSALESOTHER", "SALESCOSTOTHER", "NETSALESOTHER", "GROSSINCGAMING", "GROSSINCFNDEVENTS", "NETSALESINV", "GRANTSPAIDCURRENT", "MEMBERBENCURRENT", "SALARIESCURRENT", "TOTALEXPCURRENT", "REVLESSEXPCURRENT", "TOTALASSETSBEGYEAR", "TOTALASSETSENDYEAR", "TOTALLIABBEGYEAR", "TOTALLIABENDYEAR", "NETASSETSBEGYEAR", "OTHERASSETSCHANGES", "NETASSETSENDYEAR", "CASHINVBEGYEAR", "CASHINVENDYEAR", "LANDBEGYEAR", "LANDENDYEAR", "OTHERASSETSBEGYEAR", "OTHERASSETSENDYEAR", "LOBBYING", "proj1Desc", "proj1ExpAmt", "proj1GrantAmt", "proj2Desc", "proj2ExpAmt", "proj2GrantAmt", "proj3Desc", "proj3ExpAmt", "proj3GrantAmt"];

const csvFilePath = './data/data.csv';
const csv = require('csvtojson');

var lines = 0;
fs.appendFile('./data/data.json', '[', () => { });
csv({
    headers: headers,
    trim: true
}).fromFile(csvFilePath)
    .on('json', (jsonObj) => {
        var website = jsonObj.WEBSITE;
        if (website.startsWith('http:\\') || website.startsWith('http.//')) {
            jsonObj.WEBSITE = website.substring(7);
        }
        if (website.startsWith('http//') || website.startsWith('http:/' || website.startsWith('http: '))) {
            jsonObj.WEBSITE = website.substring(6);
        }
        try {
            var line = JSON.stringify(jsonObj, null, 2);
            if (lines > 0) {
                line = ',' + line;
            }
            fs.appendFile('./data/data.json', line, () => { });
            lines++;
        } catch (e) {
            console.log("Cannot write to file", e);
        }
    })
    .on('done', (error) => {
        fs.appendFile('./data/data.json', ']', () => { });
    });
