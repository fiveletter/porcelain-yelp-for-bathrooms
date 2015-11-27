//// Constants
const PORT = 10000;
//// Requires
var express     = require('express');
var fs          = require('fs');
var app         = express();
var bodyParser  = require('body-parser');
var Validator   = require('jsonschema').Validator;
var mysql       = require('mysql');
//// Setup
var connection = mysql.createConnection(
    JSON.parse(
        fs.readFileSync("cred/mysql_db.cred")
    )
);
connection.connect();
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));
// parse application/json
app.use(bodyParser.json());
// Init validator
var v = new Validator();

var BathroomFlagSubQuery = `( 
    SELECT COUNT(RatingFlagID) 
    FROM RatingFlags, Ratings 
    WHERE Bathrooms.BathroomID=Ratings.BathroomID 
    AND RatingFlags.RatingID=Ratings.RatingID 
    AND RatingFlags.FlagID=1 
) as "Non-Existing",
( 
    SELECT COUNT(RatingFlagID) 
    FROM RatingFlags, Ratings 
    WHERE Bathrooms.BathroomID=Ratings.BathroomID 
    AND RatingFlags.RatingID=Ratings.RatingID 
    AND RatingFlags.FlagID=2 
) as "Hard-To-Find",
( 
    SELECT COUNT(RatingFlagID) 
    FROM RatingFlags, Ratings 
    WHERE Bathrooms.BathroomID=Ratings.BathroomID 
    AND RatingFlags.RatingID=Ratings.RatingID 
    AND RatingFlags.FlagID=3 
) as "Paid",
( 
    SELECT COUNT(RatingFlagID) 
    FROM RatingFlags, Ratings 
    WHERE Bathrooms.BathroomID=Ratings.BathroomID 
    AND RatingFlags.RatingID=Ratings.RatingID 
    AND RatingFlags.FlagID=4 
) as "Public"`;


/* =============== bathroom =============== */
app.post('/bathroom/create', function(req, res){
    console.log('POST /bathroom/create');
    console.log(req.body);
    
    res.writeHead(200, {'Content-Type': 'application/json'});
    
    var schema = {
        "type": "object",
        "properties": {
            "Longitude": { "type": "number" },
            "Latitude": { "type": "number" },
            "Title": { "type": "string" },
            "Picture": { "type": "string" },
            "Rating": { "type": "number" },
            "ProfileID": { "type": "number" },
            "Comment": { "type": "string" }
        },
        "required": ["Longitude", "Latitude", "Title", "Picture", "Rating", "ProfileID", "Comment" ]
    };
    
    var results = v.validate(req.body, schema);

    var createBathroom = function(new_data) {
        return new Promise((resolve, reject) => {
            connection.query(`INSERT INTO Bathrooms (Longitude, Latitude, Title, ImagePath) VALUES
                (${new_data.Longitude}, ${new_data.Latitude}, '${new_data.Title}', '${new_data.ImagePath}')`, 
            function(err, rows, fields) {
                if (err) { 
                    reject(err);
                    return;
                }
                console.log("CREATED BATHROOM!!!");
                resolve([rows.insertId, new_data]);
            });
        });
    };
    var createRating = function(combined_data) {
        // TODO: Base64 -> jpg conversion and storage
        connection.query(`INSERT INTO Ratings (Rating, ProfileID, BathroomID, Comment) VALUES
        (${combined_data[1].Rating}, ${combined_data[1].ProfileID}, ${combined_data[0]}, '${combined_data[1].Comment}')`, 
        function(err, rows, fields) {
            if (err) { 
                res.end(JSON.stringify(err));
                return;
            }
            var jres = {
                "BathroomID": combined_data[0], 
                "RatingID": rows.insertId
            };
            res.end(JSON.stringify(jres));
        });
    };

    if(results.errors.length === 0) {
        createBathroom(req.body).then(createRating).catch(function(err) {
            res.end(JSON.stringify(err));
        });
    } else {
        res.end(JSON.stringify(results.errors));
    }
});
app.post('/bathroom/retrieve', function(req, res){
    console.log('POST /bathroom/retrieve');
    
    res.writeHead(200, {'Content-Type': 'application/json'});
    
    var schema = {
        "type": "object",
        "properties": {
            "Longitude": { "type": "number" },
            "Latitude": { "type": "number" },
            "Radius": { "type": "number" }
        },
        "required": ["Longitude", "Latitude", "Radius" ]
    };
    
    var results = v.validate(req.body, schema);

    if(results.errors.length === 0) {
        connection.query(`SELECT BathroomID, Longitude, Latitude, Title, ImagePath,
        ${BathroomFlagSubQuery}
        FROM Bathrooms`, 
        function(err, rows, fields) {
            if (err) { 
                res.end(JSON.stringify(err));
                return; 
            }
            res.end(JSON.stringify(rows));
        });
    } else {
        res.end(JSON.stringify(results.errors));
    }
});

/* =============== rating =============== */
app.post('/rating/create', function(req, res){
    console.log('POST /rating/create');
    console.log(req.body);
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end('thanks');
});
app.post('/rating/retrieve', function(req, res){
    console.log('POST /rating/retrieve');
    console.log(req.body);
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end('thanks');
});
app.post('/rating/update', function(req, res){
    console.log('POST /rating/update');
    console.log(req.body);
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end('thanks');
});
app.post('/rating/delete', function(req, res){
    console.log('POST /rating/delete');
    console.log(req.body);
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end('thanks');
});


/* =============== User =============== */
app.post('/profile/create', function(req, res){
    console.log('POST /profile/create');
    console.log(req.body);
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end('thanks');
});
app.post('/profile/retrieve', function(req, res){
    console.log('POST /profile/retrieve');
    console.log(req.body);
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end('thanks');
});
app.post('/profile/update', function(req, res){
    console.log('POST /profile/update');
    console.log(req.body);
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end('thanks');
});
app.post('/profile/delete', function(req, res){
    console.log('POST /profile/delete');
    console.log(req.body);
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end('thanks');
});

app.listen(PORT);
console.log('Listening at http://localhost:' + PORT);
//connection.end();