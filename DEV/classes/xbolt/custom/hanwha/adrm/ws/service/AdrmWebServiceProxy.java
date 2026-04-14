package xbolt.custom.hanwha.adrm.ws.service;

public class AdrmWebServiceProxy implements xbolt.custom.hanwha.adrm.ws.service.AdrmWebService {
  private String _endpoint = null;
  private xbolt.custom.hanwha.adrm.ws.service.AdrmWebService adrmWebService = null;
  
  public AdrmWebServiceProxy() {
    _initAdrmWebServiceProxy();
  }
  
  public AdrmWebServiceProxy(String endpoint) {
    _endpoint = endpoint;
    _initAdrmWebServiceProxy();
  }
  
  private void _initAdrmWebServiceProxy() {
    try {
      adrmWebService = (new xbolt.custom.hanwha.adrm.ws.service.impl.AdrmWebServiceImplServiceLocator()).getAdrmWebServiceImplPort();
      if (adrmWebService != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)adrmWebService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)adrmWebService)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (adrmWebService != null)
      ((javax.xml.rpc.Stub)adrmWebService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public xbolt.custom.hanwha.adrm.ws.service.AdrmWebService getAdrmWebService() {
    if (adrmWebService == null)
      _initAdrmWebServiceProxy();
    return adrmWebService;
  }
  
  public java.lang.String hello(java.lang.String arg0) throws java.rmi.RemoteException{
    if (adrmWebService == null)
      _initAdrmWebServiceProxy();
    return adrmWebService.hello(arg0);
  }
  
  public xbolt.custom.hanwha.adrm.ws.service.WsRuleResultVO getApprovalLine(xbolt.custom.hanwha.adrm.ws.service.WsRuleParamVO wsRuleParam) throws java.rmi.RemoteException{
    if (adrmWebService == null)
      _initAdrmWebServiceProxy();
    return adrmWebService.getApprovalLine(wsRuleParam);
  }
  
  
}