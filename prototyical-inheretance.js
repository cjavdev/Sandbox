function Dog(name) {
	this.name = name;
}
var d = new Dog("breakfast");


console.log(Dog.prototype)
console.log(Object.getPrototypeOf(d));
console.log(d.__proto__);
function bark() {
	console.log("hello");
	console.log(bark.caller.toString());
}

console.log(Dog.prototype)
console.log(Object.getPrototypeOf(d));
console.log(d.__proto__);
bark();

Dog.prototype.bark = function() {
	console.log("hi");
}

d.bark();