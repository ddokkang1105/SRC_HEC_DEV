package xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service;

public class KIACSvcSoapProxy implements xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcSoap {
  private String _endpoint = null;
  private xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcSoap kIACSvcSoap = null;
  
  public KIACSvcSoapProxy() {
    _initKIACSvcSoapProxy();
  }
  
  public KIACSvcSoapProxy(String endpoint) {
    _endpoint = endpoint;
    _initKIACSvcSoapProxy();
  }
  
  private void _initKIACSvcSoapProxy() {
    try {
      kIACSvcSoap = (new xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcLocator()).getKIACSvcSoap();
      if (kIACSvcSoap != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)kIACSvcSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)kIACSvcSoap)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (kIACSvcSoap != null)
      ((javax.xml.rpc.Stub)kIACSvcSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcSoap getKIACSvcSoap() {
    if (kIACSvcSoap == null)
      _initKIACSvcSoapProxy();
    return kIACSvcSoap;
  }
  
  public boolean updateDocumentCount(xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.CountInformation[] data) throws java.rmi.RemoteException{
    if (kIACSvcSoap == null)
      _initKIACSvcSoapProxy();
    return kIACSvcSoap.updateDocumentCount(data);
  }
  
  public xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.UserInformation searchUserInformation(java.lang.String userID) throws java.rmi.RemoteException{
    if (kIACSvcSoap == null)
      _initKIACSvcSoapProxy();
    return kIACSvcSoap.searchUserInformation(userID);
  }
  
  public xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.UserInformation[] searchLeaderInformations() throws java.rmi.RemoteException{
    if (kIACSvcSoap == null)
      _initKIACSvcSoapProxy();
    return kIACSvcSoap.searchLeaderInformations();
  }
  
  
}