/* 
 * @(#) WpFunction.java
 */
package xbolt.custom.lf.sap;


//import atom.xlog.XLog;
/**
 * <pre>
 * Funtion 위한 Wrapper클래스
 * </pre>
 */
public class WpFunction {

	public static com.sap.mw.jco.JCO.Function execute( com.sap.mw.jco.JCO.Function mFunction ) {

		//XLog.print( "SAP Function START" );
		//XLog.print( "=======" );
		//XLog.print( mFunction.getName() );

		if( ( mFunction.getImportParameterList() != null ) && ( mFunction.getTableParameterList() != null ) ){	// import parameter
			//XLog.print( mFunction.getImportParameterList().toString() );
			//XLog.print( "--------------------" );
			//XLog.print( mFunction.getTableParameterList().toString() );
		} else if(  ( mFunction.getImportParameterList() != null ) && ( mFunction.getTableParameterList() == null ) ){	// import parameter
			//XLog.print( mFunction.getImportParameterList().toString() );
		} else if(  ( mFunction.getImportParameterList() == null ) && ( mFunction.getTableParameterList() != null ) ){	// import parameter
			//XLog.print( mFunction.getTableParameterList().toString() );
		} else { // no parameter
			//XLog.print( "Input Param is NULL" );
		}

		//XLog.print( "==== execute ======" );

		return mFunction;
	}

}
