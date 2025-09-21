# FormScript

FormScript is an interpreted domain specific language for creating simple (non-branching) CLI calculator scripts.

## Overview

Suppose we need to calculate the volume and surface area of a cylinder (... or many different cylinders).
This is quickly implemented in FormScript:

```python
# cylinder.fsc
info "This program calculates the volume and surface area of a cylinder.";

get "Height of the cylinder" h;
get "Radius of base" r;

curved_surface = 2 * PI * r * h;
base_surface   = 2 * (PI * r^2);

put "Volume of the cylinder"		   h * PI * r^2;
put "Surface area of the cylinder" curved_surface + base_surface;
```

Running this script with the interpreter yields the output: 

```
$ formscript cylinder.fsc
This program calculates the volume and surface area of a cylinder.
?- Height of the cylinder: 10
?- Radius of base: 4
:- Volume of the cylinder: 502.654
:- Surface area of the cylinder: 351.858
```

Where lines prefixed by `?-` are interactive prompts asking for user input, making the script reusable for any height or radius arguments.

## Syntax and Usage

### Statements

There are four types of statements:

#### 1. `info` statement
Prints the given string to the terminal, much like a usual `printLn` function, eg:
```py
info "This program calculates the volume and surface area of a cylinder.";
```
#### 2. `get` statement
Prompts the user for a number and assigns it to the given variable, eg:
```py
get "Height of the cylinder" h;
```
... produces the prompt
`?- Height of the cylinder:` and awaits user input.

#### 3. Assignment statement

Evaluate the righthand expression and assign its result to the lefthand variable, eg:
```py
curved_surface = 2 * PI * r * h;
```

#### 4. `put`statement

Prints the result of an expression or value of a variable alongside a short info text, eg:

```py
put "Surface area of the cylinder" curved_surface + base_surface;
```

### Expressions

Expressions are composed of operators, variables and constants.

A few examples of valid expressions: `10 *  2`, `(5 + PI) * 3`, `2 ^(n + 1)`, `a + b`, `z`.

#### Operators

Currently available operators are `+ - * / ^`.

#### Variables

Variable names are alphanumeric and must start with an alphabetic character.

#### Constants

Either a number literal like `10`, `5.0`, `2.0` and so on, or one of the following predefined constants:

| Syntax | Value |
|--------|-------|
| `PI` | Pi: 3.141|
| `E` | Eulers number: 2.71828 |


### Composition

Every script is a semicolon-separated list of the four kinds of statements documented above. Considering statements are executed procedurally in order, the usual (but not stipulated) approach would be:

1. Getting input values with `get`
2. Performing calculations with assignment statements
3. Printing output with `put`

<br>
FormScript is simple by design, this pretty much sums it up. For further reference check the scripts supplied in the `examples` directory.

## Building

Have any reasonably recent version of GHC installed,
then run
```bash
./make.sh 
```

The interpreter executable will appear in the `build` directory.
