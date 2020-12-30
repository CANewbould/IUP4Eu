-- Gui.e

public include iup/iup.e
public include iup/iup_config.e
    
export procedure GuiOpen()
    sequence cmd = command_line()
    sequence argv = cmd[3..$]
    integer argc = length( argv )
    IupOpen( argc, argv )
end procedure

export procedure GuiClose()
    IupClose()
end procedure    
