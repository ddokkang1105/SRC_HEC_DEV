/**
 * UserInformation.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service;

public class UserInformation  implements java.io.Serializable {
    private java.lang.String userID;

    private java.lang.String userName;

    private java.lang.String positonID;

    private java.lang.String positionName;

    private java.lang.String dutyID;

    private java.lang.String dutyName;

    private java.lang.String organizationID;

    private java.lang.String organizationName;

    private java.lang.String email;

    private java.lang.String phone;

    private java.lang.String startTime;

    private java.lang.String endTime;

    private xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.UserInformation delegator;

    public UserInformation() {
    }

    public UserInformation(
           java.lang.String userID,
           java.lang.String userName,
           java.lang.String positonID,
           java.lang.String positionName,
           java.lang.String dutyID,
           java.lang.String dutyName,
           java.lang.String organizationID,
           java.lang.String organizationName,
           java.lang.String email,
           java.lang.String phone,
           java.lang.String startTime,
           java.lang.String endTime,
           xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.UserInformation delegator) {
           this.userID = userID;
           this.userName = userName;
           this.positonID = positonID;
           this.positionName = positionName;
           this.dutyID = dutyID;
           this.dutyName = dutyName;
           this.organizationID = organizationID;
           this.organizationName = organizationName;
           this.email = email;
           this.phone = phone;
           this.startTime = startTime;
           this.endTime = endTime;
           this.delegator = delegator;
    }


    /**
     * Gets the userID value for this UserInformation.
     * 
     * @return userID
     */
    public java.lang.String getUserID() {
        return userID;
    }


    /**
     * Sets the userID value for this UserInformation.
     * 
     * @param userID
     */
    public void setUserID(java.lang.String userID) {
        this.userID = userID;
    }


    /**
     * Gets the userName value for this UserInformation.
     * 
     * @return userName
     */
    public java.lang.String getUserName() {
        return userName;
    }


    /**
     * Sets the userName value for this UserInformation.
     * 
     * @param userName
     */
    public void setUserName(java.lang.String userName) {
        this.userName = userName;
    }


    /**
     * Gets the positonID value for this UserInformation.
     * 
     * @return positonID
     */
    public java.lang.String getPositonID() {
        return positonID;
    }


    /**
     * Sets the positonID value for this UserInformation.
     * 
     * @param positonID
     */
    public void setPositonID(java.lang.String positonID) {
        this.positonID = positonID;
    }


    /**
     * Gets the positionName value for this UserInformation.
     * 
     * @return positionName
     */
    public java.lang.String getPositionName() {
        return positionName;
    }


    /**
     * Sets the positionName value for this UserInformation.
     * 
     * @param positionName
     */
    public void setPositionName(java.lang.String positionName) {
        this.positionName = positionName;
    }


    /**
     * Gets the dutyID value for this UserInformation.
     * 
     * @return dutyID
     */
    public java.lang.String getDutyID() {
        return dutyID;
    }


    /**
     * Sets the dutyID value for this UserInformation.
     * 
     * @param dutyID
     */
    public void setDutyID(java.lang.String dutyID) {
        this.dutyID = dutyID;
    }


    /**
     * Gets the dutyName value for this UserInformation.
     * 
     * @return dutyName
     */
    public java.lang.String getDutyName() {
        return dutyName;
    }


    /**
     * Sets the dutyName value for this UserInformation.
     * 
     * @param dutyName
     */
    public void setDutyName(java.lang.String dutyName) {
        this.dutyName = dutyName;
    }


    /**
     * Gets the organizationID value for this UserInformation.
     * 
     * @return organizationID
     */
    public java.lang.String getOrganizationID() {
        return organizationID;
    }


    /**
     * Sets the organizationID value for this UserInformation.
     * 
     * @param organizationID
     */
    public void setOrganizationID(java.lang.String organizationID) {
        this.organizationID = organizationID;
    }


    /**
     * Gets the organizationName value for this UserInformation.
     * 
     * @return organizationName
     */
    public java.lang.String getOrganizationName() {
        return organizationName;
    }


    /**
     * Sets the organizationName value for this UserInformation.
     * 
     * @param organizationName
     */
    public void setOrganizationName(java.lang.String organizationName) {
        this.organizationName = organizationName;
    }


    /**
     * Gets the email value for this UserInformation.
     * 
     * @return email
     */
    public java.lang.String getEmail() {
        return email;
    }


    /**
     * Sets the email value for this UserInformation.
     * 
     * @param email
     */
    public void setEmail(java.lang.String email) {
        this.email = email;
    }


    /**
     * Gets the phone value for this UserInformation.
     * 
     * @return phone
     */
    public java.lang.String getPhone() {
        return phone;
    }


    /**
     * Sets the phone value for this UserInformation.
     * 
     * @param phone
     */
    public void setPhone(java.lang.String phone) {
        this.phone = phone;
    }


    /**
     * Gets the startTime value for this UserInformation.
     * 
     * @return startTime
     */
    public java.lang.String getStartTime() {
        return startTime;
    }


    /**
     * Sets the startTime value for this UserInformation.
     * 
     * @param startTime
     */
    public void setStartTime(java.lang.String startTime) {
        this.startTime = startTime;
    }


    /**
     * Gets the endTime value for this UserInformation.
     * 
     * @return endTime
     */
    public java.lang.String getEndTime() {
        return endTime;
    }


    /**
     * Sets the endTime value for this UserInformation.
     * 
     * @param endTime
     */
    public void setEndTime(java.lang.String endTime) {
        this.endTime = endTime;
    }


    /**
     * Gets the delegator value for this UserInformation.
     * 
     * @return delegator
     */
    public xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.UserInformation getDelegator() {
        return delegator;
    }


    /**
     * Sets the delegator value for this UserInformation.
     * 
     * @param delegator
     */
    public void setDelegator(xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.UserInformation delegator) {
        this.delegator = delegator;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof UserInformation)) return false;
        UserInformation other = (UserInformation) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.userID==null && other.getUserID()==null) || 
             (this.userID!=null &&
              this.userID.equals(other.getUserID()))) &&
            ((this.userName==null && other.getUserName()==null) || 
             (this.userName!=null &&
              this.userName.equals(other.getUserName()))) &&
            ((this.positonID==null && other.getPositonID()==null) || 
             (this.positonID!=null &&
              this.positonID.equals(other.getPositonID()))) &&
            ((this.positionName==null && other.getPositionName()==null) || 
             (this.positionName!=null &&
              this.positionName.equals(other.getPositionName()))) &&
            ((this.dutyID==null && other.getDutyID()==null) || 
             (this.dutyID!=null &&
              this.dutyID.equals(other.getDutyID()))) &&
            ((this.dutyName==null && other.getDutyName()==null) || 
             (this.dutyName!=null &&
              this.dutyName.equals(other.getDutyName()))) &&
            ((this.organizationID==null && other.getOrganizationID()==null) || 
             (this.organizationID!=null &&
              this.organizationID.equals(other.getOrganizationID()))) &&
            ((this.organizationName==null && other.getOrganizationName()==null) || 
             (this.organizationName!=null &&
              this.organizationName.equals(other.getOrganizationName()))) &&
            ((this.email==null && other.getEmail()==null) || 
             (this.email!=null &&
              this.email.equals(other.getEmail()))) &&
            ((this.phone==null && other.getPhone()==null) || 
             (this.phone!=null &&
              this.phone.equals(other.getPhone()))) &&
            ((this.startTime==null && other.getStartTime()==null) || 
             (this.startTime!=null &&
              this.startTime.equals(other.getStartTime()))) &&
            ((this.endTime==null && other.getEndTime()==null) || 
             (this.endTime!=null &&
              this.endTime.equals(other.getEndTime()))) &&
            ((this.delegator==null && other.getDelegator()==null) || 
             (this.delegator!=null &&
              this.delegator.equals(other.getDelegator())));
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
        if (getUserID() != null) {
            _hashCode += getUserID().hashCode();
        }
        if (getUserName() != null) {
            _hashCode += getUserName().hashCode();
        }
        if (getPositonID() != null) {
            _hashCode += getPositonID().hashCode();
        }
        if (getPositionName() != null) {
            _hashCode += getPositionName().hashCode();
        }
        if (getDutyID() != null) {
            _hashCode += getDutyID().hashCode();
        }
        if (getDutyName() != null) {
            _hashCode += getDutyName().hashCode();
        }
        if (getOrganizationID() != null) {
            _hashCode += getOrganizationID().hashCode();
        }
        if (getOrganizationName() != null) {
            _hashCode += getOrganizationName().hashCode();
        }
        if (getEmail() != null) {
            _hashCode += getEmail().hashCode();
        }
        if (getPhone() != null) {
            _hashCode += getPhone().hashCode();
        }
        if (getStartTime() != null) {
            _hashCode += getStartTime().hashCode();
        }
        if (getEndTime() != null) {
            _hashCode += getEndTime().hashCode();
        }
        if (getDelegator() != null) {
            _hashCode += getDelegator().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(UserInformation.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "UserInformation"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("userID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "UserID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("userName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "UserName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("positonID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "PositonID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("positionName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "PositionName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dutyID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "DutyID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dutyName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "DutyName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("organizationID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "OrganizationID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("organizationName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "OrganizationName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("email");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "Email"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("phone");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "Phone"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("startTime");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "StartTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("endTime");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "EndTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("delegator");
        elemField.setXmlName(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "Delegator"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://Service.KASC.KEFICO.CO.KR/", "UserInformation"));
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
