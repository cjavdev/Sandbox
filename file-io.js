fs = require('fs');


var data = "";
for(var i=1; i<= 100; i++) {
	data += i + "\n";
}

fs.writeFile('numbers.txt',data, function(err) {
	if(err) throw err;
	console.log("numbers.txt saved");
});

fs.readFile('numbers.txt','utf-8', function (err, data) {
	var text = data;
	var reversedText = text.split("\n").reverse().join("\n");
	fs.writeFile('reversedNumbers.txt', reversedText, function(err){
		if(err) throw err;
		console.log("reversedNumbers.txt Saved!");
	})
});


