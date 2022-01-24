Scriptname nl_cmd_example2 extends nl_cmd_module

event OnInit()
    ; By toggling the AdvancedFeatures flag to *on*
    ; we can enable dynamic command registration on a given nl_cmd_module script.
    ; Two commands will then automatically be registered for use in-game:
    ; * RegisterCommandOn_thisscriptname(string,string,string,string)
    ; * UnregisterCommandFrom_thisscriptname(string)
    ;
    ; In the case of this script, nl_cmd_example2, the in-game command names would then be:
    ; * RegisterCommandOn_nl_cmd_example2(string,string,string,string)
    ; * UnregisterCommandFrom_nl_cmd_example2(string)
    ;
    ; As shown, the in-game command definitions are virtually identical to the ones defined in papyrus, 
    ; and as such calling them in-game is as easy as one would expect.
    AdvancedFeatures = true
endevent

; Below are two callbacks that have not yet been registered in papyrus
; but can be attempted registered and tested in-game using the verbatim command calls:
;
; nl_cmd RegisterCommandOn_nl_cmd_example2(advanced example;OnAdvancedCommand;;Description here)
; nl_cmd advanced example
; nl_cmd UnregisterCommandFrom_nl_cmd_example2(advanced example)
;
; nl_cmd RegisterCommandOn_nl_cmd_example2(advanced example 2;OnAdvancedCommand2;int;Description here)
; nl_cmd advanced example 2(2)
; nl_cmd UnregisterCommandFrom_nl_cmd_example2(advanced example 2)
event OnAdvancedCommand()
    PrintConsole("Advanced command triggered!")
endevent

event OnAdvancedCommand2(int i)
    PrintConsole("Advanced command triggered with arg: " + i + "!")
endevent