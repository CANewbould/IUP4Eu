include iup/iup.e
include iup/iup_config.e

sequence cmd = command_line()
sequence argv = cmd[3..$]
integer argc = length( argv )

IupOpen( argc, argv )

IupMessage( "My App", "Works Great!" )

	IupClose() 
