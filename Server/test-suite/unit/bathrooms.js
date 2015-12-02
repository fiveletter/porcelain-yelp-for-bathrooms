"use strict";

describe('Bathrooms: Testing CRUD API', function () {
	// Loading Libraries
	var mysql = require('mysql');
	var http = require('http');
	var fs = require('fs');
	var PhotoGenerator = require('../../photo-generator');
	var photo = new PhotoGenerator();

	var options = {
		hostname: '127.0.0.1',
		port: 10000,
		path: '',
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
		}
    };

	var connection = mysql.createConnection(
	    JSON.parse(
	        fs.readFileSync("cred/mysql_db.cred")
	    )
	);

	connection.connect();

	connection.query("DELETE FROM Bathrooms WHERE Title='UNIT-TEST'");
	connection.query("DELETE FROM Ratings WHERE Comment='UNIT-TESTING-COMMENT'");

	describe('(C)reate', function () {
		var deleteTestFile = ""; 
		it('should successfully create bathroom', function (done) {
			options.path = '/bathroom/create';
			var req = http.request(options, function(res) {
				// console.log('Status: ' + res.statusCode);
				// console.log('Headers: ' + JSON.stringify(res.headers));
				res.setEncoding('utf8');
				res.on('data', function (body) {
					//console.log(body);
					var data = JSON.parse(body);
					var response_type = data.response;
					var BathroomID = data.info.BathroomID;
					var RatingID = data.info.RatingID;
				  	//console.log(data);
					expect(response_type).to.equal('success');
					expect(BathroomID).to.be.a('number');
					expect(RatingID).to.be.a('number');

					var BathroomRow;
					var RatingRow;

					var checkBathroom = function() {
						return new Promise((resolve) => {
							connection.query("SELECT Longitude, Latitude, Title FROM Bathrooms WHERE ?",
								[ { "BathroomID": BathroomID } ], 
								(err, rows) => {
							  	if (err) { throw err; }
							  	//console.log("checkBathroom: ", rows);
							  	BathroomRow = rows[0];
							  	resolve();
							});
						});
					};

					var checkRating = function() {
						return new Promise((resolve) => { 
							connection.query("SELECT Rating, ProfileID, Comment, PictureURL FROM Ratings WHERE ? ", 
								[ { "RatingID": RatingID } ], 
								(err, rows) => {
									if (err) { throw err; }
									//console.log("checkRating: ", rows);
									RatingRow = rows[0];
									deleteTestFile = rows[0].PictureURL;
									resolve();
								}
							);
						});
					};

					var checkIfPictureExists = function() {
						return new Promise((resolve) => { 
							fs.stat(deleteTestFile, function(err) {
								expect(err).to.be.null;
								resolve();
							});
						});
					};

					var checkRatingFlags = function () {
						connection.query("SELECT * FROM RatingFlags WHERE ? ", 
							[ { "RatingID": RatingID }, { "BathroomID": BathroomID } ],
							(err, rows) => {
							if (err) { throw err; }
						  	//console.log("checkRatingFlags: ", rows);
							expect(BathroomRow).to.eql({
								"Longitude": -121,
								"Latitude": 37,
								"Title": "UNIT-TEST"
							});
							//console.log(RatingRow);
							expect(RatingRow).to.have.property("Rating", 3);
							expect(RatingRow).to.have.property("ProfileID", 1);
							expect(RatingRow).to.have.property("Comment", "UNIT-TESTING-COMMENT");
							expect(RatingRow.PictureURL).to.not.be.empty;
							expect(rows.length).to.equal(4);
							done();
						});
					};
					checkBathroom().then(checkRating).then(checkIfPictureExists).then(checkRatingFlags);
				});
			});

			req.on('error', function (e) {
				assert.notOk('everything', e);
			});

			var request = {
				token: "DEMO-AUTO-AUTH",
				info: {
					"Longitude": -121,
					"Latitude": 37,
					"Title": "UNIT-TEST",
					"Picture": photo.base64testfile,
					"Rating": 3,
					"ProfileID": 1,
					"Comment": "UNIT-TESTING-COMMENT",
					"Non-Existing": true,
					"Hard-To-Find": true,
					"Paid": true,
					"Public": true
				}
			};

			req.write(JSON.stringify(request));
			req.end();
		});
		after(function() {
			connection.query("DELETE FROM Bathrooms WHERE Title='UNIT-TEST'");
			try { 
				if(deleteTestFile) {
					fs.unlink(deleteTestFile); 
				} 
			} catch(e) {}
		});
	});
	describe('(R)etrieve', function () {
		it('should return array of bathrooms', function (done) {
			options.path = '/bathroom/retrieve';
			var req = http.request(options, function(res) {
				res.setEncoding('utf8');
				res.on('data', function (body) {
					var data = JSON.parse(body);
					console.log(data);
					var response_type = data.response;
					expect(response_type).to.equal('success');
					expect(data.info).to.be.a('array');
					expect(data.info[0]).to.be.a('object');
					expect(data.info[0]).to.include.keys('BathroomID');
					expect(data.info[0]).to.include.keys('Longitude');
					expect(data.info[0]).to.include.keys('Latitude');
					expect(data.info[0]).to.include.keys('Title');

					expect(data.info[0]).to.include.keys('Non-Existing');
				    expect(data.info[0]).to.include.keys('Hard-To-Find');
				    expect(data.info[0]).to.include.keys('Paid');
				    expect(data.info[0]).to.include.keys('Public');

					expect(data.info[0].BathroomID).to.be.a('number');
					expect(data.info[0].Longitude).to.be.a('number');
					expect(data.info[0].Latitude).to.be.a('number');
					expect(data.info[0].Title).to.be.a('string');
					expect(data.info[0]['Non-Existing']).to.be.a('number');
					expect(data.info[0]['Hard-To-Find']).to.be.a('number');
					expect(data.info[0].Paid).to.be.a('number');
					expect(data.info[0].Public).to.be.a('number');
					done();
				});
			});

			req.on('error', function (e) {
				assert.notOk('everything', e);
			});

			var request = {
				token: "DEMO-AUTO-AUTH",
				info: {
					"Longitude": -121.88130950927734000000,
					"Latitude": 37.33691787719726600000,
					"MinLat": 10,
		            "MaxLat": 10,
		            "MinLong": 10,
		            "MaxLong": 10
				}
			};
			req.write(JSON.stringify(request));
			req.end();
		});
	});
});