Scriptname nl_cmd_module extends Quest

string property _CON = "Console" autoreadonly
int property CMD_QUEST_FORM = 0x00000D61 autoreadonly

bool _advanced_features = false
bool property AdvancedFeatures hidden
	function Set(bool enable)
		string script_name = _GetMyScriptName()

		if enable
			RegisterCommand("RegisterCommandOn_" + script_name, "RegisterCommand", "string,string,string,string")
			RegisterCommand("UnregisterCommandFrom_" + script_name, "UnregisterCommand", "string")
		else
			UnregisterCommand("RegisterCommandOn_" + script_name)
			UnregisterCommand("UnregisterCommandFrom_" + script_name)
		endif

		_advanced_features = enable
	endfunction

	bool function Get()
		return _advanced_features
	endfunction
endproperty

;---------\
; INTERNAL \
;--------------------------------------------------------

string function _GetMyModName()
	int form_id = self.GetFormID()
	int index = Math.RightShift(form_id, 24)

	if index == 254
		return Game.GetLightModName(Math.RightShift(form_id, 12) - 0xFE000)
	endif

	return Game.GetModName(index)
endfunction

string function _GetMyScriptName()
	string form_string = self as string
	int i = 1
	int j = StringUtil.Find(form_string, " <") - 1

	return StringUtil.SubString(form_string, i, j)
endfunction

function _Print(string cmd, string text, string type = "Info")
    Debug.Trace("NL_CMD(" + _GetMyModName() + ", " + _GetMyScriptName() + ", '" + cmd + "') [" + type + "]: " + text)
endfunction

;----\
; API \
;--------------------------------------------------------

bool function RegisterCommand(string cmd, string callback, string vars = "", string desc = "")
	if StringUtil.Find(cmd, "(") != -1 || StringUtil.Find(cmd, ")") != -1
		_Print(cmd, "The command contains one or more of the following illegal characters: '(', ')'", "Error")
		return false
	endif
	
	if StringUtil.Find(vars, " ") != -1
		_Print(cmd, "The variable types contain an illegal character ' '", "Error")
		return false
	endif

	string[] vars_type = StringUtil.Split(vars, ",")
	int i = 0

	while i != vars_type.length
		string var_type = vars_type[i]
		
		if var_type == "bool"
		elseif var_type == "int"
		elseif var_type == "float"
		elseif var_type == "string"
		elseif var_type == "form"
		else
			_Print(cmd, "The specified parameter type '" + var_type + "' at index " + i + " is not valid. Valid parameter types are: bool, int, float, string and form", "Error")
			return false
		endif
		
		i += 1
	endwhile
	
	nl_cmd main = Game.GetFormFromFile(CMD_QUEST_FORM, "nl_cmd.esl") as nl_cmd

	if main == None
		_Print(cmd, "NL_CMD is not installed, aborting registration of command")
		return false
	endif

	if !main.RegisterCommand(cmd, vars, desc)
		_Print(cmd, "Failed to register the command", "Error")
		return false
	endif
	
	RegisterForModEvent("nl_cmd_" + cmd, callback)
	
	_Print(cmd, "Registered the command")
	return true
endfunction

bool function UnregisterCommand(string cmd)
	nl_cmd main = Game.GetFormFromFile(CMD_QUEST_FORM, "nl_cmd.esl") as nl_cmd

	if main == None
		_Print(cmd, "NL_CMD is not installed, aborting registration of command")
		return false
	endif

	if !main.UnregisterCommand(cmd)
		_Print(cmd, "Failed to unregister the command", "Error")
		return false
	endif

	UnregisterForModEvent("nl_cmd_" + cmd)

	_Print(cmd, "Unregistered the command")
	return true
endfunction

function PrintConsole(string text)
	Ui.InvokeString(_CON, "_global.Console.AddHistory", text + "\n")
endfunction

function ClearConsole()
	Ui.Invoke(_CON, "_global.Console.ClearHistory")
endfunction

string function GetLastConsoleCommand()
	int cmds_i =  Ui.GetInt(_CON, "_global.Console.ConsoleInstance.Commands.length") - 1
	return Ui.GetString(_CON, "_global.Console.ConsoleInstance.Commands." + cmds_i)
endfunction