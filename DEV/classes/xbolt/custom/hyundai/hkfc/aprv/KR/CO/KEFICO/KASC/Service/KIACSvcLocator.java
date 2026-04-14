/**
 * KIACSvcLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service;

public class KIACSvcLocator extends org.apache.axis.client.Service implements xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvc {

    public KIACSvcLocator() {
    }


    public KIACSvcLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public KIACSvcLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for KIACSvcSoap
    private java.lang.String KIACSvcSoap_address = "http://appservice.kefico.co.kr/KIAC/KIACSvc.asmx";

    public java.lang.String getKIACSvcSoapAddress() {
        return KIACSvcSoap_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String KIACSvcSoapWSDDServiceName = "KIACSvcSoap";

    public java.lang.String getKIACSvcSoapWSDDServiceName() {
        return KIACSvcSoapWSDDServiceName;
    }

    public void setKIACSvcSoapWSDDServiceName(java.lang.String name) {
        KIACSvcSoapWSDDServiceName = name;
    }

    public xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcSoap getKIACSvcSoap() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(KIACSvcSoap_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getKIACSvcSoap(endpoint);
    }

    public xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcSoap getKIACSvcSoap(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
        	xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcSoapStub _stub = new xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcSoapStub(portAddress, this);
            _stub.setPortName(getKIACSvcSoapWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setKIACSvcSoapEndpointAddress(java.lang.String address) {
        KIACSvcSoap_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcSoap.class.isAssignableFrom(serviceEndpointInterface)) {
            	xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcSoapStub _stub = new xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcSoapStub(new java.net.URL(KIACSvcSoap_address), this);
                _stub.setPortName(getKIACSvcSoapWSDDServiceName());
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
        if ("KIACSvcSoap".equals(inputPortName)) {
            return getKIACSvcSoap();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "KIACSvc");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "KIACSvcSoap"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("KIACSvcSoap".equals(portName)) {
            setKIACSvcSoapEndpointAddress(address);
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
