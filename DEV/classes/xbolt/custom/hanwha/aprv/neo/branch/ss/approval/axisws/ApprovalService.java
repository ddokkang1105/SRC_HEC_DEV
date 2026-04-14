/**
 * ApprovalService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws;

public interface ApprovalService extends java.rmi.Remote {
    public java.lang.String submitTempApproval(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException;
    public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.DelegatedSignerInfo getOriginUserIDUseUserId(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.MisKey miskey, xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException;
    public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocumentList[] getListByUserKeyUseUserId(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException;
    public java.lang.String submitApprovalUseUserId(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException;
    public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocumentStatusOnly[] getProcessIdByBulkMisId(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.MisKey[] miskey) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException;
    public java.lang.String submitApproval(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException;
    public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocumentStatus getStatusByMisId(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.MisKey miskey) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException;
    public java.lang.String cancelApproval(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.CancelApprovalDocument cancelApprovalDocument) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException;
    public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.DelegatedSignerInfo getOriginUserID(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.MisKey miskey, xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException;
    public xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocumentList[] getListByUserKey(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException;
    public java.lang.String submitTempApprovalUseUserId(xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, xbolt.custom.hanwha.aprv.neo.branch.ss.common.vo.WsException;
}
