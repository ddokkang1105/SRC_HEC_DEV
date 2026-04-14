package xbolt.custom.daelim.plant.EnsemblePlus;

public class DLMWebServiceProxy implements xbolt.custom.daelim.plant.EnsemblePlus.DLMWebService {
  private String _endpoint = null;
  private xbolt.custom.daelim.plant.EnsemblePlus.DLMWebService dLMWebService = null;
  
  public DLMWebServiceProxy() {
    _initDLMWebServiceProxy();
  }
  
  public DLMWebServiceProxy(String endpoint) {
    _endpoint = endpoint;
    _initDLMWebServiceProxy();
  }
  
  private void _initDLMWebServiceProxy() {
    try {
      dLMWebService = (new xbolt.custom.daelim.plant.EnsemblePlus.DLMWebServiceServiceLocator()).getDLMWebService();
      if (dLMWebService != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)dLMWebService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)dLMWebService)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (dLMWebService != null)
      ((javax.xml.rpc.Stub)dLMWebService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public xbolt.custom.daelim.plant.EnsemblePlus.DLMWebService getDLMWebService() {
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService;
  }
  
  public java.lang.String getApprovalLineSerial(java.lang.String projectCode, java.lang.String dmcsIssueNo) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.getApprovalLineSerial(projectCode, dmcsIssueNo);
  }
  
  public java.lang.String fnFinalPDFTransferResult(java.lang.String projectNo, java.lang.String vendorItemID, java.lang.String slipNumber, java.lang.String filePath, java.lang.String originFileName) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.fnFinalPDFTransferResult(projectNo, vendorItemID, slipNumber, filePath, originFileName);
  }
  
  public java.lang.String fnFinalPDFCheckInService(java.lang.String projectNo, java.lang.String objectId, java.lang.String slipNumber, java.lang.String filePath, java.lang.String originalFileName) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.fnFinalPDFCheckInService(projectNo, objectId, slipNumber, filePath, originalFileName);
  }
  
  public java.lang.String checkoutSignImage(java.lang.String sUserNo) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.checkoutSignImage(sUserNo);
  }
  
  public boolean fnCheckNewSystemProject(java.lang.String projectNo, boolean isProject) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.fnCheckNewSystemProject(projectNo, isProject);
  }
  
  public java.lang.String fnCompleteEDBTask(java.lang.String projectNo, java.lang.String taskId, java.lang.String comments, java.lang.String taskUser) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.fnCompleteEDBTask(projectNo, taskId, comments, taskUser);
  }
  
  public java.lang.String fnGetUserProposal(java.lang.String userId) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.fnGetUserProposal(userId);
  }
  
  public java.lang.String getMYTeamProjectDoc(java.lang.String projectNo, java.lang.String sECSDocType) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.getMYTeamProjectDoc(projectNo, sECSDocType);
  }
  
  public java.lang.String getLoginNO_IDTF_TODO(java.lang.String CL_RQST, java.lang.String CD_RQST, java.lang.String ID_RQST, java.lang.String DOC_ID, java.lang.String m_SUBJECT, java.lang.String s_SUBJECT, java.lang.String SYS_NAME) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.getLoginNO_IDTF_TODO(CL_RQST, CD_RQST, ID_RQST, DOC_ID, m_SUBJECT, s_SUBJECT, SYS_NAME);
  }
  
  public java.lang.String getVPActDateInfoByPO(java.lang.String projectCode) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.getVPActDateInfoByPO(projectCode);
  }
  
  public java.lang.String getPDFSignPositionInfoJson(java.lang.String filePath, java.lang.String fileName, java.lang.String jsonHashCode) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.getPDFSignPositionInfoJson(filePath, fileName, jsonHashCode);
  }
  
  public java.lang.String getProjectMemberInfo(java.lang.String projectCode) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.getProjectMemberInfo(projectCode);
  }
  
  public java.lang.String getEnsembleDDSRInfo(java.lang.String sProjectNo, java.lang.String sProjectProposal) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.getEnsembleDDSRInfo(sProjectNo, sProjectProposal);
  }
  
  public java.lang.String getEnsembleEDCSInfo(java.lang.String sProjectNo, java.lang.String sProjectProposal, boolean isLast) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.getEnsembleEDCSInfo(sProjectNo, sProjectProposal, isLast);
  }
  
  public java.lang.String getLoginNO_IDTF(java.lang.String CL_RQST, java.lang.String CD_RQST, java.lang.String ID_RQST) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.getLoginNO_IDTF(CL_RQST, CD_RQST, ID_RQST);
  }
  
  public java.lang.String fnAddEDBTask(java.lang.String projectNo, java.lang.String DESC, java.lang.String title, java.lang.String requester, java.lang.String taskId, java.lang.String deptCode, java.lang.String requestDate, java.lang.String dueDate) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.fnAddEDBTask(projectNo, DESC, title, requester, taskId, deptCode, requestDate, dueDate);
  }
  
  public java.lang.String fnGetUserProject(java.lang.String userId) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.fnGetUserProject(userId);
  }
  
  public boolean uploadECSDOCFile(java.lang.String sBase64Input, java.lang.String fileName, java.lang.String sDOC_NO, java.lang.String sIssueNo, java.lang.String userId) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.uploadECSDOCFile(sBase64Input, fileName, sDOC_NO, sIssueNo, userId);
  }
  
  public java.lang.String checkUserError(java.lang.String userId) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.checkUserError(userId);
  }
  
  public java.lang.String VPSearch(java.lang.String projectNo, java.lang.String sItemTag) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.VPSearch(projectNo, sItemTag);
  }
  
  public java.lang.String checkInSignImage(java.lang.String sUserNo, java.lang.String sSignFileName, java.lang.String sBase64Code) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.checkInSignImage(sUserNo, sSignFileName, sBase64Code);
  }
  
  public java.lang.String VPSearchDetail(java.lang.String projectNo, java.lang.String PONo, java.lang.String PODesc, java.lang.String itemNo, java.lang.String itemDesc, java.lang.String VPNo, java.lang.String VPTitle, java.lang.String vendorNo) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.VPSearchDetail(projectNo, PONo, PODesc, itemNo, itemDesc, VPNo, VPTitle, vendorNo);
  }
  
  public java.lang.String VPSearchPMCS(java.lang.String projectNo, java.lang.String PONo) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.VPSearchPMCS(projectNo, PONo);
  }
  
  public java.lang.String setBigRoomLink(java.lang.String type, java.lang.String jobNo, java.lang.String addLink) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.setBigRoomLink(type, jobNo, addLink);
  }
  
  public java.lang.String getEnsembleUserList(java.lang.String type, java.lang.String jobNo, java.lang.String team, java.lang.String role) throws java.rmi.RemoteException{
    if (dLMWebService == null)
      _initDLMWebServiceProxy();
    return dLMWebService.getEnsembleUserList(type, jobNo, team, role);
  }
  
  
}