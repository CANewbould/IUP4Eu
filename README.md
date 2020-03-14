# IUP for Euphoria #

An Open Euphoria wrapper around [IUP (Portable User Interface)](http://webserver2.tecgraf.puc-rio.br/iup/).

The Euphoria wrapper libraries only work with Open Euphoria v4.0.5 or later. 

## The Euphoria Libraries ##

A naming policy has been adopted which takes the IUP C-language function name as the Euphoria routine name. Every effort is made to ensure the existing IUP API is maintained as closely as possible.

A major exception applies to the basic **IupOpen** routine in the core IUP library (**iup.ew**). Here the call to the C-function is simplified, but then contains extended Euphoria code to offer a means of trapping runtime errors if the shared library is not in the path specified by the function's single parameter. The example file **iup.exw** shows a way in which this feature can be used to advantage. (Remember, too, that Open Euphoria offers the means to call a function as if it were a procedure, so if you are confident that the shared library can always be detected - quite likely in Linux - then you can treat **IupOpen** as a procedure with its default parameter.)

## Shared Libraries ##

It is the user's responsibility to download an appropriate version of the shared library for the operating system on which the wrapper is to be used, and to position it either in one of the standard search-path locations, in the same folder as the wrapper, or in a location which can be passed using the **path** parameter of **IupOpen**.

Note also that IUP comes in both 64-bit and 32-bit versions; you must use a shared library with characteristics that match the version of Euphoria being used. If you want to use the wrapper on different machines with different characteristics then you need to build into your code traps for the different cases - see **iup.exw** in the **demos** folder for an example of using the **ifdef** construct to manage different cases.

## Beta Status ##

This library is currently in a **release _BETA_ state**. Please use it only at your own risk.

The wrapper is by no means complete and additional testing still needs to be performed to ensure its output is 100% correct.

Note also that the IUP library is constantly evolving. As a consequence the wrapper libraries may contain feature introduced in versions later than those stored in your shared library copy. Equally, features which have been deprecated may still be found in earlier shared libraries, but have not been wrapped for Euphoria. The very newest features might not (yet) be wrapped. You need to check the IUP documentation with that in the **docs** folder if you are in difficulties of this kind.

Comments, feedback, and contributions are always welcome!

## Examples ##

Look in the **demos** folder for samples, most of which are directly converted from the original IUP C-code. A few others have been added, designed to illustrate features not included in those samples.

These have all been tested using IUP Version 3.26 and IUP Version 3.28, in both MS Windows 10 & Linux (Mint 18), using the iup.ew library file included in the repository and, in Windows, on both 32-bit and 64-bit versions of Euphoria.

As more illustrations are added the iup.ew file is updated accordingly.

## Documentation ##

Documentation will be available via the [Wiki](). More detail of how individual routines work is provided in the **docs** folder. For even more detail, for example with regard to IUP Attributes, refer to the original IUP docs.

## Getting Help ##

Please create a new [Issue]() in our bug tracker for problems you encounter. You can also get support and discussion via the [OpenEuphoria Forum](http://openeuphoria.org/forum/index.wc).
