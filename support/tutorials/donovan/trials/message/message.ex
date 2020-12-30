include gui.e

g:message( "Your app", "Finished Sucessfully!" )

? g:alarm( "Alarm example", "File not saved!", "Yes", "No", "Cancel" )

IupMainLoop()
IupClose()
