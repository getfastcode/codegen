package [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto;

import java.util.Date;
public class Find[=AuthenticationTable]roleByIdOutput {

    private Long roleId;
    <#if AuthenticationType!="none" && !UserInput??>
    private Long [=AuthenticationTable?uncap_first]Id;
    private String [=AuthenticationTable?uncap_first]DescriptiveField;
    <#elseif AuthenticationType!="none" && UserInput??>
    <#if PrimaryKeys??>
    <#list PrimaryKeys as key,value>
    <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
    private [=value] [=AuthenticationTable?uncap_first][=key?cap_first];
    </#if> 
    </#list>
    </#if>
    </#if>
    <#if DescriptiveField?? && DescriptiveField[AuthenticationTable]?? && DescriptiveField[AuthenticationTable].description??>
    private [=DescriptiveField[AuthenticationTable].fieldType?cap_first] [=DescriptiveField[AuthenticationTable].description?uncap_first];
    <#else>
    <#if AuthenticationFields??>
  	<#list AuthenticationFields as authKey,authValue>
  	<#if authKey== "UserName">
  	private String [=AuthenticationTable?uncap_first]DescriptiveField;
    </#if>
    </#list>
    </#if>
    </#if>
    private String roleDescriptiveField;

    public String getRoleDescriptiveField() {
  		return roleDescriptiveField;
    }

    public void setRoleDescriptiveField(String roleDescriptiveField){
  		this.roleDescriptiveField = roleDescriptiveField;
    }
 
    public Long getRoleId() {
  		return roleId;
    }

    public void setRoleId(Long roleId){
  		this.roleId = roleId;
    }
  
    <#if AuthenticationType!="none" && !UserInput?? >
    public Long get[=AuthenticationTable?cap_first]Id() {
  	 	return [=AuthenticationTable?uncap_first]Id;
  	}

  	public void set[=AuthenticationTable?cap_first]Id(Long [=AuthenticationTable?uncap_first]Id){
  	  	this.[=AuthenticationTable?uncap_first]Id = [=AuthenticationTable?uncap_first]Id;
  	}
  	
  	public String get[=AuthenticationTable?cap_first]DescriptiveField() {
   	  	return [=AuthenticationTable?uncap_first]DescriptiveField;
  	}

  	public void set[=AuthenticationTable?cap_first]DescriptiveField(String [=AuthenticationTable?uncap_first]DescriptiveField){
   	  	this.[=AuthenticationTable?uncap_first]DescriptiveField = [=AuthenticationTable?uncap_first]DescriptiveField;
  	}
  	<#elseif AuthenticationType!="none" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
  	<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
  	public [=value] get[=AuthenticationTable?cap_first][=key?cap_first]() {
  	 	return [=AuthenticationTable?uncap_first][=key?cap_first];
  	}

  	public void set[=AuthenticationTable?cap_first][=key?cap_first]([=value] [=AuthenticationTable?uncap_first][=key?cap_first]){
  		this.[=AuthenticationTable?uncap_first][=key?cap_first] = [=AuthenticationTable?uncap_first][=key?cap_first];
  	}
  	</#if> 
  	</#list>
  	</#if>
    </#if>
    <#if DescriptiveField?? && DescriptiveField[AuthenticationTable]?? && DescriptiveField[AuthenticationTable].description??>
    public [=DescriptiveField[AuthenticationTable].fieldType?cap_first] get[=DescriptiveField[AuthenticationTable].description?cap_first]() {
  		return [=DescriptiveField[AuthenticationTable].description?uncap_first];
  	}

  	public void set[=DescriptiveField[AuthenticationTable].description?cap_first]([=DescriptiveField[AuthenticationTable].fieldType?cap_first] [=DescriptiveField[AuthenticationTable].description?uncap_first]){
  	 	this.[=DescriptiveField[AuthenticationTable].description?uncap_first] = [=DescriptiveField[AuthenticationTable].description?uncap_first];
  	}
    <#else>
    <#if AuthenticationFields??>
  	<#list AuthenticationFields as authKey,authValue>
  	<#if authKey== "UserName">
  	public String get[=AuthenticationTable?cap_first]DescriptiveField() {
   		return [=AuthenticationTable?uncap_first]DescriptiveField;
  	}

  	public void set[=AuthenticationTable?cap_first]DescriptiveField(String [=AuthenticationTable?uncap_first]DescriptiveField){
   	    this.[=AuthenticationTable?uncap_first]DescriptiveField = [=AuthenticationTable?uncap_first]DescriptiveField;
  	}
    </#if>
    </#list>
    </#if>
    </#if>
}
