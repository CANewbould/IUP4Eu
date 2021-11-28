# IUP for Euphoria #

An Open Euphoria wrapper around [IUP (Portable User Interface)](http://webserver2.tecgraf.puc-rio.br/iup/).

The Euphoria wrapper libraries only work with Open Euphoria v4.0.5 or later. 

## The Euphoria Libraries ##

A naming policy has been adopted which adopts the IUP C-language function name as the Euphoria routine name. This policy also includes the adoption of the function over the procedure in the wrapper, in cases which allow this. An effort has also been made the use the same number of, and broadly speaking the same names for, arguments. There has even been an attempt to imply congruence (for example, 'Ihandle*' in IUP, as a pointer to the structure of the basic element, is reflected in the atom-based wrapper type 'Ihandle'; as the Euphoria 'string' type reflects C's 'const char *').

A major exception applies to the basic **IupOpen** routine in the core IUP library (**iup.ew**). Here the call to the C-function is simplified to avoid the need for any parameters.

Whilst a parallel between the syntax of the wrapped routines and the syntax of the C-language signatures helps to link to the IUP Documentation - so as to make reading it as clear as possible - there are a number of aspects where the user of the wrapper needs to concentrate more on the Euphoria signature than on the original. This reflects the desire of the authors of the wrapper to minimise the need for users to understand the inner workings of C, on the one hand, and IUP, on the other. This is particularly the case when using the **sequence** type in the wrapper. This type is used extensively where IUP uses a variable number of arguments, without the user needing to know about NULL-terminated lists; it is also utilised to return a series of values which C would return as a pointer to a structure. Another instance of deviation is in the case where IUP uses "proxy" variables as the equivalent of multiple return values. The Euphoria user, in general, is therefore able to ignore such issues.

In a number of cases the IUP documentation shows several C-language alternatives for creating IUP elements, usually containers. Each have slightly different suffixes. In most cases the wrapper offers one, occasionally two, such option(s), so please note the precise signature in the Euphoria documentation, as otherwise, errors may well arise.

## Shared Libraries ##

It is the user's responsibility to download an appropriate version of the shared library for the operating system on which the wrapper is to be used, and to position it either in one of the standard search-path locations, in the same folder as the wrapper, or in a location which can be accessed via the **path**.

Note also that IUP comes in both 64-bit and 32-bit versions; you must use a shared library with characteristics that match the VERSION of Euphoria being used, and NOT the OS specification. (You can use either a 32-bit version or a 64-bit version of the Euphoria Interpreter on a 64-bit machine, but you must ensure a match of Interpreter and shared library.) If you want to use the wrapper on different machines with different characteristics then you need to build into your code traps for the different cases - see **iup.exw** in the **demos** folder for an example of using the **ifdef** construct to manage different cases.

## Beta Status ##

This library is currently in a **release _BETA_ state**. Please use it only at your own risk.

The wrapper is by no means complete and additional testing still needs to be performed to ensure its output is 100% correct.

Note also that the IUP library is constantly evolving. As a consequence the wrapper libraries may contain feature introduced in versions later than those stored in your shared library copy. Equally, features which have been deprecated may still be found in earlier shared libraries, but have not been wrapped for Euphoria. The very newest features might not (yet) be wrapped. Equally some discontinued features may still be sitting inside the wrapper. You need to check the IUP documentation with that in the **docs** folder if you are in difficulties of this kind.

Another issue that the Euphoria user needs to take into account is the way in which IUP's offering is delivered in each Operating System environment. The "Drivers" section of the IUP documentation covers this, but the user of the wrapper needs to understand that developments in the OS-based drivers, IUP and the wrapper are not perfectly synchronised. In the course of this development, the wrapper team have, on more than one occasion, had a driver-related error arise, over which they have no control; nor does the user. Fortunately, these anomolies (usually arising because IUP is still using a bit of outdated GTK for its Linux library) usually disappear in the next release of IUP.

Comments, feedback, and contributions are always welcome!

## Examples ##

Look in the **demos** folder for samples, most of which are directly converted from the original IUP C-code. A few others have been added, designed to illustrate features not included in those samples. Sometimes, we developers have left, for interest, examples created to test the wrapped IUP features.

The demos have all been tested using IUP Version 3.26, IUP Version 3.28, and IUP Version 3.30, in both MS Windows 10 & Linux (Mint 18->20), using the iup.ew library file included in this repository. Only in Windows have both 32-bit and 64-bit versions been tested. Please use the contact below to indicate any cases you find where there is difficulty in utilising the wrapper.

As the wrapper is still incomplete, as more illustrations are added the iup.ew file is updated accordingly, so you may need to download a new version from time-to-time.

## Learning more ##

This repository is mainly provided as a resource for Open Euphoria users; it is not intended to be a significant contribution to an understanding of IUP itself. At the time of writing a good source for learning the nuts-and-bolts of IUP has not been found.

There are also a couple of tutorials (to be found in the **support** folder) which are Euphoria-based transcriptions of material written for C-language and Lua users. They are designed to take the reader from first base to a position of good working knowledge of the GUI, but the steps are by no means even. Both are re-casts of existing tutorials, one written for Lua users; one which gives parallel Lua and C-language solutions. A good deal of licence has been taken in places, both to modify the text to Euphoria-relevant language, and to add whole new chunks of text, and re-position others, where it was felt that more explanation was necessary!

## Documentation ##

As indicated above, the intention in creating the wrapper was to exploit the existing documentation on the IUP site, thus minimising the need to replicate large chunks of technical documentation. The user is, therefore, advised to use the relatively limited material in the //docs// folder, with regard to the precise signature and usage of the wrapped routine, alongside the full IUP documentation with regard to precise details, including about attributes and callbacks, much of which is language-independent. Try to imagine a "Euphoria signature line" alongside those for C, Lua and, where appropriate, LED.

Please note that the material in the //iup.ew.html// file is all embedded inside //iup.ew// itself; some users may just prefer to study the source instead.

## Getting Help ##

Please create a new [Issue]() in our bug tracker for problems you encounter. You can also get support and discussion via the [OpenEuphoria Forum](http://openeuphoria.org/forum/index.wc).
