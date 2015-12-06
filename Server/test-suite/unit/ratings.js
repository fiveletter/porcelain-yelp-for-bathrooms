"use strict";

describe('Ratings', function () {
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

	describe('Testing CRUD', function () {
		describe('(C)reate', function () {
			var RatingID;
			var deleteTestFile = "";
			it('should create Rating and Rating Flags in database', function (done) {
				options.path = '/rating/create';
				var req = http.request(options, function(res) {
					res.setEncoding('utf8');
					res.on('data', function (body) {
						var data = JSON.parse(body);
						console.log(data);
						var response_type = data.response;
						RatingID = data.info.RatingID;
						deleteTestFile = data.info.PictureURL
						expect(response_type).to.equal('success');
						expect(RatingID).to.be.a("number");
						expect(deleteTestFile).to.be.a("string");

						var checkRating = function() {
							return new Promise((resolve) => {
								connection.query(`SELECT PictureURL FROM Ratings WHERE RatingID=${data.info.RatingID}`, function(err, rows) {
									if (err) { throw err; }
									expect(rows.length).to.be.above(0);
									expect(rows[0].PictureURL).to.equal(deleteTestFile);
									resolve();
								});
							});
						};
						var checkPhoto = function() {
							return new Promise((resolve) => { 
								fs.stat(deleteTestFile, function(err) {
									expect(err).to.be.null;
									resolve();
								});
							});
						};
						var checkFlags = function() {
							connection.query(`SELECT * FROM RatingFlags WHERE RatingID=${data.info.RatingID}`, function(err, rows) {
								// four rating flag relationships were made
								expect(rows.length).to.be.equal(4);
								done();
							});
						};
						checkRating().then(checkPhoto).then(checkFlags);
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
						"Picture": photo.base64testfile,
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
				try { 
					if(deleteTestFile) {
						fs.unlink(deleteTestFile); 
					}
				} catch(e) {}
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
			connection.query("INSERT INTO Ratings ( Rating, ProfileID, BathroomID, Comment, PictureURL ) VALUES (3, 1, 1, 'UNIT TEST (R)etrieve Via RatingID', '')", function after_query (err, insert) {
				if (err) { throw err; }
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
	// describe('(R)etrieve Failure', function () {
	// 	it('Sending invalid property to server should return error statement.', function (done) {
	// 		options.path = '/rating/retrieve';
	// 		var req = http.request(options, function(res) {
	// 		res.setEncoding('utf8');
	// 			res.on('data', function (body) {
	// 				var data = JSON.parse(body);
	// 				console.log(data);
	// 				var response_type = data.response;
	// 				expect(response_type).to.equal('failure');
	// 				var response = data.info;
	// 				expect(response).to.eql({ "error": "invalid request format" });
	// 				done();
	// 			});
	// 		});

	// 		req.on('error', function (e) {
	// 			assert.notOk('everything', e);
	// 		});

	// 		var request = {
	// 			token: "DEMO-AUTO-AUTH",
	// 			info: { "SomethingRandom": new Date() }
	// 		};

	// 		req.write(JSON.stringify(request));
	// 		req.end();
	// 	});
	// });
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
				info: {}
			};
			req.write(JSON.stringify(request));
			req.end();
		});
	});
	describe('(U)pdate', function () {
		var InsertID;
		var deleteTestFile = "";
		before(function(done) {
			fs.writeFile('fs/update-test-photo.jpg', "", function() {
				connection.query(`INSERT INTO Ratings ( Rating, ProfileID, BathroomID, Comment, PictureURL )
					VALUES (3, 1, 1, 'UNIT TEST (U)pdate Via RatingID', 'fs/update-test-photo.jpg')`, function(err, insert) {
					if(err) { console.log(err); throw err; }
					InsertID = insert.insertId;
					connection.query(`INSERT INTO RatingFlags ( RatingID, FlagID ) VALUES (${InsertID}, 2), (${InsertID}, 4)`, function(err) {
						if(err) { console.log(err); throw err; }
						done();
					});
				});
			});
		});
		it('should update rating in database', function (done) {
			var sendUpdateRequest = function() {
				return new Promise(function(resolve) {
					options.path = '/rating/update';
					var req = http.request(options, function(res) {
						res.setEncoding('utf8');
						res.on('data', function (body) {
							var data = JSON.parse(body);
							console.log(data);
							var response_type = data.response;
							expect(response_type).to.equal('success');
							expect(data).to.have.property("response", "success");
							expect(data.info.PictureURL).to.be.a('string');
							expect(data.info.PictureURL).to.contain('.jpg');
							deleteTestFile = data.info.PictureURL;
							resolve();
						});
					});

					req.on('error', function (e) {
						assert.notOk('everything', e);
					});

					var request = {
						token: "DEMO-AUTO-AUTH",
						info: {
							"RatingID": InsertID,
							"Rating": 2,
							"Comment": "UPDATE UNIT TEST (U)pdate Via RatingID",
							"Picture": photo.base64testfile,
							"Non-Existing": true,
							"Hard-To-Find": false,
							"Paid": true,
							"Public": false
						}
					};
					req.write(JSON.stringify(request));
					req.end();
				});
			};
			var checkPreviousPhotoDeleted = function () {
				return new Promise(function(resolve) { 
					fs.stat("fs/update-test-photo.jpg", function(err) {
						console.log(err);
						expect(err).to.not.be.null;
						resolve();
					});
				});
			};
			var checkNewPhotoCreated = function() {
				return new Promise(function(resolve) { 
					fs.stat(deleteTestFile, function(err) {
						console.log(err);
						expect(err).to.be.null;
						resolve();
					});
				});
			};
			var verifyUpdateRequest = function() {
				return new Promise(function(resolve, reject) {
					connection.query(`SELECT RatingID, Timestamp, Rating, ProfileID, BathroomID, Comment, PictureURL FROM Ratings WHERE RatingID=${InsertID} LIMIT 1`, function(err, rows) {
						if(err) { reject(InsertID); }
						expect(rows[0].Comment).to.equal("UPDATE UNIT TEST (U)pdate Via RatingID");
						expect(rows[0].Rating).to.equal(2);
						resolve();
					});
				});
			};
			var verifyThatOldFlagsDoNotExist = function() {
				return new Promise(function(resolve, reject) {
					connection.query(`SELECT EXISTS(SELECT * FROM RatingFlags WHERE (FlagID=2 OR FlagID=4) AND RatingID=${InsertID}) as RESULT`,function(err, rows) {
						if(err) { reject(InsertID); }
						expect(rows[0].RESULT).to.equal(0);
						resolve(InsertID);
					});
				});
			};
			var verifyThatNewFlagsExist = function() {
				connection.query(`SELECT EXISTS(SELECT * FROM RatingFlags WHERE (FlagID=1 OR FlagID=3) AND RatingID=${InsertID}) as RESULT`, function(err, rows) {
					expect(err).to.be.null;
					expect(rows[0].RESULT).to.equal(1);
					done();
				});
			};

			sendUpdateRequest().then(checkPreviousPhotoDeleted).then(checkNewPhotoCreated).then(verifyUpdateRequest).then(verifyThatOldFlagsDoNotExist).then(verifyThatNewFlagsExist);
		});
		after(function(done) {
			fs.stat("fs/update-test-photo.jpg", function(err) {
				if(err) {
					return;
				} else {
					fs.unlink("fs/update-test-photo.jpg");
				}
			});
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
			connection.query(`INSERT INTO Ratings ( Rating, ProfileID, BathroomID, Comment, PictureURL )
				VALUES (3, 1, 1, 'UNIT TEST (D)elete Via RatingID', '')`, 
			function(err, insert) {
				if(err) { console.log(err); throw err; }
				InsertID = insert.insertId;
				done();
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