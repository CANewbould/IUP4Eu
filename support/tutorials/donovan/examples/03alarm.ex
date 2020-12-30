include Gui.e

GuiOpen()
atom a = IupAlarm( "File Save Alarm", "File not saved! Save it Now?", "Yes","No","Cancel" )

switch a do
    case 1 then
        IupMessage("Save File","File Saved Successfully" )
    case 2 then
        IupMessage("File Save","File Not Saved" )
    case 3 then
        IupMessage("File Save","Operation Cancelled" )
end switch

GuiClose()
