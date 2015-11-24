var mysql      = require('mysql');
var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : '',
  database : 'Porcelain'
});
connection.connect();

var insert = new Promise((resolve, reject) => {
	connection.query(`INSERT INTO \`Porcelain\`.\`Bathrooms\` (\`Longitude\`,\`Latitude\`,\`Title\`,\`ImagePath\`) VALUES (0.0, 0.0, "UNIT TEST 6","");`, function(err, rows, fields) {
		if (err) { 
			console.log(err);
			throw err; 
		}
		console.log(rows);
		resolve(rows.insertId);
	});
});

var update = (id) => {
	console.log(id);
	connection.query(`UPDATE \`Porcelain\`.\`Bathrooms\` SET \`Longitude\` = 2.0, \`Latitude\` = 2.0, \`Title\` = 'new Title',\`ImagePath\` = 'path' WHERE \`BathroomID\`=${rows.insertId};`, (err, rows, fields) => {
		if (err) { 
			console.log(err);
			throw err; 
		}
		console.log(rows);
	});
}

insert.then(update);

connection.end();

// var calculate = function (value) {
//     return new Promise((resolve, reject) => {
//         setTimeout(() => {
//             resolve(value + 1);
//         	console.log(value);
//         }, 500);
//     });
// }; 

// calculate(1).then(calculate).then(calculate).then(calculate).then(verify);

// var test = new Promise((resolve, reject) => {
//     setTimeout(() => {
//     	console.log("Hello world");
//         resolve();
//     }, 500);
// });
// test.then(function() {
// 	return new Promise((resolve, reject) => {
// 		setTimeout(() => {
// 			console.log("Hello world");
// 			resolve();
// 		}, 500);
// 	});
// }).then(function() {
// 	return new Promise((resolve, reject) => {
// 		setTimeout(() => {
// 			console.log("Hello world");
// 			resolve();
// 		}, 500);
// 	});
// }).then(function() {
// 	return new Promise((resolve, reject) => {
// 		setTimeout(() => {
// 			console.log("Hello world");
// 			resolve();
// 		}, 500);
// 	});
// });

// function verify(result) {
//     console.log(result);
//     done();
// };