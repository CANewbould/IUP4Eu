--------------------------------------------------------------------------------
-- dialog2.ex
--------------------------------------------------------------------------------
-- IupDialog example with button & label controls
--------------------------------------------------------------------------------
-- Version 4.0.5.2
-- Dated 2022.04.07
-- Author C A Newbould
-- Changes:
--* changed extension and reference to //iupw.e//
--------------------------------------------------------------------------------
-- includes
--------------------------------------------------------------------------------
include iupw.e
--------------------------------------------------------------------------------
-- constants
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- types
--------------------------------------------------------------------------------
type Ihandle( object x )
    return 1
end type
--------------------------------------------------------------------------------
-- routines
--------------------------------------------------------------------------------
function  quit_cb( object void )
  return IUP_CLOSE
end function
--------------------------------------------------------------------------------
procedure main()
    IupOpen()

    -- Creating the button
    Ihandle quit_bt = IupButton("Quit", 0)
    IupSetCallback(quit_bt, "ACTION", Icallback("quit_cb") )
    -- the container with a label and the button
    Ihandle label_long = IupLabel("Very Long Text Label")
    IupSetAttributes(label_long, "EXPAND=YES, ALIGNMENT=ACENTER")
    Ihandle vbox = IupVbox({label_long,
           quit_bt,
           0})
    IupSetAttribute(vbox, "ALIGNMENT", "ACENTER")
    IupSetAttribute(vbox, "MARGIN", "10x10")
    IupSetAttribute(vbox, "GAP", "5")
    -- Creating the dialog
    Ihandle dialog = IupDialog(vbox)
    IupSetAttribute(dialog, "TITLE", "Dialog Title")
    IupSetAttributeHandle(dialog, "DEFAULTESC", quit_bt)
    IupSetAttribute( dialog, "SIZE", "200x100" )    --//TOM added
    printf(1, "The vbox has %d children.\n", {IupGetChildCount(vbox)})
    IupShow(dialog)
    IupMainLoop()
    IupDestroy(dialog)
    IupClose()
end procedure
--------------------------------------------------------------------------------
-- execution
--------------------------------------------------------------------------------
main()
--------------------------------------------------------------------------------
-- Previous versions
--------------------------------------------------------------------------------
-- Version 4.0.5.1
-- Dated 2020.09.11
-- Author C A Newbould
-- Changes: documented in common format
--------------------------------------------------------------------------------
