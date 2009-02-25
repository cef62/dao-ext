package com.comtaste.sql.daogenerator.commands.startup
{
    
    import com.comtaste.sql.daogenerator.model.DAOGeneratorProxy;
    import com.comtaste.sql.daogenerator.model.DaoGenModelLocator;
    import com.comtaste.sql.daogenerator.model.VOGeneratorProxy;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
    import org.puremvc.as3.patterns.observer.*;
    
    public class ModelPrepCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
            DaoGenModelLocator.getInstance();
            
            facade.registerProxy( new VOGeneratorProxy() );
            facade.registerProxy( new DAOGeneratorProxy() );
        }
    }
}