var level1 = new Promise((resolve, reject) => {
	setTimeout(() => {
		console.log(`LEVEL1 0`);
		resolve(1,2);
	}, 1000);
});

var level2 = (one,two) => {
	return new Promise((resolve, reject) => {
		setTimeout(() => {
			console.log(`LEVEL2 ${one}::${two}`);
			resolve(3,4);
		}, 1000);
	});
};

var level3 = (three,four) => {
	return new Promise((resolve, reject) => {
		setTimeout(() => {
			console.log(`LEVEL3 ${three}::${four}`);
			resolve();
		}, 1000);
	});
};

// setTimeout(() => {
// 	console.log("hello");
// 	setTimeout(() => {
// 		console.log("world");
// 		setTimeout(() => {
// 			console.log("dude");
// 			setTimeout(() => {
// 				console.log("yeah!");
// 			},1000);
// 		},1000);
// 	},1000);
// },1000);

level1.then((three, four) => { return level2(three, four); }).then(level3);