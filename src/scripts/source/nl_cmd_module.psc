Scriptname nl_cmd_module extends Quest
{
	This script contains the official API functions of nl_cmd. To call them, the mod author simply needs to extend the base nl_cmd_module script,
	and then register/unregister commands in the manner that suits them best. For example, in the OnInit() script event.
	@author NeverLost
	@version 1.0.1
}

string property _CON = "Console" autoreadonly
int property CMD_QUEST_FORM = 0x00000D61 autoreadonly
{ The core nl_cmd quest script form }

bool _advanced_features = false
bool property AdvancedFeatures hidden
{
	Toggles the advanced features flag on the script. If enabled, two commands will automatically be registered for use in-game: \
	RegisterCommandOn_thisscriptname(string,string,string,string) \
    UnregisterCommandFrom_thisscriptname(string)
	@get If AdvancedFeatures is enabled or not. Default is False.
	@set bool - Enable AdvancedFeatures
}
	function Set(bool enable)
		string script_name = nl_cmd_util.GetScriptName(self)

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

function _Print(string cmd, string text, string type = "Info")
    Ui.InvokeString(_CON, "_global.Console.AddHistory", "NL_CMD [" + type + "]: " + text + "\n")
    Debug.Trace("NL_CMD(" + nl_cmd_util.GetModName(self) + ", " + nl_cmd_util.GetScriptName(self) + ", '" + cmd + "') [" + type + "]: " + text)
endfunction

;----\
; API \
;--------------------------------------------------------

bool function RegisterCommand(string cmd, string callback, string vars = "", string desc = "")
{
	Register a new command to the nl_cmd framework.
	@param cmd - The command string. All characters are allowed except '(' and ')'
	@param callback - The string name of the event callback function
	@param vars - A variable type definition represented as a string if the callback takes any arguments. Types are separated by , and no spaces, e.g. "string,string,int" or "bool". Valid types are bool, int, string, form, float
	@param desc- A string description of the command that will be printed to the console if the player types "nl_cmd help commands"
	@return A bool indicating if the registration succeeded or not
}
	if StringUtil.Find(cmd, "(") != -1 || StringUtil.Find(cmd, ")") != -1
		_Print(cmd, "The command contains one or more of the following illegal characters: '(', ')'", "Error")
		return false
	endif
	
	if StringUtil.Find(vars, " ") != -1
		_Print(cmd, "The variable types contain an illegal character ' '", "Error")
		return false
	endif

	if StringUtil.Find(vars, ";") != -1
		_Print(cmd, "The variable types contain an illegal character ';'", "Error")
		_Print(cmd, "Remember, ';' is used to separate variables when calling a command. ',' is used to separate types when *defining* a command.", "Error")
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
		_Print(cmd, "NL_CMD core is not installed, aborting registration of command")
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
{
	Unregister an existing command from the nl_cmd framework.
	@param cmd - The command string
	@return A bool indicating if the unregistration succeeded or not
}
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
{
	Print some text to the console.
	@param text - The text string to print to the console
}
	Ui.InvokeString(_CON, "_global.Console.AddHistory", text + "\n")
endfunction

function ClearConsole()
{
	Clear the console history.
}
	Ui.Invoke(_CON, "_global.Console.ClearHistory")
endfunction

function ExecuteConsoleNative(string cmd)
{
	Execute a native console command.
	@param cmd - The native string command to execute
}
	if cmd != ""
		int handle = UiCallback.Create(_CON, "_global.flash.external.ExternalInterface.call")
		
		string[] args = new string[2]
		args[0] = -1
		args[1] = cmd
		
		if handle
			UiCallback.PushString(handle, "ExecuteCommand")
			UiCallback.PushStringA(handle, args)

			UiCallback.Send(handle)
		endif
	endif
endfunction

objectreference function GetCurrentConsoleSelection()
{
	Get the current user reference selection in the console menu.
	@return The object reference of the currently selected object, or None if nothing is selected
}
	string form_string = Ui.GetString(_CON, "_global.Console.ConsoleInstance.CurrentSelection.text")

	if form_string == ""
		return None
	endif

	int form_string_len = StringUtil.GetLength(form_string)
	int form_string_var_i = StringUtil.Find(form_string, "(")
	form_string = StringUtil.Substring(form_string, form_string_var_i + 1, form_string_len - form_string_var_i - 2)

	return Game.GetFormEx(nl_cmd_util.HexStringToInt(form_string)) as objectreference
endfunction

string function GetLastConsoleCommand()
{
	Get the last command that the user input into the console.
	@return The command string
}
	int cmds_i =  Ui.GetInt(_CON, "_global.Console.ConsoleInstance.Commands.length") - 1
	return Ui.GetString(_CON, "_global.Console.ConsoleInstance.Commands." + cmds_i)
endfunction