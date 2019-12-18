package [=PackageName].RestControllers;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.persistence.EntityExistsException;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityNotFoundException;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.SpyBean;
<#if Cache !false>
import org.springframework.cache.CacheManager;
</#if>
import org.springframework.data.web.SortHandlerMethodArgumentResolver;

import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import [=CommonModulePackage].logging.LoggingHelper;
import [=PackageName].application.Authorization.Role.RoleAppService;
import [=PackageName].application.Authorization.Role.Dto.CreateRoleInput;
import [=PackageName].application.Authorization.Role.Dto.FindRoleByIdOutput;
import [=PackageName].application.Authorization.Role.Dto.FindRoleByNameOutput;
import [=PackageName].application.Authorization.Role.Dto.UpdateRoleInput;
import [=PackageName].application.Authorization.Rolepermission.RolepermissionAppService;
import [=PackageName].application.Authorization.[=AuthenticationTable]role.[=AuthenticationTable]roleAppService;
import [=PackageName].domain.IRepository.IRoleRepository;
import [=PackageName].domain.model.RoleEntity;


@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class RoleControllerTest {

	private static final String DEFAULT_ROLE_NAME = "R1";
	private static final String DEFAULT_DISPLAY_NAME = "D1";
	
	@Autowired
    private SortHandlerMethodArgumentResolver sortArgumentResolver;
	
	@Autowired 
	private IRoleRepository role_repository;

	@SpyBean
	private RoleAppService roleAppService;
	
	@SpyBean
	private [=AuthenticationTable]roleAppService [=AuthenticationTable?uncap_first]roleAppService;
	
	@SpyBean
	private RolepermissionAppService rolepermissionAppService;
	
	@SpyBean
	private LoggingHelper logHelper;
	
	@Mock
	private Logger loggerMock;
	
	private RoleEntity role;
	
	private MockMvc mvc;
	<#if Cache !false>
	
	@Autowired 
	private CacheManager cacheManager; 
	</#if>
	
	@Autowired
	EntityManagerFactory emf;
	
	<#if Cache !false>
	public void evictAllCaches(){ 
	    for(String name : cacheManager.getCacheNames()){
	        cacheManager.getCache(name).clear(); 
	    } 
	}
    </#if>
	public static RoleEntity createEntity() {
		RoleEntity role = new RoleEntity();
		role.setName(DEFAULT_ROLE_NAME);
		role.setId(1L);
		role.setDisplayName(DEFAULT_DISPLAY_NAME);

		return role;
	}

	public static CreateRoleInput createRoleInput() {
		CreateRoleInput role = new CreateRoleInput();
		role.setName("newRole");
		role.setDisplayName("newRole");

		return role;
	}
	
	public static RoleEntity createNewEntity() {
		RoleEntity role = new RoleEntity();
		role.setName("R2");
		//role.setId(2L);
		role.setDisplayName("D2");

		return role;
	}

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        <#if Cache !false>
        evictAllCaches();
        </#if>
        final RoleController roleController = new RoleController(roleAppService,logHelper,[=AuthenticationTable?uncap_first]roleAppService,rolepermissionAppService);
        
        when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
		
		
        this.mvc = MockMvcBuilders.standaloneSetup(roleController)
        		.setCustomArgumentResolvers(sortArgumentResolver)
        		.setControllerAdvice()
                .build();
        	
    }

	@Before
	public void initTest() {
	
		role= createEntity();
		List<RoleEntity> list= role_repository.findAll();
	    if(list.isEmpty())
		   role_repository.save(role);

	}

	@Test
	public void FindById_IdIsValid_ReturnStatusOk() throws Exception {
		 mvc.perform(get("/role/1")
				 .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  

	@Test
	public void FindById_IdIsNotValid_ReturnStatusNotFound() throws Exception {

	      mvc.perform(get("/role/15")
	    		  .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	
	}    

	@Test
	public void CreateRole_RoleAlreadyExists_ThrowEntityExistsException() throws Exception {

		FindRoleByNameOutput output= new FindRoleByNameOutput();
	    output.setId(3L);
	    output.setName("R1");
	    output.setDisplayName("D2");
	    doReturn(output).when(roleAppService).FindByRoleName(anyString());

	    CreateRoleInput role = createRoleInput();
        ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(role);
       
       org.assertj.core.api.Assertions.assertThatThrownBy(() ->
        mvc.perform(post("/role")
        		.contentType(MediaType.APPLICATION_JSON).content(json))
         .andExpect(status().isOk())
         ).hasCause(new EntityExistsException("There already exists a role with name=" + role.getName()));
      
	}    
	
	@Test
	public void CreateRole_RoleDoesNotExist_ReturnStatusOk() throws Exception {
	
	    doReturn(null).when(roleAppService).FindByRoleName(anyString());
		CreateRoleInput role = createRoleInput();
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(role);
      
		 mvc.perform(post("/role").contentType(MediaType.APPLICATION_JSON).content(json))
		  .andExpect(status().isOk());
		 
	
	}  
	
	@Test
	public void DeleteRole_IdIsNotValid_ThrowEntityNotFoundException() throws Exception {
	   
		doReturn(null).when(roleAppService).FindById(anyLong());
     	 org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/role/21")
     			 .contentType(MediaType.APPLICATION_JSON))
		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("There does not exist a role with a id=21"));

	}  

	@Test
	public void Delete_IdIsValid_ReturnStatusNoContent() throws Exception {
		
		Long id = role_repository.save(createNewEntity()).getId();
		
		FindRoleByIdOutput output= new FindRoleByIdOutput();
	    output.setId(id.longValue());
	    output.setName("R2");
	    output.setDisplayName("d2");

	    Mockito.when(roleAppService.FindById(id.longValue())).thenReturn(output);
	    
     	 mvc.perform(delete("/role/"+id.toString())
     			 .contentType(MediaType.APPLICATION_JSON))
		  .andExpect(status().isNoContent());
	}  
	
	@Test
	public void UpdateRole_RoleDoesNotExist_ReturnStatusNotFound() throws Exception {
		
		doReturn(null).when(roleAppService).FindById(anyLong());
       
        UpdateRoleInput role = new UpdateRoleInput();
        role.setId(21L);
 		role.setName("R116");
 		role.setDisplayName("D299");
 		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(role);
        mvc.perform(put("/role/21").contentType(MediaType.APPLICATION_JSON).content(json))
		  .andExpect(status().isNotFound());
     
	}    
	
	@Test
	public void UpdateRole_RoleExists_ReturnStatusOk() throws Exception {
		Long id = role_repository.save(createNewEntity()).getId();
		FindRoleByIdOutput output= new FindRoleByIdOutput();
	    output.setId(id.longValue());
	    output.setName("R2");
	    output.setDisplayName("d2");
	    doReturn(output).when(roleAppService).FindById(anyLong());
        UpdateRoleInput role = new UpdateRoleInput();
        role.setId(id.longValue());
		role.setName("R116");
		role.setDisplayName("D299");
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(role);
        System.out.println("id " +id);
        mvc.perform(put("/role/"+id).contentType(MediaType.APPLICATION_JSON).content(json))
	    .andExpect(status().isOk());

        RoleEntity e= createEntity();
        e.setId(id);
        role_repository.delete(e);
	}    
	
	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsValid_ReturnStatusOk() throws Exception {
		
		 mvc.perform(get("/role?search=id[equals]=1&limit=10&offset=1")
				 .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}    
	
	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsNotValid_ThrowException() throws Exception {
		 
		 org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/role?search=roleid[equals]=1&limit=10&offset=1")
				 .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property roleid not found!"));
	
	} 
	
	@Test
	public void Get[=AuthenticationTable]role_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("roleid", "1");
		Mockito.when(roleAppService.parse[=AuthenticationTable]roleJoinColumn(any(String.class))).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/role/2/[=AuthenticationTable?uncap_first]role?search=roleid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property roleid not found!"));
	
	}    
	
	@Test
	public void Get[=AuthenticationTable]role_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("roleid", "1");
		Mockito.when(roleAppService.parse[=AuthenticationTable]roleJoinColumn(any(String.class))).thenReturn(joinCol);

		mvc.perform(get("/role/2/[=AuthenticationTable?uncap_first]role?search=roleId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void Get[=AuthenticationTable]role_searchIsNotEmpty() throws Exception {
	
		Mockito.when(roleAppService.parse[=AuthenticationTable]roleJoinColumn(any(String.class))).thenReturn(null);
		mvc.perform(get("/role/2/[=AuthenticationTable?uncap_first]role?search=roleid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
	
	@Test
	public void GetRolepermission_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("roleid", "1");
		Mockito.when(roleAppService.parseRolepermissionJoinColumn(any(String.class))).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/role/2/rolepermission?search=roleid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property roleid not found!"));
	
	}    
	
	@Test
	public void GetRolepermission_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("roleid", "1");
		Mockito.when(roleAppService.parseRolepermissionJoinColumn(any(String.class))).thenReturn(joinCol);

		mvc.perform(get("/role/2/rolepermission?search=roleId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetRolepermission_searchIsNotEmpty() throws Exception {
	
		Mockito.when(roleAppService.parseRolepermissionJoinColumn(any(String.class))).thenReturn(null);
		mvc.perform(get("/role/2/rolepermission?search=roleid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
	
}
