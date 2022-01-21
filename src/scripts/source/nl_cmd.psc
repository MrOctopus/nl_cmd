Scriptname nl_cmd extends Quest

string property _CON = "Console" autoreadonly
int property _DX_ENTER = 0x1C autoreadonly ; Enter
int property _DX_NUM_ENTER = 0x9C autoreadonly ; Numpad enter

string[] _registered_cmds
string[] _registered_var_types
string[] _registered_descs

bool _busy_mutex = true
int _last_cmds_i = -1

;-------\
; EVENTS \
;--------------------------------------------------------

event OnInit()
    _registered_cmds = new string[2]
    _registered_var_types = new string[2]
    _registered_descs = new string[2]

    ; Default help command
    _registered_cmds[0] = "help"
    _registered_var_types[0] = ""
    _registered_descs[0] = "List all commands"

    ; Built in mod event sender
    _registered_cmds[1] = "SendModEvent"
    _registered_var_types[1] = "string,string,float"
    _registered_descs[1] = "Send a general mod event"

    _busy_mutex = false

    RegisterForModEvent("nl_cmd_help", "OnHelpCommand")
    RegisterForModEvent("nl_cmd_sendmodevent", "OnSendModEventCommand")
    RegisterForMenu(_CON)
endevent

event OnMenuOpen(string menu)
    RegisterForKey(_DX_ENTER)
    RegisterForKey(_DX_NUM_ENTER)
endevent

event OnMenuClose(string menu)
	UnregisterForAllKeys()
endevent

event OnKeyDown(int key)
    int cmds_i =  Ui.GetInt(_CON, "_global.Console.ConsoleInstance.Commands.length") - 1
	
    ; Ensure we don't run the same command twice
    if cmds_i == _last_cmds_i
        return
    endif
    _last_cmds_i = cmds_i
    
    string cmd = Ui.GetString(_CON, "_global.Console.ConsoleInstance.Commands." + cmds_i)
	string vars = ""
	
	int cmd_i = StringUtil.Find(cmd, "nl_cmd")
	int cmd_j
	
	if cmd_i != 0
        return
	endif

    ; Remove error essage by finding last new line
    string history = Ui.GetString(_CON, "_global.Console.ConsoleInstance.CommandHistory.text")
    int history_i = StringUtil.GetLength(history) - 1

    while history_i > 0
        history_i -= 1
        string char = StringUtil.GetNthChar(history, history_i)

        if StringUtil.AsOrd(char) == 13
            ; Trick to jump out of the while loop whilst retaining our value :)
            ; avoids an additional if check
            history_i = -history_i
        endif
    endwhile

    history = StringUtil.Substring(history, 0, -history_i + 1)
    Ui.SetString(_CON, "_global.Console.ConsoleInstance.CommandHistory.text", history)

	cmd_i = 7
	cmd_j = StringUtil.GetLength(cmd)
	
	if cmd_i >= cmd_j
        _Print("Please specify a command to run")
		return
	endif

    if StringUtil.GetNthChar(cmd, 6) != " "
        _Print("Please use a space between the nl_cmd keyword and your command")
        return
    endif
	
	int var_i = StringUtil.Find(cmd, "(", cmd_i)

	if var_i != -1
		if var_i == cmd_i
            _Print("Please provide a command before supplying variables")
            return
		endif
		
		if StringUtil.GetNthChar(cmd, cmd_j - 1) != ")"
            _Print("The provided command is missing a ')' terminator at the end")
			return
		endif

        ; If the index of ( is the same as the index of ) - 1, there are no variables
        if var_i != (cmd_j - 2)
            vars = StringUtil.SubString(cmd, var_i + 1, cmd_j - var_i - 2)
        endif
		cmd = StringUtil.Substring(cmd, cmd_i, var_i - cmd_i) 
	else
		cmd = StringUtil.Substring(cmd, cmd_i) 
	endif
	
	_RunCommand(cmd, vars)
endevent

event OnSendModEventCommand(string event_name, string arg, float argF)
    SendModEvent(event_name, arg, argF)
endevent

event OnHelpCommand()
    int num_cmds = _registered_cmds.length
    int i = 0

    Ui.Invoke(_CON, "_global.Console.ClearHistory")
    Ui.InvokeString(_CON, "_global.Console.AddHistory", "NL_CMD [Info] The following commands are currently registered:\n")
    while i < num_cmds
        if _registered_descs[i] != ""
            Ui.InvokeString(_CON, "_global.Console.AddHistory", i + " - " + _registered_cmds[i] + "(" +  _registered_var_types[i] + ") | " + _registered_descs[i] + "\n")
        else
            Ui.InvokeString(_CON, "_global.Console.AddHistory", i + " - " + _registered_cmds[i] + "(" +  _registered_var_types[i] + ")\n")
        endif

        i += 1
    endwhile
endevent

;---------\
; INTERNAL \
;--------------------------------------------------------

function _RunCommand(string cmd, string vars)
	int cmd_i = _registered_cmds.Find(cmd)

	if cmd_i == -1
        _Print("No command exists with the given name")
		return
	endif
	
	int handle = ModEvent.Create("nl_cmd_" + cmd)
	
	if !handle
        _Print("Something went wrong when running the command, try again", "Error")
		return
	endif

    string[] vars_arr = StringUtil.Split(vars, ";")
    string[] vars_type = StringUtil.Split(_registered_var_types[cmd_i], ",")
    
    if vars_arr.length != vars_type.length
        ModEvent.Release(handle)
        _Print("The number of given parameters did not match the expected number. Found " + vars_arr.length + ", expected " + vars_type.length)
        return
    endif

    int i = 0
	
    while i != vars_arr.length
        string var_type = vars_type[i]
        
        if var_type == "bool"
            bool var
            
            if vars_arr[i] == "true"
                var = true
            elseif vars_arr[i] != "false"
                var = vars_arr[i] as bool
            endif
        
            ModEvent.PushBool(handle, var)
        elseif var_type == "int"
            ModEvent.PushInt(handle, vars_arr[i] as int)
        elseif var_type == "float"
            ModEvent.PushFloat(handle, vars_arr[i] as float)
        elseif var_type == "string"
            ModEvent.PushString(handle, vars_arr[i])
        elseif var_type == "form"
            form var = Game.GetFormEx(_HexStringToInt(vars_arr[i]))
            ModEvent.PushForm(handle, var)
        endif
        
        i += 1
    endwhile
	
	ModEvent.Send(handle)
endfunction

int function _HexStringToInt(string sHex)
    if StringUtil.Find(sHex, "0x") == 0
        sHex = StringUtil.Substring(sHex, 2)
    endif

    int iDec
    int iPlace = 1
    int iIndex = 6
    
    while iIndex > 0
        iIndex -= 1
        string sChar = StringUtil.SubString(sHex, iIndex, 1)
        int iSubNumber
        
        if StringUtil.IsDigit(sChar)
            iSubNumber = sChar as int
        Else
            iSubNumber = StringUtil.AsOrd(sChar) - 55
        endIf
        
        iDec += iSubNumber * iPlace
        iPlace *= 16
    endWhile
    
    Return iDec
endfunction

function _Print(string text, string type = "Info")
    Debug.Trace("NL_CMD(nl_cmd.esl, nl_cmd.psc) [" + type + "]: " + text)
    Ui.InvokeString(_CON, "_global.Console.AddHistory", "NL_CMD [" + type + "]: " + text + "\n")
endfunction

;---------\
; EXTERNAL \
;--------------------------------------------------------

bool function RegisterCommand(string cmd, string vars, string desc)
    while _busy_mutex
        Utility.WaitMenuMode(0.3)
    endwhile
    _busy_mutex = true

    if _registered_cmds.Find(cmd) != -1
        _Print("The command name is already taken: " + cmd + "(" + vars + ")", "Error")
        _busy_mutex = false
        return false
    endif

    _registered_cmds = Utility.ResizeStringArray(_registered_cmds, _registered_cmds.length + 1, cmd)
    _registered_var_types = Utility.ResizeStringArray(_registered_var_types, _registered_var_types.length + 1, vars)
    _registered_descs = Utility.ResizeStringArray(_registered_descs, _registered_descs.length + 1, desc)
	
    _busy_mutex = false
	return true
endfunction

bool function UnregisterCommand(string cmd)
    while _busy_mutex
        Utility.WaitMenuMode(0.3)
    endwhile
    _busy_mutex = true

    int i = _registered_cmds.Find(cmd)

    if i == -1
        _Print("The command name is not registered: " + cmd, "Error")
        _busy_mutex = false
        return false
    endif

    int last_cmd = _registered_cmds.length - 1

    ; Shift array
    while i < last_cmd
        int j = i + 1

        _registered_cmds[i] = _registered_cmds[j]
        _registered_var_types[i] = _registered_var_types[j]
        _registered_descs[i] = _registered_descs[j]

        i += 1
    endwhile

    _registered_cmds = Utility.ResizeStringArray(_registered_cmds, _registered_cmds.length - 1)
    _registered_var_types = Utility.ResizeStringArray(_registered_var_types, _registered_var_types.length - 1)
    _registered_descs = Utility.ResizeStringArray(_registered_descs, _registered_descs.length - 1)
    
    _busy_mutex = false
	return true
endfunction