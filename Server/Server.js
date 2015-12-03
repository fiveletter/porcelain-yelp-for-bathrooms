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
var PhotoGenerator = require('./photo-generator');
var photo = new PhotoGenerator();
var google = require('googleapis');
var plus = google.plus('v1');
var OAuth2 = google.auth.OAuth2;
const CLIENT_ID = "32596942715-55efrjhgepaqloiaoakaua1eoin9n9cp.apps.googleusercontent.com"
//"672822966449-efaa1229enfq2o5kfbbr1p82k7vdacm5.apps.googleusercontent.com";
const CLIENT_SECRET = "eJ2XyXoAUl5eF9fzy4SX3qwf";

//// MySQL Setup
var connection;
var db_config = JSON.parse(
	fs.readFileSync("cred/mysql_db.cred")
);

function mysqlConnect() {
	connection = mysql.createConnection(db_config); // Recreate the connection, since
													// the old one cannot be reused.
	connection.connect(function(err) {				// The server is either down
		if(err) {									// or restarting (takes a while sometimes).
			console.log('error when connecting to db:', err);
			setTimeout(mysqlConnect, 2000); // We introduce a delay before attempting to reconnect,
		}									// to avoid a hot loop, and to allow our node script to
	});										// process asynchronous requests in the meantime.
											// If you're also serving http, display a 503 error.
	connection.on('error', function(err) {
		console.log('db error', err);
		if(err.code === 'PROTOCOL_CONNECTION_LOST') { // Connection to the MySQL server is usually
			mysqlConnect();					// lost due to either server restart, or a
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
		'/profile/auth',
		''
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
	} else if(req.method === 'GET') {
		next();
	} else {
		reply(res, false, { error: "NO AUTH" });
	}
}

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));
// parse application/json
app.use(bodyParser.json({ limit: '50mb'}));
// authentication method
app.use(appAuth);
// To serve static files using built-in middleware function in Express
app.use("/fs", express.static('fs'));
// Init validator
var v = new Validator();

var BathroomFlagSubQuery = `
( 
	SELECT AVG(Rating) 
	FROM Ratings 
	WHERE Bathrooms.BathroomID=Ratings.BathroomID 
) as AverageRating,
( 
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
			"Comment": { "type": "string" }
		},
		"required": ["Longitude", "Latitude", "Title", "Picture", "Rating", "Comment" ]
	};
	// Validate the input data against the schema
	var results = v.validate(info, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		var BathroomID = -1;
		var RatingID = -1;
		var image_path = "";
		var savePhoto = function() {
			return new Promise((resolve) => {
				photo.savePhoto(info.Picture, function(file_name) {
					image_path = file_name;
					resolve();
				});
			});
		};
		var insertBathroom = function() {
			return new Promise((resolve) => {
				connection.query("INSERT INTO `Porcelain`.`Bathrooms` (`Longitude`,`Latitude`,`Title`) VALUES ?",
				[ [[ info.Longitude, info.Latitude, info.Title ]] ], 
				function(err, insert) {
					if (err) { reply(res, false, err); return; }
					BathroomID = insert.insertId;
					//console.log("BathroomID: ", BathroomID);
					resolve();
				});
			});
		};
		var insertRating = function() {
			return new Promise((resolve) => {
				connection.query("INSERT INTO Ratings (Rating, ProfileID, BathroomID, Comment, PictureURL) VALUES ?",
				[ [[ info.Rating, req.body.ProfileID, BathroomID, info.Comment, image_path ]] ],
				function(err, insert) {
					if (err) { 
						reply(res, false, err); 
						console.log("Create bathroom rating failure"); 
						return; 
					}
					RatingID = insert.insertId;
					//console.log("RatingID: ", RatingID);
					var flags = [];
					if(info["Non-Existing"] === true) 	{ flags.push([1, RatingID]); }
					if(info["Hard-To-Find"] === true) 	{ flags.push([2, RatingID]); }
					if(info["Paid"] === true) 			{ flags.push([3, RatingID]); }
					if(info["Public"] === true) 		{ flags.push([4, RatingID]); }

					if(flags.length !== 0) {
						resolve(flags);
					} else {
						reply(res, true, {
							"BathroomID": BathroomID, 
							"RatingID": RatingID,
							"PictureURL": image_path
						});
					}
				});
			});
		};
		var insertFlags = function(flags) {
			connection.query("INSERT INTO RatingFlags (FlagID, RatingID) VALUES ?", [ flags ], function(err) { 
				if(err) { 
					reply(res, false, err); 
					console.log("Create bathroom flag failure"); 
					return; 
				}				
				console.log("CREATED BATHROOM!!!");
				reply(res, true, {
					"BathroomID": BathroomID, 
					"RatingID": RatingID
				});
			});
		};
		savePhoto().then(insertBathroom).then(insertRating).then(insertFlags);
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
			"MinLat": { "type": "number" },
            "MaxLat": { "type": "number" },
            "MinLong": { "type": "number" },
            "MaxLong": { "type": "number" }
		},
		"required": ["Longitude", "Latitude", "MinLat", "MaxLat", "MinLong", "MaxLong" ]
	};
	// Validate the input data against the schema
	var results = v.validate(info, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		connection.query(`SELECT BathroomID, Longitude, Latitude, Title, ${BathroomFlagSubQuery} FROM Bathrooms WHERE 
			Longitude <= ? AND Longitude >= ? AND Latitude <= ? AND Latitude >= ?`,
		[ info.MaxLong, info.MinLong, info.MaxLat, info.MinLat ], 
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
			"Comment": { "type": "string" },
			"Picture": { "type": "string" },
			"Non-Existing": { "type": "boolean" },
			"Hard-To-Find": { "type": "boolean" },
			"Paid": { "type": "boolean" },
			"Public": { "type": "boolean" }
		},
		"required": [ "Rating", "BathroomID", "Comment", "Picture", "Non-Existing", "Hard-To-Find", "Paid", "Public" ]
	};
	// Validate the input data against the schema
	var results = v.validate(info, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		var image_path = "";
		var RatingID = -1;
		var savePhoto = function() {
			return new Promise((resolve) => {
				photo.savePhoto(info.Picture, function(file_name) {
					image_path = file_name;
					resolve();
				});
			});
		};
		var insertRating = function() {
			return new Promise((resolve) => {
				connection.query("INSERT INTO Ratings (Rating, ProfileID, BathroomID, Comment, PictureURL) VALUES ?",
					[ [[ info.Rating, req.body.ProfileID, info.BathroomID, info.Comment, image_path ]] ],
					function(err, insert) {
					if (err) {
						reply(res, false, err);
						console.log("Create Rating failure");
						return;
					}
					RatingID = insert.insertId;
					// SETUP Flags
					var flags = [];
					if(info["Non-Existing"] === true) 	{ flags.push([1, insert.insertId]); }
					if(info["Hard-To-Find"] === true) 	{ flags.push([2, insert.insertId]); }
					if(info["Paid"] === true) 			{ flags.push([3, insert.insertId]); }
					if(info["Public"] === true) 		{ flags.push([4, insert.insertId]); }

					if(flags.length !== 0) {
						resolve(flags);
					} else {
						reply(res, true, { RatingID: insert.insertId });
					}
				});
			});
		};
		var insertFlags = function(flags) {
			connection.query("INSERT INTO RatingFlags (FlagID, RatingID) VALUES ?", [ flags ],
			function(err) { 
				if(err) { 
					reply(res, false, err); 
					console.log("Create flag failure"); 
					return; 
				}
				console.log("CREATED RATING!!!");
				reply(res, true, { 
					"RatingID": RatingID,
					"PictureURL": image_path
				});
			});
		};
		savePhoto().then(insertRating).then(insertFlags);
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
	var query = `SELECT RatingID, Timestamp, Rating, Ratings.ProfileID, BathroomID, Comment, PictureURL, 
		EXISTS(SELECT 1 FROM RatingFlags WHERE RatingFlags.RatingID=Ratings.RatingID AND RatingFlags.FlagID=1) as "Non-Existing",
		EXISTS(SELECT 1 FROM RatingFlags WHERE RatingFlags.RatingID=Ratings.RatingID AND RatingFlags.FlagID=2) as "Hard-To-Find",
		EXISTS(SELECT 1 FROM RatingFlags WHERE RatingFlags.RatingID=Ratings.RatingID AND RatingFlags.FlagID=3) as "Paid",
		EXISTS(SELECT 1 FROM RatingFlags WHERE RatingFlags.RatingID=Ratings.RatingID AND RatingFlags.FlagID=4) as "Public",
		FirstName, LastName
		FROM Ratings, Profiles WHERE ?`;

	var returnResults = function(err, rows) {
		if (err) { reply(res, false, err); return; }
		reply(res, true, rows);
	};

	if(info.hasOwnProperty("RatingID")) {
		connection.query(query, [ { "Ratings.RatingID": info.RatingID } ], returnResults);
	} else if(info.hasOwnProperty("BathroomID")) {
		connection.query(query, [ { "Ratings.BathroomID": info.BathroomID } ], returnResults);
	} else {
		for (let i = 0; i < sessions.length; i++) {
			if(req.body.token === sessions[i].token) {
				req.body.ProfileID = sessions[i].profile;
				query = connection.query(query, [ { "Ratings.ProfileID": req.body.ProfileID } ], returnResults);
				console.log("sql = ", query);
				return;
			}
		}
		reply(res, false, { "error": "invalid request format" });
	}
});
app.post('/rating/update', function(req, res){
	console.log('POST /rating/update');
	//console.log(req.body);
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
		var image_path = "";
		var RatingID = -1;
		var previousPhoto = "";

		var getPreviousPhoto = function() {
			return new Promise((resolve, reject) => {
				connection.query("SELECT PictureURL FROM Ratings WHERE ?",
					[ { "RatingID": info.RatingID } ],
					function(err, rows) {
					if (err) {
						console.log("Update operation on Rating that does not exist");
						reply(res, false, err);
						reject();
					} else if(rows.length === 0) {
						reply(res, false, { "error": "Rating does not exist" });
						reject();
					} else {
						previousPhoto = rows[0].PictureURL;
						resolve();
					}
				});
			});
		};
		var savePhoto = function() {
			return new Promise((resolve) => {
				photo.savePhoto(info.Picture, function(file_name) {
					image_path = file_name;
					resolve();
				});
			});
		};
		var deleteOldPhoto = function() {
			return new Promise((resolve) => {
				fs.stat(previousPhoto, function(err) {
					if(err) {
						// skip, it does not exist
						resolve();
					} else {
						// delete previous photo using path
						fs.unlink(previousPhoto, function() {
							resolve();
						});
					}
				});
			});
		};
		var insertRating = function() {
			return new Promise((resolve, reject) => {
				connection.query("UPDATE Ratings SET ? WHERE ?",
					[ { "Rating": info.Rating, "Comment": info.Comment, "PictureURL": image_path }, { "RatingID": info.RatingID} ], 
					function(err, insert) {
					RatingID = insert.insertId;
					if (err) { reply(res, false, err); console.log("UPDATE rating failure"); reject(); }
					resolve();
				});
			});
		};
		var deleteOldFlags = function() {
			return new Promise((resolve) => {
				connection.query("DELETE FROM RatingFlags WHERE ?", [ { "RatingID": info.RatingID } ], function() {
					resolve();
				});
			});
		};
		var createFlagStructure = function() {
			return new Promise((resolve) => {
				var flags = [];
				if(info["Non-Existing"] === true) 	{ flags.push([ 1, info.RatingID ]); }
				if(info["Hard-To-Find"] === true) 	{ flags.push([ 2, info.RatingID ]); }
				if(info["Paid"] === true) 			{ flags.push([ 3, info.RatingID ]); }
				if(info["Public"] === true) 		{ flags.push([ 4, info.RatingID ]); }
				resolve(flags);
			});
		};
		var insertFlags = function(flags) {
			if(flags.length !== 0) {
				connection.query("INSERT INTO RatingFlags (FlagID, RatingID) VALUES ?", [ flags ],
				function(err) { 
					if(err) { reply(res, false, err); console.log("UPDATE flag failure"); return; }
					console.log("UPDATED RATING!!!");
					reply(res, true, {
						"PictureURL": image_path
					});
				});
			} else {
				reply(res, true, {});
			}
		};

		getPreviousPhoto().then(savePhoto).then(deleteOldPhoto).then(insertRating).then(deleteOldFlags).then(createFlagStructure).then(insertFlags);
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
	console.log('POST /profile/auth');
	
	console.log(req.body);
	var info = req.body.info;
	// Set MIME Type of data returned to client to JSON
	res.writeHead(200, {'Content-Type': 'application/json'});
	// Structure that the input data must conform to 
	var schema = {
		"type": "object",
		"properties": {
			"access_token": { "type": "string" },
			"refresh_token": { "type": "string" },
		},
		"required": [ "access_token", "refresh_token" ]
	};
	// Validate the input data against the schema
	var results = v.validate(info, schema);
	// If results show that there are no errors, then do action
	if(results.errors.length === 0) {
		var oauth2Client = new OAuth2(CLIENT_ID, CLIENT_SECRET);
		// Retrieve tokens via token exchange explained above or set them:
		oauth2Client.setCredentials({
		  access_token:   info.access_token,
		  refresh_token:  info.refresh_token
		});

		var FirstName, LastName, Email, ProfileID;

		var grabUserInfo = function() {
			return new Promise(function(resolve) {
				plus.people.get({ userId: 'me', auth: oauth2Client }, function(err, response) {
					if(err) { reply(res, false, { "error": "FAILED TO AUTHENTICATE" } ); }
					// handle err and response
					FirstName = response.name.familyName;
					LastName = response.name.givenName;
					Email = response.emails[0].value;
					console.log(err);
					console.log(response);
					resolve();
				});
			});
		};
		var checkDatabaseForUser = function() {
			return new Promise(function(resolve) {
				connection.query("SELECT ProfileID FROM Profiles WHERE ?", [ { "Email": Email } ], function(err, rows) {
					if(err) { reply(res, false, { "error": "FAILED TO AUTHENTICATE" }); return; }
					if(rows.length != 0) {
						resolve(true);
					} else {
						ProfileID = rows[0].ProfileID;
						resolve(false);
					}
				});
			});
		};
		var addUserToDatabase = function(isInServer) {
			return new Promise(function(resolve) {
				if(isInServer) {
					resolve();
				} else {
					connection.query("INSERT INTO Profiles (Email, FirstName, LastName) VALUES ? ", [ [[ Email, FirstName, LastName ]] ], function(err, insert) {
						if(err) { reply(res, false, { "error": "FAILED TO CREATE USER" }); return; }
						ProfileID = insert.insertId;
						resolve();
					});
				}
			});
		};
		var pushUserIntoSessions = function() {
			sessions.push({
				token: info.access_token,
				refresh: info.refresh_token,
				profile: ProfileID
			});
		};
	} else {
		reply(res, false, results.errors);
	}
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
mysqlConnect();
// Listen on PORT
app.listen(PORT);
console.log('Listening at on port:' + PORT);
