"use strict";
//// Constants
const PORT = 10000;
const DEBUG = true;
//// Requires
var express     = require('express');
var fs          = require('fs');
var app         = express();
var bodyParser  = require('body-parser');
var Validator   = require('jsonschema').Validator;
var mysql       = require('mysql');
//// MySQL Setup
var connection;
var db_config = JSON.parse(
	fs.readFileSync("cred/mysql_db.cred")
);

function MySQLConnect() {
	connection = mysql.createConnection(db_config); // Recreate the connection, since
													// the old one cannot be reused.
	connection.connect(function(err) {				// The server is either down
		if(err) {									// or restarting (takes a while sometimes).
			console.log('error when connecting to db:', err);
			setTimeout(MySQLConnect, 2000); // We introduce a delay before attempting to reconnect,
		}									// to avoid a hot loop, and to allow our node script to
	});										// process asynchronous requests in the meantime.
											// If you're also serving http, display a 503 error.
	connection.on('error', function(err) {
		console.log('db error', err);
		if(err.code === 'PROTOCOL_CONNECTION_LOST') { // Connection to the MySQL server is usually
			MySQLConnect();					// lost due to either server restart, or a
		} else {							// connnection idle timeout (the wait_timeout
			throw err;						// server variable configures this)
		}
	});
}

function reply(res, isSuccess, info) {
	var rep = { "response": "", "info": {} };
	rep.response = (isSuccess) ? "success" : "failure";
	rep.info = info;
	res.end(JSON.stringify(rep));
}

/* SESSION STRUCTURE: 
	[
		{
			token: "",
			profile: <number>
		}
	]
*/
var sessions = [];

if(DEBUG) {
	sessions.push({
		token: "DEMO-AUTO-AUTH",
		profile: 1
	});
}

function appAuth (req, res, next) {
	var nonAuthRequests = [
		'/bathroom/retrieve',
		'/rating/retrieve',
		'/profile/retrieve',
		'/profile/auth'
	];
	console.log("BFAUTH: ", req.body, req.originalUrl);
	if (req.method === 'POST') {
		// Check if the address is one that does not require authentication
		for (let i = 0; i < nonAuthRequests.length; i++) {
			if(nonAuthRequests[i] === req.originalUrl) {
				// keep executing the router middleware
				next();
				return;
			}
		}
		// If the request does require authentication, check if a session exists.
		for (let i = 0; i < sessions.length; i++) {
			if(req.body.token === sessions[i].token) {
				req.body.ProfileID = sessions[i].profile;
				console.log("AUTHED: ", req.body);
				next();
				return;
			}
		}
	}
	reply(res, false, { error: "NO AUTH" });
}

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));
// parse application/json
app.use(bodyParser.json());
// authentication method
app.use(appAuth);
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
	var info = req.body.info;

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
	var results = v.validate(info, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		connection.query("INSERT INTO Bathrooms (Longitude, Latitude, Title, ImagePath) VALUES ?",
		[ [[ info.Longitude, info.Latitude, info.Title, "" ]] ], 
		function(err, insert) {
			if (err) { reply(res, false, err); return; }
			// TODO: Base64 -> jpg conversion and storage
			connection.query("INSERT INTO Ratings (Rating, ProfileID, BathroomID, Comment) VALUES ?",
			[ [[ info.Rating, req.body.ProfileID, insert.insertId, info.Comment ]] ],
			function(err, insertRating) {
				if (err) { reply(res, false, err); return; }
				var jres = {
					"BathroomID": insert.insertId, 
					"RatingID": insertRating.insertId
				};
				console.log("CREATED BATHROOM!!!");
				reply(res, true, jres);
			});
		});	
	} else {
		reply(res, false, results.errors);
	}
});
app.post('/bathroom/retrieve', function(req, res){
	console.log('POST /bathroom/retrieve');
	console.log(req.body);
	var info = req.body.info;
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
	var results = v.validate(info, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		connection.query(`SELECT BathroomID, Longitude, Latitude, Title, ImagePath, ${BathroomFlagSubQuery} FROM Bathrooms`, 
		function(err, rows) {
			if (err) { reply(res, false, err); return; }
			reply(res, true, rows);
		});
	} else {
		reply(res, false, results.errors);
	}
});

/* =============== rating =============== */
app.post('/rating/create', function(req, res){
	console.log('POST /rating/create');
	console.log(req.body);
	var info = req.body.info;
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
	var results = v.validate(info, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		connection.query("INSERT INTO Ratings (Rating, ProfileID, BathroomID, Comment, PictureURL) VALUES ?",
			[ [[ info.Rating, req.body.ProfileID, info.BathroomID, info.Comment, "" ]] ],
			function(err, insert) {
			if (err) { reply(res, false, err); console.log("Create Rating failure"); return; }
			
			var inserts = [];
			if(info["Non-Existing"] === true) 	{ inserts.push([1, insert.insertId]); }
			if(info["Hard-To-Find"] === true) 	{ inserts.push([2, insert.insertId]); }
			if(info["Paid"] === true) 			{ inserts.push([3, insert.insertId]); }
			if(info["Public"] === true) 		{ inserts.push([4, insert.insertId]); }

			if(inserts.length !== 0) {
				connection.query("INSERT INTO RatingFlags (FlagID, RatingID) VALUES ?",
				[ inserts ],
				function(err) { 
					if(err) { reply(res, false, err); console.log("Create flag failure"); return; }				
					console.log("CREATED RATING!!!");
					reply(res, true, { RatingID: insert.insertId });
				});
			}
			reply(res, true, { RatingID: insert.insertId });
		});
	} else {
		reply(res, false, results.errors);
	}
});
app.post('/rating/retrieve', function(req, res) {
	console.log('POST /rating/retrieve');
	console.log(req.body);
	var info = req.body.info;
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
		if (err) { reply(res, false, err); return; }
		reply(res, true, rows);
	};

	if(info.hasOwnProperty("RatingID")) {
		connection.query(query, [ { "RatingID": info.RatingID } ], returnResults);
	} else if(info.hasOwnProperty("BathroomID")) {
		connection.query(query, [ { "BathroomID": info.BathroomID } ], returnResults);
	} else {
		for (let i = 0; i < sessions.length; i++) {
			if(req.body.token === sessions[i].token) {
				req.body.ProfileID = sessions[i].profile;
				connection.query(query, [ { "ProfileID": req.body.ProfileID } ], returnResults);
				return;
			}
		}
		reply(res, false, { "error": "invalid request format" });
	}
});
app.post('/rating/update', function(req, res){
	console.log('POST /rating/update');
	console.log(req.body);
	var info = req.body.info;
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
	var results = v.validate(info, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		// UPDATE Ratings SET Rating=${info.Rating},
		// 		Comment="${info.Comment}",
		// 		PictureURL=""
		// 		WHERE RatingID=${info.RatingID}`, 
		var query = connection.query("UPDATE Ratings SET ? WHERE ?",
			[ { "Rating": info.Rating, "Comment": info.Comment }, { "RatingID": info.RatingID} ], 
			function(err, insert) {
			if (err) { reply(res, false, err); console.log("UPDATE rating failure"); return; }
			console.log(insert);
			var inserts = [];
			if(info["Non-Existing"] === true) 	{ inserts.push([ 1, info.RatingID ]); }
			if(info["Hard-To-Find"] === true) 	{ inserts.push([ 2, info.RatingID ]); }
			if(info["Paid"] === true) 			{ inserts.push([ 3, info.RatingID ]); }
			if(info["Public"] === true) 		{ inserts.push([ 4, info.RatingID ]); }

			connection.query("DELETE FROM RatingFlags WHERE ?", [ { "RatingID": info.RatingID } ], function() {
				if(inserts.length !== 0) {
					connection.query("INSERT INTO RatingFlags (FlagID, RatingID) VALUES ?",
					[ inserts ],
					function(err) { 
						if(err) { reply(res, false, err); console.log("UPDATE flag failure"); return; }
						console.log("UPDATED RATING!!!");
						reply(res, true, {});
					});
				}
			});
		});
		console.log(query.sql);
	} else {
		reply(res, false, results.errors);
	}
});
app.post('/rating/delete', function(req, res){
	console.log('POST /rating/delete');
	console.log(req.body);
	var info = req.body.info;
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
	var results = v.validate(info, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		connection.query("DELETE FROM Ratings WHERE ?", [ { "RatingID": info.RatingID } ], function(err) {
			if(err) { reply(res, false, err); return; }
			reply(res, true, {});
		});
	} else {
		reply(res, false, results.errors);
	}
});

/* =============== User =============== */
app.post('/profile/auth', function(req, res) {
	console.log('POST /profile/create');
	console.log(req.body);
	res.writeHead(200, {'Content-Type': 'application/json'});
	res.end('thanks');
});

// https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=XYZ123

app.post('/profile/retrieve', function(req, res) {
	console.log('POST /profile/retrieve');
	console.log(req.body);
	res.writeHead(200, {'Content-Type': 'application/json'});
	res.end('thanks');
});
app.post('/profile/delete', function(req, res) {
	console.log('POST /profile/delete');
	console.log(req.body);
	res.writeHead(200, {'Content-Type': 'application/json'});
	res.end('thanks');
});

// Connect to MySQL server
MySQLConnect();
// Listen on PORT
app.listen(PORT);
console.log('Listening at on port:' + PORT);