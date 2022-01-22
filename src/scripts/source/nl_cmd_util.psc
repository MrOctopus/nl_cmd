Scriptname nl_cmd_util

int function HexStringToInt(string hex_string) global
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
    
    Return hex_int
endfunction