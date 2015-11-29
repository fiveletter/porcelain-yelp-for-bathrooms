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
	
	// Set MIME Type of data returned to client to JSON
	res.writeHead(200, {'Content-Type': 'application/json'});
	// Structure that the input data must conform to 
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
	// Validate the input data against the schema
	var results = v.validate(req.body, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		connection.query("INSERT INTO Bathrooms (Longitude, Latitude, Title, ImagePath) VALUES ?",
		[ [[ req.body.Longitude, req.body.Latitude, req.body.Title, "" ]] ], 
		function(err, insert) {
			if (err) { res.end(JSON.stringify(err)); return; }
			// TODO: Base64 -> jpg conversion and storage
			connection.query("INSERT INTO Ratings (Rating, ProfileID, BathroomID, Comment) VALUES ?",
			[ [[ req.body.Rating, req.body.ProfileID, insert.insertId, req.body.Comment ]] ],
			function(err, insertRating) {
				if (err) { res.end(JSON.stringify(err)); return; }
				var jres = {
					"BathroomID": insert.insertId, 
					"RatingID": insertRating.insertId
				};
				console.log("CREATED BATHROOM!!!");
				res.end(JSON.stringify(jres));
			});
		});	
	} else {
		res.end(JSON.stringify(results.errors));
	}
});
app.post('/bathroom/retrieve', function(req, res){
	console.log('POST /bathroom/retrieve');
	
	// Set MIME Type of data returned to client to JSON
	res.writeHead(200, {'Content-Type': 'application/json'});
	// Structure that the input data must conform to 
	var schema = {
		"type": "object",
		"properties": {
			"Longitude": { "type": "number" },
			"Latitude": { "type": "number" },
			"Radius": { "type": "number" }
		},
		"required": ["Longitude", "Latitude", "Radius" ]
	};
	// Validate the input data against the schema
	var results = v.validate(req.body, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		connection.query(`SELECT BathroomID, Longitude, Latitude, Title, ImagePath, ${BathroomFlagSubQuery} FROM Bathrooms`, 
		function(err, rows) {
			if (err) { res.end(JSON.stringify(err)); return; }
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
	// Set MIME Type of data returned to client to JSON
	res.writeHead(200, {'Content-Type': 'application/json'});
	// Structure that the input data must conform to 
	var schema = {
		"type": "object",
		"properties": {
			"Rating": { "type": "number" },
			"BathroomID": { "type": "number" },
			"ProfileID": { "type": "number" },
			"Comment": { "type": "string" },
			"Picture": { "type": "string" },
			"Non-Existing": { "type": "boolean" },
			"Hard-To-Find": { "type": "boolean" },
			"Paid": { "type": "boolean" },
			"Public": { "type": "boolean" }
		},
		"required": [ "Rating", "BathroomID", "ProfileID", "Comment", "Picture", "Non-Existing", "Hard-To-Find", "Paid", "Public" ]
	};
	// Validate the input data against the schema
	var results = v.validate(req.body, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		connection.query("INSERT INTO Ratings (Rating, ProfileID, BathroomID, Comment, PictureURL) VALUES ?",
			[ [[ req.body.Rating, req.body.ProfileID, req.body.BathroomID, req.body.Comment, "" ]] ],
			function(err, insert) {
			if (err) { res.end(JSON.stringify(err)); console.log("Create Rating failure"); return; }
			
			var inserts = [];
			if(req.body["Non-Existing"] === true) 	{ inserts.push([1, insert.insertId]); }
			if(req.body["Hard-To-Find"] === true) 	{ inserts.push([2, insert.insertId]); }
			if(req.body["Paid"] === true) 			{ inserts.push([3, insert.insertId]); }
			if(req.body["Public"] === true) 		{ inserts.push([4, insert.insertId]); }

			if(inserts.length != 0) {
				connection.query("INSERT INTO RatingFlags (FlagID, RatingID) VALUES ?",
				[ inserts ],
				function(err) { 
					if(err) { res.end(JSON.stringify(err)); console.log("Create flag failure"); return; }				
					console.log("CREATED RATING!!!");
					res.end(JSON.stringify({ RatingID: insert.insertId }));
				});
			}
			res.end(JSON.stringify({ RatingID: insert.insertId }));
		});
	} else {
		res.end(JSON.stringify(results.errors));
	}
});
app.post('/rating/retrieve', function(req, res){
	console.log('POST /rating/retrieve');
	
	// Set MIME Type of data returned to client to JSON
	res.writeHead(200, {'Content-Type': 'application/json'});

	var flagSubQuery = `
		EXISTS(SELECT 1 FROM RatingFlags WHERE RatingFlags.RatingID=Ratings.RatingID AND RatingFlags.FlagID=1) as "Non-Existing",
		EXISTS(SELECT 1 FROM RatingFlags WHERE RatingFlags.RatingID=Ratings.RatingID AND RatingFlags.FlagID=2) as "Hard-To-Find",
		EXISTS(SELECT 1 FROM RatingFlags WHERE RatingFlags.RatingID=Ratings.RatingID AND RatingFlags.FlagID=3) as "Paid",
		EXISTS(SELECT 1 FROM RatingFlags WHERE RatingFlags.RatingID=Ratings.RatingID AND RatingFlags.FlagID=4) as "Public"
	`;
	
	var query = `SELECT RatingID, Timestamp, Rating, ProfileID, BathroomID, Comment, PictureURL, ${flagSubQuery} FROM Ratings WHERE ? LIMIT 1`;

	var returnResults = function(err, rows) {
		if (err) { res.end(JSON.stringify(err)); return; }
		res.end(JSON.stringify(rows));
	}

	if(req.body.hasOwnProperty("RatingID")) {
		connection.query(query, [ { "RatingID": req.body.RatingID } ], returnResults);
	} else if(req.body.hasOwnProperty("BathroomID")) {
		connection.query(query, [ { "BathroomID": req.body.BathroomID } ], returnResults);
	} else if(req.body.hasOwnProperty("ProfileID")) {
		connection.query(query, [ { "ProfileID": req.body.ProfileID } ], returnResults);
	} else {
		res.end(JSON.stringify({ "error": "invalid request format" }));
	}
});
app.post('/rating/update', function(req, res){
	console.log('POST /rating/update');
	console.log(req.body);
	// Set MIME Type of data returned to client to JSON
	res.writeHead(200, {'Content-Type': 'application/json'});
	// Structure that the input data must conform to 	
	var schema = {
		"type": "object",
		"properties": {
			"RatingID": { "type": "number" },
			"Rating": { "type": "number" },
			"Comment": { "type": "string" },
			"Picture": { "type": "string" },
			"Non-Existing": { "type": "boolean" },
			"Hard-To-Find": { "type": "boolean" },
			"Paid": { "type": "boolean" },
			"Public": { "type": "boolean" },
		},
		"required": [ "RatingID", "Rating", "Comment", "Picture", "Non-Existing", "Hard-To-Find", "Paid", "Public" ]
	};
	// Validate the input data against the schema
	var results = v.validate(req.body, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		// UPDATE Ratings SET Rating=${req.body.Rating},
		// 		Comment="${req.body.Comment}",
		// 		PictureURL=""
		// 		WHERE RatingID=${req.body.RatingID}`, 
		var query = connection.query("UPDATE Ratings SET ? WHERE ?",
			[ { "Rating": req.body.Rating, "Comment": req.body.Comment }, { "RatingID": req.body.RatingID} ], 
			function(err, insert) {
			if (err) { res.end(JSON.stringify(err)); console.log("UPDATE rating failure"); return; }
			console.log(insert);
			var inserts = [];
			if(req.body["Non-Existing"] === true) 	{ inserts.push([ 1, req.body.RatingID ]); }
			if(req.body["Hard-To-Find"] === true) 	{ inserts.push([ 2, req.body.RatingID ]); }
			if(req.body["Paid"] === true) 			{ inserts.push([ 3, req.body.RatingID ]); }
			if(req.body["Public"] === true) 		{ inserts.push([ 4, req.body.RatingID ]); }

			connection.query("DELETE FROM RatingFlags WHERE ?", [ { "RatingID": req.body.RatingID } ], function(err) {
				if(inserts.length != 0) {
					connection.query("INSERT INTO RatingFlags (FlagID, RatingID) VALUES ?",
					[ inserts ],
					function(err, insert) { 
						if(err) { res.end(JSON.stringify(err)); console.log("UPDATE flag failure"); return; }
						console.log("UPDATED RATING!!!");
						res.end(JSON.stringify({ "response": "success" }));
					});
				}
			});
		});
		console.log(query.sql);
	} else {
		res.end(JSON.stringify(results.errors));
	}
});
app.post('/rating/delete', function(req, res){
	console.log('POST /rating/delete');
	console.log(req.body);
	res.writeHead(200, {'Content-Type': 'application/json'});
	// Structure that the input data must conform to 	
	var schema = {
		"type": "object",
		"properties": {
			"RatingID": { "type": "number" },
		},
		"required": [ "RatingID" ]
	};
	// Validate the input data against the schema
	// Validate the input data against the schema
	var results = v.validate(req.body, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		connection.query("DELETE FROM Ratings WHERE ?", [ { "RatingID": req.body.RatingID } ], function(err) {
			if(err) { res.end(JSON.stringify(err)); return; }
			res.end(JSON.stringify({ "response": "success" }));
		});
	} else {
		res.end(JSON.stringify(results.errors));
	}
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