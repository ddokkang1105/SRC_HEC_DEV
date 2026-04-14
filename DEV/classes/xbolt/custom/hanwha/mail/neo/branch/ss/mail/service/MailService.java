/**
 * MailService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package xbolt.custom.hanwha.mail.neo.branch.ss.mail.service;

public interface MailService extends java.rmi.Remote {
    public xbolt.custom.hanwha.mail.neo.branch.ss.mail.vo.WsMailStatus[] getMailStatusCounts(java.lang.String[] mailKey) throws java.rmi.RemoteException, xbolt.custom.hanwha.mail.neo.branch.ss.common.vo.WsException;
    public java.lang.String cancelMISMailByRecipient(java.lang.String mailKey, java.lang.String[] receiverForCancel, xbolt.custom.hanwha.mail.neo.branch.ss.mail.vo.WsResource senderInfo) throws java.rmi.RemoteException, xbolt.custom.hanwha.mail.neo.branch.ss.common.vo.WsException;
    public java.lang.String sendMISMail(java.lang.String mailBody, xbolt.custom.hanwha.mail.neo.branch.ss.mail.vo.WsMailInfo mailInfo, xbolt.custom.hanwha.mail.neo.branch.ss.mail.vo.WsRecipient[] receivers, xbolt.custom.hanwha.mail.neo.branch.ss.common.vo.WsAttachFile[] attachFile) throws java.rmi.RemoteException, xbolt.custom.hanwha.mail.neo.branch.ss.common.vo.WsException;
}
