/**
 * KIACSvcSoap.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service;

public interface KIACSvcSoap extends java.rmi.Remote {

    /**
     * 오토웨이 통합 결재문서 건수 연계
     */
    public boolean updateDocumentCount(xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.CountInformation[] data) throws java.rmi.RemoteException;

    /**
     * 오토웨이 결재자 정보 조회
     */
    public xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.UserInformation searchUserInformation(java.lang.String userID) throws java.rmi.RemoteException;

    /**
     * 오토웨이 조직장 정보 조회
     */
    public xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.UserInformation[] searchLeaderInformations() throws java.rmi.RemoteException;
}
