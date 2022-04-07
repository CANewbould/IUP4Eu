--------------------------------------------------------------------------------
--	Test application: dialog.ex
--------------------------------------------------------------------------------
--/*
--%%disallow={camelcase}
--*/
--------------------------------------------------------------------------------
--/*
--=  Application: (iup4eu)(demos)dialog.ex
-- Description: Simple dialog example
------
--[[[Version: 4.0.5.5
-- Date: 2022.04.02
-- Author: Charles Newbould
-- Status: complete; operational]]]
-- Changes in this version:
--* modified to use //iupw.e// and new aliases therein
--* changed //IUP_CLOSE// return value to ##IupClose##
------
--
-- Details of earlier incremental changes can be found embedded in the source
-- code at the end of this module, with the title "Previous Versions".
--
--== Testing the Euphoria IUP Wrapper
--
-- This example shows a simple dialog using IupDialog, but showcases a range of
-- other features of IUP. Please read the code before running the demo.
--
-- Run the test using your desired version of Euphoria, with, if required, the
-- parameter //path// value reset to the location of the IUP shared library you
-- wish to incorporate into the test.
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
include iupw.e
--------------------------------------------------------------------------------
--
--=== Constants
--
--------------------------------------------------------------------------------
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
--
--=== Routines
--
--------------------------------------------------------------------------------
function quit_cb()
  return IupClose()--alternative to IUP_CLOSE
end function
--------------------------------------------------------------------------------
procedure main(string title)
    IupOpen()
    -- Creating the button
    Ihandle quit_bt = IupButton("Quit")
    IupSetCallback(quit_bt, "ACTION", _("quit_cb"))
    -- the container with a label and the button
    Ihandle vbox = IupVbox({
        IHandle(IupLabel("Not especially long Text Label"),
        "EXPAND=YES, ALIGNMENT=ACENTER"),
        quit_bt})
    IupSetAttributes(vbox, "ALIGNMENT=ACENTER,MARGIN=10x10,GAP=5")
    -- Creating the dialog
    Ihandle dialog = IupDialog(vbox)
    IupSetAttribute(dialog, "TITLE", title)
    IupSetAttribute(dialog, "SIZE", "QuarterxEight")
    IupSetAttributeHandle(dialog, "DEFAULTESC", quit_bt)
    IupShow(dialog)
    IupMainLoop()
    IupDestroy(dialog)
    -- Finishes IUP
    IupClose() -- not actually necessary
    -- Program finished successfully
end procedure
--------------------------------------------------------------------------------
--/*
--=== Execution
--*/
--------------------------------------------------------------------------------
main("Dialog Title")
--------------------------------------------------------------------------------
--
--Previous versions
--
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.4
-- Date: 2021.08.06
-- Author: Charles Newbould
-- Status: complete; operational]]]
-- Changes in this version:
--* modified label text
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.3
-- Date: 2020.05.06
-- Author: Charles Newbould
-- Status: complete; operational]]]
-- Changes in this version:
--* modified for simpler call to IUP shared library
--------------------------------------------------------------------------------
--[[[Version: 4.1.0.2
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.04.27
-- Author: Charles Newbould
-- Status: complete; operational]]]
-- Changes in this version:
--* modified ##main## to simplify call to dll
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.1
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.03.31
-- Author: Charles Newbould
-- Status: complete; operational]]]
-- Changes in this version:
--* added in-code documentation to source
--* modified Bitbucket version to allow for new IupOpen
--------------------------------------------------------------------------------
