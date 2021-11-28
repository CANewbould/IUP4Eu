--------------------------------------------------------------------------------
--	Library: iup.e
--------------------------------------------------------------------------------
--/*
--%%disallow={camelcase}
--*/
--------------------------------------------------------------------------------
--/*
--=  Library: (iup4eu)(include)iup.e
-- Description: Load module for Open Euphoria's access to the IUP GUI Toolkit
--[[[Version: 4.0.5.2
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.05.10
-- Author: Charles Newbould
-- Status: complete; operational]]]
-- Changes in this version:
--  * corrected error on ##doCN##
------
--
------
--
-- Details of earlier incremental changes can be found embedded in the source
-- code at the end of this module, with the title "Previous Versions".
--
--== The Euphoria IUP Interface
--
-- This file attempts to load the appropriate IUP shared library, either:
--* //iup.dll// (MS Windows), or
--* //libiup.so// (Linux)
--
-- This is the main purpose of the module, which is intended to be called by the
-- file //iup.ew//, which contains the full Open Euphoria wrappers for the
-- IUP Toolkit.
--
-- If a shared library cannot be loaded then the module issues an error report
-- before initiating an abort.
--
-- If, however, the library call is successful and IUP becomes available then
-- two wrapper-enabling routines:
--
--* ##doC##, and
--* ##doCN##
--
-- are made available to help simplify the definitions in the major
-- Open Euphoria //iup.ew// module.
--
-- Another routine
--
--* ##toCOrNot##
--
-- is also provided to assist in cases where //NULL// values are acceptable
-- as alternatives to **string** values.
--
-- This module is called by including //iup.e// in the calling code.
--*/
--------------------------------------------------------------------------------
--/*
--==Interface
--*/
--------------------------------------------------------------------------------
--/*
--=== Includes
--*/
--------------------------------------------------------------------------------
include std/console.e   -- for any_key
include std/dll.e       -- for open_dll, define_c_func, define_c_proc
include std/machine.e   -- for allocate_string
include std/types.e     -- for string
--------------------------------------------------------------------------------
--/*
--=== Constants
--*/
--------------------------------------------------------------------------------
constant EMPTY = {}
ifdef WINDOWS then
    constant DLL = "iup.dll"
elsifdef LINUX then
    ifdef BITS64 then
        constant WHERE = "/usr/lib64/"
    elsedef
        constant WHERE = "/usr/lib/"
    end ifdef
    constant DLL = WHERE & "libiup.so"
end ifdef
export constant IUPLIB = open_dll(DLL) -- the [atom] handle to the shared library
constant NULL = 0
constant VOID = -99
--------------------------------------------------------------------------------
--
--=== Variables
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--=== Types
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--/*
--=== Routines
--*/
--------------------------------------------------------------------------------
function addNull(sequence this)
    return append(this, NULL)
end function
--------------------------------------------------------------------------------
export function doC(string fn_name, sequence c_args = EMPTY, sequence e_args = EMPTY, atom c_ret = NULL) -- calls the wrapped C-function
    if c_ret then
        return c_func(define_c_func(IUPLIB, "+" & fn_name, c_args, c_ret), e_args)
    else
        c_proc(define_c_proc(IUPLIB, "+" & fn_name, c_args), e_args)
        return VOID
    end if
end function
--------------------------------------------------------------------------------
--/*
-- This function calls and executes the defined C-function with Euphoria values
--
-- Parameters:
--# //fn_name//: the name by which the C-function is declared in the shared library
--# //c_args//: the sequence of C-language value types that the function requires
--# //e_args//: the matching sequence of Euphoria-based values to pass to the wrapper
--# //c_ret//: the C-language value type of the return value
--
-- Returns:
--
-- an **integer**: either the value returned by calling the C-function, with the
-- //e_args// or //VOID// if the C-function is //void//.
--*/
--------------------------------------------------------------------------------
export function doCN(string fn_name, atom c_arg, sequence e_args, atom c_ret) -- calls the wrapped C-function
    sequence c_args = repeat(c_arg, length(e_args) + 1)
    e_args = addNull(e_args)
    return c_func(define_c_func(IUPLIB, "+" & fn_name, c_args, c_ret), e_args)
end function
--------------------------------------------------------------------------------
--/*
-- This function calls a C-function which takes a repeated, unspecified number of,
-- arguments, all of the same C-language value type. The function is called with
-- the specified Euphoria values.
--
-- Parameters:
--# //fn_name//: the name by which the C-function is declared in the shared library
--# //c_arg//: the C-language value type that the function (repeatedly) requires
--# //e_args//: the matching sequence of Euphoria-based values to pass to the wrapper
--# //c_ret//: the C-language value type of the return value
--
-- Returns:
--
-- an **integer**: the value returned by calling the C-function
--
-- Notes:
--
-- The C-function works by terminated the set of parameters with a //NULL//
-- value. This wrapper function adds the terminations automatically.
--
-- This function is useful for wrapping Container controls, such as ##IupHbox##
-- and ##IupVbox##.
--*/
--------------------------------------------------------------------------------
export function toCOrNot(object this)
    if atom(this) then
        return this
    else -- string
        return allocate_string(this)
    end if
end function
--------------------------------------------------------------------------------
--/*
-- This helper function is most useful in cases, such as the definition of
-- controls like ##IupButton## where Euphoria's wrapper arguments can be either
-- //NULL// or a string. The function returns the approriate value.
--
-- Parameter:
--# //this//: the //NULL// or **string** value
--
-- Returns:
--
-- an **atom**: the original value, or a pointer to a null-terminated
-- C-language string holding the value of //this//
--*/
--------------------------------------------------------------------------------
--/*
--=== Action
--*/
--------------------------------------------------------------------------------
if IUPLIB < 1 then
    printf(2, "** ERROR **: cannot find '%s'\n", {DLL})
    any_key("!!Press any key to abort!!")
    abort(1)
end if
--------------------------------------------------------------------------------
--/*
-- When included this module does one of two things:
--* either it executes silently and offers the shared library's handle and access
-- to the three functions to simplify wrapper-function writing, or
--* issues an error message, to indicate failure to find the shared library,
-- before aborting.
--*/
--------------------------------------------------------------------------------
--
-- Previous versions
--
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.1
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.05.09
-- Author: Charles Newbould
-- Status: complete; operational]]]
-- Changes in this version:
--  * documentation modified
--  * ##toCOrNot## defined
--  * added call to //std/machine.e//
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.0
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.05.06
-- Author: Charles Newbould
-- Status: complete; operational]]]
-- Changes in this version:
--  * created
--  * ##doC## defined
--  * EMPTY defined
--  * NULL defined
--  * VOID defined
--  * addNull defined
--  * ##doCN## defined
--------------------------------------------------------------------------------
