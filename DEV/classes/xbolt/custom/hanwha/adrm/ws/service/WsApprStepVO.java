/**
 * WsApprStepVO.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package xbolt.custom.hanwha.adrm.ws.service;

public class WsApprStepVO  implements java.io.Serializable {
    private int apprSystem;

    private int apprType;

    private int changeOption;

    private xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO[] selectableUsers;

    private java.lang.String stepName;

    private int stepType;

    private xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO[] users;

    public WsApprStepVO() {
    }

    public WsApprStepVO(
           int apprSystem,
           int apprType,
           int changeOption,
           xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO[] selectableUsers,
           java.lang.String stepName,
           int stepType,
           xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO[] users) {
           this.apprSystem = apprSystem;
           this.apprType = apprType;
           this.changeOption = changeOption;
           this.selectableUsers = selectableUsers;
           this.stepName = stepName;
           this.stepType = stepType;
           this.users = users;
    }


    /**
     * Gets the apprSystem value for this WsApprStepVO.
     * 
     * @return apprSystem
     */
    public int getApprSystem() {
        return apprSystem;
    }


    /**
     * Sets the apprSystem value for this WsApprStepVO.
     * 
     * @param apprSystem
     */
    public void setApprSystem(int apprSystem) {
        this.apprSystem = apprSystem;
    }


    /**
     * Gets the apprType value for this WsApprStepVO.
     * 
     * @return apprType
     */
    public int getApprType() {
        return apprType;
    }


    /**
     * Sets the apprType value for this WsApprStepVO.
     * 
     * @param apprType
     */
    public void setApprType(int apprType) {
        this.apprType = apprType;
    }


    /**
     * Gets the changeOption value for this WsApprStepVO.
     * 
     * @return changeOption
     */
    public int getChangeOption() {
        return changeOption;
    }


    /**
     * Sets the changeOption value for this WsApprStepVO.
     * 
     * @param changeOption
     */
    public void setChangeOption(int changeOption) {
        this.changeOption = changeOption;
    }


    /**
     * Gets the selectableUsers value for this WsApprStepVO.
     * 
     * @return selectableUsers
     */
    public xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO[] getSelectableUsers() {
        return selectableUsers;
    }


    /**
     * Sets the selectableUsers value for this WsApprStepVO.
     * 
     * @param selectableUsers
     */
    public void setSelectableUsers(xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO[] selectableUsers) {
        this.selectableUsers = selectableUsers;
    }

    public xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO getSelectableUsers(int i) {
        return this.selectableUsers[i];
    }

    public void setSelectableUsers(int i, xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO _value) {
        this.selectableUsers[i] = _value;
    }


    /**
     * Gets the stepName value for this WsApprStepVO.
     * 
     * @return stepName
     */
    public java.lang.String getStepName() {
        return stepName;
    }


    /**
     * Sets the stepName value for this WsApprStepVO.
     * 
     * @param stepName
     */
    public void setStepName(java.lang.String stepName) {
        this.stepName = stepName;
    }


    /**
     * Gets the stepType value for this WsApprStepVO.
     * 
     * @return stepType
     */
    public int getStepType() {
        return stepType;
    }


    /**
     * Sets the stepType value for this WsApprStepVO.
     * 
     * @param stepType
     */
    public void setStepType(int stepType) {
        this.stepType = stepType;
    }


    /**
     * Gets the users value for this WsApprStepVO.
     * 
     * @return users
     */
    public xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO[] getUsers() {
        return users;
    }


    /**
     * Sets the users value for this WsApprStepVO.
     * 
     * @param users
     */
    public void setUsers(xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO[] users) {
        this.users = users;
    }

    public xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO getUsers(int i) {
        return this.users[i];
    }

    public void setUsers(int i, xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO _value) {
        this.users[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof WsApprStepVO)) return false;
        WsApprStepVO other = (WsApprStepVO) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.apprSystem == other.getApprSystem() &&
            this.apprType == other.getApprType() &&
            this.changeOption == other.getChangeOption() &&
            ((this.selectableUsers==null && other.getSelectableUsers()==null) || 
             (this.selectableUsers!=null &&
              java.util.Arrays.equals(this.selectableUsers, other.getSelectableUsers()))) &&
            ((this.stepName==null && other.getStepName()==null) || 
             (this.stepName!=null &&
              this.stepName.equals(other.getStepName()))) &&
            this.stepType == other.getStepType() &&
            ((this.users==null && other.getUsers()==null) || 
             (this.users!=null &&
              java.util.Arrays.equals(this.users, other.getUsers())));
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
        _hashCode += getApprSystem();
        _hashCode += getApprType();
        _hashCode += getChangeOption();
        if (getSelectableUsers() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getSelectableUsers());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getSelectableUsers(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getStepName() != null) {
            _hashCode += getStepName().hashCode();
        }
        _hashCode += getStepType();
        if (getUsers() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getUsers());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getUsers(), i);
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
        new org.apache.axis.description.TypeDesc(WsApprStepVO.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://service.ws.adrm.acube.sds.com/", "wsApprStepVO"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("apprSystem");
        elemField.setXmlName(new javax.xml.namespace.QName("", "apprSystem"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("apprType");
        elemField.setXmlName(new javax.xml.namespace.QName("", "apprType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("changeOption");
        elemField.setXmlName(new javax.xml.namespace.QName("", "changeOption"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("selectableUsers");
        elemField.setXmlName(new javax.xml.namespace.QName("", "selectableUsers"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://service.ws.adrm.acube.sds.com/", "wsApprUserVO"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("stepName");
        elemField.setXmlName(new javax.xml.namespace.QName("", "stepName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("stepType");
        elemField.setXmlName(new javax.xml.namespace.QName("", "stepType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("users");
        elemField.setXmlName(new javax.xml.namespace.QName("", "users"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://service.ws.adrm.acube.sds.com/", "wsApprUserVO"));
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
