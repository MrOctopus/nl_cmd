Scriptname nl_cmd_example2 extends nl_cmd_module

event OnInit()
    ; Enable dynamic command registration on this script
    ; Registers two commands with the following call syntax:
	; * RegisterCommandOn_thisscriptname(string;string;string;string)
    ; * UnregisterCommandFrom_thisscriptname(string)
    self.AdvancedFeatures = true
endevent