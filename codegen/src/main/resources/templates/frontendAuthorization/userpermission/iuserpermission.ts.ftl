export interface I[=AuthenticationTable]permission {  

	permissionId: number;
	permissionName?: string;
	<#if AuthenticationType=="database" && !UserInput??>
	[=AuthenticationTable?uncap_first]Username?: string;
	<#elseif AuthenticationType=="database" && UserInput??>
	<#if PrimaryKeys??>
	<#list PrimaryKeys as key,value>
	<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double">
	[=value.fieldName] : number;
	<#elseif value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
	[=value.fieldName] : string;
	<#elseif value.fieldType?lower_case == "boolean">
	[=value.fieldName] : boolean;
	</#if> 
	</#list>
	</#if>
	</#if>
	<#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??>
	[=AuthenticationTable?uncap_first + DescriptiveField[AuthenticationTable].fieldName?cap_first]: string;
	<#else>
	[=AuthenticationTable?uncap_first]Username: string;
	</#if>
  }
