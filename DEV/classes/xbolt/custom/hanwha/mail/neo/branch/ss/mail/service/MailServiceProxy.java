package xbolt.custom.hanwha.mail.neo.branch.ss.mail.service;

public class MailServiceProxy implements xbolt.custom.hanwha.mail.neo.branch.ss.mail.service.MailService {
  private String _endpoint = null;
  private xbolt.custom.hanwha.mail.neo.branch.ss.mail.service.MailService mailService = null;
  
  public MailServiceProxy() {
    _initMailServiceProxy();
  }
  
  public MailServiceProxy(String endpoint) {
    _endpoint = endpoint;
    _initMailServiceProxy();
  }
  
  private void _initMailServiceProxy() {
    try {
      mailService = (new xbolt.custom.hanwha.mail.neo.branch.ss.mail.service.MailServiceServiceLocator()).getMailService();
      if (mailService != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)mailService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)mailService)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (mailService != null)
      ((javax.xml.rpc.Stub)mailService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public xbolt.custom.hanwha.mail.neo.branch.ss.mail.service.MailService getMailService() {
    if (mailService == null)
      _initMailServiceProxy();
    return mailService;
  }
  
  public xbolt.custom.hanwha.mail.neo.branch.ss.mail.vo.WsMailStatus[] getMailStatusCounts(java.lang.String[] mailKey) throws java.rmi.RemoteException, xbolt.custom.hanwha.mail.neo.branch.ss.common.vo.WsException{
    if (mailService == null)
      _initMailServiceProxy();
    return mailService.getMailStatusCounts(mailKey);
  }
  
  public java.lang.String cancelMISMailByRecipient(java.lang.String mailKey, java.lang.String[] receiverForCancel, xbolt.custom.hanwha.mail.neo.branch.ss.mail.vo.WsResource senderInfo) throws java.rmi.RemoteException, xbolt.custom.hanwha.mail.neo.branch.ss.common.vo.WsException{
    if (mailService == null)
      _initMailServiceProxy();
    return mailService.cancelMISMailByRecipient(mailKey, receiverForCancel, senderInfo);
  }
  
  public java.lang.String sendMISMail(java.lang.String mailBody, xbolt.custom.hanwha.mail.neo.branch.ss.mail.vo.WsMailInfo mailInfo, xbolt.custom.hanwha.mail.neo.branch.ss.mail.vo.WsRecipient[] receivers, xbolt.custom.hanwha.mail.neo.branch.ss.common.vo.WsAttachFile[] attachFile) throws java.rmi.RemoteException, xbolt.custom.hanwha.mail.neo.branch.ss.common.vo.WsException{
    if (mailService == null)
      _initMailServiceProxy();
    return mailService.sendMISMail(mailBody, mailInfo, receivers, attachFile);
  }
  
  
}