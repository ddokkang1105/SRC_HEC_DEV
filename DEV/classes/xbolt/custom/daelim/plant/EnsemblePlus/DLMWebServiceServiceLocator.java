/**
 * DLMWebServiceServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package xbolt.custom.daelim.plant.EnsemblePlus;

import xbolt.custom.daelim.val.DaelimGlobalVal;

public class DLMWebServiceServiceLocator extends org.apache.axis.client.Service implements xbolt.custom.daelim.plant.EnsemblePlus.DLMWebServiceService {

    public DLMWebServiceServiceLocator() {
    }


    public DLMWebServiceServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public DLMWebServiceServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for DLMWebService
    private java.lang.String DLMWebService_address = DaelimGlobalVal.DLM_WEBSERVICE_URL;

    public java.lang.String getDLMWebServiceAddress() {
        return DLMWebService_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String DLMWebServiceWSDDServiceName = "DLMWebService";

    public java.lang.String getDLMWebServiceWSDDServiceName() {
        return DLMWebServiceWSDDServiceName;
    }

    public void setDLMWebServiceWSDDServiceName(java.lang.String name) {
        DLMWebServiceWSDDServiceName = name;
    }

    public xbolt.custom.daelim.plant.EnsemblePlus.DLMWebService getDLMWebService() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(DLMWebService_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getDLMWebService(endpoint);
    }

    public xbolt.custom.daelim.plant.EnsemblePlus.DLMWebService getDLMWebService(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            xbolt.custom.daelim.plant.EnsemblePlus.DLMWebServiceSoapBindingStub _stub = new xbolt.custom.daelim.plant.EnsemblePlus.DLMWebServiceSoapBindingStub(portAddress, this);
            _stub.setPortName(getDLMWebServiceWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setDLMWebServiceEndpointAddress(java.lang.String address) {
        DLMWebService_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (xbolt.custom.daelim.plant.EnsemblePlus.DLMWebService.class.isAssignableFrom(serviceEndpointInterface)) {
                xbolt.custom.daelim.plant.EnsemblePlus.DLMWebServiceSoapBindingStub _stub = new xbolt.custom.daelim.plant.EnsemblePlus.DLMWebServiceSoapBindingStub(new java.net.URL(DLMWebService_address), this);
                _stub.setPortName(getDLMWebServiceWSDDServiceName());
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
        if ("DLMWebService".equals(inputPortName)) {
            return getDLMWebService();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://EnsemblePlus.Webservice", "DLMWebServiceService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://EnsemblePlus.Webservice", "DLMWebService"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("DLMWebService".equals(portName)) {
            setDLMWebServiceEndpointAddress(address);
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
