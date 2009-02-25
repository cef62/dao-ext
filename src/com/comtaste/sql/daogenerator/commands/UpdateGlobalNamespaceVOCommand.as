package com.comtaste.sql.daogenerator.commands
{
    import com.comtaste.sql.daogenerator.model.DaoGenModelLocator;
    import com.comtaste.sql.daogenerator.model.vo.GlobalNamespaceUpdateVO;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
    import org.puremvc.as3.patterns.observer.*;
    
    public class UpdateGlobalNamespaceVOCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
			var vo:GlobalNamespaceUpdateVO = note.getBody() as GlobalNamespaceUpdateVO; 
			
			DaoGenModelLocator.getInstance().globalNamespaceVO = vo.newValue;
		}
        
    }
}
