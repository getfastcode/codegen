export interface [=IEntity] {  

 <#list Fields as key,value>
 <#if value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "integer" ||  value.fieldType?lower_case == "short" ||  value.fieldType?lower_case == "double"> 
     <#if value.isNullable == true>
      [=value.fieldName]?: number;
     <#else>
      [=value.fieldName]: number;
      </#if> 
<#elseif value.fieldType?lower_case == "boolean">
     <#if value.isNullable == true>
      [=value.fieldName]?: boolean;
     <#else>
      [=value.fieldName]: boolean;
      </#if> 
 <#elseif value.fieldType?lower_case == "date">
      <#if value.isNullable == true>
      [=value.fieldName]?: string;
     <#else>
      [=value.fieldName]: string;
      </#if> 
<#elseif value.fieldType?lower_case == "string">
       <#if value.isNullable == true>
      [=value.fieldName]?: string;
     <#else>
      [=value.fieldName]: string;
      </#if> 
 </#if> 
</#list>
<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToOne">
<#if DescriptiveField[relationValue.eName]??>
  <#if DescriptiveField[relationValue.eName].fieldType?lower_case == "long" || DescriptiveField[relationValue.eName].fieldType?lower_case == "int" || DescriptiveField[relationValue.eName].fieldType?lower_case == "short" || DescriptiveField[relationValue.eName].fieldType?lower_case == "double">
      [=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first]?: number;
  <#elseif DescriptiveField[relationValue.eName].fieldType?lower_case == "boolean">
      [=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first]?: boolean;
  <#else>
      [=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first]?: string;
  </#if> 
</#if>
<#list relationValue.joinDetails as joinDetails>
<#if joinDetails.joinEntityName == relationValue.eName>
<#if joinDetails.joinColumn??>
<#if joinDetails.isJoinColumnOptional==false>
 <#if joinDetails.joinColumnType?lower_case == "long" ||  joinDetails.joinColumnType?lower_case == "int" ||  joinDetails.joinColumnType?lower_case == "short" ||  joinDetails.joinColumnType?lower_case == "double"> 
      [=joinDetails.joinColumn]: number;
  <#elseif joinDetails.joinColumnType?lower_case == "boolean">
      [=joinDetails.joinColumn]: boolean;
  <#else>    
      [=joinDetails.joinColumn]: string;
  </#if>
<#else>   
      <#if joinDetails.joinColumnType?lower_case == "long" ||  joinDetails.joinColumnType?lower_case == "int" ||  joinDetails.joinColumnType?lower_case == "short" ||  joinDetails.joinColumnType?lower_case == "double"> 
      [=joinDetails.joinColumn]?: number;
  <#elseif joinDetails.joinColumnType?lower_case == "boolean">
      [=joinDetails.joinColumn]?: boolean;
  <#else>    
      [=joinDetails.joinColumn]?: string;
  </#if>
</#if>
</#if>
</#if>
</#list>
</#if>
</#list>
  }
