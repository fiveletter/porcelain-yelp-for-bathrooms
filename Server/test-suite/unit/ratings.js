"use strict";


describe('Ratings', function () {
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

	describe('Testing CRUD', function () {
		describe('(C)reate', function () {
			var RatingID;
			it('should create Rating and Rating Flags in database', function (done) {
				options.path = '/rating/create';
				var req = http.request(options, function(res) {
					res.setEncoding('utf8');
					res.on('data', function (body) {
						var data = JSON.parse(body);
						console.log(data);
						var response_type = data.response;
						expect(response_type).to.equal('success');
						RatingID = data.info.RatingID;

						connection.query(`SELECT * FROM Ratings WHERE RatingID=${data.info.RatingID}`, function(err, rows) {
							if (err) { throw err; return; }
							expect(rows.length).to.be.above(0);
							connection.query(`SELECT * FROM RatingFlags WHERE RatingID=${data.info.RatingID}`, function(err, rows) {
								// four rating flag relationships were made
								expect(rows.length).to.be.equal(4);
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
						"Rating": 3,
						"BathroomID": 1,
						"ProfileID": 1,
						"Comment": "UNIT TESTING COMMENT",
						"Picture": "",
		            	"Non-Existing": true,
		            	"Hard-To-Find": true,
		            	"Paid": true,
		            	"Public": true
					}
				};

				req.write(JSON.stringify(request));
				req.end();
			});
			after(function(done) {
				if(typeof RatingID === "number") {
					connection.query(`DELETE FROM Ratings WHERE RatingID=${RatingID}`, function() { done(); });
				} else {
					done();
				}
			});
		});
	});

	describe('(R)etrieve via RatingID', function () {
		var InsertID;
		after(function(done) {
			if(typeof InsertID === "number") {
				connection.query(`DELETE FROM Ratings WHERE RatingID=${InsertID}`, function() { done(); });
			} else {
				done();
			}
		});
		it('should return JSON structure fitting the CRUD API', function (done) {
			connection.query(`INSERT INTO Ratings ( Rating, ProfileID, BathroomID, Comment, PictureURL )
				VALUES (3, 1, 1, 'UNIT TEST (R)etrieve Via RatingID', '')`, function after_query (err, insert) {
				if (err) { throw err; return; }
				InsertID = insert.insertId;
				options.path = '/rating/retrieve';
				var req = http.request(options, function(res) {
				res.setEncoding('utf8');
					res.on('data', function (body) {
						var data = JSON.parse(body);
						console.log(data);
						var response_type = data.response;
						expect(response_type).to.equal('success');
						var response = data.info[0];

						expect(response['RatingID']).to.be.a('number');
						expect(response['Rating']).to.equal(3);
						expect(response['ProfileID']).to.equal(1);
						expect(response['BathroomID']).to.equal(1);
						expect(response['Comment']).to.equal('UNIT TEST (R)etrieve Via RatingID');
						expect(response['PictureURL']).to.equal('');
						expect(response['Non-Existing']).to.equal(0);
						expect(response['Hard-To-Find']).to.equal(0);
						expect(response['Paid']).to.equal(0);
						expect(response['Public']).to.equal(0);

						done();
					});
				});

				req.on('error', function (e) {
					assert.notOk('everything', e);
				});

				var request = {
					token: "DEMO-AUTO-AUTH",
					info: { "RatingID": insert.insertId }
				};
				req.write(JSON.stringify(request));
				req.end();
			});
		});
	});
	describe('(R)etrieve Failure', function () {
		it('Sending invalid property to server should return error statement.', function (done) {
			options.path = '/rating/retrieve';
			var req = http.request(options, function(res) {
			res.setEncoding('utf8');
				res.on('data', function (body) {
					var data = JSON.parse(body);
					console.log(data);
					var response_type = data.response;
					expect(response_type).to.equal('failure');
					var response = data.info;
					expect(response).to.eql({ "error": "invalid request format" });
					done();
				});
			});

			req.on('error', function (e) {
				assert.notOk('everything', e);
			});

			var request = {
				token: "DEMO-AUTO-AUTH",
				info: { "SomethingRandom": new Date() }
			};

			req.write(JSON.stringify(request));
			req.end();
		});
	});
	describe('(R)etrieve array', function () {
		it('should retrieve rating using BathroomID', function (done) {
			options.path = '/rating/retrieve';
			var req = http.request(options, function(res) {
				res.setEncoding('utf8');
				res.on('data', function (body) {
					var data = JSON.parse(body);
					console.log(data);
					var response_type = data.response;
					expect(response_type).to.equal('success');
					var response = data.info;

					expect(response).to.be.a('array');
					expect(response[0]).to.be.a('object');
					expect(response[0]).to.include.keys('RatingID');
					expect(response[0]).to.include.keys('Rating');
					expect(response[0]).to.include.keys('ProfileID');
					expect(response[0]).to.include.keys('BathroomID');
					expect(response[0]).to.include.keys('Comment');
					expect(response[0]).to.include.keys('PictureURL');
					expect(response[0]).to.include.keys("Non-Existing");
					expect(response[0]).to.include.keys("Hard-To-Find");
					expect(response[0]).to.include.keys("Paid");
					expect(response[0]).to.include.keys("Public");

					expect(response[0]['RatingID']).to.be.a('number');
					expect(response[0]['Rating']).to.be.a('number');
					expect(response[0]['ProfileID']).to.be.a('number');
					expect(response[0]['BathroomID']).to.be.a('number');
					expect(response[0]['Comment']).to.be.a('string');
					expect(response[0]['PictureURL']).to.be.a('string');
					expect(response[0]['Non-Existing']).to.be.a('number');
					expect(response[0]['Hard-To-Find']).to.be.a('number');
					expect(response[0]['Paid']).to.be.a('number');
					expect(response[0]['Public']).to.be.a('number');

					done();
				});
			});

			req.on('error', function (e) {
				assert.notOk('everything', e);
			});

			var request = {
				token: "DEMO-AUTO-AUTH",
				info: {
					"BathroomID": 1,
				}
			};
			req.write(JSON.stringify(request));
			req.end();
		});
	
		it('should retrieve rating using ProfileID', function (done) {
			options.path = '/rating/retrieve';
			var req = http.request(options, function(res) {
				res.setEncoding('utf8');
				res.on('data', function (body) {
					var data = JSON.parse(body);
					console.log(data);
					var response_type = data.response;
					expect(response_type).to.equal('success');
					var response = data.info;

					expect(response).to.be.a('array');
					expect(response[0]).to.be.a('object');
					expect(response[0]).to.include.keys('RatingID');
					expect(response[0]).to.include.keys('Rating');
					expect(response[0]).to.include.keys('ProfileID');
					expect(response[0]).to.include.keys('BathroomID');
					expect(response[0]).to.include.keys('Comment');
					expect(response[0]).to.include.keys('PictureURL');
					expect(response[0]).to.include.keys("Non-Existing");
					expect(response[0]).to.include.keys("Hard-To-Find");
					expect(response[0]).to.include.keys("Paid");
					expect(response[0]).to.include.keys("Public");

					expect(response[0]['RatingID']).to.be.a('number');
					expect(response[0]['Rating']).to.be.a('number');
					expect(response[0]['ProfileID']).to.be.a('number');
					expect(response[0]['BathroomID']).to.be.a('number');
					expect(response[0]['Comment']).to.be.a('string');
					expect(response[0]['PictureURL']).to.be.a('string');
					expect(response[0]['Non-Existing']).to.be.a('number');
					expect(response[0]['Hard-To-Find']).to.be.a('number');
					expect(response[0]['Paid']).to.be.a('number');
					expect(response[0]['Public']).to.be.a('number');

					done();
				});
			});

			req.on('error', function (e) {
				assert.notOk('everything', e);
			});

			var request = {
				token: "DEMO-AUTO-AUTH",
				info: {
					"ProfileID": 1,
				}
			};
			req.write(JSON.stringify(request));
			req.end();
		});
	});
	describe('(U)pdate', function () {
		var InsertID;
		before(function(done) {
			connection.query(`INSERT INTO Ratings ( Rating, ProfileID, BathroomID, Comment, PictureURL )
				VALUES (3, 1, 1, 'UNIT TEST (U)pdate Via RatingID', '')`, function(err, insert) {
				if(err) { console.log(err); throw err; }
				InsertID = insert.insertId;
				connection.query(`INSERT INTO RatingFlags ( RatingID, FlagID ) VALUES 
					(${InsertID}, 2), (${InsertID}, 4)`, function(err, insert) {
					if(err) { console.log(err); throw err; }
					done();
				});
			});
		});
		it('should update rating in database', function (done) {
			var sendUpdateRequest = function(insertId) {
				return new Promise(function(resolve, reject) {
					options.path = '/rating/update';
					var req = http.request(options, function(res) {
						res.setEncoding('utf8');
						res.on('data', function (body) {
							var data = JSON.parse(body);
							console.log(data);
							var response_type = data.response;
							expect(response_type).to.equal('success');
							expect(data).to.eql({
								response: "success",
								info: {}
							});
							resolve(insertId);
						});
					});

					req.on('error', function (e) {
						assert.notOk('everything', e);
					});

					var request = {
						token: "DEMO-AUTO-AUTH",
						info: {
							"RatingID": insertId,
							"Rating": 2,
							"Comment": "UPDATE UNIT TEST (U)pdate Via RatingID",
							"Picture": "",

							"Non-Existing": true,
							"Hard-To-Find": false,
							"Paid": true,
							"Public": false,
						}
					};
					req.write(JSON.stringify(request));
					req.end();
				});
			};
			var verifyUpdateRequest = function(insertId) {
				return new Promise(function(resolve, reject) {
					connection.query(`SELECT RatingID, Timestamp, Rating, ProfileID, BathroomID, Comment, PictureURL FROM Ratings WHERE RatingID=${insertId} LIMIT 1`, function(err, rows) {
							if(err) { reject(insertId); }
							expect(rows[0].Comment).to.equal("UPDATE UNIT TEST (U)pdate Via RatingID");
							expect(rows[0].Rating).to.equal(2);
							resolve(insertId);
					});
				});
			};
			var verifyThatOldFlagsDoNotExist = function(insertId) {
				return new Promise(function(resolve, reject) {
					connection.query(`SELECT EXISTS(SELECT * FROM RatingFlags WHERE (FlagID=2 OR FlagID=4) AND RatingID=${insertId}) as RESULT`, function(err, rows) {
							if(err) { reject(insertId); }
							expect(rows[0].RESULT).to.equal(0);
							resolve(insertId);
					});
				});
			};
			var verifyThatNewFlagsExist = function(insertId) {
				return new Promise(function(resolve, reject) {
					connection.query(`SELECT EXISTS(SELECT * FROM RatingFlags WHERE (FlagID=1 OR FlagID=3) AND RatingID=${insertId}) as RESULT`, function(err, rows) {
							if(err) { reject(insertId); }
							expect(rows[0].RESULT).to.equal(1);
							done();
					});
				});
			};
			sendUpdateRequest(InsertID)
				.then(verifyUpdateRequest)
				.then(verifyThatOldFlagsDoNotExist)
				.then(verifyThatNewFlagsExist);
		});
		after(function(done) {
			if(typeof InsertID === "number") {
				connection.query(`DELETE FROM Ratings WHERE RatingID=${InsertID}`, function() {
					done();
				});
			} else {
				done();
			}
		});
	});

	describe('(D)elete', function () {
		var InsertID;
		before(function(done) {
			var createRatings = new Promise(function(resolve, reject) {
				connection.query(`INSERT INTO Ratings ( Rating, ProfileID, BathroomID, Comment, PictureURL )
					VALUES (3, 1, 1, 'UNIT TEST (D)elete Via RatingID', '')`, 
				function(err, insert) {
					if(err) { console.log(err); throw err; }
					InsertID = insert.insertId;
					done();
				});
			});
		});
		it('should remove Rating from database', function (done) {
			options.path = '/rating/delete';
			var req = http.request(options, function(res) {
				res.setEncoding('utf8');
				res.on('data', function (body) {
					var data = JSON.parse(body);
					console.log(data);
					var response_type = data.response;
					expect(response_type).to.equal('success');
					expect(data).to.eql({
						response: "success",
						info: {}
					});
					connection.query("SELECT * FROM Ratings WHERE ?", [ { "RatingID": InsertID } ], function(err, rows) {
						if(err) { console.log(err); throw err; }
						expect(rows.length).to.equal(0);
						done();
					});
				});
			});

			req.on('error', function (e) {
				assert.notOk('everything', e);
			});

			var request = {
				token: "DEMO-AUTO-AUTH",
				info: { "RatingID": InsertID }
			};
			req.write(JSON.stringify(request));
			req.end();

		});
		after(function(done) {
			if(typeof InsertID === "number") {
				connection.query("DELETE FROM Ratings WHERE ?", [ { "RatingID": InsertID } ], function() {
					done();
				});
			} else {
				done();
			}
		});
	});
});