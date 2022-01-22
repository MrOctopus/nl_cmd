Scriptname nl_cmd_example1 extends nl_cmd_module

event OnInit()
    self.RegisterCommand("hello", "OnHello", desc = "Prints hello to the console")
    self.RegisterCommand("clear", "OnClear")
    self.RegisterCommand("spawn form", "OnSpawn", "form,int")
    self.RegisterCommand("disable selection", "OnDisableSel")
    self.RegisterCommand("trigger", "OnCommandTrigger", "string")
    self.RegisterCommand("example", "OnExampleTest", "string,int,float")
    ; Invalid because randomtype is not a valid parameter type
    self.RegisterCommand("invalid_example", "OnExampleInvalid2", "string,randomtype")
endevent

event OnSpawn(form to_spawn, int number)
    Game.GetPlayer().PlaceAtMe(to_spawn, number)
endevent

event OnHello()
    self.PrintConsole("Hello!")
endevent

event OnDisableSel()
    Objectreference obj = self.GetCurrentConsoleSelection()
    if obj
        obj.Disable()
    endif
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