# IUP for Euphoria #

An Open Euphoria wrapper around [IUP (Portable User Interface)](http://webserver2.tecgraf.puc-rio.br/iup/).

## Wrapper ##

The wrapper is a hand-coded Euphoria utility that reads the IUP header files and generates corresponding Euphoria includes.

Additional effort is made to ensure the existing IUP API is maintained as closely as possible.

The wrapper is by no means complete and additional testing still needs to be performed to ensure its output is 100% correct.

## Beta Status ##

This library is currently in a **release _BETA_ state**. Please use it only at your own risk. Comments, feedback, and contributions are welcome!

## Examples ##

Check out **samples** in the [Source]() for samples converted from the original IUP C code, plus a few others designed to illustrate features not included in those examples.

These have all been tested using IUP Version 3.26 and UP Version 3.28, in both Windows 10 & Linux (Mint 18), using the iup.ew library file included in the repository.

As more illustrations are added the iup.ew file is updated accordingly.

## Documentation ##

Documentation will be available via the [Wiki](). More detail of how individual routines work is provided in the **docs** folder. For even more detail, for example with regard to IUP Attributes, refer to the original IUP docs.

## Getting Help ##

Please create a new [Issue]() in our bug tracker for problems you encounter. You can also get support and discussion via the [OpenEuphoria Forum](http://openeuphoria.org/forum/index.wc).
