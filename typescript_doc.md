# Typescript Learning

## node.js and npm

npm is part of the node.js package and with npm we can install typescript with

```
npm install typescript --save-dev
```

This will create or update the package.json and store typescript as dev dependency.

## Developement Setup

- VSC: Install extensions, see below.
- Create a .prettierrc file in yaml or json for configuration. See https://prettier.io/docs/en/configuration.html You can also set the VSC setting editor.formatOnSave to true to format on save.

- If you want to create a node.js project, then call `npm init` -> this will create the package.json file
- Run `tsc --init` to create tsconfig.json
- Run `tsc --watch` to watch your ts files and automatically compile
- Start live server with CMD + L + O from inside the html file
- After editing files press Shift + alt + f to apply formatting as configured in .prettierrc

When you want to use VSCs built-in debugger, VSC will create
.vscode/launch.json where you can configure the debugger. See https://code.visualstudio.com/docs/editor/debugging#_launch-configurations

tasks.json comes from?

## VSC

Recommended extensions:

- Path intellisense
- ESLint
- Material Icon Theme
- prettier - Code formatter: install prettier with `npm install prettier -D --save-exact` to have this stored to your package.json
- Live Server

### Editing in VSC

Add "html" in editor of new file => then you can choose html:5 and vsc will add the html base code.

- Code actions: cmd .
- Ctrl + space: get suggestions
- Shift cmd M: open problems console

- Shift + CMD + E => go to (files) Explorer
- Shift + CMD + F => go to Search (Find)

- Go back: Ctrl -
- Go to line: Ctrl g
- Go to last edited file: CTRL ALT CMD arrow-left/right
- Action: jump to bracket (mit neuem Shortcut versehen?): CTRL ALT Cmd 7

- Open file: Cmd P

- Toggle full screan: Ctrl Cmd F

- Show command palette: Shift Cmd P
- !!! Go to symbol in Workspace: Cmd T (e.g. search for a class name in all files -> case sensitive)
- !!!! Go to symbol in Editor: Shift Cmd O -> you can then type : (colon) and the symbols will be grouped by category.

- !!! Rename: F2

Keyboard shortcuts for macos: https://code.visualstudio.com/shortcuts/keyboard-shortcuts-macos.pdf

### Debugging

Before:

- enable sourceMaps

In VSC go to Run -> Start Debugging

When run for the first time, choose web or script or so
then a .vscode/launch.json file is created. There you need to adapt the url where the server is
running, e.g. http://localhost:3000

Don't forget to run tsc again (for the sourceMaps)

## General javascript et al

Use defer in script tags:
This Boolean attribute is set to indicate to a browser that the script is meant to be executed after the document has been parsed, but before firing DOMContentLoaded . Scripts with the defer attribute will prevent the DOMContentLoaded event from firing until the script has loaded and finished evaluating.

Open developer tools in Chrome with Alt + Cmd + j

In javascript:
if (bla){}
is executed if bla is a "truthy value" which can be more than just a boolean value, e.g. also 0 is false, 1 is true.

=== includes a type check in javascript
(whereas == will try to typecast the values, e.g. 3 == "3" is true, but 3 === "3" is false)

## npm install or npm ci?

```
npm ci
```

installs dependencies exactly as they are configured in package-lock.json.
It is much faster as well.

=> always use npm ci unless you want to install something new.

## Object destructuring

see https://www.honeybadger.io/blog/javascript-destructuring/

let car = { brand: "Honda", color: "red"};
let { brand } = car;
console.log(brand); // returns "Honda"

---

Also in object destructuring patterns:
In Typescript you can use

```
function paintShape({ shape, xPos = 0, yPos = 0 }: PaintOptions) {
```

but you cannot place type annotations within the destructuring patterns.

Because in Javascript:

```
function draw({ shape: Shape, xPos: number = 100 /*...*/ }) { ... }
```

This means: grab the property shape and redefine it locally as a variable name Shape.
Likewise xPos: number creates a var named number whose value is based on the parameter's xPos.

### Versions

In ES5 there are no let and const keywords. Instead you have to use var.

ES6 is the equivalent to es2015.
From ES6 on let and const is supported in browsers.

ES6 is next-gen javascript.

ES6 has arrow-functions and const and let.
const add = (a: number) => {
// bla bla
};
OR if you only have one expression:

const add = (a: number, b: number ) => a + b ;

With only one function parameter you can omit the round brackets (but only without the types). So
in cases where the type is inferred you can e.g. write:

button.addEventListener('click', event => console.log(event))

### throw

In Javascript you can throw any object, e.g.
throw { name: "bla", foo: "gaga" }

### Bind

```
class Bla {
  message = 'Bla';

  showMessage() {
    console.log(this.message);
  }
}

const b = new Bla();
// Here "this" refers to b
b.showMessage();
const button = document.querySelector('button')!;

// But in this context "this" refers to the button element: <button>click me</button>
// and showMessage() is undefined:
button.addEventListener('click', b.showMessage);

// Therefore bind the object b to "this" by calling bind(b):
button.addEventListener('click', b.showMessage.bind(b));
```

### Prototypes

### Scopes and var

Using var in Javascript means: var only knows the global scope and the function scope. This means
that if you define var a = "bla"; within an if statement, a is still available in the global scope.

This is different with const and let. let is only available within its block - even if it is an if statement or just {}.

### spread operator

const a = [2,3,4];
const b = [1,9];

b.push(...a);
OR
const b = [1,9,...a];

This is also available for objects.
e.g.
person = {
name: "jonny",
age: 30
}
const person2 = person;

This would copy the pointer to the memory where the person is stored.

If you want to make a real copy:
const person2 = { ...person };

### rest parameters

E.g. if you want to be flexible in giving a changing number of parameters:
const add = (...numbers: number[]) => {
...
}

### destructuring syntax

// not available in es5, but in es6 and also typescript.
person = {
firstName: "Max",
age: 24
};

const { firstName: userName, age } = person;

would store person.firstName into the const userName.

## Classes

// only in modern javascript / typescript
Convention: start class names with an uppercase letter

The keyword "this" refers to the calling object.

For more type safety if you are writing a method in a class, then give it "this: MyClass" as parameter.
Because if you now try to call a method on something that is not an instance of that class, you will get
a typescript error.

BUT
it only needs to comply with an object of that class. It doesn't have to use the constructor to create
that class.

See https://www.udemy.com/course/understanding-typescript/learn/lecture/16888250#content

class Department {
private bla: string;

    // Setting the properties can be done in the constructor like this:
    constructor(
        private readonly id: string,
        private name: string
    ){}
    // It will automatically do: this.id = id, etc. You also don't have to add it in the class (like bla above)

}

readonly is only available in typescript.

#### Getters and Setters

Example:

class XY {
constructor(
private someProperty: string
){}

get someProperty() {
console.log("Bla");
return this.someProperty;
}

set someProperty(value: string){
this.someProperty = value;
}

xy = new XY("i am a property");
// access it with:
xy.someProperty
// set it with
xy.someProperty = "blafoo";

class XY{
static myMethod(){ ... }
}

// call it with:
XY.myMethod();

##

e.g. if add() is a function and
const a = { adder: add };

then you can call the add function with:
const result = a.adder(2,88);

### Abstract methods

Force inheriting subclasses to implement a certain method with:
First add "abstract" to class:

abstract class Blafoo {...}

inside class:
abstract mymethod(this: Blafoo): void;

But now the class Blafoo cannot be instantiated itself anymore!
It has to be inherited. You cannot add an abstract method to a non abstract class.

### Singletons

See https://www.udemy.com/course/understanding-typescript/learn/lecture/16888290#content Section 5: Singletons & Private Constructors

### Property Descriptors

If you have an object in Javascript, all assigned properties are readable, writable, will show up in for loops and .keys.

If you set properties of an object with

```
Object.defineProperty(obj, mykey, myvalue);
```

it is by default not writable, not enumerable and not configurable. It does not use the setter. You could also overwrite getters and setters here.

See https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty

## Typescript

### General features

The typescript compiler also allows to use next-gen javascript features and compiles it
to older javascript code (this is what Babel usually does: translate the new features to old javascript code for vanilla javascript).

Typescript adds non-javascript features like interfaces and generics plus meta-programming features like decorators.

The core primitive types in TypeScript are all lowercase!

If you want to publish your library then you should have a manifest file. It ends with filename.d.ts

### Configuration

Use
tsc --init
to create the tsconfig.json file.

tsc -w
is the same as
tsc --watch

Add to tsconfig.json (top hierarchy):
"exclude": [
"node_modules" // But HAHAHAHA node_modules is already excluded by default.
]
But if you add other files/folders here, "node_modules" must be given, too.

You can also use "include" and it will always compile include minus exclude.

#### Target and libraries

If you choose es6 then things like document and its functions etc. are available because
when compiling to es6 typescript without setting the config "lib", it includes those libraries by default.
So you can write:
const button = document.querySelector("button");

and typescript knows about document, etc..
By default all DOM elements are available (as in javascript).

If you have
{
CompilerOptions: {
lib: []
}
}
then typescript would not compile the above line of code, it doesn't even know about console.log.

One example for a lib would be "dom"

Example for what you might need in a browser environment:

lib: [
"dom",
"es6",
"dom.iterable",
"scripthost"
] // this is actually the default setting for es6

When you set
"allowJs": true
then make sure that the generated js files do not be compiled again by using include and exclude.

#### sourceMap

Compiling with sourceMap: true results in map files with the ending ...js.map
Those are used to also show you the .ts files in the developer console to make debugging easier.

#### rootDir and outDir

"rootDir": "./src"
"outDir": "./dist"

#### noEmitOnError

default: false
If set to true then in case of a typescript error the js files will NOT be written.

### Exclamation mark

Example:
const input2 = document.getElementById("num2")!;
will tell typescript, that input2 will never be null

### Cast

const input2 = document.getElementById("num2")! as HTMLInputElement;
means:
cast input2 to an HTMLInputElement

### Constants

const myarray = [1,2,3];
you can still do
myarray.push(7);
because arrays and objects in javascript are references and a push will change the memory but not the address.

### Tuples

Javascript does not have tuples, only Typescript has.
Tuples are fixed length arrays.
and can be specified by
role: [number, string]
would mean: exactly 2 entries: one number, one string

an array with numbers or strings would be specified as
role: (number | string)[]

Careful:
role.push("a third string")
would not cause an error!!
push is exception - does not work

### Enum

does not exist in Javascript, only in typescript

enum is kind of a custom type - therefore use a capital letter for Role.

enum Role { ADMIN, READONLY, USER }

Then use it as
role.USER

where in javascript will substitute ADMIN with 0, READONLY with 1, etc.

or assign your own values with
enum Role { ADMIN = 'ADMIN', READONLY = 5 };

## Type aliases

type Combinable = number | string;
or
type User = { name: string, age: number }
const olli: User = { name: 'Olli', age: 12 }

## void

A function return type can be void which means that it does not have a return statement.
A function could in theory also have "undefined" as the return type but then you would
have to say:
return;
like: return undefined.
Because in Javascript undefined is a real value, e.g. when accessing a property of an object that is not defined.

## Function types

let add_second: Function;
add_second = add;
console.log(add_second(3,5));

More specifically:
let add_second: (a: number, b: number) => number;
i.e. accept any function with 2 numbers as parameters and returns a number.

You can add default values for parameters, e.g.:
const add = (a: number, b: number = 2) => a + b;
add(5);

You have to put the optional parameters in the end because the parameters are set in the correct order,
meaning, if you have
const add = (a: number = 5, b: number) => a + b;

add(3)
would fail because a would be set to 3, but b still not set.

## Type unknown

Example:
let userInput: unknown;
let userName: string;

userInput = 5; // ok
userInput = "Max"; // ok

userName = userInput; // NOT OK

So in this example you would have to add something like

if (typeof userInput === 'string'){
userName = userInput;
}

Because in this case typescript knows that userInput must be string.

Difference to type any:
any disables all type checking, therefore the above with using any instead of unknown would not throw any error.

## Type never

functions can return with type "never" - meant for error functions throwing errors.
function generateError(message: string, code: number): never {
throw {message: message, code: code}
}

generateError("I crashed", 500);

## Debugging

- Shift + CMD + D => go to Debugger

## Live server

- open html file with live server (vsc extension "Live Server"):
  cmd L cmd O
- cml L cmd C to stop the server
- or right click in file in vsc -> open with live server

# Typescript

## General

- Either call tsc myfile.ts and then node myfile.js or do both at once with:
  ts-node app.ts

use

```
tsc --watch
```

to keep typescript compilation running whenever code is changed.

TypeScript normally erases all type information so it doesn’t exist at runtime.
But: "emitDecoratorMetadata" is a feature that keeps the types around for classes and methods that have a decorator applied to them.

Having the type at runtime allows us to do all sorts of fancy things, such as dependency injection and mapping the TypeScript types to types in an SQL database.

### Babel vs. tsc

https://blog.logrocket.com/babel-vs-typescript

Babel by default will just ignore the types.

Instead of using tsc you could also compile your typescript code with babel. Babel is more extensible
than TypeScript with a lot of plugins available.

Most TypeScript tools allow to both use TypeScript and then run the code through Babel afterwards, to get the best of both worlds.

When compiling with tsc becomes to slow you can try https://github.com/TypeStrong/ts-loader

- transpile without type checking and type check in background

## When should you use type annotations?

- You should always use the type inference as much as possible.
- When you declare a variable and assign it a value later.
- When you want a variable that can’t be inferred.
- When a function returns the any type and you need to clarify the value.
- Avoid using the Number type as much as possible.
- Add type annotations for function parameters and return types as much as possible.

## Example

[Example](https://www.typescriptlang.org/play?&q=51#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)

## Strings

Use backticks `for multiline strings with interpolation, e.g.`title = ${title}`

## Interfaces

Interfaces can work as a contract that a class can implement.

Interface is a structure that defines the contract in your application. It defines the syntax for classes to follow. Classes that are derived from an interface must follow the structure provided by their interface. The TypeScript compiler does not convert interface to JavaScript.

You can even use it without a class but as a type definition. Other than custom type definitions, interfaces only define the structure of objects, whereas type definitions can also define e.g. union types.

```
interface TelephoneOrder extends Order {
  callerNumber: string;
}

type PossibleOrder = TelephoneOrder | undefined;

if ("callerNumber" in possibleOrder) {
  ...
}

The difference between interfaces and abstract classes is that interfaces cannot have methods implemented, only declared, whereas abstract classes can have a combination of abstract declarations of methods plus real implementations. But: a class can implement several interfaces but can inherit only from one superclass.

If you create a variable with a type, you can also use the interface as the type.

In interfaces you can use readonly for properties, but not if its private or public...
Then a class that implements that property will automatically be readonly if declared as readonly within the interface. You don't have to declare that inside the class anymore.

Interfaces can also be extended, e.g.
interface Greetable extends Named {...}
when Named is another interface.

Interfaces are not translated to javascript.

Interfaces can also declare a function type like this:
interface AddFunction {
  (a: number, b: number): number;
}

This can be done with custom types like this (more common than using interfaces in this case):
type AddFunction = (a: number, b: number) => number;

interfaces can have optional properties and methods:
interfaces ExampleInterface {
  optionalProp?: string;
  greet?(): void;
}

The question mark can also be used like this inside classes (even in the constructor definition)
constructor(name?: string){...}

### How check a type code-wise?
- if ("my_attr" in myobj){...}
- if (typeof xy === "undefined") // only primitives (typeof is javascript)
- if (xy instanceof MyClass) // if you have a class (instanceof is javascript)

```

// How code flows inside our JavaScript files can affect
// the types throughout our programs.
See [here](https://www.typescriptlang.org/play?ssl=1&ssc=1&pln=4&pc=1&q=51#code/PTAEAkHsHdQY0gEwKagGYBsYGdQEsA7bPFUSAVwCdQApAQwDc6BlOSvABwBd08NlccOgVB00aZHC4AoEKC4ALVFwCeHAfIWUKAcwUUeFah207KdALbYAdNOkIiPctmSVcAXlABtAN6gClsgAXKAARACCChbIiKGgAL4ANKB+AdEhoQDiyBYWdHFJKf6BGTSQBAUAugDcdnIA6sgA5JSoOpCEOvKQoFiQANbdoC6oeGig0KhCImiEiKKgzq7F0fOhAFblobYO2DybIp5LbtazBIgAFBfkAJSg7gB8i9ZpqO7vYQehN7WyYACSIkUqDoACNIAwpnQXMkmmdEE14BQMPM0HQ+NZQIDNHQeEIXBNkH9QIhyk0eApGCCRJBQetJFxMQAVBR4QStXEaYHyNTBP7E0BFV4hPbsAhdeKgAA+i3OyDOMX5cn+4xUFFA+kh1DVVFAFgoBIhy25ilaqDQkAwWGgnUWLlwkHGTQOiNByGtiWJOqaVuGyFQ+lgJt5gkp4tQKHU51t5QmSlamlQ0EglHmbN6kCEXBiQTsY1AFwOdx80kFB1qkvdBJLZfKFbqYBZyl5oCaqRKwy4Yol0tlKAVCLtGjooCZvNY7G4xIkuKoUKtMVleFjqnUNlA4SXK5b6ZH0DoKm6xJQcAwdATilxohpdIZSPIKNAbrIBFQjr1wkPik6NiVjaUoAcJwIJSLg0KJn6HDnriKZPsgXCTMgIiIGMEitAQPCrgIthyPQTATpwXBNLgiAqGkeBwMUXBznqyDCLgl48FgXAOuMaDkAQUjLkQxKtHAyB4JC17zK01GUDe9KgWQ4wca0Z7ZvMWFgechL+P6iDElwPTPmC-BDMgAAeJgCLg0CsnACgvhokx6ngeg8M+KB0Bgto2ootjEo08DCEOmjpoQCwSLA+4qOuAAy8HEZ254OYefT9LauLEj557mIeZmuMoAFMBg5AaJSQkoeImUYTya4ebsPAkEhXBjHgrgeN4oTgO6WChMkoT1CmKLtaAABMAAsyQAIwAJw1A2oBedMvncnhLBsIRrZYe+Bn3B8KiItgZFcHQa1acSFmSIMFrUMG6jSRBsxuDw7o5DVmIAJrqjNmrLOUxItMIpIWP8KAYXVriuu6MBDCMGqg3geJhjoGhugh-oEMeqElUxma4tx2B2JVoDmOckC-f9tWzMsnjVQDJNuF4AAME35hcK3jHjP1-TVgPUO8nihAQ5AWG6lDfCkpa499BOsxT9WUBWoBVqgNYi-jhNs5T9bEiy6YOF2lroNa17OaF6bRPROI8DZM3QOw2agEwBB8GexLzQR3DCaO46Lc7Nq+l2X49BxKA3d9ENBkoh1IM2a4THb8Aw6MyEo+haNZpjHlyEyPT8OeIj6gmYIGEipCYKDwj68Q2C5nIAC0MsGZYHD8EEWEVzo5DnogWNqz0muEHluN0Sh4qaNo5B6NXtf8LgOr3o+6y8xwQx0NOyCwEVaE1YBZ78bgBAwOXwDElXACyYfibQjALZOXAhIZY-BHguTkLtoJ8FDKj767F2ZC3qZl6PFh18Ejdm6tyxpXUAAAxDiXFyjOVAAABVMOYXIrkoaWUdu7W6Nc-713YpxWq5QK4WXRLbcUQA).

## Types

```
let skills = ['Problem Sovling','Software Design','Programming'];
```

is equivalent to:

```
let skills: string[];
skills = ['Problem Sovling','Software Design','Programming'];
```

because typescript infers the type.

The type names String, Number, and Boolean (starting with capital letters) are legal, but refer to some special built-in types that will very rarely appear in your code. Always use string, number, or boolean for types.

intersection types, e.g.:
type xy = typeZ & typeZZ
In case of object types this means a combination of the properties,
in case of other types it is really an intersection

### Type guards

example:
if (typeof a === 'string'){...}
is called a type guard.

But for objects you cannot use
if (typeof a === 'MyObject')
because javascript's typeof will just return 'object'

instead you can use
if ('myProperty' in myObject){...}

OR
if (a instanceof MyClass){...}
instanceof is a normal operator built into javascript and executes at runtime. But this only works with classes, not with interfaces since interfaces are not translated to any javascript code. Therefore javascript cannot use it. But for objects it works and also a has to be an object and not a "simple" type like string/number.

### Discriminated unions

Useful when working with union types.
You can give interfaces a literal type, e.g.

```
interface Bird {
  type: 'bird',
  name: string
}

type Animal = Bird | Horse;

const animal: Animal = {name: "Speedy"}

switch (animal.type){
  case 'bird':
    bla = 'foo'
}
```

It is called discriminated union because there is one property available in all the interfaces called type. discriminate = unterschiedlich behandeln

### Type casting

either with
<HTMLInputElement>document.getElementById('bla')
or
document.getElementById('bla') as HTMLInputElement

If you to type casting here you should be sure that this element is actually of this type because otherwise you will get a runtime error.

You need this because otherwise typescript would moan when you try to call a method that is only available e.g. in HTMLInputElement, but not for HTMLElement (which would be returned from document.getElementById())

When you add an exclamation mark to tell typescript that I am sure that this is not null:
document.getElementById('bla')! as HTMLInputElement

If you are not sure you can also not type cast because the type casting tells typescript that it is not null. You would have to check if it null:

```
if (el){
  (el as HTMLInputELement).value = "blafoo";
}
```

### Index types

Example:

```
interface ErrorContainer {
  [props: string]: string;
}

const error: ErrorContainer = {
  name: 'This is an error',
  status: '200',
};
```

means: an ErrorContainer can have many properties whose name is a string and are not further specified and its value is a string. This is called an intex type. The ErrorContainer now cannot have other types like numbers, or booleans in addition, but strings with a defined name too, e.g. id: string could be added.

name here is then interpreted as a string.

## Generics

### Generic types

Also see https://www.typescriptlang.org/docs/handbook/generics.html

Array is a generic type - it needs another type.
Array<string> or string[]
Both is equivalent.

```
const promise: Promise<string> = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve('This is done!');
  }, 2000);
})
```

```
doSomething()
  .then(function (result) {
    // If using a full function expression: return the promise
    return doSomethingElse(result);

   // If using arrow functions: omit the braces and implicitly return the result
  .then((newResult) => doThirdThing(newResult))
  })

  // Always end the promise chain with a catch handler to avoid any
  // unhandled rejections!
  .catch((error) => console.error(error));
```

Note that () => x is short for () => { return x; }.

If there's an exception, the browser will look down the chain for .catch() handlers or onRejected.
Exactly like when putting the whole block in a try {} catch {}.

The promises syntax can also be expressed in async/await syntax:

```
async function foo() {
  try {
    const result = await doSomething();
    const newResult = await doSomethingElse(result);
    const finalResult = await doThirdThing(newResult);
    console.log(`Got the final result: ${finalResult}`);
  } catch (error) {
    failureCallback(error);
  }
}
```

#### Building your own generic types

```
function merge<T, U> (obja: T, objb: U) {
  Object.assign(obja, objb);
}

const merged = merge({name: "max"}, {age: 12});
```

Types T and U are not specified (can have any name, but T and U are common names for this), but typescript understands that merged will be of type {name: string, age: number}

Typescript infers the types T and U when we call the function.
You can also specify the types to be used when you call the function:

```
merge<{name: string},{age: number}>(obja, objb);
```

But here Typescript can infer the types so this is redundant in this case.

To constraint T and U to always be an object, you can

```
function merge<T extends object, U extends object> (a, b){...}
```

These are called type constraints.

You can also use interfaces:

```
interface Lengthy {
  length: number;
}

function bla<T extends Lengthy>(element: T){
  const x = element.length;
  ...
}
```

Now element can be of any type that has a .length
T is the generic type.

```
function extractAndConvert<T extends object, U extends keyof T>(obj: T, key: U){
  return "value = " + obj[key]
}
```

U extends keyof T makes sure that key of type U is a key of the object of type T.

### Generic classes

```
class MyStorage<T> {
  private data: T[] = [];

  addItem(item: T){
    this.data.push(item);
  }
  ...
}

const stor = new MyStorage<string>();
```

## Partial Types

let bla: Partial<MyType> = {};
Use this if you first want to start with {} and only one after the other want to fill in the necessary parts of your type.

Partial sets all your type entries (if having an object) to be optional temporarily.
When you return the finally correct MyType variable, you can typecast it to MyType: return bla as MyType;

## Readonly Types

const names: Readonly<string[]> = ['Max', 'Anna'];
Readonly is a "utility type" and is not translated to javascript.

Here is a list of all utility types:
https://www.typescriptlang.org/docs/handbook/utility-types.html

## Decorators

First enable experimentalDecorators in tsconfig.json plus target to be es6.

```
function Logger(constructor: Function){
  console.log("Bla");
}

@Logger
class Persion {
name = 'bla';
  constructor
}
```

Use function names with capital letter by convention.
Decorators retrieve one argument when used for classes.
Decorators get executed when the class is defined, not when it is instantiated.

Example use case for decorators would be templating to render some content.

### Decorator factories

```
function Logger(logString: string){
  return function(constructor: Function){
  // DO sth.
  }
}

@Logger('Bla foo')
  class Person {
...
}
```

Decorator Factory means: create a function that can decorate a class.
Difference: when decorating class you call the factory (e.g. with a parameter) => @Logger()
instead of @Logger.

If you don't need the constructur in your decorator you can use an underscore:

function(\_: Function){}
instead of
function(constructor: Function){}

When using several decorators then the definition of the decorator function when using a factory is done in top to bottom down order as usual.
But the execution of the decorator function happens from the inside out - so actually from bottom to top.

You can also decorate class properties, methods, parameters of methods and accessors (getters and setters). But the parameters that get passed to the decorator function differ depending on what type of thing the decorator is used for.

To use decorators to do stuff when an object is instantiated see lecture 112 (Returning and changing a Class in a Class Decorator) at https://www.udemy.com/course/understanding-typescript/learn/lecture/16935728#overview

There are ready-made decorators, e.g. for class validation:
https://github.com/typestack/class-validator

Another example: nest.js
It is a framework for server side node apps
Uses a lot of decorators, e.g. @Get() to implement routes, @Controller, etc.
or to extract data from incoming requests

Further reading about decorators:
https://www.typescriptlang.org/docs/handbook/decorators.html

## Promises

```
const promise: Promise<string> = new Promise((resolve, reject) => {
  // do slow tasks
  resolve('myString');
});

promise.then(mystring => {
  mystring.split(',');
});
```

This means that the promise will eventually yield a string and will call the resolve function on it.

## Tuples

The number of elements in the tuple is fixed, e.g.

```
let skill: [string, number];
skill = ['Programming', 5];
```

Using

```
let skill: [string, number?]
```

means that number is optional.

## Enums

A TypeScript enum is a group of constant values.

See https://www.typescripttutorial.net/typescript-tutorial/typescript-enum/

## Type any

If you declare a variable without specifying a type, TypeScript assumes that you use the any type (via type inference), e.g.

```
let a;
```

It instructs the compiler to skip type checking.

## void

It is a good practice to add the void type as the return type of a function or a method that doesn’t return any value.

## never

The never type represents the return type of a function that always throws an error or a function that contains an indefinite loop.
https://www.typescripttutorial.net/typescript-tutorial/typescript-never-type/

## union types

let result: number | string;
function add(a: number | string, b: number | string) {...

## type aliases

e.g.

```
type alphanumeric = string | number;
let input: alphanumeric;
```

## type string literal

e.g.

```
let mouseEvent: 'click' | 'dblclick' | 'mouseup' | 'mousedown';
mouseEvent = 'click'; // valid
```

## type functions

example with optional argument c:

```
function multiply(a: number, b: number, c?: number): number {
  if (typeof c !== 'undefined') {
        return a * b * c;
    }
    return a * b;
}
```

### Function overloadings

```
function add(a: number, b: number): number;
function add(a: string, b: string): string;
function add(a: any, b: any): any {
   return a + b;
}
```

-> typescript knows that function returns string, if two strings given
which means that we can also use string's available methods on the result.

### Optional chaining operator

like in Ruby:
user?.job?.title

### null or undefined

const a = null; // could come from user input

The following will set b to 'DEFAULT' also when a is ''
const b = a || 'DEFAULT';

The following will set b to '' when a is '' - so default only if a is either undefined or null:
const b = a ?? 'DEFAULT';

### Constants

const a = {
xy: 123
}
a.xy = 456 // is still allowed!

For objects use instead:
const a = Object.freeze({
xy: 123
})
This is javascript!
It prevents extensions and makes existing properties non-writable and non-configurable.

In typescript you can use

```
const a = {
  xy: 123
} as const
```

### Remark

Note that if you use the expression if(c) to check if an argument is not initialized, you would find that the empty string or zero would be treated as undefined.

Default values example:

```
function applyDiscount(price: number, discount: number = 0.05): number {
    return price * (1 - discount);
}
```

You cannot include default parameters in function type definitions. The following code will result in an error:

```
let promotion: (price: number, discount: number = 0.05) => number;
```

Rest parameters (arbitrarily many parameters allowed, all captured by "numbers" array):

```
function getTotal(...numbers: number[]): number {
    let total = 0;
    numbers.forEach((num) => total += num);
    return total;
}
```

# Classes

## readonly

Mark the properties of a class immutable:

```
class Person {
    readonly birthDate: Date;

    constructor(birthDate: Date) {
```

or

```
class Person {
    constructor(readonly birthDate: Date) {
        this.birthDate = birthDate;
    }
}
```

Constants are used for variables, not for class properties.

## getters and setters

https://www.typescripttutorial.net/typescript-tutorial/typescript-getters-setters/
e.g.

```
public get fullName() {
```

The getter/setters are also known as accessors/mutators.

## Inheritance

JavaScript uses prototypal inheritance, not classical inheritance like Java or C#. ES6 introduces the class syntax that is simply the syntactic sugar of the prototypal inheritance. TypeScript supports inheritance like ES6.

```
class Employee extends Person {
    //..
}
```

https://www.typescripttutorial.net/typescript-tutorial/typescript-inheritance/

## Modules

In TypeScript, just as in ECMAScript 2015, any file containing a top-level import or export is considered a module. Conversely, a file without any top-level import or export declarations is treated as a script whose contents are available in the global scope.

Distinguish between the ES5 modules syntax and Node.js's CommonJS syntax!
In typescript it is the same but typescript has to use a different module loader for transpiling. See tsconfig.json.

---

If you are exporting a variable (or an arrow function) as a default export, you have to declare it on 1 line and export it on the next.

You can't declare and default export a variable on the same line.

index.ts

const multiply = (a: number, b: number) => {
return a \* b;
};

export default multiply;

Named exports (not default) make it easier to leverage your IDE for auto-completion and auto-imports => prefer name exports.

# Loops

You should use a for loop if you know how many times the loop should run. If you want to stop the loop based on a condition other than the number of times the loop executes, you should use a while loop.

# Function Chaining

// Function chaining APIs are a common pattern in
// JavaScript, which can make your code focused
// with less intermediary values and easier to read
// because of their nesting qualities.

A really common API which works via chaining
is jQuery. Here is an example of jQuery
being used with the types from DefinitelyTyped:

```
import $ from "jquery";
```

Here's an example use of the jQuery API:

```
$("#navigation").css("background", "red").height(300).fadeIn(200);
```

// If you add a dot on the line above, you'll see
// a long list of functions. This pattern is easy to
// reproduce in JavaScript. The key is to make sure
// you always return the same object.

// Here is an example API which creates a chaining
// API. The key is to have an outer function which
// keeps track of internal state, and an object which
// exposes the API that is always returned.

const addTwoNumbers = (start = 1) => {
let n = start;

const api = {
// Implement each function in your API
add(inc: number = 1) {
n += inc;
return api;
},

    print() {
      console.log(n);
      return api;
    },

};
return api;
};

// Which allows the same style of API as we
// saw in jQuery:

addTwoNumbers(1).add(3).add().print().add(1);

// Here's a similar example which uses a class:

class AddNumbers {
private n: number;

constructor(start = 0) {
this.n = start;
}

public add(inc = 1) {
this.n = this.n + inc;
return this;
}

public print() {
console.log(this.n);
return this;
}
}

// Here it is in action:

```
new AddNumbers(2).add(3).add().print().add(1);
```

# Javascript

## Null and undefined

Using only one equal sign means:

```
a != null
```

checks if a != null and a != undefined.

# Webpack

Configuration in webpack.config.js
https://webpack.js.org/concepts
Webpack is a popular tool that we can use to bundle all our JavaScript code into a single minified file.
Webpack also has a handy development server capable of serving an HTML, JavaScript, and CSS app.

We can use a package called fork-ts-checker-webpack-plugin to enable the Webpack process to type check the code. This means that Webpack will inform us of any type errors.

Webpack allows TypeScript, Babel, and ESLint to work together, allowing us to develop a modern project. The ForkTsCheckerWebpackPlugin Webpack plugin allows code to be type-checked during the bundling process.

## Modules

There are several options for bundling:

### Bundle into one file - recommended only very small projects

in tsconfig use compilerOptions.module = "amd"
and configure "outfile" to e.g. bundle.js

import other files with
/// <reference path="path-to-file.ts" />

and it will work when using the same namespaces within all files:
namespace App {
...
}

and use export ...

Note: namespace ... is purely typescript

Disadvantage: it would work if you import everything just in one file, e.g. the main file instead of importing modules in those files where you need it. Typescript will not throw an error and even the javascript will work like this because it is compiled to one single file.

### Step 2: es6 modules: this is the recommendation

- only modern browsers

Use compilerOptions.module = "es2015" in tsconfig.json
because es2015 was the javascript version that introduced module imports like the below.
Also compilerOptions.target must be >= es6
and compilerOptions.outFile is not supported since we want to use javascript module imports instead of one big file. The import handling is then done by Javascript and you only need to include the main file e.g. dist/app.js in your index.html but by

<script type="module" src="dist/app.js"></script>

(with type=module and without defer)

Remove the namespaces and the references (/// <reference path="...")

import { MyClassOrMethodOrWhatever } from '../path-to-file.js'
OR

```
import * as Validation from '../utils/validation.js'
```

and then use it e.g. like Validation.myvalidator(...) This is called grouping.

OR

```
import { bla as Bla } from '../bla.js'
```

OR use export default ... Then you are free to choose your own name

```
import Blafoogaa from './myThing.js'
```

! use .js instead of .ts - import as it were already compiled - the .js can only be skipped if you use some kind of bundler that handles this. This approach here is handled by pure javascript.

Still remember to export your things.

Advantage: here typescript will show errors if the needed files are not imported.

When the same module is being imported by several files, the module is only run the first time it is imported. So a console.log within the module would be run only once even if the modules gets imported 100 times.

If you want your code to run in old browsers anyway, use a bundler!
The bundler will then pack all your modules into one big file.

# Using webpack

npm install --save-dev webpack webpack-cli webpack-dev-server typescript ts-loader

ts-loader
package tells webpack how to convert typescript to javascript by using the typescript compiler under the hood.

webpack can then compile to js and also bundle into one bundle js file.

Changes to tsconfig.json:
no rootDir needed (-> comment out)
because webpack takes care of that.

Add webpack.config.js file:

```
const path = require('path');

module.exports = {
  entry: './src/app.ts',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist') // webpack needs an absolute path here
  },
  devtool : 'inline-source-map', // tells webpack that sourcemaps are already created: please use it.
  module: {
    rules: [ // specify which loaders (packages for webpack on how to dealer with certain files)
      test: /\.ts$/,
      use: 'ts-loader', // means: webpack should apply the ts-loader to all typescript files. ts-loader will automatically take tsconfig.json into account.
      exclude: /node_modules/
    ]
  },
  resolve: {
    extensions: ['.ts', '.js'] // tells webpack to use all files with these extensions
  }
};
```

module.exports = {...} is the way how you do exports in a node.js environment.

"\_\_dirname" is a global variable available in a node.js environment and node.js is being used by webpack to do its tasks.

TODO:
Remove the .js names in all the imports in the code.

## webpack-dev-server

To start the server configure in package.json

```
"scripts": {
    "start": "webpack-dev-server"
```

webpack-dev-server does not use the files in the outdir "./dist" folder but keeps the .js file in memory.

(you have to add output.publicPath = "dist" in webpack.config.js)
Plus
mode: 'development' (in webpack.config.js)

For production create a new file webpack.config.prod.js with mode: production, etc.
add
plugins: [
...
]

# Libraries

## Lodash

pure javascript
npm install --save lodash
-> typescript will throw errors since it is just javascript, but we can tell typescript to understand javascript libraries

.d.ts -> declaration files. -> instructions for typescript for pure .js modules
see @types/lodash
They define the types that code works with for typescript.

see git repo DefinitelyTypes with a huge list of declaration files for ts.

Some libraries ship with type declaration files already even when they are written in javascript. (not lodash though).

Install lodash with the types:
npm install --save-dev @types/lodash

So you also have typescript VSC autocompletion etc.

BUT
if there is no types package for a js library: use declare (?)
declare var GLOBAL: string;

Here we had "lodash" in "dependencies" in package.json plus @types/lodash in the dev-dependencies.

## Class-transformer

plainToClass(MyClass, [{name: date}] )
so you don't have to instantiate all your classes by hand.

## class-validator

decorators for class validation

# Node applications with typescript

in the tsconfig.json file set
"compilerOptions.moduleResolution": "node"
and the target can be "es2018"

- install nodemon (= 'node monitor') to dev dependencies:
  nodemon watches for file changes and restarts the node server if needed.

in package.json add script e.g. like
"start": "nodemon dist/app.js"

Also install
npm install --save-dev @types/node
and the types for libraries that you install for the app.

CHECKOUT nestJS:
A complete development kit for building scalable server-side apps.

# Notes

- You can call the classes with DOM handling "components" and other classes can go to "models" (or "utils" etc.)

# Frameworks

# Find out

- test frameworks? jest or npm run flow?
- eslint?
- prototypes

# Questions

Do I need webpack at all when using tsc and vsc live server? Webpack minifies code in addition...
