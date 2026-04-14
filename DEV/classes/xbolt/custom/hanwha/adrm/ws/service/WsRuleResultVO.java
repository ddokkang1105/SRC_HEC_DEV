/**
 * WsRuleResultVO.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package xbolt.custom.hanwha.adrm.ws.service;

public class WsRuleResultVO  implements java.io.Serializable {
    private java.lang.String businessName;

    private java.lang.String businessNameEn;

    private java.lang.String errorMessage;

    private java.lang.String orgId;

    private java.lang.String pathName;

    private int resultCode;

    private xbolt.custom.hanwha.adrm.ws.service.WsApprStepVO[] steps;

    public WsRuleResultVO() {
    }

    public WsRuleResultVO(
           java.lang.String businessName,
           java.lang.String businessNameEn,
           java.lang.String errorMessage,
           java.lang.String orgId,
           java.lang.String pathName,
           int resultCode,
           xbolt.custom.hanwha.adrm.ws.service.WsApprStepVO[] steps) {
           this.businessName = businessName;
           this.businessNameEn = businessNameEn;
           this.errorMessage = errorMessage;
           this.orgId = orgId;
           this.pathName = pathName;
           this.resultCode = resultCode;
           this.steps = steps;
    }


    /**
     * Gets the businessName value for this WsRuleResultVO.
     * 
     * @return businessName
     */
    public java.lang.String getBusinessName() {
        return businessName;
    }


    /**
     * Sets the businessName value for this WsRuleResultVO.
     * 
     * @param businessName
     */
    public void setBusinessName(java.lang.String businessName) {
        this.businessName = businessName;
    }


    /**
     * Gets the businessNameEn value for this WsRuleResultVO.
     * 
     * @return businessNameEn
     */
    public java.lang.String getBusinessNameEn() {
        return businessNameEn;
    }


    /**
     * Sets the businessNameEn value for this WsRuleResultVO.
     * 
     * @param businessNameEn
     */
    public void setBusinessNameEn(java.lang.String businessNameEn) {
        this.businessNameEn = businessNameEn;
    }


    /**
     * Gets the errorMessage value for this WsRuleResultVO.
     * 
     * @return errorMessage
     */
    public java.lang.String getErrorMessage() {
        return errorMessage;
    }


    /**
     * Sets the errorMessage value for this WsRuleResultVO.
     * 
     * @param errorMessage
     */
    public void setErrorMessage(java.lang.String errorMessage) {
        this.errorMessage = errorMessage;
    }


    /**
     * Gets the orgId value for this WsRuleResultVO.
     * 
     * @return orgId
     */
    public java.lang.String getOrgId() {
        return orgId;
    }


    /**
     * Sets the orgId value for this WsRuleResultVO.
     * 
     * @param orgId
     */
    public void setOrgId(java.lang.String orgId) {
        this.orgId = orgId;
    }


    /**
     * Gets the pathName value for this WsRuleResultVO.
     * 
     * @return pathName
     */
    public java.lang.String getPathName() {
        return pathName;
    }


    /**
     * Sets the pathName value for this WsRuleResultVO.
     * 
     * @param pathName
     */
    public void setPathName(java.lang.String pathName) {
        this.pathName = pathName;
    }


    /**
     * Gets the resultCode value for this WsRuleResultVO.
     * 
     * @return resultCode
     */
    public int getResultCode() {
        return resultCode;
    }


    /**
     * Sets the resultCode value for this WsRuleResultVO.
     * 
     * @param resultCode
     */
    public void setResultCode(int resultCode) {
        this.resultCode = resultCode;
    }


    /**
     * Gets the steps value for this WsRuleResultVO.
     * 
     * @return steps
     */
    public xbolt.custom.hanwha.adrm.ws.service.WsApprStepVO[] getSteps() {
        return steps;
    }


    /**
     * Sets the steps value for this WsRuleResultVO.
     * 
     * @param steps
     */
    public void setSteps(xbolt.custom.hanwha.adrm.ws.service.WsApprStepVO[] steps) {
        this.steps = steps;
    }

    public xbolt.custom.hanwha.adrm.ws.service.WsApprStepVO getSteps(int i) {
        return this.steps[i];
    }

    public void setSteps(int i, xbolt.custom.hanwha.adrm.ws.service.WsApprStepVO _value) {
        this.steps[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof WsRuleResultVO)) return false;
        WsRuleResultVO other = (WsRuleResultVO) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.businessName==null && other.getBusinessName()==null) || 
             (this.businessName!=null &&
              this.businessName.equals(other.getBusinessName()))) &&
            ((this.businessNameEn==null && other.getBusinessNameEn()==null) || 
             (this.businessNameEn!=null &&
              this.businessNameEn.equals(other.getBusinessNameEn()))) &&
            ((this.errorMessage==null && other.getErrorMessage()==null) || 
             (this.errorMessage!=null &&
              this.errorMessage.equals(other.getErrorMessage()))) &&
            ((this.orgId==null && other.getOrgId()==null) || 
             (this.orgId!=null &&
              this.orgId.equals(other.getOrgId()))) &&
            ((this.pathName==null && other.getPathName()==null) || 
             (this.pathName!=null &&
              this.pathName.equals(other.getPathName()))) &&
            this.resultCode == other.getResultCode() &&
            ((this.steps==null && other.getSteps()==null) || 
             (this.steps!=null &&
              java.util.Arrays.equals(this.steps, other.getSteps())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getBusinessName() != null) {
            _hashCode += getBusinessName().hashCode();
        }
        if (getBusinessNameEn() != null) {
            _hashCode += getBusinessNameEn().hashCode();
        }
        if (getErrorMessage() != null) {
            _hashCode += getErrorMessage().hashCode();
        }
        if (getOrgId() != null) {
            _hashCode += getOrgId().hashCode();
        }
        if (getPathName() != null) {
            _hashCode += getPathName().hashCode();
        }
        _hashCode += getResultCode();
        if (getSteps() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getSteps());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getSteps(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(WsRuleResultVO.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://service.ws.adrm.acube.sds.com/", "wsRuleResultVO"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("businessName");
        elemField.setXmlName(new javax.xml.namespace.QName("", "businessName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("businessNameEn");
        elemField.setXmlName(new javax.xml.namespace.QName("", "businessNameEn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("errorMessage");
        elemField.setXmlName(new javax.xml.namespace.QName("", "errorMessage"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("orgId");
        elemField.setXmlName(new javax.xml.namespace.QName("", "orgId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("pathName");
        elemField.setXmlName(new javax.xml.namespace.QName("", "pathName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resultCode");
        elemField.setXmlName(new javax.xml.namespace.QName("", "resultCode"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("steps");
        elemField.setXmlName(new javax.xml.namespace.QName("", "steps"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://service.ws.adrm.acube.sds.com/", "wsApprStepVO"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
