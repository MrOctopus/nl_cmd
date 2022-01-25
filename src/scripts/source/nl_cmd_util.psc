Scriptname nl_cmd_util
{
	This script contains miscellaneous useful global functions.
	@author NeverLost
	@version 1.0.1
}

string function GetModName(form to_find) global
{
    Get the mod name of a form.
    @param to_find - The form to find the mod name of
    @return The mod name string
}

	int form_id = to_find.GetFormID()
	int index = Math.RightShift(form_id, 24)

	if index == 254
		return Game.GetLightModName(Math.RightShift(form_id, 12) - 0xFE000)
	endif

	return Game.GetModName(index)
endfunction

string function GetScriptName(form to_find) global
{
    Get the script name form.
    @param to_find - The form to find the scripts name of
    @return The script name string
}
	string form_string = to_find as string
	int i = 1
	int j = StringUtil.Find(form_string, " <") - 1

	return StringUtil.SubString(form_string, i, j)
endfunction

int function HexStringToInt(string hex_string) global
{
    Converts a given hex string to an int.
    @param hex_string - The hex string to convert (0x prefix is optional)
    @return The int conversion
}
    if StringUtil.Find(hex_string, "0x") == 0
        hex_string = StringUtil.Substring(hex_string, 2)
    endif

    int i = StringUtil.GetLength(hex_string)
    int hex_int
    int hex_place = 1
    
    while i > 0
        i -= 1
        string char = StringUtil.GetNthChar(hex_string, i)
        
        if StringUtil.IsDigit(char)
            hex_int += (char as int) * hex_place
        Else
            hex_int += (StringUtil.AsOrd(char) - 55) * hex_place
        endIf
        
        hex_place *= 16
    endWhile
    
    return hex_int
endfunction