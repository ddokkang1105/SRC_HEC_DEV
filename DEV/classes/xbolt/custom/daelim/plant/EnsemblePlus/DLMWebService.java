/**
 * DLMWebService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package xbolt.custom.daelim.plant.EnsemblePlus;

public interface DLMWebService extends java.rmi.Remote {
    public java.lang.String getApprovalLineSerial(java.lang.String projectCode, java.lang.String dmcsIssueNo) throws java.rmi.RemoteException;
    public java.lang.String fnFinalPDFTransferResult(java.lang.String projectNo, java.lang.String vendorItemID, java.lang.String slipNumber, java.lang.String filePath, java.lang.String originFileName) throws java.rmi.RemoteException;
    public java.lang.String fnFinalPDFCheckInService(java.lang.String projectNo, java.lang.String objectId, java.lang.String slipNumber, java.lang.String filePath, java.lang.String originalFileName) throws java.rmi.RemoteException;
    public java.lang.String checkoutSignImage(java.lang.String sUserNo) throws java.rmi.RemoteException;
    public boolean fnCheckNewSystemProject(java.lang.String projectNo, boolean isProject) throws java.rmi.RemoteException;
    public java.lang.String fnCompleteEDBTask(java.lang.String projectNo, java.lang.String taskId, java.lang.String comments, java.lang.String taskUser) throws java.rmi.RemoteException;
    public java.lang.String fnGetUserProposal(java.lang.String userId) throws java.rmi.RemoteException;
    public java.lang.String getMYTeamProjectDoc(java.lang.String projectNo, java.lang.String sECSDocType) throws java.rmi.RemoteException;
    public java.lang.String getLoginNO_IDTF_TODO(java.lang.String CL_RQST, java.lang.String CD_RQST, java.lang.String ID_RQST, java.lang.String DOC_ID, java.lang.String m_SUBJECT, java.lang.String s_SUBJECT, java.lang.String SYS_NAME) throws java.rmi.RemoteException;
    public java.lang.String getVPActDateInfoByPO(java.lang.String projectCode) throws java.rmi.RemoteException;
    public java.lang.String getPDFSignPositionInfoJson(java.lang.String filePath, java.lang.String fileName, java.lang.String jsonHashCode) throws java.rmi.RemoteException;
    public java.lang.String getProjectMemberInfo(java.lang.String projectCode) throws java.rmi.RemoteException;
    public java.lang.String getEnsembleDDSRInfo(java.lang.String sProjectNo, java.lang.String sProjectProposal) throws java.rmi.RemoteException;
    public java.lang.String getEnsembleEDCSInfo(java.lang.String sProjectNo, java.lang.String sProjectProposal, boolean isLast) throws java.rmi.RemoteException;
    public java.lang.String getLoginNO_IDTF(java.lang.String CL_RQST, java.lang.String CD_RQST, java.lang.String ID_RQST) throws java.rmi.RemoteException;
    public java.lang.String fnAddEDBTask(java.lang.String projectNo, java.lang.String DESC, java.lang.String title, java.lang.String requester, java.lang.String taskId, java.lang.String deptCode, java.lang.String requestDate, java.lang.String dueDate) throws java.rmi.RemoteException;
    public java.lang.String fnGetUserProject(java.lang.String userId) throws java.rmi.RemoteException;
    public boolean uploadECSDOCFile(java.lang.String sBase64Input, java.lang.String fileName, java.lang.String sDOC_NO, java.lang.String sIssueNo, java.lang.String userId) throws java.rmi.RemoteException;
    public java.lang.String checkUserError(java.lang.String userId) throws java.rmi.RemoteException;
    public java.lang.String VPSearch(java.lang.String projectNo, java.lang.String sItemTag) throws java.rmi.RemoteException;
    public java.lang.String checkInSignImage(java.lang.String sUserNo, java.lang.String sSignFileName, java.lang.String sBase64Code) throws java.rmi.RemoteException;
    public java.lang.String VPSearchDetail(java.lang.String projectNo, java.lang.String PONo, java.lang.String PODesc, java.lang.String itemNo, java.lang.String itemDesc, java.lang.String VPNo, java.lang.String VPTitle, java.lang.String vendorNo) throws java.rmi.RemoteException;
    public java.lang.String VPSearchPMCS(java.lang.String projectNo, java.lang.String PONo) throws java.rmi.RemoteException;
    public java.lang.String setBigRoomLink(java.lang.String type, java.lang.String jobNo, java.lang.String addLink) throws java.rmi.RemoteException;
    public java.lang.String getEnsembleUserList(java.lang.String type, java.lang.String jobNo, java.lang.String team, java.lang.String role) throws java.rmi.RemoteException;
}
