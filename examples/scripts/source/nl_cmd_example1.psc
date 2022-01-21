Scriptname nl_cmd_example1 extends nl_cmd_module

event OnInit()
    self.RegisterCommand("hello", "OnHello", desc = "Prints hello to the console")
    self.RegisterCommand("clear", "OnClear")
    self.RegisterCommand("trigger", "OnCommandTrigger", "string")
    self.RegisterCommand("example", "OnExampleTest", "string,int,float")
    ; Invalid because of white space in command name
    self.RegisterCommand("invalid example", "OnExampleInvalid")
    ; Invalid because randomtype is not a valid parameter type
    self.RegisterCommand("invalid_example", "OnExampleInvalid2", "string,randomtype")
endevent

event OnHello()
    self.PrintConsole("Hello!")
endevent

event OnClear()
    self.ClearConsole()
endevent

event OnCommandTrigger(string str)
    self.PrintConsole("Trigger worked: " + str)
endevent

event OnExampleTest(string str, int i, float f)
    self.PrintConsole("Example worked: " + str + ", " + i + ", " + f)
endevent