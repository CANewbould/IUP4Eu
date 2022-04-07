--------------------------------------------------------------------------------
--	Test application: dialog1.ex
--------------------------------------------------------------------------------
--/*
--%%disallow={camelcase}
--*/
--------------------------------------------------------------------------------
--/*
--=  Application: (iup4eu)(demos)dialog1.ex
-- Description: Creates a dialog showing an icon, the "DEFAULTESC" attribute and
-- a simple menu
------
--[[[Version: 4.0.5.4
-- Euphoria Version: v4.0.5 and later
-- Date: 2022.04.07
-- Author: Charles Newbould
-- Status: complete; operational]]]
-- Changes in this version:
--* changed extension and reference to //iupw.e//
------
--
-- Details of earlier incremental changes can be found embedded in the source
-- code at the end of this module, with the title "Previous Versions".
--
--== Testing the Euphoria IUP Wrapper
--
-- Run the test using your desired version of Euphoria, with, if required, the
-- parameter set to the location of the IUP shared library you wish to incorporate
-- into the test.
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
-- defines icon's image - "IUP" in a box
constant img = allocate_image(
{
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,
1,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,6,6,6,6,6,6,5,5,6,6,5,5,6,6,5,5,6,6,6,6,6,6,6,5,5,5,4,2,
1,3,5,5,6,6,6,6,6,6,5,5,6,6,5,5,6,6,5,5,6,6,6,6,6,6,6,6,5,5,4,2,
1,3,5,5,5,5,6,6,5,5,5,5,6,6,5,5,6,6,5,5,6,6,6,5,5,6,6,6,5,5,4,2,
1,3,5,5,5,5,6,6,5,5,5,5,6,6,5,5,6,6,5,5,6,6,5,5,5,5,6,6,5,5,4,2,
1,3,5,5,5,5,6,6,5,5,5,5,6,6,5,5,6,6,5,5,6,6,5,5,5,5,6,6,5,5,4,2,
1,3,5,5,5,5,6,6,5,5,5,5,6,6,5,5,6,6,5,5,6,6,5,5,5,5,6,6,5,5,4,2,
1,3,5,5,5,5,6,6,5,5,5,5,6,6,5,5,6,6,5,5,6,6,6,5,5,6,6,6,5,5,4,2,
1,3,5,5,5,5,6,6,5,5,5,5,6,6,5,5,6,6,5,5,6,6,6,6,6,6,6,6,5,5,4,2,
1,3,5,5,5,5,6,6,5,5,5,5,6,6,5,5,6,6,5,5,6,6,6,6,6,6,6,5,5,5,4,2,
1,3,5,5,5,5,6,6,5,5,5,5,6,6,5,5,6,6,5,5,6,6,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,6,6,5,5,5,5,6,6,5,5,6,6,5,5,6,6,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,6,6,5,5,5,5,6,6,5,5,6,6,5,5,6,6,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,6,6,5,5,5,5,6,6,5,5,6,6,5,5,6,6,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,6,6,5,5,5,5,6,6,5,5,6,6,5,5,6,6,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,6,6,6,6,6,6,5,5,6,6,6,6,6,6,5,5,6,6,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,6,6,6,6,6,6,5,5,5,6,6,6,6,5,5,5,6,6,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,2,
1,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,2,
1,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,
1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
} )
constant NULL = 0
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
type Ihandle(object x)
    return 1
end type
--------------------------------------------------------------------------------
--
--=== Routines
--
--------------------------------------------------------------------------------
function quit_cb()
  return IUP_CLOSE 
end function
--------------------------------------------------------------------------------
procedure main(string title="")
    IupOpen()
    -- Creating dialog's icon
    Ihandle icon = IupImage(32, 32, img) 
    IupSetAttribute (icon, "1", "255 255 255") 
    IupSetAttribute (icon, "2", "000 000 000") 
    IupSetAttribute (icon, "3", "226 226 226") 
    IupSetAttribute (icon, "4", "128 128 128") 
    IupSetAttribute (icon, "5", "192 192 192") 
    IupSetAttribute (icon, "6", "000 000 255") 
    IupSetHandle ("icon", icon)
    -- Creating dialog's content  
    Ihandle quit_bt = IupButton("Quit", NULL)
    IupSetCallback(quit_bt, "ACTION", Icallback("quit_cb")) 
    IupSetHandle("quit", quit_bt) 
    -- Creating dialog's menu
    Ihandle ext = IupItem("Exit") 
    Ihandle options = IupMenu({ext}) 
    IupSetCallback(ext, "ACTION", Icallback("quit_cb")) 
    Ihandle submenu = IupSubmenu("File", options) 
    Ihandle menu = IupMenu({submenu, NULL}) 
    IupSetHandle("menu", menu) 
    -- Creating main dialog  
    Ihandle dialog = IupDialog(IupVbox({quit_bt, NULL})) 
    IupSetAttribute(dialog, "TITLE", title) 
    IupSetAttribute(dialog, "MENU", "menu") 
    IupSetAttribute(dialog, "CURSOR", "CROSS") 
    IupSetAttribute(dialog, "ICON", "icon") 
    IupSetAttribute(dialog, "DEFAULTESC", "quit")
    IupSetAttribute(dialog, "SIZE", "QUARTERxQUARTER")
    IupShowXY(dialog, IUP_CENTER, IUP_CENTER) 
    IupMainLoop() 
    IupClose() 
end procedure
--------------------------------------------------------------------------------
--/*
--=== Execution
--*/
--------------------------------------------------------------------------------
main("IupDialog")
--------------------------------------------------------------------------------
--
--Previous versions
--
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.3
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.05.16
-- Author: Charles Newbould
-- Status: complete; operational]]]
-- Changes in this version:
--* simplfied to accept revised iup.ew arrangement
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.2
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.04.04
-- Author: Charles Newbould
-- Status: complete; operational]]]
-- Changes in this version:
--* completed to full example, as iup.ew refined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.1
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.04.04
-- Author: Charles Newbould
-- Status: complete; operational]]]
-- Changes in this version:
--* converted to new style
--------------------------------------------------------------------------------
