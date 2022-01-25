Scriptname nl_cmd_example1 extends nl_cmd_module

event OnInit()
    ; Here we register commands in the OnInit event,
    ; but you can also do it elsewhere if you wish.
    ;
    ; The papyrus comment behind the registration calls are
    ; verbatim examples of how you would call them in-game.
    ;
    ; Note that since the command namespace is shared, 
    ; a good practice would be to prefix your commands with a unique tag
    ; to differentiate them from other mods' commands. E.g. "mymod hello" instead of "hello".
    ; That, or ensure you handle registration errors if they occur.

    ; Simple commands without arguments
    RegisterCommand("hello", "OnHelloCommand", desc = "Prints hello to the console") ; nl_cmd hello
    RegisterCommand("clear", "OnClearCommand") ; nl_cmd clear
    RegisterCommand("disable_selection", "OnDisableSel", desc = "Disable the currently selected console object") ; nl_cmd disable_selection
    ; Single argument commands
    RegisterCommand("hello to", "OnHelloToCommand", "string") ; nl_cmd hello to(peter)
    RegisterCommand("run native", "OnRunNativeCommand", "string", "Run a native console command") ; nl_cmd run native(player.placeatme 00013BBF 1)
    ; Double argument command
    RegisterCommand("spawn form", "OnSpawnCommand", "form,int", "Identical to place at me command") ; nl_cmd spawn form(0x00013BBF;1)
    ; Multiple argument command
    RegisterCommand("spam", "OnSpamC", "form,string,bool,int,float", "Print random stuff") ; nl_cmd spam(0xF;test;test2;1;2.0)
    
    ; To unregister any of the above commands, we just call UnregisterCommand on their name
    ; e.g. UnregisterCommand("spam")

    ; Below are some examples of invalid command registrations that will trigger errors
    RegisterCommand("hello", "OnInvalidCommand") ; Fails because the hello command has already been registered
    RegisterCommand("set alias", "OnInvalidCommand2", "referencealias") ; Fails because the only valid parameter types are: form, string, float, bool, int
    RegisterCommand("advanced print", "OnInvalidCommand3", "string;int") ; Fails because we define type using ; as our type separator. We only use ; to separate variables when *calling* registered commands

    ; Errors can be detected by checking the returned bool result of a function call
    bool succeeded = RegisterCommand("hello", "OnInvalidCommand")

    if succeeded
        ; Yaay!!!
    else
        ; Damn...
    endif
endevent

event OnHelloCommand()
    PrintConsole("Hello user!")
endevent

event OnClearCommand()
    ClearConsole()
endevent

event OnDisableSel()
    Objectreference obj = GetCurrentConsoleSelection()
    
    ; If user has selected something, obj is not None
    if obj != None
        obj.Disable()
    endif
endevent

event OnHelloToCommand(string name)
    PrintConsole("Hello to " + name + "!")
endevent

event OnRunNativeCommand(string command)
    ExecuteConsoleNative(command)
endevent

event OnSpawnCommand(form to_spawn, int number)
    ; Check if form is valid before we try to spawn
    if to_spawn
        Game.GetPlayer().PlaceAtMe(to_spawn, number)
    endif
endevent

event OnSpamC(form some_form, string text, bool b, int i, float f)
    Debug.Trace("I just want to print random stuff!!!! " + some_form as string + " " + text + " " + b + " " + i + " " + f)
endevent

event OnInvalidCommand()
    ; This callback will never trigger
    ; because the registrations will fail
endevent

event OnInvalidCommand2(referencealias the_alias)
    ; This callback will never trigger
    ; because the registrations will fail
endevent

event OnInvalidCommand3(string text, int some_number)
    ; This callback will never trigger
    ; because the registrations will fail
endevent