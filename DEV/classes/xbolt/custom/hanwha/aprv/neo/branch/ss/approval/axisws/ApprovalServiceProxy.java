package xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws;

public class ApprovalServiceProxy implements xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalService {
  private String _endpoint = null;
  private xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalService approvalService = null;
  
  public ApprovalServiceProxy() {
    _initApprovalServiceProxy();
  }
  
  public ApprovalServiceProxy(String endpoint) {
    _endpoint = endpoint;
    _initApprovalServiceProxy();
  }
  
  private void _initApprovalServiceProxy() {
    try {
      approvalService = (new xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalServiceServiceLocator()).getApprovalService();
      if (approvalService != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)approvalService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)approvalService)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (approvalService != null)
      ((javax.xml.rpc.Stub)approvalService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalService getApprovalService() {
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService;
  }
  
  public java.lang.String submitTempApproval(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.submitTempApproval(approvalDocument);
  }
  
  public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.DelegatedSignerInfo getOriginUserIDUseUserId(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.MisKey miskey, xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.getOriginUserIDUseUserId(miskey, delegatedSignerInfo);
  }
  
  public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocumentList[] getListByUserKeyUseUserId(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.getListByUserKeyUseUserId(approvalUserKey);
  }
  
  public java.lang.String submitApprovalUseUserId(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.submitApprovalUseUserId(approvalDocument);
  }
  
  public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocumentStatusOnly[] getProcessIdByBulkMisId(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.MisKey[] miskey) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.getProcessIdByBulkMisId(miskey);
  }
  
  public java.lang.String submitApproval(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.submitApproval(approvalDocument);
  }
  
  public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocumentStatus getStatusByMisId(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.MisKey miskey) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.getStatusByMisId(miskey);
  }
  
  public java.lang.String cancelApproval(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.CancelApprovalDocument cancelApprovalDocument) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.cancelApproval(cancelApprovalDocument);
  }
  
  public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.DelegatedSignerInfo getOriginUserID(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.MisKey miskey, xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.getOriginUserID(miskey, delegatedSignerInfo);
  }
  
  public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocumentList[] getListByUserKey(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.getListByUserKey(approvalUserKey);
  }
  
  public java.lang.String submitTempApprovalUseUserId(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.submitTempApprovalUseUserId(approvalDocument);
  }
  
  
}