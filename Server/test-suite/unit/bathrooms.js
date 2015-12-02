"use strict";

describe('Bathrooms: Testing CRUD API', function () {
	// Loading Libraries
	var mysql = require('mysql');
	var http = require('http');
	var fs = require('fs');

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

	connection.query(`DELETE FROM Bathrooms WHERE Title='UNIT-TEST'`);
	connection.query(`DELETE FROM Ratings WHERE Comment='UNIT-TESTING-COMMENT'`);

	describe('(C)reate', function () {
		it('should successfully create bathroom', function (done) {
			options.path = '/bathroom/create';
			var req = http.request(options, function(res) {
				// console.log('Status: ' + res.statusCode);
				// console.log('Headers: ' + JSON.stringify(res.headers));
				res.setEncoding('utf8');
				res.on('data', function (body) {
					var data = JSON.parse(body);
					var response_type = data.response;
					var BathroomID = data.info.BathroomID;
					var RatingID = data.info.RatingID;
					expect(response_type).to.equal('success');
					expect(BathroomID).to.be.a('number');
					expect(RatingID).to.be.a('number');
					
					var checkBathroom = new Promise((resolve, reject) => {
						connection.query(`SELECT Longitude, Latitude, Title FROM Bathrooms WHERE BathroomID=${BathroomID}`, function(err, rows, fields) {
						  	if (err) { throw err; }
						  	resolve({
						  		BathroomRow: rows[0], 
						  		RatingID: RatingID, 
						  		BathroomID: BathroomID
						  	});
						});
					});

					checkBathroom.then((handoff) => {
						connection.query(`SELECT Rating, ProfileID, BathroomID, Comment, PictureURL FROM Ratings WHERE RatingID=${handoff.RatingID}`, (err, rows, fields) => {
							if (err) { throw err; }
							expect(handoff.BathroomRow).to.eql({
								"Longitude": -121,
								"Latitude": 37,
								"Title": "UNIT-TEST"
							});
							console.log(rows);
							expect(rows[0]).to.eql({
								"Rating": 3, 
								"ProfileID": 1, 
								"BathroomID": handoff.BathroomID, 
								"Comment": "UNIT-TESTING-COMMENT", 
								"PictureURL": null
							});

							connection.query(`DELETE FROM Bathrooms WHERE Title='UNIT-TEST'`);
							connection.query(`DELETE FROM Ratings WHERE Comment='UNIT-TESTING-COMMENT'`);

							done();
						});
					});
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
					"Picture": "",
					"Rating": 3,
					"ProfileID": 1,
					"Comment": "UNIT-TESTING-COMMENT"
				}
			};

			req.write(JSON.stringify(request));
			req.end();
		});
	});
	describe('(R)etrieve', function () {
		it('should return array of bathrooms', function (done) {
			options.path = '/bathroom/retrieve';
			var req = http.request(options, function(res) {
				res.setEncoding('utf8');
				res.on('data', function (body) {
					var data = JSON.parse(body);
					var response_type = data.response;
					expect(response_type).to.equal('success');
					expect(data.info).to.be.a('array');
					expect(data.info[0]).to.be.a('object');
					expect(data.info[0]).to.include.keys('BathroomID');
					expect(data.info[0]).to.include.keys('Longitude');
					expect(data.info[0]).to.include.keys('Latitude');
					expect(data.info[0]).to.include.keys('Title');
					expect(data.info[0]).to.include.keys('ImagePath');

					expect(data.info[0]).to.include.keys('Non-Existing');
				    expect(data.info[0]).to.include.keys('Hard-To-Find');
				    expect(data.info[0]).to.include.keys('Paid');
				    expect(data.info[0]).to.include.keys('Public');

					expect(data.info[0].BathroomID).to.be.a('number');
					expect(data.info[0].Longitude).to.be.a('number');
					expect(data.info[0].Latitude).to.be.a('number');
					expect(data.info[0].Title).to.be.a('string');
					expect(data.info[0].ImagePath).to.be.a('string');
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
					"Longitude": 0,
					"Latitude": 0,
					"Radius": 1, //miles
				}
			};
			req.write(JSON.stringify(request));
			req.end();
		});
	});
});