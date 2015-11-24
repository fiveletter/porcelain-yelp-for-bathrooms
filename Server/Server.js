var express = require('express');
var fs = require('fs');
var app = express();
const PORT = 9000;

/* =============== User =============== */
app.post('/profile/create', function(req, res){
    console.log('POST /profile/create');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});
app.post('/profile/retrieve', function(req, res){
    console.log('POST /profile/retrieve');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});
app.post('/profile/update', function(req, res){
    console.log('POST /profile/update');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});
app.post('/profile/delete', function(req, res){
    console.log('POST /profile/delete');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});

/* =============== toilet =============== */
app.post('/bathroom/create', function(req, res){
    console.log('POST /bathroom/create');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});
app.post('/bathroom/retrieve', function(req, res){
    console.log('POST /bathroom/retrieve');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});
app.post('/bathroom/update', function(req, res){
    console.log('POST /bathroom/update');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});
app.post('/bathroom/delete', function(req, res){
    console.log('POST /bathroom/delete');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});

/* =============== rating =============== */
app.post('/rating/create', function(req, res){
    console.log('POST /rating/create');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});
app.post('/rating/retrieve', function(req, res){
    console.log('POST /rating/retrieve');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});
app.post('/rating/update', function(req, res){
    console.log('POST /rating/update');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});
app.post('/rating/delete', function(req, res){
    console.log('POST /rating/delete');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});

/* =============== rating =============== */
app.post('/rating/create', function(req, res){
    console.log('POST /rating/create');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});
app.post('/rating/retrieve', function(req, res){
    console.log('POST /rating/retrieve');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});
app.post('/rating/update', function(req, res){
    console.log('POST /rating/update');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});
app.post('/rating/delete', function(req, res){
    console.log('POST /rating/delete');
    console.dir(req.body);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('thanks');
});

app.listen(PORT);
console.log('Listening at http://localhost:' + PORT)