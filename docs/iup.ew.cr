%%disallow={camelcase}
=  Library: (iup4eu)(include)iup.ew
 Description: Wrapper library for use with Eu4.0.5 and beyond
----
[[[Version: 4.0.5.21
 Euphoria Version: v4.0.5 and later
 Date: 2020.03.14
 Author: Charles Newbould
 Status: incomplete; operational]]]
 Changes in this version:
* ##IupOpen## turned into a function
* ##IupVersionNumber## defined

----

 Details of earlier incremental changes can be found embedded in the source
 code at the end of this module, with the title "Previous Versions".

== The Euphoria IUP Wrapper

 The wrapper is called by including the module //iup.ew// in the source code.

 To initialised the library call the ##IupOpen## procedure, with the single
 parameter value which is either //""// or is set to a string value which
 designates the folder in which the shared library (.dll or .so) is to be found.
 This facility allows users to call 32-bit or 64-bit versions of IUP and/or
 test their code using different versions of the source IUP library.

 A typical IUP code block is as follows:

<eucode>include iup.ew
 --
 IupOpen()
 --
 -- the IUP-based code
 --
 IupMainLoop()
 --
 IupClose()</eucode>

==Interface
=== Includes
<eucode>include std/dll.e		-- for open_dll, call_back, define_c_func, define_c_proc, C_INT, C_POINTER</eucode>
<eucode>include std/machine.e	-- for allocate, allocate_pointer_array, allocate_string, free, peek_string & poke_pointer</eucode>
<eucode>include std/os.e		-- for platform constants</eucode>
<eucode>public include std/types.e     -- for string</eucode>
=== Constants
  //flags//
<eucode>public constant EXIT_SUCCESS = 0</eucode>
<eucode>public constant IUP_IGNORE = -1</eucode>
<eucode>public constant IUP_DEFAULT = -2</eucode>
<eucode>public constant IUP_CLOSE = -3</eucode>
  //IupPopup and IupShowXY Parameter Values//
<eucode>public constant IUP_CURRENT = 65531</eucode>
<eucode>public constant IUP_CENTER = #FFFF</eucode>
<eucode>public constant IUP_CENTRE = IUP_CENTER</eucode>
=== Routines
<eucode>public function IupOpen(string path = "")  -- initializes the IUP toolkit</eucode>
Parameter:
# //path//: any search path required to locate desired version of the shared
 library [Default ""]

Returns:

 an **atom**: the handle to the shared library

 Notes:

* To avoid runtime errors,
 use the return value to test for success in finding the shared library.
* This routine must be called before any other IUP function,
 except IupVersion and its associated routines.
<eucode>public procedure IupClose() -- ends access to the IUP toolkit and releases internal memory</eucode>
Note:

 ##IupClose## will also automatically destroy all dialogs and all elements
 that have names.
<eucode>public function IupVersionNumber()  -- returns the version number as an integer</eucode>
 Returns:

 an **integer**: the version number including any bug fixes.
