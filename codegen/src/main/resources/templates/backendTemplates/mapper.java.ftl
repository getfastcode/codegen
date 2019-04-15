package [=PackageName].application.[=ClassName];

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>
</#list>
import [=PackageName].application.[=ClassName].Dto.*;
import [=PackageName].domain.model.[=ClassName]Entity;


@Mapper(componentModel = "spring")
public interface [=ClassName]Mapper {

    [=ClassName]Entity Create[=ClassName]InputTo[=ClassName]Entity(Create[=ClassName]Input [=ClassName?lower_case]Dto);

    Create[=ClassName]Output [=ClassName]EntityToCreate[=ClassName]Output([=ClassName]Entity entity);

    [=ClassName]Entity Update[=ClassName]InputTo[=ClassName]Entity(Update[=ClassName]Input [=ClassName?lower_case]Dto);

    Update[=ClassName]Output [=ClassName]EntityToUpdate[=ClassName]Output([=ClassName]Entity entity);

    Find[=ClassName]ByIdOutput [=ClassName]EntityToFind[=ClassName]ByIdOutput([=ClassName]Entity entity);

    Find[=ClassName]ByNameOutput [=ClassName]EntityToFind[=ClassName]ByNameOutput([=ClassName]Entity entity);

  <#list Relationship as relationKey, relationValue>

   <#if relationValue.relation == "ManyToOne">
  @Mappings({
  <#list relationValue.fDetails as fValue>
  <#list Fields as key,value> 
   <#if fValue.fieldName == value.fieldName>
    @Mapping(source = "[=relationValue.eName?lower_case].[=fValue.fieldName]", target = "[=fValue.fieldName]"),                  
   </#if>
   </#list>
   </#list> 
    @Mapping(source = "[=InstanceName].id", target = "[=InstanceName]Id")
    })
    Get[=relationValue.eName]Output [=relationValue.eName]EntityToGet[=relationValue.eName]Output([=relationValue.eName]Entity [=relationValue.eName?lower_case], [=EntityClassName] [=InstanceName]);
   
    
  <#elseif relationValue.relation == "ManyToMany">
  <#list RelationInput as relationInput>
  <#assign parent = relationInput>
  <#if parent?keep_before("-") == relationValue.eName>
  @Mappings({
  <#list relationValue.fDetails as fValue>
  <#list Fields as key,value> 
  <#if fValue.fieldName == value.fieldName>
    @Mapping(source = "[=relationValue.eName?lower_case].[=fValue.fieldName]", target = "[=fValue.fieldName]"),                  
  </#if>
   </#list>
   </#list> 
     @Mapping(source = "[=InstanceName].[=relationValue.referenceColumn]", target = "[=InstanceName][=relationValue.referenceColumn?cap_first]")
    })
    Get[=relationValue.eName]Output [=relationValue.eName]EntityToGet[=relationValue.eName]Output([=relationValue.eName]Entity [=relationValue.eName?lower_case],[=EntityClassName] [=InstanceName]);
    </#if>
    </#list>
   </#if>
  
  </#list>

}
