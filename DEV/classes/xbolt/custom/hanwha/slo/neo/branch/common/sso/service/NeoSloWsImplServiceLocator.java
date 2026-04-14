/**
 * NeoSloWsImplServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package xbolt.custom.hanwha.slo.neo.branch.common.sso.service;

import xbolt.custom.hanwha.val.HanwhaGlobalVal;

public class NeoSloWsImplServiceLocator extends org.apache.axis.client.Service implements xbolt.custom.hanwha.slo.neo.branch.common.sso.service.NeoSloWsImplService {

    public NeoSloWsImplServiceLocator() {
    }


    public NeoSloWsImplServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public NeoSloWsImplServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for NeoSloWsImplPort
    private java.lang.String NeoSloWsImplPort_address = HanwhaGlobalVal.HW_WSDL_SERVICE_URL+"soap/auth/neoslo";
    //private java.lang.String NeoSloWsImplPort_address = "http://htg.circle.hanwha.com/api/ss/neoslo";

    public java.lang.String getNeoSloWsImplPortAddress() {
        return NeoSloWsImplPort_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String NeoSloWsImplPortWSDDServiceName = "NeoSloWsImplPort";

    public java.lang.String getNeoSloWsImplPortWSDDServiceName() {
        return NeoSloWsImplPortWSDDServiceName;
    }

    public void setNeoSloWsImplPortWSDDServiceName(java.lang.String name) {
        NeoSloWsImplPortWSDDServiceName = name;
    }

    public xbolt.custom.hanwha.slo.neo.branch.common.sso.service.NeoSloWs getNeoSloWsImplPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(NeoSloWsImplPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getNeoSloWsImplPort(endpoint);
    }

    public xbolt.custom.hanwha.slo.neo.branch.common.sso.service.NeoSloWs getNeoSloWsImplPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
        	xbolt.custom.hanwha.slo.neo.branch.common.sso.service.NeoSloWsImplServiceSoapBindingStub _stub = new xbolt.custom.hanwha.slo.neo.branch.common.sso.service.NeoSloWsImplServiceSoapBindingStub(portAddress, this);
            _stub.setPortName(getNeoSloWsImplPortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setNeoSloWsImplPortEndpointAddress(java.lang.String address) {
        NeoSloWsImplPort_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (xbolt.custom.hanwha.slo.neo.branch.common.sso.service.NeoSloWs.class.isAssignableFrom(serviceEndpointInterface)) {
            	xbolt.custom.hanwha.slo.neo.branch.common.sso.service.NeoSloWsImplServiceSoapBindingStub _stub = new xbolt.custom.hanwha.slo.neo.branch.common.sso.service.NeoSloWsImplServiceSoapBindingStub(new java.net.URL(NeoSloWsImplPort_address), this);
                _stub.setPortName(getNeoSloWsImplPortWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("NeoSloWsImplPort".equals(inputPortName)) {
            return getNeoSloWsImplPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://service.sso.common.branch.neo.hanwha/", "NeoSloWsImplService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://service.sso.common.branch.neo.hanwha/", "NeoSloWsImplPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("NeoSloWsImplPort".equals(portName)) {
            setNeoSloWsImplPortEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
