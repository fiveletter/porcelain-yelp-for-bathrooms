"use strict";

var fs = require('fs');
var readChunk = require('read-chunk');
var imageType = require('image-type');
var PhotoGenerator = require('../../photo-generator');

describe('Photo Creation', function () {
	var deleteTestFile = "";
	// Loading Libraries
	it('should take base64 jpg decode and store it in a jpg file and return file name in callback', function (done) {
		var photo = new PhotoGenerator();
		photo.savePhoto(photo.base64testfile, function(file_name) {
			deleteTestFile = file_name;
			// expect file to exist in filestyem
			var buffer = readChunk.sync(file_name, 0, 12);
			expect(imageType(buffer)).to.eql({
				ext: 'jpg', 
				mime: 'image/jpeg'
			});
			fs.stat(file_name, function(err) {
				expect(err).to.be.null;
				expect(file_name).to.be.a("string");
				expect(file_name).to.contain(".jpg");
				done();
			});
		});
	});
	after(function() {
		try { 
			if(deleteTestFile) {
				fs.unlink(deleteTestFile); 
			} 
		} catch(e) {}
	});
});

describe('Photo Creation Failure', function () {
	var deleteTestFile = "";
	it('should take base64 jpg decode and store it in a jpg file and return file name in callback', function (done) {
		var photo = new PhotoGenerator();
		photo.savePhoto("", function(file_name) {
			deleteTestFile = file_name;
			// TODO: expect file to NOT exist in filestyem
			// file_name should be empty
			// expect file to exist in filestyem
			fs.stat(file_name, function(err) {
				expect(err).to.not.be.null;
				expect(file_name).to.be.a("string");
				expect(file_name).to.not.contain(".jpg");
				done();
			});
		});
	});
	after(function() {
		try {
			if(deleteTestFile) {
				fs.unlink(deleteTestFile); 
			}
		} catch(e) {}
	});
});