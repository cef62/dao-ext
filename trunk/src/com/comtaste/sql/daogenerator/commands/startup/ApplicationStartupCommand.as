package com.comtaste.sql.daogenerator.commands.startup
{
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    /**
     * A MacroCommand executed when the application starts.
     * 
     */
    public class ApplicationStartupCommand extends MacroCommand
    {
        override protected function initializeMacroCommand() :void
        {
            addSubCommand( ModelPrepCommand );
            addSubCommand( ViewPrepCommand );
        }
        
    }
}
