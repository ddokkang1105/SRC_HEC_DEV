/**
 * AdrmWebServiceImplServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package xbolt.custom.hanwha.adrm.ws.service.impl;

import xbolt.custom.hanwha.val.HanwhaGlobalVal;

public class AdrmWebServiceImplServiceLocator extends org.apache.axis.client.Service implements xbolt.custom.hanwha.adrm.ws.service.impl.AdrmWebServiceImplService {

    public AdrmWebServiceImplServiceLocator() {
    }


    public AdrmWebServiceImplServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public AdrmWebServiceImplServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for AdrmWebServiceImplPort
    private java.lang.String AdrmWebServiceImplPort_address = HanwhaGlobalVal.HW_ADRM_WSDL_SERVICE_URL+"adrm/ws/appr";
    //private java.lang.String AdrmWebServiceImplPort_address = "http://96.97.23.86:8080/adrm/ws/appr";

    public java.lang.String getAdrmWebServiceImplPortAddress() {
        return AdrmWebServiceImplPort_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String AdrmWebServiceImplPortWSDDServiceName = "AdrmWebServiceImplPort";

    public java.lang.String getAdrmWebServiceImplPortWSDDServiceName() {
        return AdrmWebServiceImplPortWSDDServiceName;
    }

    public void setAdrmWebServiceImplPortWSDDServiceName(java.lang.String name) {
        AdrmWebServiceImplPortWSDDServiceName = name;
    }

    public xbolt.custom.hanwha.adrm.ws.service.AdrmWebService getAdrmWebServiceImplPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(AdrmWebServiceImplPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getAdrmWebServiceImplPort(endpoint);
    }

    public xbolt.custom.hanwha.adrm.ws.service.AdrmWebService getAdrmWebServiceImplPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            xbolt.custom.hanwha.adrm.ws.service.impl.AdrmWebServiceImplServiceSoapBindingStub _stub = new xbolt.custom.hanwha.adrm.ws.service.impl.AdrmWebServiceImplServiceSoapBindingStub(portAddress, this);
            _stub.setPortName(getAdrmWebServiceImplPortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setAdrmWebServiceImplPortEndpointAddress(java.lang.String address) {
        AdrmWebServiceImplPort_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (xbolt.custom.hanwha.adrm.ws.service.AdrmWebService.class.isAssignableFrom(serviceEndpointInterface)) {
                xbolt.custom.hanwha.adrm.ws.service.impl.AdrmWebServiceImplServiceSoapBindingStub _stub = new xbolt.custom.hanwha.adrm.ws.service.impl.AdrmWebServiceImplServiceSoapBindingStub(new java.net.URL(AdrmWebServiceImplPort_address), this);
                _stub.setPortName(getAdrmWebServiceImplPortWSDDServiceName());
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
        if ("AdrmWebServiceImplPort".equals(inputPortName)) {
            return getAdrmWebServiceImplPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://impl.service.ws.adrm.acube.sds.com/", "AdrmWebServiceImplService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://impl.service.ws.adrm.acube.sds.com/", "AdrmWebServiceImplPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("AdrmWebServiceImplPort".equals(portName)) {
            setAdrmWebServiceImplPortEndpointAddress(address);
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
