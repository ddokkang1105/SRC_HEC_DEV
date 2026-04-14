/**
 * WsRuleParamVO.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package xbolt.custom.hanwha.adrm.ws.service;

public class WsRuleParamVO  implements java.io.Serializable {
    private java.lang.String adrmWsKey;

    private java.lang.String costCenterID;

    private java.lang.String currency;

    private java.lang.String currencyDate;

    private java.lang.String documentId;

    private java.lang.String draftEmpNo;

    private xbolt.custom.hanwha.adrm.ws.service.WsRuleParamVOFactorMapEntry[] factorMap;

    private int isBackground;

    private java.lang.String serviceCode;

    public WsRuleParamVO() {
    }

    public WsRuleParamVO(
           java.lang.String adrmWsKey,
           java.lang.String costCenterID,
           java.lang.String currency,
           java.lang.String currencyDate,
           java.lang.String documentId,
           java.lang.String draftEmpNo,
           xbolt.custom.hanwha.adrm.ws.service.WsRuleParamVOFactorMapEntry[] factorMap,
           int isBackground,
           java.lang.String serviceCode) {
           this.adrmWsKey = adrmWsKey;
           this.costCenterID = costCenterID;
           this.currency = currency;
           this.currencyDate = currencyDate;
           this.documentId = documentId;
           this.draftEmpNo = draftEmpNo;
           this.factorMap = factorMap;
           this.isBackground = isBackground;
           this.serviceCode = serviceCode;
    }


    /**
     * Gets the adrmWsKey value for this WsRuleParamVO.
     * 
     * @return adrmWsKey
     */
    public java.lang.String getAdrmWsKey() {
        return adrmWsKey;
    }


    /**
     * Sets the adrmWsKey value for this WsRuleParamVO.
     * 
     * @param adrmWsKey
     */
    public void setAdrmWsKey(java.lang.String adrmWsKey) {
        this.adrmWsKey = adrmWsKey;
    }


    /**
     * Gets the costCenterID value for this WsRuleParamVO.
     * 
     * @return costCenterID
     */
    public java.lang.String getCostCenterID() {
        return costCenterID;
    }


    /**
     * Sets the costCenterID value for this WsRuleParamVO.
     * 
     * @param costCenterID
     */
    public void setCostCenterID(java.lang.String costCenterID) {
        this.costCenterID = costCenterID;
    }


    /**
     * Gets the currency value for this WsRuleParamVO.
     * 
     * @return currency
     */
    public java.lang.String getCurrency() {
        return currency;
    }


    /**
     * Sets the currency value for this WsRuleParamVO.
     * 
     * @param currency
     */
    public void setCurrency(java.lang.String currency) {
        this.currency = currency;
    }


    /**
     * Gets the currencyDate value for this WsRuleParamVO.
     * 
     * @return currencyDate
     */
    public java.lang.String getCurrencyDate() {
        return currencyDate;
    }


    /**
     * Sets the currencyDate value for this WsRuleParamVO.
     * 
     * @param currencyDate
     */
    public void setCurrencyDate(java.lang.String currencyDate) {
        this.currencyDate = currencyDate;
    }


    /**
     * Gets the documentId value for this WsRuleParamVO.
     * 
     * @return documentId
     */
    public java.lang.String getDocumentId() {
        return documentId;
    }


    /**
     * Sets the documentId value for this WsRuleParamVO.
     * 
     * @param documentId
     */
    public void setDocumentId(java.lang.String documentId) {
        this.documentId = documentId;
    }


    /**
     * Gets the draftEmpNo value for this WsRuleParamVO.
     * 
     * @return draftEmpNo
     */
    public java.lang.String getDraftEmpNo() {
        return draftEmpNo;
    }


    /**
     * Sets the draftEmpNo value for this WsRuleParamVO.
     * 
     * @param draftEmpNo
     */
    public void setDraftEmpNo(java.lang.String draftEmpNo) {
        this.draftEmpNo = draftEmpNo;
    }


    /**
     * Gets the factorMap value for this WsRuleParamVO.
     * 
     * @return factorMap
     */
    public xbolt.custom.hanwha.adrm.ws.service.WsRuleParamVOFactorMapEntry[] getFactorMap() {
        return factorMap;
    }


    /**
     * Sets the factorMap value for this WsRuleParamVO.
     * 
     * @param factorMap
     */
    public void setFactorMap(xbolt.custom.hanwha.adrm.ws.service.WsRuleParamVOFactorMapEntry[] factorMap) {
        this.factorMap = factorMap;
    }


    /**
     * Gets the isBackground value for this WsRuleParamVO.
     * 
     * @return isBackground
     */
    public int getIsBackground() {
        return isBackground;
    }


    /**
     * Sets the isBackground value for this WsRuleParamVO.
     * 
     * @param isBackground
     */
    public void setIsBackground(int isBackground) {
        this.isBackground = isBackground;
    }


    /**
     * Gets the serviceCode value for this WsRuleParamVO.
     * 
     * @return serviceCode
     */
    public java.lang.String getServiceCode() {
        return serviceCode;
    }


    /**
     * Sets the serviceCode value for this WsRuleParamVO.
     * 
     * @param serviceCode
     */
    public void setServiceCode(java.lang.String serviceCode) {
        this.serviceCode = serviceCode;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof WsRuleParamVO)) return false;
        WsRuleParamVO other = (WsRuleParamVO) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.adrmWsKey==null && other.getAdrmWsKey()==null) || 
             (this.adrmWsKey!=null &&
              this.adrmWsKey.equals(other.getAdrmWsKey()))) &&
            ((this.costCenterID==null && other.getCostCenterID()==null) || 
             (this.costCenterID!=null &&
              this.costCenterID.equals(other.getCostCenterID()))) &&
            ((this.currency==null && other.getCurrency()==null) || 
             (this.currency!=null &&
              this.currency.equals(other.getCurrency()))) &&
            ((this.currencyDate==null && other.getCurrencyDate()==null) || 
             (this.currencyDate!=null &&
              this.currencyDate.equals(other.getCurrencyDate()))) &&
            ((this.documentId==null && other.getDocumentId()==null) || 
             (this.documentId!=null &&
              this.documentId.equals(other.getDocumentId()))) &&
            ((this.draftEmpNo==null && other.getDraftEmpNo()==null) || 
             (this.draftEmpNo!=null &&
              this.draftEmpNo.equals(other.getDraftEmpNo()))) &&
            ((this.factorMap==null && other.getFactorMap()==null) || 
             (this.factorMap!=null &&
              java.util.Arrays.equals(this.factorMap, other.getFactorMap()))) &&
            this.isBackground == other.getIsBackground() &&
            ((this.serviceCode==null && other.getServiceCode()==null) || 
             (this.serviceCode!=null &&
              this.serviceCode.equals(other.getServiceCode())));
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
        if (getAdrmWsKey() != null) {
            _hashCode += getAdrmWsKey().hashCode();
        }
        if (getCostCenterID() != null) {
            _hashCode += getCostCenterID().hashCode();
        }
        if (getCurrency() != null) {
            _hashCode += getCurrency().hashCode();
        }
        if (getCurrencyDate() != null) {
            _hashCode += getCurrencyDate().hashCode();
        }
        if (getDocumentId() != null) {
            _hashCode += getDocumentId().hashCode();
        }
        if (getDraftEmpNo() != null) {
            _hashCode += getDraftEmpNo().hashCode();
        }
        if (getFactorMap() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getFactorMap());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getFactorMap(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        _hashCode += getIsBackground();
        if (getServiceCode() != null) {
            _hashCode += getServiceCode().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(WsRuleParamVO.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://service.ws.adrm.acube.sds.com/", "wsRuleParamVO"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("adrmWsKey");
        elemField.setXmlName(new javax.xml.namespace.QName("", "adrmWsKey"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("costCenterID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "costCenterID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("currency");
        elemField.setXmlName(new javax.xml.namespace.QName("", "currency"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("currencyDate");
        elemField.setXmlName(new javax.xml.namespace.QName("", "currencyDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("documentId");
        elemField.setXmlName(new javax.xml.namespace.QName("", "documentId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("draftEmpNo");
        elemField.setXmlName(new javax.xml.namespace.QName("", "draftEmpNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("factorMap");
        elemField.setXmlName(new javax.xml.namespace.QName("", "factorMap"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://service.ws.adrm.acube.sds.com/", ">>wsRuleParamVO>factorMap>entry"));
        elemField.setNillable(false);
        elemField.setItemQName(new javax.xml.namespace.QName("", "entry"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("isBackground");
        elemField.setXmlName(new javax.xml.namespace.QName("", "isBackground"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("serviceCode");
        elemField.setXmlName(new javax.xml.namespace.QName("", "serviceCode"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
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
