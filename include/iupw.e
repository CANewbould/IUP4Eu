--------------------------------------------------------------------------------
--	Library: iup.ew
--------------------------------------------------------------------------------
--/*
--%%disallow={camelcase}
--*/
--------------------------------------------------------------------------------
-- Notes:
--
-- need to edit embedded documentation from IupImage onwards
--------------------------------------------------------------------------------
--/*
--=  Library: (iup4eu)(include)iup.ew
-- Description: Wrapper library for use with Eu4.0.5 and beyond
------
--[[[Version: 4.0.5.70
-- Euphoria Verion: v4.0.5 and later
-- Date: 2022.04.02
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * added alias for ##IupSetAttributes##
--  * added alias for ##Icallback##
--
-- Details of earlier incremental changes can be found embedded in the source
-- code at the end of this module, with the title "Previous Versions".
------
--
--== The Euphoria IUP Wrapper
--
-- The wrapper is called by including the module //iup.ew// in the source code.
--
-- To initialised the library call the ##IupOpen## procedure.
--
-- Note that this library works with both 32-bit and 64-bit versions of IUP.
-- The user needs to ensure that the path to the appropriate shared/dynamic
-- library is "pointed" to before IUP is initiated.
--
-- A typical IUP code block is as follows:
--
--<eucode>include iup.ew
-- --
-- definition of any callback functions
-- -- [definition of a main routine, containing]
-- if IupOpen() then
--     -- definition of the widgets;
--     -- their attributes;
--     -- associated callbacks
--     -- display of the dialog (top-level window)
--     IupMainLoop()
--     IupClose()
-- else
--     -- any desired error management
-- end if</eucode>
--
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
include iup.e           -- for IUPLIB, or abort
public include std/dll.e	-- for open_dll, call_back, define_c_func, define_c_proc, C_INT, C_POINTER, NULL
include std/machine.e	-- for allocate, allocate_pointer_array, allocate_string, free, peek_string & poke_pointer
include std/os.e		-- for platform constants
include std/text.e      -- for upper
public include std/types.e     -- for string
--------------------------------------------------------------------------------
--/*
--=== Constants
--*/
--------------------------------------------------------------------------------
--/*
--==== Events
--*/
--------------------------------------------------------------------------------
public constant IUP_CONTINUE = -4
public constant IUP_CLOSE = -3
public constant IUP_DEFAULT = -2
public constant EXIT_SUCCESS = 0    -- successful completion of IUP loop
public constant EXIT_FAILURE = 1    -- unsuccessful completion of IUP loop
public constant IUP_IGNORE = -1
--------------------------------------------------------------------------------
--/*
--====IupPopup and IupShowXY Parameter Values
--*/
--------------------------------------------------------------------------------
public constant IUP_CENTER = 0xFFFF /* 65535 */
public constant IUP_CENTRE = IUP_CENTER
public constant IUP_LEFT = 0xFFFE /* 65534 */
public constant IUP_RIGHT = 0xFFFD /* 65533 */
public constant IUP_MOUSEPOS = 0xFFFC /* 65532 */
public constant IUP_CURRENT = 0xFFFB /* 65531 */
public constant IUP_CENTERPARENT = 0xFFFA /* 65530 */
public constant IUP_TOP = IUP_LEFT
public constant IUP_BOTTOM = IUP_RIGHT
--------------------------------------------------------------------------------
--/*
--====Mouse Button Values and Macros
--*/
--------------------------------------------------------------------------------
public constant IUP_BUTTON1 = '1'
public constant IUP_BUTTON2 = '2'
public constant IUP_BUTTON3 = '3'
public constant IUP_BUTTON4 = '4'
public constant IUP_BUTTON5 = '5'
--------------------------------------------------------------------------------
--/*
--==== Keys
--*/
--------------------------------------------------------------------------------
public constant K_ampersand = '&'
public constant K_apostrophe = '\''
public constant K_asterisk = '*'
public constant K_at = '@'
public constant K_bar = '|'
public constant K_braceleft ='{'
public constant K_braceright ='}'
public constant K_backslash = '\\'
public constant K_bracketleft ='['
public constant K_bracketright =']'
public constant K_BS = 8
public constant K_circum = '^'
public constant K_colon = ':'
public constant K_comma = ','
public constant K_CR = '\r'
public constant K_DEL = #FFFF
public constant K_dollar = '$'
public constant K_DOWN = #FF54
public constant K_END = #FF57
public constant K_equal = '='
public constant K_ESC = #FF1B
public constant K_exclam = '!'
public constant K_grave = '`'
public constant K_greater = '>'
public constant K_HOME = #FF50
public constant K_INS = #FF63
public constant K_LEFT = #FF51
public constant K_less = '<'
public constant K_MIDDLE = #FF0B
public constant K_minus = '-'
public constant K_numbersign = '#'
public constant K_parentleft = '('
public constant K_parentright = ')'
public constant K_percent = '%'
public constant K_period = '.'
public constant K_PGDN = #FF56
public constant K_PGUP = #FF55
public constant K_plus = '+'
public constant K_question = '?'
public constant K_quotedbl = '"'
public constant K_RIGHT = #FF53
public constant K_semicolon = ';'
public constant K_slash = '/'
public constant K_SP = ' '
public constant K_TAB = '\t'
public constant K_tilde = '~'
public constant K_underscore = '_'
public constant K_UP = #FF52
public enum K_0 = '0', K_1, K_2, K_3, K_4, K_5, K_6, K_7, K_8, K_9
public enum K_A = 'A', K_B, K_C, K_D, K_E, K_F, K_G, K_H, K_I, K_J, K_K, K_L,
            K_M, K_N, K_O, K_P, K_Q, K_R, K_S, K_T, K_U, K_V, K_W, K_X, K_Y, K_Z
public enum K_a = 'a', K_b, K_c, K_d, K_e, K_f, K_g, K_h, K_i, K_j, K_k, K_l,
            K_m, K_n, K_o, K_p, K_q, K_r, K_s, K_t, K_u, K_v, K_w, K_x, K_y, K_z
--------------------------------------------------------------------------------
--/*
--==== Pre-Defined Masks
--*/
--------------------------------------------------------------------------------
public constant IUP_MASK_FLOAT = "[+/-]?(/d+/.?/d*|/./d+)"
public constant IUP_MASK_UFLOAT = "(/d+/.?/d*|/./d+)"
public constant IUP_MASK_EFLOAT = "[+/-]?(/d+/.?/d*|/./d+)([eE][+/-]?/d+)?"
public constant IUP_MASK_FLOATCOMMA = "[+/-]?(/d+/,?/d*|/,/d+)"
public constant IUP_MASK_UFLOATCOMMA = "(/d+/,?/d*|/,/d+)"
public constant IUP_MASK_INT = "[+/-]?/d+"
public constant IUP_MASK_UINT = "/d+"
/* Old definitions for backward compatibility */
public constant IUPMASK_FLOAT = IUP_MASK_FLOAT
public constant IUPMASK_UFLOAT = IUP_MASK_UFLOAT
public constant IUPMASK_EFLOAT = IUP_MASK_EFLOAT
public constant IUPMASK_INT = IUP_MASK_INT
public constant IUPMASK_UINT = IUP_MASK_UINT
--------------------------------------------------------------------------------
--
--=== Variables
--
--------------------------------------------------------------------------------
integer hIupSetAttribute, hIupSetCallback
--------------------------------------------------------------------------------
--/*
--=== Types
--*/
--------------------------------------------------------------------------------
type attrib(string this)
    for i = 1 to length(this) do
        if not upper_case(this[i]) then return FALSE end if
    end for
    return TRUE
end type
--------------------------------------------------------------------------------
public type Ihandle(atom this) -- pointer to an IUP Ihandle structure
    return this >= 0
end type
--------------------------------------------------------------------------------
type upper_case(integer this)
    return (this > 64) and (this < 91)
end type
--------------------------------------------------------------------------------
--/*
--=== Routines
--*/
--------------------------------------------------------------------------------
-- service routines
--------------------------------------------------------------------------------
function get_param_get(object param, atom p)
    if sequence(param) then
	   return peek_string(p)
    else
	   return peek4s(p)
    end if
end function
--------------------------------------------------------------------------------
function get_param_set(object param, integer len)
    atom p
    if sequence(param) then
        p = allocate(len * 4)
        mem_set(p, 0, len)
        poke(p, param)
    else
        p = allocate(4)
        poke4(p, param)
    end if
    return p
end function
--------------------------------------------------------------------------------
--/*
--==== Management
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupClose         (void);
--------------------------------------------------------------------------------
public function IupClose() -- ends access to the IUP toolkit and releases internal memory
    return doC("IupClose")
end function
--------------------------------------------------------------------------------
--/*
--Note:
--
-- ##IupClose## will also automatically destroy all dialogs and all elements
-- that have names.
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupIsOpened      (void);
--------------------------------------------------------------------------------
public function IupIsOpened() -- reports whether IupOpen has been invoked and IupClose not
    return doC("IupIsOpened", , , C_BOOL)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- a **boolean**: TRUE if IUP open.
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupOpen          (int *argc, char ***argv);
--------------------------------------------------------------------------------
public function IupOpen()  -- initializes the IUP toolkit
    -- defined reusable ones
    hIupSetAttribute = define_c_proc(IUPLIB, "+IupSetAttribute",
                {C_POINTER, C_POINTER, C_POINTER})
    hIupSetCallback = define_c_func(IUPLIB, "+IupSetCallback",
                {C_POINTER, C_POINTER, C_INT}, C_INT)
    return doC("IupOpen", {C_INT, C_POINTER}, {0, 0}, C_INT)
end function
--------------------------------------------------------------------------------
--/*
--Returns:
--
-- an **integer**: IUP_OPENED (already opened), IUP_ERROR or IUP_NOERROR
--
-- Notes:
--
--* To avoid runtime errors,
-- use the return value to test for success in finding the shared library.
--* This routine must be called before any other IUP function,
-- except IupVersion and its associated routines.
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupSetLanguage   (const char *lng);
--------------------------------------------------------------------------------
public function IupSetLanguage(string name = "ENGLISH") -- sets the language name used by some pre-defined dialogs
    return doC("IupSetLanguage", {C_POINTER}, {allocate_string(name)})
end function
--------------------------------------------------------------------------------
--/*
-- Language can also be changed using the global attribute LANGUAGE.
--
-- Parameter:
--# //name//: one of "ENGLISH" [Default], "PORTUGUESE", "SPANISH"
--*/
--------------------------------------------------------------------------------
-- IUP_API char*     IupGetLanguage   (void);
--------------------------------------------------------------------------------
public function IupGetLanguage()  -- returns the current language
    return peek_string(doC("IupGetLanguage", , , C_POINTER))
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- a **sequence**: the language used by some pre-defined dialogs.
--
-- Returns the same value as the //LANGUAGE// global attribute.
--*/
--------------------------------------------------------------------------------
-- IUP_API char*     IupVersion       (void);
--------------------------------------------------------------------------------
public function IupVersion()  -- returns the version number as a string
    return peek_string(doC("IupVersion", , , C_POINTER))
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- a **string**: the version number including any bug fixes.
--*/
--------------------------------------------------------------------------------
-- IUP_API char*     IupVersionDate   (void);
--------------------------------------------------------------------------------
public function IupVersionDate()  -- returns the version date as a string
    return peek_string(doC("IupVersionDate", , , C_POINTER))
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- a **string**: the version date.
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupVersionNumber (void);
--------------------------------------------------------------------------------
public function IupVersionNumber()  -- returns the version number as an integer
    return doC("IupVersionNumber", , , C_INT)/100000
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- an **integer**: the version number including any bug fixes.
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupVersionShow   (void);
--------------------------------------------------------------------------------
public function IupVersionShow()  -- returns the version number as a string
    return doC("IupVersionShow")
end function
--------------------------------------------------------------------------------
--/*
-- Shows a popup dialog with IUP version information and more.
-- This is a debug dialog with lots of information of additional libraries too.
--*/
--------------------------------------------------------------------------------
--/*
--==== Dialogs
--*/
--------------------------------------------------------------------------------
-- IUP_API int  IupAlarm(const char *title, const char *msg, const char *b1, const char *b2, const char *b3);
--------------------------------------------------------------------------------
public function IupAlarm(string title, string mess, string b1, object b2 = NULL, object b3 = NULL)
	sequence arg = repeat(NULL, 5)
	arg[1] = allocate_string(title)
	arg[2] = allocate_string(mess)
	arg[3] = allocate_string(b1)
	if string(b2) then
		arg[4] = allocate_string(b2)
		if string(b3) then
			arg[5] = allocate_string(b3)
		end if
	end if
	return doC("IupAlarm", repeat(C_POINTER, 5), arg, C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- Shows a modal dialog containing a message and up to three buttons.
--
-- Parameters: the first button is obligatory and is named by ##b1##.
-- To set the second button set ##b2## to a text string; ditto for ##b3##.
-- (Note: you cannot set ##b3## and not ##b2##!)
--
-- Returns: an integer - the number of the button selected by the user (1, 2 or 3),
-- or 0 if failed. It fails only if ##b1## is not defined.
--
-- Example:
-- <eucode>
-- -- Example 2
--
-- include iup.ew
-- IupOpen()
--
-- constant b = IupAlarm("IupAlarm Example", "File not saved! Save it now?" ,"Yes" ,"No" ,"Cancel")
-- -- Shows a message for each selected button
-- if b = 0 then
--         IupMessage("Save file", "Dialog closed, without selection")
-- elsif b = 1 then
--         IupMessage("Save file", "File saved sucessfully - leaving program")
-- elsif b = 2 then
--         IupMessage("Save file", "File not saved - leaving program anyway")
-- elsif b = 3 then
--         IupMessage("Save file", "Operation cancelled")
-- end if
-- IupClose()
--</eucode>
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupDialog     (Ihandle* child);
--------------------------------------------------------------------------------
public function IupDialog(Ihandle child = NULL)  -- creates a dialog element
    return doC("IupDialog", {C_POINTER}, {child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- A dialog manages user interaction with the interface elements.
-- For any interface element to be shown, it must be encapsulated in a dialog.
--
-- Parameter:
--# //child//: the (**Ihandle**) identifier of an interface element.
-- The dialog has only one child. It can be NULL.
--
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle* IupFileDlg(void);
--------------------------------------------------------------------------------
public function IupFileDlg() -- creates the File Dialog element
    return doC("IupFileDlg", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It is a predefined dialog for selecting files or a directory.
-- The dialog can be shown with the IupPopup function only.
--
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle* IupFontDlg(void);
--------------------------------------------------------------------------------
public function IupFontDlg() -- creates the Font Dialog element
    return doC("IupFontDlg", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It is a predefined dialog for selecting a font.
-- The dialog can be shown with the IupPopup function only.
--
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API int  IupGetColor(int x, int y, unsigned char* r, unsigned char* g, unsigned char* b);
--------------------------------------------------------------------------------
public function IupGetColor(atom x, atom y) -- shows a modal dialog which allows the user to select a colour
	atom rgb = allocate_data(sizeof(C_INT) * 3, 1)
	atom r = rgb + sizeof(C_INT) * 0
	atom g = rgb + sizeof(C_INT) * 1
	atom b = rgb + sizeof(C_INT) * 2
    boolean ret = doC("IupGetColor",{C_INT, C_INT, C_POINTER, C_POINTER, C_POINTER},
                              {x, y, r, g, b}, C_INT)
    if ret then return peek({rgb, 3})
    else return {}
    end if
end function
--------------------------------------------------------------------------------
--/*
-- Based on IupColorDlg.
--
-- Returns:
--
-- a **sequence**: the {r,g,b} values, or empty, if the //OK// button is not
-- clicked.
--*/
--------------------------------------------------------------------------------
-- IUP_API int  IupGetFile(char *arq);
--------------------------------------------------------------------------------
public function IupGetFile(string filename) -- shows a modal dialog of the native interface system to select a filename
    atom pn = allocate(4096) -- maximum specified in IUP documentation
    poke(pn, filename & NULL) -- previous version failed to allocate enow space
    sequence result = {doC("IupGetFile", {C_POINTER}, {pn}, C_INT), peek_string(pn)}
    free(pn)
    return result
end function
--------------------------------------------------------------------------------
--/*
-- Uses the IupFileDlg element.
--
-- Parameters:
--# //filename//: the (**string**) default filter and directory
--
-- Returns:
--
-- a **sequence** containing two elements:
--# an **integer** status code, whose values can be:
--* //1//: New file.
--* //0//: Normal, existing file.
--* //-1//: Operation cancelled.
--# a **string**: containing the full pathname of the selected file
--
--*/
--------------------------------------------------------------------------------
-- IUP_API int IupGetParam(const char* title, Iparamcb action, void* user_data, const char* format,...);
--------------------------------------------------------------------------------
public function IupGetParam(string title, integer rid, object data, string format, sequence args) -- shows a modal dialog for capturing parameter values using several types of controls
    atom pTitle = allocate_string(title)
    atom pRid = 0
    atom pData = data
    atom pFormat = allocate_string(format)
    atom nargs = length(args)
    sequence p = repeat(0, nargs)
    if rid > 0 then		--if rid >= 0 then
	   pRid = call_back({'+', rid})
    end if
    for i = 1 to nargs do
        p[i] = get_param_set(args[i], 1024)
    end for
    integer hIupGetParam = define_c_func(IUPLIB, "IupGetParam",
                {C_POINTER, C_INT, C_INT} & repeat(C_INT, nargs) &
                {C_POINTER, C_INT}, C_INT)
    integer result = c_func(hIupGetParam, {pTitle, pRid, pData, pFormat} & p & {NULL})
    sequence vals = repeat(0, nargs)
    for i = 1 to nargs do
        vals[i] = get_param_get(args[i], p[i])
    end for
    return result & vals
end function
--------------------------------------------------------------------------------
--/*
-- The dialog uses the {{{IupParam and IupParamBox}}} controls internally.
--
-- Parameters:
--# //title//: the dialog's title.
--# //rid//: user callback to be called whenever a parameter value was changed,
-- and when the user pressed the OK button. It can be NULL.
--# //data//: user pointer passed to the user callback.
--# //format//: a string describing all the parameters.
-- It is a sequence of format strings for each parameter,
-- see {{{IupParam}}}. (It is a list of variables address with initial values for the
-- parameters. The number of lines in the format string (number of '\n') will
-- determine the number of required parameters.
-- The separators will not count as parameters.
-- There is no maximum number of parameters (since 3.13), and this is now
-- also the same in the Euphoria implementation.
--# //args//: a sequence holding place-markers for the return data value
-- defined in ##format##.
--
-- Returns:
--
-- a **sequence** containing two elements:
--# a status code 1 if the button 1 was pressed,
-- 0 if the button 2 was pressed or if an error occurred;
--# the [1-length(##args##)] returned values, in the order set by ##format##.
--
--*/
--------------------------------------------------------------------------------
-- IUP_API int  IupGetText(const char* title, char* text, int maxsize);
--------------------------------------------------------------------------------
public function IupGetText(string title, string text, integer maxsize=10240) -- shows a modal dialog to edit a multiline text
    atom pn = allocate(maxsize) -- need to allocate enough for response
    poke(pn, text & NULL) -- previous version failed to allocate enow space
    sequence result = {doC("IupGetText", {C_POINTER, C_POINTER, C_INT},
                {allocate_string(title), pn, maxsize}, C_INT), peek_string(pn)}
    free(pn)
    return result
end function
--------------------------------------------------------------------------------
--/*
-- Parameters:
--# //title//: the (**string**) caption of the dialog
--# //text//: the (**string**) text value
--# //maxsize//: maximum size for the edited string [default = 10240]
--  If set to 0 will be the current length of text,
--  if set to -1 the dialog will be read-only and only the OK button is displayed
--
-- Returns:
--
-- a **sequence** containing two elements:
--# an **integer** a non zero value if successful
--# a **string**: containing the resulting text value
--
-- The function does not allocate memory space to store the text entered by
-- the user. Therefore, the text parameter must be large enough to contain the
-- user input. The returned string is limited to //maxsize// characters.
--*/
--------------------------------------------------------------------------------
-- IUP_API void IupMessage(const char *title, const char *msg);
--------------------------------------------------------------------------------
public function IupMessage(string title, string message)  -- shows a modal dialog containing a message
    return doC("IupMessage", {C_POINTER, C_POINTER},
                {allocate_string(title), allocate_string(message)})
end function
--------------------------------------------------------------------------------
--/*
-- This procedure simply creates and then pops up a ##MessageDlg##.
--
-- Parameters:
--# ##title##: the **string** to put in the title
--# ##message##: the **string** to put in the body of the dialog
--
-- Notes:
--
-- The ##Message## routine shows a dialog centralised on the screen, showing
-- the message and the "OK" button.
-- The '\n' character can be added to the message to indicate a line change.
--
-- The dialog uses a global attribute called "PARENTDIALOG" as the parent
-- dialog if it is defined.
-- It also uses a global attribute called "ICON" as the dialog icon if it is
-- defined (used only in Motif; in Windows MessageBox does not have an icon in
-- the title bar).
--*/
--------------------------------------------------------------------------------
-- IUP_API int IupMessageAlarm(Ihandle* parent, const char* title, const char *message, const char *buttons);
--------------------------------------------------------------------------------
public function IupMessageAlarm(Ihandle parent = NULL, string title = "", string message, string buttons)  -- shows a modal dialog containing a question message, similar to IupAlarm
    return doC("IupMessageAlarm", {C_POINTER, C_POINTER, C_POINTER, C_POINTER},
                {parent, allocate_string(title), allocate_string(message),
                allocate_string(buttons)}, C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- It simply creates and popup a IupMessageDlg with DIALOGTYPE=QUESTION.
--
-- Parameters:
--# //parent//: parent dialog, can be NULL
--# //title//: the **string** to put in the title
--# //message//: the **string** to put in the body of the dialog
--# //buttons//: list of buttons- "OK", "OKCANCEL", "RETRYCANCEL", "YESNO",
-- or "YESNOCANCEL"
--
-- Returns:
--
-- an **integer**: the number of the button selected by the user (1, 2 or 3).
--*/
--------------------------------------------------------------------------------
-- IUP_API void IupMessageError(Ihandle* parent, const char* message);
--------------------------------------------------------------------------------
public function IupMessageError(Ihandle parent = NULL, string message)  -- shows a modal dialog containing an error message
    return doC("IupMessageError", {C_POINTER, C_POINTER},
                {parent, allocate_string(message)})
end function
--------------------------------------------------------------------------------
--/*
-- It simply creates and popup a IupMessageDlg with DIALOGTYPE=ERROR.
--
-- Parameters:
--# //parent//: parent dialog, can be NULL
--# //message//: the **string** to put in the body of the dialog
--
-- Notes:
--
-- If parent is NULL the title defaults to "Error!" and tries the global attribute
-- "PARENTDIALOG" as the parent dialog.
--
-- The dialog title will be the same title of the parent dialog.
--
--The dialog is shown centered relative to its parent.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupParamBox(Ihandle* param, ...);
--------------------------------------------------------------------------------
public function IupParamBox(sequence params) -- creates a void container for composing elements created using a list of IupParam elements
    if length(params) then return doCN("IupParamBox", C_POINTER, params, C_POINTER)
    else return NULL
    end if
end function
--------------------------------------------------------------------------------
--/*
-- Each param is used to create several lines of controls internally arranged in a
-- vertical composition.
--
--It does not have a native representation.
--
-- Returns:
--
-- a **Ihandle**: the identifier of the created element, or NULL if an error occurs
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupProgressDlg(void);
--------------------------------------------------------------------------------
public function IupProgressDlg() -- creates a progress dialog element
    return doC("IupProgressDlg", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It is a predefined dialog for displaying the progress of an operation.
-- The dialog is meant to be shown with the show functions ##IupShow## or
-- ##IupShowXY##.
--
-- Returns:
--
-- An **Ihandle**: the identifier of the created element,
-- or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle* IupClassInfoDialog(Ihandle* parent);
--------------------------------------------------------------------------------
public function IupClassInfoDialog(Ihandle parent) -- creates an Iup Class Information dialog
    return doC("IupElementPropertiesDialog", {C_POINTER}, {parent}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
--  It is a predefined dialog to show all registered classes, each class
-- attributes and callbacks.
-- It is a standard IupDialog constructed with other IUP elements.
-- The dialog can be shown with any of the show functions IupShow, IupShowXY
-- or IupPopup.
--
-- This is a dialog intended for developers, so they can see attributes and
-- callbacks information of a class.
--
-- Returns:
--
-- An **Ihandle**: the identifier of the created element,
-- or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle* IupElementPropertiesDialog(Ihandle* parent, Ihandle* elem);
--------------------------------------------------------------------------------
public function IupElementPropertiesDialog(Ihandle parent, Ihandle elem) -- creates an Element Properties Dialog
    return doC("IupElementPropertiesDialog", {C_POINTER, C_POINTER}, {parent, elem}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It is a predefined dialog to edit the properties of an element in run time.
-- It is a standard IupDialog constructed with other IUP elements.
-- The dialog can be shown with any of the show functions IupShow, IupShowXY or IupPopup.
--
-- Any existent element can be edited.
-- It does not need to be mapped on the native system nor visible.
-- It could have been created in any language.
--
-- This is a dialog intended for developers, so they can see and inspect their
-- elements in other ways.
--
-- It contains 3 Tab sections: one for the registered attributes of the element,
-- one for custom attributes set by the application, and one for the callbacks.
-- The callbacks are just for inspection, and custom attributes should be handled
-- carefully because they may be not strings.
-- Registered attributes values are shown in red when they were changed by the
-- application.
--
-- Returns:
--
-- An **Ihandle**: the identifier of the created element,
-- or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle* IupLayoutDialog(Ihandle* dialog);
--------------------------------------------------------------------------------
public function IupLayoutDialog(Ihandle dialog) -- creates a Layout Dialog
    return doC("IupLayoutDialog", {C_POINTER}, {dialog}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It is a predefined dialog to edit visually the layout of another dialog in
-- run time.
-- It is a standard IupDialog constructed with other IUP elements.
-- The dialog can be shown with any of the show functions IupShow, IupShowXY
-- or IupPopup.
--
-- Any existent dialog can be selected. It does not need to be mapped on the
-- native system nor visible.
--
-- The layout dialog is composed by two areas: one showing the given dialog
-- children hierarchy tree, and one displaying its layout.
--
-- This is a dialog intended for developers, so they can see and inspect their
-- dialogs in other ways.
--
-- Returns:
--
-- An **Ihandle**: the identifier of the created element,
-- or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
--/*
--==== Dialog actions
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupHide          (Ihandle* ih);
--------------------------------------------------------------------------------
public function IupHide(Ihandle widget) -- hides an interface element
    return doC("IupHide", {C_POINTER}, {widget}, C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- This function has the same effect as attributing value "NO" to the interface
-- element’s VISIBLE attribute.
--
-- Parameter:
--# //widget//: the dialog or menu to hide
--
-- Returns:
--
-- IUP_NOERROR always.
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupPopup         (Ihandle* ih, int x, int y);
--------------------------------------------------------------------------------
public function IupPopup(Ihandle widget, integer x, integer y) -- shows a dialog or menu and restricts user interaction only to the specified element
    return doC("IupPopup", {C_POINTER, C_INT, C_INT}, {widget, x, y}, C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- ##IupPopup## is equivalent of creating a Modal dialog is some toolkits.
--
-- If another dialog is shown after IupPopup using IupShow, then its interaction
-- will not be inhibited. Every IupPopup call creates a new popup level that
-- inhibits all previous dialogs interactions, but does not disable new ones
-- (even if they were disabled by the Popup, calling IupShow will re-enable the
-- dialog because it will change its popup level).
-- IMPORTANT: The popup levels must be closed in the reverse order they were
-- created or unpredictable results will occur.
--
-- For a dialog this function will only return the control to the application
-- after a callback returns IUP_CLOSE, IupExitLoop is called, or when the popup
-- dialog is hidden, for example using IupHide. For a menu it returns
-- automatically after a menu item is selected.
-- IMPORTANT: If a menu item callback returns IUP_CLOSE, it will also ends the
-- current popup level dialog.
--
-- Parameters:
--# //widget//: the dialog or menu to display
--# //x//: horizontal position of the top-left corner of the window or menu,
--  relative to the origin of the main screen
--# //y//: vertical position of the top-left corner of the window or menu,
--  relative to the origin of the main screen
--
-- Returns:
--
-- an **integer**: one of IUP_NOERROR (if successful), IUP_INVALID
-- (if not a dialog or menu); IUP_ERROR (if there was an error)
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupShow          (Ihandle* ih);
--------------------------------------------------------------------------------
public function IupShow(Ihandle dialog)   -- displays a dialog in the current display space
    return doC("IupShow", {C_POINTER}, {dialog}, C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# //dialog//: the dialog to be displayed
--
-- Returns:
--
-- IUP_NOERROR if successful. If there was an error returns IUP_ERROR.
--
-- Notes:
--
-- For dialogs it is equivalent to call IupShowXY using IUP_CURRENT.
-- See ##IupShowXY## for more details.
--
-- For other controls, to call ##IupShow ##is the same as setting VISIBLE=YES.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupShowXY        (Ihandle* ih, int x, int y);
--------------------------------------------------------------------------------
public function IupShowXY(Ihandle dialog, integer x, integer y)   -- displays a dialog in a specific position
    return doC("IupShowXY", {C_POINTER, C_INT, C_INT}, {dialog, x, y}, C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- Displays a dialog in a given position on the screen. The values x and y give
-- the horizontal and vertical positions respectively of the top left corner of
-- the window, relative to the origin of the main screen.
--
-- Parameters:
--# //dlg// - identifier of the dialog;
--# //x//, //y// - co-ordinates from the top left corner of the window,
-- relative to the origin of the main screen.
--
-- The following definitions can also be used for //x//:
--* IUP_LEFT: Positions the dialog on the left corner of the main screen
--* IUP_CENTER: Horizontally centralizes the dialog on the main screen
--* IUP_RIGHT: Positions the dialog on the right corner of the main screen
--* IUP_MOUSEPOS: Positions the dialog on the mouse position
--* IUP_CENTERPARENT: Horizontally centralizes the dialog relative to its parent (Since 3.0)
--* IUP_CURRENT: use the current position of the dialog. This is the default value in Lua if the parameter is not defined. (Since 3.0)
--
-- The following definitions can also be used for //y//:
--* IUP_TOP: Positions the dialog on the top of the main screen
--* IUP_CENTER: Vertically centralizes the dialog on the main screen
--* IUP_BOTTOM: Positions the dialog on the base of the main screen
--* IUP_MOUSEPOS: Positions the dialog on the mouse position
--* IUP_CENTERPARENT: Vertically centralizes the dialog relative to its parent (Since 3.0)
--* IUP_CURRENT: use the current position of the dialog. This is the default value in Lua if the parameter is not defined.(Since 3.0)
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupDestroy      (Ihandle* ih)
--------------------------------------------------------------------------------
public function IupDestroy(Ihandle widget)  -- destroys an interface element and all its children
    return doC("IupDestroy", {C_POINTER}, {widget})
end function
--------------------------------------------------------------------------------
--/*
-- Only dialogs, timers, popup menus and images should be normally destroyed,
-- but detached controls can also be destroyed.
--
-- Parameter:
--# //widget//: the control to be destroyed
--
-- Notes:
--
-- The procedure ##destroy## will automatically unmap and detach the element,
-- if necessary, and then destroy the element.
--
-- This routine also deletes the main names associated to the interface element
-- being destroyed, but if it has more than one name then some names may be
-- left behind.
--
-- Menu bars associated with dialogs are automatically destroyed when the dialog
-- is destroyed.
--
-- Images associated with controls are NOT automatically destroyed,
-- because images can be reused in several controls the application must
-- destroy them when they are not used anymore.
--
-- All dialogs and all elements that have names are automatically destroyed when
-- ##IupClose## is invoked.
--*/
--------------------------------------------------------------------------------
--/*
--==== Containers
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupBackgroundBox(Ihandle* child);
--------------------------------------------------------------------------------
public function IupBackgroundBox(Ihandle child = NULL) -- creates a simple native container with no decorations
    return doC("IupBackgroundBox", {C_POINTER}, {child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# //child//: Identifier of an interface element which will receive the box.
-- It can be NULL.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupCbox       (Ihandle* child, ...);
--------------------------------------------------------------------------------
public function IupCbox(sequence children = {})  -- creates a void container for position elements in absolute coordinates. It is a concrete layout container.
    return doCN("IupCbox", C_POINTER, children, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- ##IupCbox## does not have a native representation.
--
-- ##IupCbox## is the equivalent of an ##IupVbox## or an ##IupHbox##
-- where all the children have the FLOATING attribute set to YES,
-- but children must use CX and CY attributes instead of the POSITION attribute.
--
-- Parameter:
--# //children//: an array of compositional elements to be displayed in the box.
-- It can be empty (the default).
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupDetachBox  (Ihandle* child);
--------------------------------------------------------------------------------
public function IupDetachBox(Ihandle child = NULL)
    return doC("IupDetachBox", {C_POINTER}, {child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Creates a detachable void container.
--
-- Dragging and dropping this element, it creates a new dialog composed by
-- its child or elements arranged in it (for example, a child like {{{IupVbox or
-- IupHbox).}}} During the drag, the ESC key can be pressed to cancel the action.
--
-- It does not have a native representation, but it contains also a {{{IupCanvas}}}
-- to implement the bar handler.
--
-- Parameter: ##child## - Identifier of an interface element.
-- It can be NULL.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupExpander(Ihandle* child);
--------------------------------------------------------------------------------
public function IupExpander(Ihandle child = NULL) -- creates a container that can interactively show or hide its child
    return doC("IupExpander", {C_POINTER}, {child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It does not have a native representation, but it contains also several
-- elements to implement the bar handler.
--
-- Parameter: ##child## - Identifier of an interface element.
-- It can be NULL.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupFlatFrame  (Ihandle* child);
--------------------------------------------------------------------------------
public function IupFlatFrame(Ihandle child = NULL)	-- creates a native container, which draws a frame with a title around its child
    return doC("IupFlatFrame", {C_POINTER}, {child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# ##child##: Identifier of an interface element which the frame surrounds.
-- It can be NULL.
--
-- The decorations are manually drawn.
-- The control inherits from IupBackgroundBox.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupFlatScrollBox(Ihandle* child);
--------------------------------------------------------------------------------
public function IupFlatScrollBox(Ihandle child = NULL)	-- creates a native container that allows its child to be scrolled
    return doC("IupFlatScrollBox", {C_POINTER}, {child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# ##child##: Identifier of an interface element which will receive the box.
-- It can be NULL.
--
-- The difference from ##IupScrollBox## is that its scrollbars are drawn.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupFlatTabs   (Ihandle* first, ...);
--------------------------------------------------------------------------------
public function IupFlatTabs(sequence children = {})	-- creates a native container for composing elements in hidden layers with only one layer visible
    return doCN("IupFlatTabs", C_POINTER, children, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# //children//: an array of compositional elements to be displayed in the box.
-- It can be empty (the default).
--
-- Its visibility can be interactively controlled.
-- The interaction is done in a line of tabs with titles and arranged according
-- to the tab type. Also known as Notebook in native systems.
-- Identical to the ##IupTabs## control but the decorations and buttons are manually
-- drawn. It inherits from ##IupCanvas##.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupFlatVal   (Ihandle* const char *orientation);
--------------------------------------------------------------------------------
public function IupFlatVal(object orientation = NULL)	-- creates a Valuator control, but it does not have native decorations
    if string(orientation) then orientation = allocate_string(orientation) end if
    return doC("IupFlatVal", C_POINTER, {orientation}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It behaves just like an IupVal, but since it is not a native control it has
-- more flexibility for additional options. But ticks are NOT supported.
--
-- Parameter:
--# //orientation//: optional orientation of valuator.
-- It can be NULL - see ORIENTATION attribute.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupFrame      (Ihandle* child);
--------------------------------------------------------------------------------
public function IupFrame(Ihandle child = NULL)	-- creates a native container, which draws a frame with a title around its child
    return doC("IupFrame", {C_POINTER}, {child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# ##child##: Identifier of an interface element which the frame surrounds.
-- It can be NULL.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupGridBox    (Ihandle* child, ...);
--------------------------------------------------------------------------------
public function IupGridBox(sequence children = {})  -- creates a void container composing elements in a regular grid
    return doCN("IupGridBox", C_POINTER, children, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It is a box that arranges the elements it contains from top to bottom and
-- from left to right, but can distribute the elements in lines or in columns.
--
-- Parameter:
--# //children//: an array of compositional elements to be displayed in the box.
-- It can be empty (the default).
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
--  IUP_API Ihandle*  IupHbox       (Ihandle* child, ...);
--------------------------------------------------------------------------------
public function IupHbox(sequence children = {})  -- creates a void container for composing elements horizontally; it is a box that arranges the elements it contains from left to right.
    return doCN("IupHbox", C_POINTER, children, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- ##Hbox## does not have a native representation.
--
-- Parameter:
--# //children//: an array of compositional elements to be displayed in the box.
-- It can be empty (the default).
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupMultiBox   (Ihandle* child, ...);
--------------------------------------------------------------------------------
public function IupMultiBox(sequence children = {})  -- creates a void container for composing elements in a irregular grid
    return doCN("IupMultiBox", C_POINTER, children, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It is a box that arranges the elements it contains from top to bottom and
-- from left to right, by distributing the elements in lines or in columns.
-- But its EXPAND attribute does not behave as a regular container,
-- instead it behaves as a regular element expanding into the available space.
--
-- Parameter:
--# //children//: an array of compositional elements to be displayed in the box.
-- It can be empty (the default).
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupNormalizer (Ihandle* ih_first, ...);
--------------------------------------------------------------------------------
public function IupNormalizer(sequence ih_first = {})  -- creates a void container that does not affect the dialog layout
    return doCN("IupNormalizer", C_POINTER, ih_first, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It acts by normalizing all the controls in a list so their natural size
-- becomes the biggest natural size amongst them.
-- All natural widths will be set to the biggest width, and all natural heights
-- will be set to the biggest height.
-- The controls of the list must be inside a valid container in the dialog.
--
-- Parameter:
--# //ih_first//: List of the identifiers that will be normalized.
-- It can be empty (the default).
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupRadio      (Ihandle* child);
--------------------------------------------------------------------------------
public function IupRadio(Ihandle child = NULL) -- creates a void container for grouping mutual exclusive toggles
    return doC("IupRadio", {C_POINTER}, {child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Only one of its descendent toggles will be active at a time.
-- The toggles can be at any composition.
--
-- It does not have a native representation.
--
-- Parameter:
--# ##child##: Identifier of an interface element.
-- Usually it is a vbox or an hbox containing the toggles associated with the radio.
-- It can be NULL.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupSbox       (Ihandle* child);
--------------------------------------------------------------------------------
public function IupSbox(Ihandle child = NULL) -- creates a void container that allows its child to be resized
    return doC("IupSbox", {C_POINTER}, {child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
--  Allows expanding and contracting the child size in one direction.
--
-- It does not have a native representation but it contains also a IupFlatSeparator
-- to implement the bar handler.
--
-- Parameter:
--# ##child##: Identifier of an interface element which will receive the box.
-- It can be NULL.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupSplit      (Ihandle* child1, Ihandle* child2);
--------------------------------------------------------------------------------
public function IupSplit(Ihandle child1 = NULL, Ihandle child2 = NULL) -- creates a void container that split its client area in two
    return doC("IupSplit", {C_POINTER, C_POINTER}, {child1, child2}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Allows the provided controls to be enclosed in a box that allows expanding
-- and contracting the element size in one direction,
-- but when one is expanded the other is contracted.
--
-- It does not have a native representation, but it contains also a
-- IupFlatSeparator to implement the bar handler.
--
-- Parameters:
--# ##child1##: Identifier of an interface element that will be at left or top.
-- It can be NULL.
--# ##child2##: Identifier of an interface element that will be at right or bottom.
-- It can be NULL.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupScrollBox  (Ihandle* child);
--------------------------------------------------------------------------------
public function IupScrollBox(Ihandle child = NULL) -- creates a native container that allows its child to be scrolled
    return doC("IupScrollBox", {C_POINTER}, {child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It inherits from {{{IupCanvas.}}}
--
-- Parameter:
--# //child//: Identifier of an interface element,
-- which will receive the box. It can be NULL.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupTabs       (Ihandle* child, ...);
--------------------------------------------------------------------------------
public function IupTabs(sequence children = {})  -- creates a void container for composing elements vertically; it is a box that arranges the elements it contains from top to bottom.
    return doCN("IupTabs", C_POINTER, children, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# //children//: an array of compositional elements to be displayed in the box.
-- It can be empty (the default).
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupVbox       (Ihandle* child, ...);
--------------------------------------------------------------------------------
public function IupVbox(sequence children = {})  -- creates a void container for composing elements vertically; it is a box that arranges the elements it contains from top to bottom.
    return doCN("IupVbox", C_POINTER, children, C_POINTER)
end function
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupVboxv      (Ihandle* *children);
--------------------------------------------------------------------------------
public function IupVboxv(sequence children = {})  -- creates a void container for composing elements vertically; it is a box that arranges the elements it contains from top to bottom.
	atom p_children = allocate_pointer_array(children)
	sequence e_args = {p_children}
	free(p_children)
    return doC("IupVboxv", {C_POINTER}, e_args, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- ##Vbox## does not have a native representation.
--
-- Parameter:
--# //children//: an array of compositional elements to be displayed in the box.
-- It can be empty (the default).
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupZbox       (Ihandle* child, ...);
--------------------------------------------------------------------------------
public function IupZbox(sequence children = {})  -- creates a void container for composing elements in hidden layers with only one layer visible
    return doCN("IupZbox", C_POINTER, children, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It is a box that piles up the children it contains;
-- only the one child is visible.
--
-- It does not have a native representation.
--
-- Parameter:
--# //children//: Identifier of an interface element,
-- that will be placed in the box. It can be NULL.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
--/*
--*/
--------------------------------------------------------------------------------
--/*
--==== Controls
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupAnimatedLabel(Ihandle* animation);
--------------------------------------------------------------------------------
public function IupAnimatedLabel(Ihandle animation) -- creates an animated label interface element, which displays an image that is changed periodically
    return doC("IupAnimatedLabel", {C_POINTER}, animation, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# //animation//: element that contains the list of images. It can be NULL.
--
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error
-- occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupButton     (const char* title, const char* action);
--------------------------------------------------------------------------------
public function IupButton(string title = "", object action = NULL)  -- creates a button interface element, which displays a separator, a text or an image
	sequence arg
	if atom(action) then
		arg = {allocate_string(title), action}
	else
		arg = {allocate_string(title), allocate_string(action)}
	end if
	return doC("IupButton", {C_POINTER, C_POINTER}, arg, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameters:
--# //title//: the text to be shown on the button.
-- It can be EMPTY. It will set the TITLE attribute.
--# //action//: the name of the action generated when the button is selected.
-- It can be NULL.
--
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error
-- occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupCalendar   (void);
--------------------------------------------------------------------------------
public function IupCalendar() -- creates a month calendar interface element, where the user can select a date
    return doC("IupCalendar", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupCanvas       (const char* action);
--------------------------------------------------------------------------------
public function IupCanvas(object action = NULL)  -- creates an interface element that is a canvas - a drawing area for your application
    return doC("IupCanvas", {C_POINTER}, {toCOrNot(action)}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# ##action##: the name of the action generated when the user types something,
-- or //NULL/.
--
-- Returns: the (**Ihandle**) identifier of the created element, or //NULL// if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupColorbar   (void);
--------------------------------------------------------------------------------
public function IupColorbar() -- creates a color palette to enable a color selection from several samples
    return doC("IupColorbar", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupColorBrowser(void)
--------------------------------------------------------------------------------
public function IupColorBrowser() -- creates an element for selecting a colour
    return doC("IupColorBrowser", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- Note:
--
--The selection is done using a cylindrical projection of the RGB cube.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupDatePick   (void)
--------------------------------------------------------------------------------
public function IupDatePick() -- creates a date editing interface element, which can displays a calendar for selecting a date
    return doC("IupDatePick", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupDial       (const char* type)
--------------------------------------------------------------------------------
public function IupDial(string orientation) -- creates a dial for regulating a given angular variable
    return doC("IupDial", {C_POINTER}, {allocate_string(orientation)}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# //orientation//: optional dial orientation, can be NULL;
--  see ORIENTATION attribute
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupDropButton (Ihandle* dropchild);
--------------------------------------------------------------------------------
public function IupDropButton(Ihandle dropchild) -- creates an interface element that is a button with a drop down arrow
    return doC("IupDropButton", {C_POINTER}, {dropchild}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# //dropchild//: identifier of an interface element to be displayed when the
--  dropdown is activated. It can be NULL.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--
-- Notes:
--
-- //dropchild// is not a regular child of the dropbutton.
-- It will be displayed inside a dialog with no decorations.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupFill (void);
--------------------------------------------------------------------------------
public function IupFill() 	-- creates a void element, which dynamically occupies empty spaces always trying to expand itself
	return doC("IupFill", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Its parent should be an IupHbox, an IupVbox or a IupGridBox, or else this
-- type of expansion will not work.
-- If //EXPAND// is set on at least one of the other children of the box, then
-- the fill expansion is ignored.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupFlatButton (const char* title);
--------------------------------------------------------------------------------
public function IupFlatButton(string title = "")  -- creates an interface element that is a button, but it does not have native decorations
	return doC("IupFlatButton", {C_POINTER}, {allocate_string(title)}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# //title//: the text to be shown on the button.
-- It can be EMPTY. It will set the TITLE attribute.
--
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error
-- occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupFlatLabel  (const char* title)
--------------------------------------------------------------------------------
public function IupFlatLabel(string title = "")  -- creates an interface element that is a label, but it does not have native decorations
	return doC("IupFlatLabel", {C_POINTER}, {allocate_string(title)}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# //title//: the text to be shown  to the user.
-- It can be EMPTY. It will set the TITLE attribute.
--
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error
-- occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupFlatList   (void)
--------------------------------------------------------------------------------
public function IupFlatList()  -- creates an interface element that displays a list of items, but it does not have native decorations
	return doC("IupFlatList", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error
-- occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupFlatSeparator(void)
--------------------------------------------------------------------------------
public function IupFlatSeparator()  -- creates an interface element that is a Separator, but it does not have native decorations
	return doC("IupFlatSeparator", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error
-- occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupFlatToggle (const char* title)
--------------------------------------------------------------------------------
public function IupFlatToggle(string title = "")  -- creates an interface element that is a toggle, but it does not have native decorations
	return doC("IupFlatLabel", {C_POINTER}, {allocate_string(title)}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# //title//: the text to be shown  to the user.
-- It can be EMPTY. It will set the TITLE attribute.
--
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error
-- occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupFlatTree   (void)
--------------------------------------------------------------------------------
public function IupFlatTree()  -- creates a tree containing nodes of branches or leaves
	return doC("IupFlatTree", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error
-- occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupGauge      (void);
--------------------------------------------------------------------------------
public function IupGauge() -- creates a Gauge control
    return doC("IupGauge", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupLabel      (const char* title);
--------------------------------------------------------------------------------
public function IupLabel(string title = "")  -- creates a label interface element, which displays a separator, a text or an image
	return doC("IupLabel", {C_POINTER}, {allocate_string(title)}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# //title//: the text to be shown on the label. It can be EMPTY. It will set the TITLE attribute.
--
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupLink       (const char* url, const char* title);
--------------------------------------------------------------------------------
public function IupLink(string url, string title = "") -- creates a label that displays an underlined clickable text
	return doC("IupLink", {C_POINTER, C_POINTER}, {allocate_string(url), allocate_string(title)}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It inherits from IupLabel.
-- Parameters:
--# //url//: the destination address of the link.
--# //title//: the text to be shown on the link. It can be EMPTY. It will set the TITLE attribute.
--
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupList       (const char* action);
--------------------------------------------------------------------------------
public function IupList(object action = NULL) -- creates an interface element that displays a list of items
    if atom(action) then -- action = action
    else action = allocate_string(action)
    end if
    return doC("IupList", {C_POINTER}, {action}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- The list can be visible or can be dropped down.
-- It also can have an edit box for text input.
-- So it is a 4 in 1 element.
-- In native systems the dropped down case is called a Combo Box.
--
-- Parameter:
--# //action//: the name of the action generated when the button is selected.
-- It can be NULL.
--
-- Returns: the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupProgressBar(void);
--------------------------------------------------------------------------------
public function IupProgressBar() -- creates a progress bar control
    return doC("IupProgressBar", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Shows a percent value that can be updated to simulate a progression.
--
-- It is similar of IupGauge, but uses native controls internally.
-- Also does not have support for text inside the bar.
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupSpace(void);
--------------------------------------------------------------------------------
public function IupSpace() 	-- creates a void element, which occupies an empty space
	return doC("IupSpace", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- It does not have a native representation.
--
-- When an IupFill is inside a IupVbox or IupHbox it will affect the expansion
-- of the box because it is always expandable.
-- Even when you set its size to a given value, it will still affect the layout,
-- because it is always marked as an expandable element.
--
-- ##IupSpace## will simply occupy a space in the layout.
-- It does not have a natural size, it is 0x0 by default.
-- It can be expandable or not, EXPAND will work as a regular element.
-- The attributes SIZE and RASTERSIZE can be normally set.
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupSpin       (void);
--------------------------------------------------------------------------------
public function IupSpin() -- create a control set with a vertical box containing two buttons
    return doC("IupSpin", , , C_POINTER)
end function
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupSpinbox    (Ihandle* child);
--------------------------------------------------------------------------------
public function IupSpinbox(Ihandle child) -- create a control set with a vertical box containing two buttons
    return doC("IupSpinbox", {C_POINTER}, {child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- The buttons, one with an up arrow and the other with a down arrow,
-- are used to increment and decrement values.
--
-- Unlike the SPIN attribute of the IupText element, the IupSpin element
-- can NOT automatically increment the value and it is NOT inserted inside
-- the IupText area. But they can be used with any element.
--
-- Parameter:
-- # //child//: the widget enclosed by the spinbox
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupText       (const char* action);
--------------------------------------------------------------------------------
public function IupText(object action = NULL)  -- creates an editable text field
    return doC("IupText", {C_POINTER}, {toCOrNot(action)}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# ##action##: the name of the action generated when the user types something,
-- or //NULL/.
--
-- Returns: the (**Ihandle**) identifier of the created element, or //NULL// if an error occurs.
--*/
--------------------------------------------------------------------------------
-- void IupTextConvertLinColToPos(Ihandle* ih, int lin, int col, int *pos)
-- usage: IupTextConvertLinColToPos(ih, lin, col, &pos)
--------------------------------------------------------------------------------
public function IupTextConvertLinColToPos(Ihandle ih, sequence lnc) -- converts a (lin, col) character positioning into an absolute position
    integer lin = lnc[1], col = lnc[2]
    atom pos = allocate(sizeof(C_INT))
    doC("IupTextConvertLinColToPos",
                {C_POINTER, C_INT, C_INT, C_POINTER},
                {ih, lin, col, pos})
    integer ret = peek(pos)
    free(pos)
    return ret + 1 -- forced to be OE-compliant
end function
--------------------------------------------------------------------------------
--/*
-- Parameters:
--# //lin// and //col// starts at 1,
--# //pos// starts at 0.
-- For single line controls //pos// is always //col-1//.
--*/
--------------------------------------------------------------------------------
-- IUP_API void  IupTextConvertPosToLinCol(Ihandle* ih, int pos, int *lin, int *col);
-- usage: IupTextConvertPosToLinCol(ih, pos, &lin, &col)
--------------------------------------------------------------------------------
public function IupTextConvertPosToLinCol(Ihandle ih, integer pos) -- converts an absolute position into a (lin, col) character positioning
    integer sCI = sizeof(C_INT)
    atom lin = allocate(sCI)
    atom col = allocate(sCI)
    doC("IupTextConvertPosToLinCol",
                {C_POINTER, C_INT, C_POINTER, C_POINTER},
                {ih, pos-1, lin, col}) -- IUP is zero-referenced
    sequence ret = {peek(lin), peek(col)}
    free(lin)
    free(col)
    return ret
end function
--------------------------------------------------------------------------------
--/*
-- Parameters:
--# //lin// and //col// starts at 1,
--# //pos// starts at 0.
-- For single line controls lin is always 1, and col is always //pos+1//.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupToggle     (const char* title, const char* action);
--------------------------------------------------------------------------------
public function IupToggle(string title = "", object action = NULL)  -- the toggle interface element
    sequence arg
    if atom(action) then
        arg = {allocate_string(title), action}
    else
        arg = {allocate_string(title), allocate_string(action)}
    end if
    return doC("IupToggle", {C_POINTER, C_POINTER}, arg, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- A toggle is a two-state (on/off) button that, when selected, generates an
-- action that activates a function in the associated application.
-- Its visual representation can contain a text or an image.
--
-- Parameters:
--# //title//: the text to be shown on the button.
-- It can be EMPTY. It will set the TITLE attribute.
--# //action//: the name of the action generated when the button is selected.
-- It can be NULL.
--
-- Returns:
--
-- the (**Ihandle**) identifier of the created element, or NULL if an error
-- occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupTree       (void);
--------------------------------------------------------------------------------
public function IupTree() -- creates a tree containing nodes of branches or leaves
    return doC("IupTree", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Both branches and leaves can have an associated text and image.
--
-- The branches can be expanded or collapsed. When a branch is expanded,
-- its immediate children are visible, and when it is collapsed they are hidden.
--
-- The leaves can generate an "executed" or "renamed" actions, branches can only
--  generate a "renamed" action.
--
-- The focus node is the node with the focus rectangle, marked nodes have their
-- background inverted.
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupVal        (const char *type);
--------------------------------------------------------------------------------
public function IupVal(object orientation = NULL) -- creates a Valuator control
    if string(orientation) then orientation = allocate_string(orientation) end if
    return doC("IupVal", {C_POINTER}, {orientation}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Selects a value in a limited interval.
-- Also known as Scale or Trackbar in native systems.
--
-- Parameter:
--# //orientation//: optional orientation of valuator.
-- It can be NULL - see ORIENTATION attribute.
--
-- Returns:
--
--the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--/*
--==== Menus
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupMenu       (Ihandle* child, ...);
--------------------------------------------------------------------------------
public function IupMenu(sequence items)
	atom pItems = allocate_pointer_array(items)
	atom result = doC("IupMenuv", {C_POINTER}, {pItems}, C_POINTER)
	free(pItems)
	return result
end function
--------------------------------------------------------------------------------
--/*
-- Creates a menu element, which groups 3 types of interface elements:
-- item, submenu and separator.
-- Any other interface element defined inside a menu will be an error.
--
-- Parameter:
--# //items//: sequence containing one or more items in the menu.
-- It can be empty.
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupItem       (const char* title, const char* action);
--------------------------------------------------------------------------------
public function IupItem(object title = NULL, object action = NULL)
	sequence arg = {NULL, action}
    if sequence(title) then
        arg[1] = allocate_string(title)
    end if
    if sequence(action) then
        arg[2] = allocate_string(action)
    end if
    return doC("IupItem", {C_POINTER, C_POINTER}, arg, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Creates an item of the menu interface element.
-- It is so created that to generate an action, when selected, a specific
-- call-back function is needed.
--
-- Parameters:
--# //title//: text to be shown on the toggle. It can be NULL.
-- It will set the TITLE attribute.
--# //action//: name of the action generated when the button is selected. It can be NULL.
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupSeparator  (void);
--------------------------------------------------------------------------------
public function IupSeparator()
	return doC("IupSeparator", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Creates the separator interface element.
--It shows a line between two menu items.
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupSubmenu    (const char* title, Ihandle* child);
--------------------------------------------------------------------------------
export function IupSubmenu(object title = NULL, object menu = NULL)
	sequence arg = {NULL, menu}
    if sequence(title) then
        arg[1] = allocate_string(title)
    end if
	return doC("IupSubmenu", {C_POINTER, C_POINTER}, arg, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Creates a menu item that, when selected, opens another menu.
--
-- Parameters:
--# //title//: text to be shown on the toggle. It can be NULL.
-- It will set the TITLE attribute.
--# //menu//: optional child menu identifier. It can be NULL.
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--*/
--------------------------------------------------------------------------------
--/*
-- Example, using all menu elements:
-- <eucode>
-- --menus.exw
--
-- include iup.ew
--
-- function selected_cb(atom self)
--     IupMessage("IupMenu", "You selected: " & IupGetAttribute(self, "TITLE") & "!")
--     return IUP_CONTINUE
-- end function
--
-- function exit_cb()
--     return IUP_CLOSE
-- end function
--
-- IupOpen()
--
-- constant
-- 	item_open = IupItem("&Open"),
-- 	item_save = IupItem("&Save"),
-- 	item_undo = IupItem("&Undo"),
-- 	item_exit = IupItem("E&xit"),
-- 	menu_file = IupMenu({item_open, item_save, item_undo, IupSeparator(), item_exit}),
-- 	sub1_menu = IupSubmenu("File", menu_file),
-- 	menu = IupMenu({sub1_menu})
--
-- IupSetHandle("mymenu", menu)
--
-- constant dlg = IupDialog(IupCanvas())
--
-- IupSetAttribute(item_undo, "ACTIVE", "NO")
-- IupSetCallback(item_exit, "ACTION", Icallback(routine_id("exit_cb")))
-- IupSetCallback(item_open, "ACTION", Icallback(routine_id("selected_cb")))
-- IupSetCallback(item_save, "ACTION", Icallback(routine_id("selected_cb")))
-- IupSetAttributes(dlg, "SIZE = HALFxHALF, TITLE = Menus, MENU = mymenu")
--
-- IupShow(dlg)
-- IupMainLoop()
--
-- IupClose()</eucode>
--*/
--------------------------------------------------------------------------------
--/*
--==== Events
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupExitLoop      (void);
--------------------------------------------------------------------------------
public function IupExitLoop() -- terminates the current message loop
    return doC("IupExitLoop")
end function
--------------------------------------------------------------------------------
--/*
-- It has the same effect of a callback returning IUP_CLOSE.
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupFlush         (void);
--------------------------------------------------------------------------------
public function IupFlush() -- processes all pending messages in the message queue
    return doC("IupFlush")
end function
--------------------------------------------------------------------------------
-- IUP_API int       IupLoopStep      (void);
--------------------------------------------------------------------------------
public function IupLoopStep()  -- runs one iteration of the message loop
	return doC("IupLoopStep", , , C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- Returns immediately after processing any messages or if there are no messages
-- to process.
--
-- Returns:
--
-- an **integer**: //IUP_CLOSE// or //IUP_DEFAULT//
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupLoopStepWait  (void);
--------------------------------------------------------------------------------
public function IupLoopStepWait()  -- runs one iteration of the message loop
	return doC("IupLoopStepWait", , , C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- Puts the system into idle mode until a message is processed
--
-- Returns:
--
-- an **integer**: //IUP_CLOSE// or //IUP_DEFAULT//
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupMainLoop      (void);
--------------------------------------------------------------------------------
public function IupMainLoop()  -- executes the user interaction until a callback returns IUP_CLOSE, or IupExitLoop is called, or the last visible dialog is hidden
	return doC("IupMainLoop", , , C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- IUP_NOERROR always.
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupMainLoopLevel (void);
--------------------------------------------------------------------------------
public function IupMainLoopLevel() --> [integer] the cascade level of IupMainLoop
	return doC("IupMainLoopLevel", , , C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- The cascade level.
--
-- When no calls were done, return value is 0.
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupPostMessage   (Ihandle* ih, const char* s, int i, double d, void* p);
--------------------------------------------------------------------------------
public function IupPostMessage(Ihandle ih, string s, integer i, atom d, atom p) --sends data to an element, that will be received by a callback when the main loop regain control
    return doC("IupPostMessage", {C_POINTER, C_POINTER, C_INT, C_DOUBLE, C_POINTER},
                                 {ih, allocate_string(s), i, d, p})
end function
--------------------------------------------------------------------------------
--/*
-- It is expected to be thread safe.
--
-- Parameters:
--# //ih//: identifier of the interface element.
--# //s//: string. Can be NULL. It will be internally duplicated if not NULL.
--# //i//: integer number.
--# //d//: floating point number.
--# //p//: generic pointer.
--*/
--------------------------------------------------------------------------------
--/*
--==== Attributes
--*/
--------------------------------------------------------------------------------
-- IUP_API char*     IupGetAttribute(Ihandle* ih, const char* name);
--------------------------------------------------------------------------------
public function IupGetAttribute(Ihandle widget, string attr) -- gets an interface element attribute
    atom ret = doC("IupGetAttribute", {C_POINTER, C_POINTER}, {widget, allocate_string(attr)}, C_POINTER)
    if ret = NULL then return ""
    else return peek_string(ret)
    end if
end function
--------------------------------------------------------------------------------
--/*
-- Use only when the attribute value is a string.
--
-- Parameters:
--# //widget//: identifier of the interface element.
--# //attr//: the name of the attribute.
--
-- (For other value types use the relevant function. For example:
-- for an integer value use {{{IupGetInt}}}.)
--
-- Returns:
--
--* the attribute value or
--* NULL, if the attribute is not set or does not exist.
--
-- Notes:
--
-- In testing it has been found to return negative values if unset?
--*/
--------------------------------------------------------------------------------
-- IUP_API float     IupGetFloat    (Ihandle* ih, const char* name);
--------------------------------------------------------------------------------
public function IupGetFloat(Ihandle widget, string attr)	-- gets an atom attribute value
    return doC("IupGetFloat", {C_BOOL, C_POINTER}, {widget, allocate_string(attr)}, C_FLOAT)
end function
--------------------------------------------------------------------------------
--/*
-- Gets the attribute value, where this is an atom.
--
-- Parameters:
--# //widget//: identifier of the interface element.
--# //attr//: the name of the attribute.
--
-- Use upper-case for the attribute.
--
-- Returns:
--
-- the floating-point value of an interface element attribute.
--*/
--------------------------------------------------------------------------------
public function IupGetInt(atom widget, string attr)	-- gets an integer attribute value
    return doC("IupGetInt", {C_INT, C_POINTER}, {widget, allocate_string(attr)}, C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- Gets the attribute value, where this is an integer.
--
-- Parameters:
--# //widget//: identifier of the interface element.
--# //attr//: the name of the attribute.
--
-- Use upper-case for the attribute.
--
-- Returns:
--
-- the integer value of an interface element attribute.
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupSetAttribute   (Ihandle* ih, const char* name, const char* value);
--------------------------------------------------------------------------------
public procedure IupSetAttribute(Ihandle widget, string attribute, object val = NULL)    -- sets an interface element attribute to the stated val(ue)
    if not attrib(attribute) then attribute = upper(attribute) end if
    sequence arg = {widget, allocate_string(attribute), val}
    if string(val) then arg[3] = allocate_string(val) end if
    c_proc(hIupSetAttribute, arg)
end procedure
--------------------------------------------------------------------------------
--/*
-- Parameters:
--# //widget//: identifier of the interface element. If NULL will set the
-- attribute in the global environment
--# //attribute//: the (upper-case) name of the attribute to change. If the name
-- is given in the wrong case then it will be converted to upper-case.
--# //val//: the value to be set.
-- If NULL then the default value for that attribute will be used.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupSetAttributes (Ihandle* ih, const char *str);
--------------------------------------------------------------------------------
public function IupSetAttributes(Ihandle widget, string attributes)  -- sets several attributes of an interface element
    return doC("IupSetAttributes", {C_POINTER, C_POINTER}, {widget, allocate_string(attributes)},  C_POINTER)
end function
--------------------------------------------------------------------------------
public function IHandle(Ihandle widget, string attributes)  -- creates an interface element with several attributes set 
    return doC("IupSetAttributes", {C_POINTER, C_POINTER}, {widget, allocate_string(attributes)},  C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameters:
--# //widget//: identifier of the interface element.
--# //attributes//: the attributes in the format "v1=a1, v2=a2,..." where vi is
-- the name of an attribute and ai is its value
--
-- Returns:
--
--  an **Ihandle**: the (same) identifier
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupSetAttributeHandle(Ihandle* ih, const char* name, Ihandle* ih_named);
--------------------------------------------------------------------------------
public function IupSetAttributeHandle(Ihandle widget, string attribute, Ihandle ih_named)    -- creates a non conflict name and associates the name with the attribute
    if not attrib(attribute) then attribute = upper(attribute) end if
    return doC("IupSetAttributeHandle", {C_POINTER, C_POINTER, C_POINTER}, {widget, allocate_string(attribute), ih_named})
end function
--------------------------------------------------------------------------------
--/*
-- Parameters:
--# //widget//: identifier of the interface element.
--# //attribute//: the (upper-case) name of the attribute to change. If the name
-- is given in the wrong case then it will be converted to upper-case.
--# //ih_named//: element to associate using a name
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupSetGlobal  (const char* name, const char* value);
--------------------------------------------------------------------------------
public function IupSetGlobal(string name, object val)
    sequence args = {allocate_string(name), val}
    if sequence(val) then
        args[2] = allocate_string(val)
    end if
    return doC("IupSetGlobal", {C_POINTER, C_POINTER}, args)
end function
--------------------------------------------------------------------------------
--/*
-- Sets an attribute in the public environment.
-- If the driver process the attribute then it will not be stored internally.
--
-- Parameters:
--# //name//: the (upper-case) name of the attribute to change. If the name
-- is given in the wrong case then it will be converted to upper-case.
--# //val//: the value to be set.
--
-- If the value is set to NULL (as it is by default) then the attribute setting
-- will be removed.
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupSetInt         (Ihandle* ih, const char* name, int value);
--------------------------------------------------------------------------------
public function IupSetInt(Ihandle widget, string attr, integer val)
    return doC("IupSetInt", {C_POINTER, C_POINTER, C_INT}, {widget, allocate_string(attr), val})
end function
--------------------------------------------------------------------------------
--/*
-- Sets the integer value of an interface element attribute.
--
-- Parameters:
--# //widget//: identifier of the interface element.
--# //attr//: the (upper-case) name of the attribute to change. If the name
-- is given in the wrong case then it will be converted to upper-case.
--# //val//:  the value to be set.
--
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupSetStrAttribute(Ihandle* ih, const char* name, const char* value);
--------------------------------------------------------------------------------
public function IupSetStrAttribute(Ihandle widget, string attr, string val) -- sets an interface element attribute
    return doC("IupSetStrAttribute", {C_POINTER, C_POINTER, C_POINTER}, {widget, allocate_string(attr), allocate_string(val)})
end function
--------------------------------------------------------------------------------
--/*
-- Parameters:
--# //widget//: the widget whose attribute is to be changed
--# //attr//: the attribute to be changed
--# //val//: the new value
--
-- Use only when the attribute value is a string.
--
-- Use upper-case for the attribute and for many of the values.
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupSetStrf        (Ihandle* ih, const char* name, const char* format, ...);
--------------------------------------------------------------------------------
public procedure IupSetStrf(Ihandle ih, string name, string format, object data) -- formatted-string version of IupSetAttribute
    IupSetAttribute(ih, name, sprintf(format, data))
end procedure
--------------------------------------------------------------------------------
--/*
-- Parameters:
--# //ih//: the widget whose attribute is to be changed
--# //name//: the attribute to be changed
--# //format//: the desired formatting code
--# //data//: the new data
--
-- This is alternative approach to the IUP void function,
-- using OE's ##sprintf## and ##IupSetAttribute##.
--
-- The data variable is formatted before assigning to the specified attribute.
--*/
--------------------------------------------------------------------------------
--/*
--==== Call back handling
--*/
--------------------------------------------------------------------------------
public function Icallback(string name, atom rid = routine_id(name)) -- converts a routine_id to the appropriate form
    return call_back({'+', rid})
end function
--------------------------------------------------------------------------------
public function _(string name, atom rid = routine_id(name)) -- converts a routine_id to the appropriate form
    return call_back({'+', rid})
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--# ##name##: the identifier of the appropriate callback routine for the given
-- action.
--
-- Returns:
--
-- the callback.
--*/
--------------------------------------------------------------------------------
-- IUP_API Icallback IupSetCallback (Ihandle* ih, const char *name, Icallback func);
--------------------------------------------------------------------------------
public function IupSetCallback(Ihandle widget, string action, atom rid)  -- associates a callback to an event
	sequence arg = {widget, allocate_string(action), rid}
	return c_func(hIupSetCallback, arg)
end function
--------------------------------------------------------------------------------
--/*
-- Parameters:
--# ##widget##: the (**Ihandle**) identifier of an interface element
--# ##action##: the name of the action to be trapped
--# ##rid##: the id of the routine to be called when the action occurs
--
-- Returns:
--
-- the address of the previous function associated with the action.
--
--*/
--------------------------------------------------------------------------------
--/*
--==== Handles
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupGetHandle    (const char *name);
--------------------------------------------------------------------------------
public function IupGetHandle(string title)    -- get handle from name
    return doC("IupGetHandle", {C_POINTER}, {allocate_string(title)}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns the identifier of an interface element that has an associated name
-- using {{{IupSetHandle.}}}
--
-- Parameter:
--# the //title// of an interface element.
--
-- Returns:
--
-- the element handle or NULL if not found.
--*/
--------------------------------------------------------------------------------
-- IUP_API char*     IupGetName      (Ihandle* ih);
--------------------------------------------------------------------------------
public function IupGetName(Ihandle widget) -- finds the name of an interface element
    return peek_string(doC("IupGetName", {C_POINTER}, {widget}, C_POINTER))
end function
--------------------------------------------------------------------------------
--/*
-- Parameter:
--#  //widget//: identifier of the interface element.
--
-- Returns:
--
-- the name associated with the widget, set using ##IupSetHandle##
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupSetHandle    (const char *name, Ihandle* ih);
--------------------------------------------------------------------------------
public function IupSetHandle(string title, Ihandle widget) -- associate name with a handle
    return doC("IupSetHandle", {C_POINTER, C_POINTER}, {allocate_string(title), widget}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Associates a name with an interface element.
--
-- Parameters:
--# //title//: name of the interface element;
--# //widget//: identifier of the interface element.
-- Use NULL to remove the association.
--
-- Returns:
--
-- the identifier of the interface element previously associated with the parameter name.
--*/
--------------------------------------------------------------------------------
--/*
--==== Resources
--*/
--------------------------------------------------------------------------------
public function allocate_image(sequence data, integer cleanup = 0) -- creates an image in memory
	atom buff = allocate_data(length(data), cleanup)
	poke(buff, data)
    return buff
end function
--------------------------------------------------------------------------------
--/*
-- Parameters:
--# //data//: the array of pixels
--# //cleanup//: an integer, if non-zero, then the returned pointer will be
-- automatically freed when its reference count drops to zero, or when passed
-- as a parameter to ##delete##.
--
-- Returns:
--
-- the pointer to the image.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupGetDialog    (Ihandle* ih);
--------------------------------------------------------------------------------
public function IupGetDialog(Ihandle handle)
    return doC("IupGetDialog", {C_POINTER}, {handle}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Gets the handle of the dialog that contains that interface element.
-- It works also for children of a menu that is associated with a dialog.
--
-- Parameter:
--# the //handle// to an interface element.
--
-- Returns:
--
-- the handle of the dialog or NULL if not found.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupImage      (int width, int height, const unsigned char* pixels);
--------------------------------------------------------------------------------
public function IupImage(atom width, atom height, object pixmap)
    return doC("IupImage", {C_INT, C_INT, C_POINTER}, {width, height, pixmap}, C_POINTER)
end function
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupImageRGB   (int width, int height, const unsigned char* pixels);
--------------------------------------------------------------------------------
public function IupImageRGB(atom width, atom height, object pixmap)
    return doC("IupImageRGB", {C_INT, C_INT, C_POINTER}, {width, height, pixmap}, C_POINTER)
end function
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupImageRGBA  (int width, int height, const unsigned char* pixels);
--------------------------------------------------------------------------------
public function IupImageRGBA(atom width, atom height, object pixmap)
    return doC("IupImageRGBA", {C_INT, C_INT, C_POINTER}, {width, height, pixmap}, C_POINTER)
end function
--------------------------------------------------------------------------------
-- IUPIMGLIB_API void IupImageLibOpen(void);
--------------------------------------------------------------------------------
public function IupImageLibOpen() -- opens a library of pre-defined stock images for buttons and labels
    atom iupimagelib = open_dll({"iupimglib.dll", "libiupimglib.so"})
    c_proc(define_c_proc(iupimagelib, "+IupImageLibOpen", {}), {})
    return 0
end function
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupGetFocus     (void);
--------------------------------------------------------------------------------
--/*
--==== Keyboard
--*/
--------------------------------------------------------------------------------
public function IupGetFocus() -- returns the identifier of the interface element that has the keyboard focus
    return doC("IupGetFocus", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- an **Ihandle**: the element with focus or NULL if no element has the focus.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupNextField    (Ihandle* ih);
--------------------------------------------------------------------------------
public function IupNextField(Ihandle ih) -- shifts the focus to the next element that can have the focus
    return doC("IupNextField", {C_POINTER}, {ih}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- an **Ihandle**: the element that received the focus or NULL if not found.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupPreviousField(Ihandle* ih);
--------------------------------------------------------------------------------
public function IupPreviousField(Ihandle ih) -- shifts the focus to the previous element that can have the focus
    return doC("IupPreviousField", {C_POINTER}, {ih}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- an **Ihandle**: the element that received the focus or NULL if not found.
--*/
--------------------------------------------------------------------------------
-- Ihandle *IupSetFocus(Ihandle *ih);
--------------------------------------------------------------------------------
public function IupSetFocus(Ihandle ih) -- sets the interface element that will receive the keyboard focus, i.e. the element that will receive keyboard events
    return doC("IupSetFocus", {C_POINTER}, {ih}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Returns:
--
-- an **Ihandle**: the identifier of the interface element that
-- previously had the keyboard focus.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupTimer      (void);
--------------------------------------------------------------------------------
public function IupTimer() -- creates a timer which periodically invokes a callback when the time is up
    return doC("IupTimer", , , C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Each timer should be destroyed using IupDestroy.
--
-- Returns:
--
-- the identifier of the created element, or NULL if an error occurs.
--
-- See the IUP documentation for the appropriate set of Attributes.
--*/
--------------------------------------------------------------------------------
--/*
-- == Layout (hierarchy)
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupAppend       (Ihandle* ih, Ihandle* child);
--------------------------------------------------------------------------------
public function IupAppend(Ihandle ih, Ihandle child) -- inserts an interface element at the end of the container, after the last element of the container
    return doC("IupAppend", {C_POINTER, C_POINTER}, {ih, child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameters: identifier of a container like hbox, vbox, zbox and menu;
-- identifier of the element to be inserted
--
-- Returns:  the actual parent if the interface element was successfully
-- inserted. Otherwise NULL.
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupDetach       (Ihandle* child);
--------------------------------------------------------------------------------
public function IupDetach(Ihandle child) -- detaches an interface element from its parent
    return doC("IupDetach", {C_POINTER}, {child})
end function
--------------------------------------------------------------------------------
--/*
-- Parameter: identifier of the element to be detached
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupInsert       (Ihandle* ih, Ihandle* ref_child, Ihandle* child);
--------------------------------------------------------------------------------
public function IupInsert(Ihandle ih, Ihandle ref_child, Ihandle child) -- inserts an interface element before another child of the container
    return doC("IupInsert", {C_POINTER, C_POINTER, C_POINTER}, {ih, ref_child, child}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameters: identifier of a container like hbox, vbox, zbox and menu;
-- identifier of the element to be used as reference, which
-- can be NULL - to insert as the first element;
-- identifier of the element to be inserted (before the reference child)
--
-- Returns:  the actual parent if the interface element was successfully
-- inserted. Otherwise NULL.
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupReparent     (Ihandle* ih, Ihandle* new_parent, Ihandle* ref_child);
--------------------------------------------------------------------------------
public function IupReparent(Ihandle child, Ihandle new_parent, Ihandle ref_child)
    return doC("IupReparent", {C_POINTER, C_POINTER, C_POINTER}, {child, new_parent, ref_child}, C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- Moves an interface element from one position in the hierarchy tree to another.
--
-- Parameters: ##child##: Identifier of the element to be moved,
-- ##new_parent##: Identifier of the new parent
-- ##ref_child##: Identifier of the element to be used as reference, where
-- the child will be inserted before it. It can be NULL.
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupGetChildCount(Ihandle* ih);
--------------------------------------------------------------------------------
public function IupGetChildCount(Ihandle widget) -- returns the number of children of the given control
    return doC("IupGetChildCount", {C_POINTER}, {widget}, C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter: the ##widget## to investigate.
--
-- Returns: number of children.
--*/
--------------------------------------------------------------------------------
-- IUP_API int       IupGetChildPos  (Ihandle* ih, Ihandle* child);
--------------------------------------------------------------------------------
public function IupGetChildPos(Ihandle widget, Ihandle child) -- gets the position of a child of the given control
    return doC("IupGetChildPos", {C_POINTER, C_POINTER}, {widget, child}, C_INT)
end function
--------------------------------------------------------------------------------
--/*
-- Parameters: the ##widget## to investigate,
-- the ##child## of interest
--
-- Returns: the position of the desire child starting at 0,
-- or -1 if the child is not found.
--*/
--------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupGetDialogChild(Ihandle* ih, const char* name);
--------------------------------------------------------------------------------
public function IupGetDialogChild(Ihandle ih, string name) -- returns the identifier of the child element that has the NAME attribute equals to the given value on the same dialog hierarchy
    return doC("IupGetDialogChild", {C_POINTER, C_POINTER},
                {ih, allocate_string(name)}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Works also for children of a menu that is associated with a dialog.
--
-- Returns:
--
-- a **Ihandle**: to the relevant child element, or
-- //NULL// if not found.
--*/
-------------------------------------------------------------------------------
-- IUP_API Ihandle*  IupGetParent    (Ihandle* ih);
--------------------------------------------------------------------------------
public function IupGetParent(Ihandle widget) -- gets the parent of a widget
    return doC("IupGetParent", {C_POINTER}, {widget}, C_POINTER)
end function
--------------------------------------------------------------------------------
--/*
-- Parameter: the ##widget## to investigate.
--
-- Returns: the handle of the parent or NULL,
-- if the widget does not have a parent.
--*/
--------------------------------------------------------------------------------
--/*
-- == Layout (management)
--*/
--------------------------------------------------------------------------------
-- IUP_API void      IupRefresh       (Ihandle* ih);
--------------------------------------------------------------------------------
public function IupRefresh(Ihandle dialog)
    return doC("IupRefresh", {C_POINTER}, {dialog})
end function
--------------------------------------------------------------------------------
--/*
-- Updates the size and layout of all controls in the same ##dialog##.
--
-- To be used after changing size attributes, or attributes that affect the
-- size of the control. Can be used for any element inside a dialog, but the
-- layout of the dialog and all controls will be updated.
-- It can change the layout of all the controls inside the dialog because of
-- the dynamic layout positioning.
--*/
--------------------------------------------------------------------------------
--/*
-- == Web browser
--*/
--------------------------------------------------------------------------------
ifdef LINUX then
    public procedure IupWebBrowserOpen() -- opens the web browser library
        c_proc(define_c_proc(IUPLIBWB, "+IupWebBrowserOpen",{}), {})
    end procedure
    public function IupWebBrowser() -- creates the web browser widget
            return c_func(define_c_func(IUPLIBWB, "+IupWebBrowser",{},C_POINTER), {})
    end function
end ifdef
--------------------------------------------------------------------------------
--/*
-- == Scintilla
--*/
--------------------------------------------------------------------------------
-- void IupScintillaOpen(void);
public procedure IupScintillaOpen()
    c_proc(define_c_proc(IUPSCINTILLA,"+IupScintillaOpen",{}),{})
end procedure
--Ihandle *IupScintilla(void);
public function IupScintilla()
    return c_func(define_c_func(IUPSCINTILLA,"+IupScintilla",{},C_POINTER),{})
end function
--Ihandle *IupScintillaDlg(void);
public function IupScintillaDlg()
    return c_func(define_c_func(IUPSCINTILLA,"+IupScintillaDlg",{},C_POINTER),{})
end function
--sptr_t IupScintillaSendMessage(Ihandle* ih, unsigned int iMessage, uptr_t wParam, sptr_t lParam);
public function IupScintillaSendMessage(atom ih, atom iMessage, atom wParam, atom lParam)
    atom ISSM = define_c_func(IUPSCINTILLA, "+IupScintillaSendMessage", {C_POINTER,C_UINT,C_POINTER,C_POINTER}, C_POINTER)
	return c_func(ISSM, {ih,iMessage,wParam,lParam} )
end function
--------------------------------------------------------------------------------
-- Previous versions
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.69
-- Euphoria Verion: v4.0.5 and later
-- Date: 2022.03.28
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * corrected error in finding WebBrowser functions
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.68
-- Euphoria Verion: v4.0.5 and later
-- Date: 2022.03.12
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * added ##IupScintillaOpen##
--  * added ##IupScintilla##
--  * added ##IupScintillaDlg##
--  * added ##IupScintillaSendMessage##
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.67
-- Euphoria Verion: v4.0.5 and later
-- Date: 2022.01.31
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * made definitions of ##IupWebBrowserOpen## and ##IupWebBrowser## conditional
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.66
-- Euphoria Verion: v4.0.5 and later
-- Date: 2022.01.15
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupWebBrowserOpen## defined
--  * ##IupWebBrowser## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.65
-- Euphoria Verion: v4.0.5 and later
-- Date: 2022.01.14
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupCanvas## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.64
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.07.04
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * errors in embedded documentation corrected
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.63
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.03.06
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupAppend## defined
--  * ##IupDetach## defined
--  * ##Insert## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.62
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.03.04
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupGetText## error corrected
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.61
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.03.03
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupFlatVal## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.60
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.03.02
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupAnimatedLabel## defined
--  * ##IupDropButton## defined
--  * ##IupColorBrowser## defined
--  * ##IupDatePick## defined
--  * ##IupDial## defined
--  * ##IupFlatLabel## defined
--  * ##IupFlatSeparator## defined
--  * ##IupFlatToggle## defined
--  * ##IupFlatTree## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.59
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.02.24
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupGetFocus## defined
--  * ##IupNextField## defined
--  * ##IupPreviousField## defined
--  * more K-constants added
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.58
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.02.20
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupGetFile## - error corrected: not enough space allocated for return value
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.57
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.02.07
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupTextConvertLinColToPos## modified further
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.56
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.02.06
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupTextConvertLinColToPos## modified
--  * ##IupTextConvertPosToLinCol## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.55
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.02.05
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupTextConvertLinColToPos## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.54
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.02.03
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupGetDialogChild## defined
--  * ##IupSetStrf## defined - single value temporarily
--  * IupPopup and IupShowXY Parameter Values added
--  * Pre-Defined Masks added
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.53
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.02.03
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupGetAttribute## modified
--  * ##IupVersion## defined
--  * ##IupVersionShow## defined
--  * ##IupVersionDate## defined
--  * ##IupVersionNumber## modified
--  * ##IupIsOpened## defined
--  * ##IupGetLanguage## defined
--  * **Ihandle** defined
--  * added (as comment) the C-language definitions
--  * changed all **Ihandle** refs to **atom** and //C_POINTER//
--  * ##IupLoopStep## defined
--  * ##IupLoopStepWait## defined
--  * ##IupPostMessage## defined
--  * ##IupGetColor## defined
--  * ##IupClassInfoDialog## defined
--  * ##IupParamBox## defined
--  * ##IupLayoutDialog## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.52
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.01.29
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupFontDlg## defined
--  * ##IupGetAttribute## modified to trap -ive values
--  * ##IupElementPropertiesDialog## defined
--  * ##IupMessageAlarm## defined
--  * ##IupMessageError## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.51
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.01.25
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupSpace## defined
--  * ##IupFlatTabs## defined
--  * ##IupFlatScrollBox## defined
--  * at least one version of all Containers wrapped
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.50
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.01.13
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupMainLoopLevel## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.49
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.01.03
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupProgressDlg## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.48
-- Euphoria Verion: v4.0.5 and later
-- Date: 2021.01.02
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupGetParam## defined
--  * added support (service) routines
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.47
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.12.30
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupGetFile## defined
--  * ##IupGetText## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.46
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.12.23
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupLink## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.45
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.11.18
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupImageRGB## defined
--  * ##IupImageRGBA## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.44
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.11.11
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupHide## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.43
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.10.17
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupGetParent## defined
--  * ##IupGetChildPos## defined
--  * ##IupTree## defined
--  * ##IupVal## defined
--  * ##IupSetStrAttribute## defined
--  * ##IupGetName## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.42
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.10.13
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupList## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.41
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.09.16
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupPopup## defined
--  * ##IupSetLanguage## defined
--  * ##IupFileDlg## defined
--  * documentation slightly modified
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.40
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.09.11
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupToggle## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.39
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.09.11
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupGetChildCount## defined
--  * ##IupGetFloat## defined
--  * ##IupProgressBar## defined
--  * ##IupTimer## defined
--  * ##IupImageLibOpen## defined
--  * ##IupSpin## defined
--  * ##IupSpinbox## defined
--  * Key constants added
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.38
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.09.08
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupGridBox## defined
--  * ##IupMultiBox## defined
--  * ##IupZbox## defined
--  * ##IupRadio## defined
--  * ##IupSbox## defined
--  * ##IupExpander## defined
--  * ##IupSplit## defined
--  * ##IupNormalizer## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.37
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.08.22
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupScrollBox## defined
--  * ##IupInsert## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.36
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.08.21
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupFlatFrame## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.35
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.08.20
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * modified all procedures to functions
--  * changed all calls to ##doC##
--  * ##IupExitLoop## defined
--  * ##IupFlush## defined
--  * ##IupCalendar## defined
--  * ##IupColorbar## defined
--  * ##IupGauge## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.34
-- Euphoria Verion: v4.0.5 and later
-- Date: 2020.08.19
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupGetAttribute## defined
--  * ##IupSetInt## defined
--  * //dll.e// made public, to pass on //NULL//
--  * ##IupGetDialog## defined
--  * ##IupReparent## defined
--  * ##IupRefresh## defined
--  * ##IupDetachBox## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.33
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.07.04
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupCbox## defined
--  * ##IupFlatButton## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.32
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.06.28
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--------------------------------------------------------------------------------
--  * ##IupBackgroundBox## defined
--[[[Version: 4.0.5.31
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.05.15
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupTabs## simplified
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.30
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.05.09
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * ##IupText## simplified
--  * ##IupLabel## simplified
--  * //IupFill## simplified
--  * ##IupSeparator## simplified
--  * ##IupVbox## defined
--  * ##IupVboxv## re-defined
--  * ##IupMessage## simplified
--  * ##IupDestroy## simplified
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.29
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.05.0
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--  * modified to call //iup.e// at the outset
--  * ##IupOpen## changed accordingly
--  * ##IupVersionNumber## modified
--  * ##IupHbox## re-defined, to adopt precise IUP definition
--  * ##IupDialog## modified
--  * ##IupShow## modified
--  * ##IupShowXY## modified
--  * ##IupMessage## modified
--  * ##IupFrame## modified
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.28
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.05.05
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--* ##IupGetHandle## defined
--* ##IupGetInt## defined
--* ##IupGetInt## defined
--* ##IupSetGlobal## defined
--* Mouse button constants added
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.26
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.04.24
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--* //IUP_CONTINUE// defined
--* ##IupHbox## defined
--* ##IupText## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.27
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.04.28
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--* ##IupFrame## defined
--* ##IupFill## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.25
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.04.05
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--* ##IupItem## defined
--* ##allocate_image## defined
--* ##IupImage## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.24
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.04.04
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--* ##IupShowXY## defined
--* ##IupMenu## defined
--* ##IupSeparator## defined
--* ##IupSetHandle## defined
--* ##IupSubmenu## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.23
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.03.31
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--* ##IupButton## defined
--* ##IupVbox## defined
--* ##IupDialog## defined
--* ##IupShow## defined
--* ##IupMainLoop## defined
--* ##IupSetAttribute## defined
--* ##IupLabel## defined
--* ##IupSetCallback## defined
--* ##Icallback## defined
--* ##IupSetAttributes## defined
--* ##IupSetAttributeHandle## defined
--* ##IupDestroy## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.22
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.03.28
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--* ##IupAlarm## defined
--* ##IupMessage## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.21
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.03.14
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--* ##IupOpen## turned into a function
--* ##IupVersionNumber## defined
--------------------------------------------------------------------------------
--[[[Version: 4.0.5.20
-- Euphoria Version: v4.0.5 and later
-- Date: 2020.03.13
-- Author: Charles Newbould
-- Status: incomplete; operational]]]
-- Changes in this version:
--* rebuilt from various previous versions
--* incorporated former ##init## into ##IupOpen##
--------------------------------------------------------------------------------
