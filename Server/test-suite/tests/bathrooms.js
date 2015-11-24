"use strict";

describe('Profiles', function () {
	// Loading Libraries
	var mysql = require('mysql');
	var http = require('http');

	var options = {
		hostname: '127.0.0.1',
		port: 9000,
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

	describe('Testing CRUD', function () {
		it('(C)reate', function (done) {
			options.path = '/profile/retrieve';
			var req = http.request(options, function(res) {
				console.log('Status: ' + res.statusCode);
				console.log('Headers: ' + JSON.stringify(res.headers));
				res.setEncoding('utf8');
				res.on('data', function (body) {
					expect(JSON.parse(body)).to.eql({
						response: "success"
					});
					connection.connect();
					connection.query("SELECT Longitude, Latitude, Title FROM Toilets WHERE abs(Longitude-(-121.881)) <= 1e-3 AND abs(Latitude-37.3369) <= 1e-3 AND Title='SJSU Engineering Bathroom'", function(err, rows, fields) {
					  	if (err) { throw err; }
					  	expect(rows[0]).to.eql({
							"Longitude": -121.881,
							"Latitude": 37.3369,
							"Title": "SJSU Engineering Bathroom"
						};)
						console.log('The solution is: ', rows[0]);
						done();
					});
					connection.end();
				});
			});

			req.on('error', function (e) {
				expect(true).to.be.false;
			});

			var request = {
				"Longitude": -121.881,
				"Latitude": 37.3369,
				"Title": "SJSU Engineering Bathroom",
				"Image": ""
			};
			req.write(JSON.stringify(request));
			req.end();
		});
		it('(R)etrieve', function (done) {
			options.path = '/profile/retrieve';
			var req = http.request(options, function(res) {
				console.log('Status: ' + res.statusCode);
				console.log('Headers: ' + JSON.stringify(res.headers));
				res.setEncoding('utf8');
				res.on('data', function (body) {
					expect(JSON.parse(body)).to.eql({
						ProfileID: 1, 
						Email: 'unit@test.com', 
						FirstName: 'Unit', 
						LastName: 'Test', 
						GoogleHash: 'HashBrowns'
					});
					done();
				});
			});

			req.on('error', function (e) {
				expect(true).to.be.false;
			});

			var request = { Email: "unit@test.com" };
			req.write(JSON.stringify(request));
			req.end();
		});

		it('(U)pdate', function (done) {
			options.path = '/profile/update';
			var req = http.request(options, function(res) {
				console.log('Status: ' + res.statusCode);
				console.log('Headers: ' + JSON.stringify(res.headers));
				res.setEncoding('utf8');
				res.on('data', function (body) {
					expect(JSON.parse(body)).to.eql({
						response: "failure",
						reasons: [
							"Could not find account"
						]
					});
					done();
				});
			});

			req.on('error', function (e) {
				expect(true).to.be.false;
			});

			var request = {
				ProfileID: 1,
				Email: 'unit-update@test.com', 
				FirstName: 'Unit-update', 
				LastName: 'Test-update', 
				GoogleHash: 'HashBrowns-update'
			};
			req.write(JSON.stringify(request));
			req.end();
		});
		it('(D)elete', function (done) {
			options.path = '/profile/delete';
			var request = {
				Email: 'unit-update@test.com'
			};
			req.write(JSON.stringify(request));
			req.end();
		});
	});
	// TODO: create test for handleIdleStatus()
});