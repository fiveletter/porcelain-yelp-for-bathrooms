"use strict";
/*
describe('Profiles', function () {
	// Loading Libraries
	http = require('http');

	var options = {
		hostname: '127.0.0.1',
		port: 9000,
		path: '',
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
		}
    };

	describe('Testing CRUD', function () {
		it('(C)reate', function (done) {
			options.path = '/profile/create';
			var req = http.request(options, function(res) {
				console.log('Status: ' + res.statusCode);
				console.log('Headers: ' + JSON.stringify(res.headers));
				res.setEncoding('utf8');
				res.on('data', function (body) {
					expect(true).to.be.false;
					done();
				});
			});

			req.on('error', function (e) {
				expect(true).to.be.false;
			});

			var request = {};
			req.write(JSON.stringify(request));
			req.end();
		});
		it('(R)etrieve Success', function (done) {
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

		it('(R)etrieve Failure', function (done) {
			options.path = '/profile/retrieve';
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

			var request = { Email: "unit@failtest.com" };
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
});*/