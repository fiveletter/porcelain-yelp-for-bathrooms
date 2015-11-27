"use strict";

describe('Profiles', function () {
	// Loading Libraries
	var mysql = require('mysql');
	var http = require('http');

	var options = {
		hostname: '127.0.0.1',
		port: 10000,
		path: '',
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
		}
    };

	var connection = mysql.createConnection({
	  host     : 'localhost',
	  user     : 'root',
	  password : '',
	  database : 'Porcelain'
	});

	connection.connect();

	connection.query(`DELETE FROM Bathrooms WHERE Title='UNIT-TEST'`);
	connection.query(`DELETE FROM Ratings WHERE Comment='UNIT-TESTING-COMMENT'`);

	describe('Testing CRUD', function () {
		it('(C)reate', function (done) {
			options.path = '/bathroom/create';
			var req = http.request(options, function(res) {
				// console.log('Status: ' + res.statusCode);
				// console.log('Headers: ' + JSON.stringify(res.headers));
				res.setEncoding('utf8');
				res.on('data', function (body) {
					var BathroomID = JSON.parse(body).BathroomID;
					var RatingID = JSON.parse(body).RatingID;
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
				expect("Request to have an error").to.be.false;
			});

			var request = {
				"Longitude": -121,
				"Latitude": 37,
				"Title": "UNIT-TEST",
				"Picture": "",
				"Rating": 3,
				"ProfileID": 1,
				"Comment": "UNIT-TESTING-COMMENT",
			};

			req.write(JSON.stringify(request));
			req.end();
		});
	});

	it('(R)etrieve Radius', function (done) {
		options.path = '/bathroom/retrieve';
		var req = http.request(options, function(res) {
			res.setEncoding('utf8');
			res.on('data', function (body) {
				var jres = JSON.parse(body);
				expect(jres).to.be.a('array');
				expect(jres[0]).to.be.a('object');
				expect(jres[0]).to.include.keys('BathroomID');
				expect(jres[0]).to.include.keys('Longitude');
				expect(jres[0]).to.include.keys('Latitude');
				expect(jres[0]).to.include.keys('Title');
				expect(jres[0]).to.include.keys('ImagePath');

				expect(jres[0]).to.include.keys('Non-Existing');
			    expect(jres[0]).to.include.keys('Hard-To-Find');
			    expect(jres[0]).to.include.keys('Paid');
			    expect(jres[0]).to.include.keys('Public');

				expect(jres[0].BathroomID).to.be.a('number');
				expect(jres[0].Longitude).to.be.a('number');
				expect(jres[0].Latitude).to.be.a('number');
				expect(jres[0].Title).to.be.a('string');
				expect(jres[0].ImagePath).to.be.a('string');
				expect(jres[0]['Non-Existing']).to.be.a('number');
				expect(jres[0]['Hard-To-Find']).to.be.a('number');
				expect(jres[0].Paid).to.be.a('number');
				expect(jres[0].Public).to.be.a('number');
				done();
			});
		});

		req.on('error', function (e) {
			expect("Request to have an error").to.be.false;
		});

		var request = {
			"Longitude": 0,
			"Latitude": 0,
			"Radius": 1, //miles
		};
		req.write(JSON.stringify(request));
		req.end();
	});
});