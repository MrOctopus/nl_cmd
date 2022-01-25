Scriptname nl_cmd_globalinfo
{
	This script contains useful global functions to check the nl_cmd api version/state.
	@author NeverLost
	@version 1.0.1
}

bool function IsInstalled() global
{
	Check if nl_cmd is installed.
	@return The install state of nl_cmd
}
	return true
endfunction

int function CurrentVersion() global
{
	Get the current version of nl_cmd.
	@return The current nl_cmd version
}
	return 101
endfunction