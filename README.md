# IDOC - Indentation DOCument

Idoc is a text file format to store data to be used by other programs.
This repository includes it's parser, written in C.
An idoc file uses the extension `.idoc`

## A .idoc file

This is how a typical idoc file would be written

``` text example.idoc
Program:
  Name = "Program name"
  Colors:
    red = (255.0, 0.0, 0.0) # the color red!
    green = (0.0, 255.0, 0.0) # this is green wow!
  Font = "Comic Sans"
  width =  100 # it ignores whitespace!
  height=200 # you can even do this!
  cool_number = Program.width # you can even use references!
  # local references (such as just using .width) are planned
  things_i_have_to_buy = ("apples", "200 tons of uranium")
```
### How to write .idoc file

As the name implies, this file uses indentation to define scopes (like python).
You can use tabs or spaces to indent, but you must keep it consistent through the whole file (even between scopes).

You can define *Sections* by using a name followed by a ":", such as the `Program:` section in the example.

You can define an *Assignment* by using a name followed by a "=", such as the `Name = "Program name"` in the example.

Idoc files support 4 types of assignments, `int`, `double`, `string` and `reference`.
A reference is just the full path to another assignment, split by ".", such as the `cool_number = Program.width` example.
You can reference a future assignment (a.k.a defined later).

## Using idoc.h

To actually read the data of these files you must include the parser in your program.

Since this is an [stb-style](https://github.com/nothings/stb) single-header-library, you must initialize the library like this:

```c main.c
#define IDOC_IMPLEMENTATION
#include "idoc.h"
```

Then, you start the parser, and get fields like so (lets use the idoc file defined in the example above):

```c main.c
Idoc idoc = idoc_init("./example.idoc");
char *name = idoc_get(&idoc, cstr, "Program", "Name");
double red[3]
if (!idoc_tuple_get(&idoc, double, red, "program", "COLORS", "red") exit(1);
idoc_free(&idoc);
// Your program here that uses name and red
// ...
free(red);
free(name); // Since the string lives after idoc_free, it must be manually freed
```

The full explanation of the API is given inside [idoc.h](./idoc.h).
