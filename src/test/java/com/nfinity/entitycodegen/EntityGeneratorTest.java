package com.nfinity.entitycodegen;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.nfinity.codegen.CodeGeneratorUtils;

@RunWith(SpringJUnit4ClassRunner.class)
public class EntityGeneratorTest {
	
	@Rule
    public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	EntityGenerator entityGenerator;
	
	@Mock
	BaseAppGen mockedBaseAppGen;
	
	@Mock
	ReverseMapping reverseMapping;
	
	@Mock
	CodeGeneratorUtils mockedCodeGeneratorUtils;
	
	@Mock
	EntityDetails mockedEntityDetails;
	
	@Mock
	EntityGeneratorUtils mockedEntityGeneratorUtils;
	
	@Mock
	UserInput mockedUserInput;
	
	@Mock
	CGenClassLoader loader;
	
    File destPath;
    List<String> tableList= new ArrayList<String>();
    
    final static String SCHEMA_NAME = "demo";
	final static String CONNECTION_STRING = "jdbc:postgresql://localhost:5432/Demo?username=postgres;password=fastcode";
	final static String PACKAGE_NAME = "com.nfinity.test";
	final static String AUTHENTICATION_TABLE = "user";
	final static String AUTHENTICATION_TYPE = "database";
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(entityGenerator);
		destPath = folder.newFolder("tempFolder");
		tableList.add("user");
		tableList.add("blog");
		tableList.add("tag");
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void buildTablesStringFromList_listIsNotEmpty_returnString()
	{
		String tables = "demo.user,demo.blog,demo.tag";
		Assertions.assertThat(entityGenerator.buildTablesStringFromList(tableList, SCHEMA_NAME)).isEqualTo(tables);
	}
	
	@Test
	public void generateEntities_parametersAreValid_returnMap()
	{
		Mockito.doReturn(new HashMap<String, String>()).when(mockedEntityGeneratorUtils).parseConnectionString(anyString());
		Mockito.doReturn("").when(entityGenerator).buildTablesStringFromList(any(List.class), any(String.class));
		Mockito.doNothing().when(reverseMapping).run(anyString(), anyString(), anyString(), any(HashMap.class));
		Mockito.doNothing().when(mockedBaseAppGen).CompileApplication(anyString());
		Mockito.doNothing().when(mockedEntityGeneratorUtils).deleteFile(anyString());
		Mockito.doReturn(new HashMap<String, EntityDetails>()).when(entityGenerator).processAndGenerateRelevantEntities(anyString(),anyString(),anyString(),anyString(),anyString(),anyString(),anyString());
		Mockito.doNothing().when(mockedEntityGeneratorUtils).deleteDirectory(anyString());
		
		entityGenerator.generateEntities(CONNECTION_STRING, SCHEMA_NAME, tableList, PACKAGE_NAME, destPath.getAbsolutePath(), AUTHENTICATION_TABLE, AUTHENTICATION_TYPE);
        Mockito.verify(mockedBaseAppGen,Mockito.times(1)).CompileApplication(anyString());
        Mockito.verify(entityGenerator,Mockito.times(1)).processAndGenerateRelevantEntities(anyString(),anyString(),anyString(),anyString(),anyString(),anyString(),anyString());
	
	}
	
	@Test
	public void processAndGenerateRelevantEntities_authenticationTypeIsNotNone_returnMap() throws ClassNotFoundException
	{
		List<Class<?>> classList= new ArrayList<Class<?>>();
		Class<?> c1 = Class.forName("java.lang.String"); 
        Class<?> c2 = int.class; 
        classList.add(c1);
        classList.add(c2);
        
        List<String> compositePrimaryKeyEntities= new ArrayList<String>();
        compositePrimaryKeyEntities.add("User");
        
        Map<String,EntityDetails> entityDetailsMap= new HashMap<String, EntityDetails>();
        EntityDetails entityDetails = new EntityDetails();
        entityDetails.setIdClass("blogId");
        entityDetails.setRelationsMap(new HashMap<String, RelationDetails>());
        entityDetails.setFieldsMap(new HashMap<String, FieldDetails>());
        entityDetails.setCompositeKeyClasses(compositePrimaryKeyEntities);
		entityDetailsMap.put("user", entityDetails);
		
		Mockito.doNothing().when(loader).setPath(anyString());
		Mockito.doReturn(new ArrayList<Class<?>>()).when(loader).findClasses(anyString());
		Mockito.doReturn(classList).when(mockedEntityGeneratorUtils).filterOnlyRelevantEntities(any(ArrayList.class));
		Mockito.doReturn(compositePrimaryKeyEntities).when(mockedEntityGeneratorUtils).findCompositePrimaryKeyClasses(any(ArrayList.class));
		Mockito.doReturn(entityDetails).when(mockedEntityDetails).retreiveEntityFieldsAndRships(any(Class.class),anyString(),any(List.class));
		Mockito.doReturn(new HashMap<String,String>()).when(mockedEntityGeneratorUtils).getPrimaryKeysFromMap(any(HashMap.class));
	    Mockito.doReturn(entityDetails.getRelationsMap()).when(mockedEntityDetails).FindOneToManyJoinColFromChildEntity(any(HashMap.class), any(List.class));
	    Mockito.doReturn(entityDetails.getRelationsMap()).when(mockedEntityDetails).FindOneToOneJoinColFromChildEntity(any(HashMap.class), any(List.class));
	    Mockito.doReturn(entityDetails).when(entityGenerator).setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(any(HashMap.class),any(HashMap.class),any(EntityDetails.class),anyString());
	    Mockito.doReturn(entityDetails).when(entityGenerator).updateFieldsListInRelationMap(any(EntityDetails.class));
	    Mockito.doReturn(new HashMap<String, Object>()).when(entityGenerator).buildRootMap(any(EntityDetails.class), anyString(), anyString(), anyString(), anyString(), anyString());
	    Mockito.doNothing().when(entityGenerator).generateEntityAndIdClass(any(HashMap.class), any(EntityDetails.class),anyString(), anyString(),any(List.class));
	    Mockito.doReturn(entityDetailsMap).when(entityGenerator).validateAuthenticationTable(any(HashMap.class), anyString());
	    Mockito.doNothing().when(entityGenerator).generateAutheticationEntities(any(HashMap.class), anyString(), anyString(), anyString(), anyString(), anyString());
	 
	    Assertions.assertThat(entityGenerator.processAndGenerateRelevantEntities(destPath.getAbsolutePath(), PACKAGE_NAME, SCHEMA_NAME, PACKAGE_NAME, destPath.getAbsolutePath(), AUTHENTICATION_TYPE,AUTHENTICATION_TABLE)).isEqualTo(entityDetailsMap);
	}
	
	@Test
	public void processAndGenerateRelevantEntities_authenticationTypeIsNone_returnMap() throws ClassNotFoundException
	{
		List<Class<?>> classList= new ArrayList<Class<?>>();
		Class<?> c1 = Class.forName("java.lang.String"); 
        Class<?> c2 = int.class; 
        classList.add(c1);
        classList.add(c2);
        
        List<String> compositePrimaryKeyEntities= new ArrayList<String>();
        compositePrimaryKeyEntities.add("User");
        
        Map<String,EntityDetails> entityDetailsMap= new HashMap<String, EntityDetails>();
        EntityDetails entityDetails = new EntityDetails();
        entityDetails.setIdClass("blogId");
        entityDetails.setRelationsMap(new HashMap<String, RelationDetails>());
        entityDetails.setFieldsMap(new HashMap<String, FieldDetails>());
        entityDetails.setCompositeKeyClasses(compositePrimaryKeyEntities);
		entityDetailsMap.put("String", entityDetails);
		entityDetailsMap.put("int", entityDetails);
		
		Mockito.doNothing().when(loader).setPath(anyString());
		Mockito.doReturn(new ArrayList<Class<?>>()).when(loader).findClasses(anyString());
		Mockito.doReturn(classList).when(mockedEntityGeneratorUtils).filterOnlyRelevantEntities(any(ArrayList.class));
		Mockito.doReturn(compositePrimaryKeyEntities).when(mockedEntityGeneratorUtils).findCompositePrimaryKeyClasses(any(ArrayList.class));
		Mockito.doReturn(entityDetails).when(mockedEntityDetails).retreiveEntityFieldsAndRships(any(Class.class),anyString(),any(List.class));
		Mockito.doReturn(new HashMap<String,String>()).when(mockedEntityGeneratorUtils).getPrimaryKeysFromMap(any(HashMap.class));
	    Mockito.doReturn(entityDetails.getRelationsMap()).when(mockedEntityDetails).FindOneToManyJoinColFromChildEntity(any(HashMap.class), any(List.class));
	    Mockito.doReturn(entityDetails.getRelationsMap()).when(mockedEntityDetails).FindOneToOneJoinColFromChildEntity(any(HashMap.class), any(List.class));
	    Mockito.doReturn(entityDetails).when(entityGenerator).setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(any(HashMap.class),any(HashMap.class),any(EntityDetails.class),anyString());
	    Mockito.doReturn(entityDetails).when(entityGenerator).updateFieldsListInRelationMap(any(EntityDetails.class));
	    Mockito.doReturn(new HashMap<String, Object>()).when(entityGenerator).buildRootMap(any(EntityDetails.class), anyString(), anyString(), anyString(), anyString(), anyString());
	    Mockito.doNothing().when(entityGenerator).generateEntityAndIdClass(any(HashMap.class), any(EntityDetails.class),anyString(), anyString(),any(List.class));
	
	    Assertions.assertThat(entityGenerator.processAndGenerateRelevantEntities(destPath.getAbsolutePath(), PACKAGE_NAME, SCHEMA_NAME, PACKAGE_NAME, destPath.getAbsolutePath(), "none",AUTHENTICATION_TABLE)).isEqualTo(entityDetailsMap);
	}

	@Test
	public void findAndSetDescriptiveField_parametersAreValid_returnMap()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.seteName("blog");
	
		Mockito.doReturn(details).when(mockedUserInput).getEntityDescriptionField(anyString(), any(List.class));
		Map<String,FieldDetails> descriptiveFieldEntities= new HashMap<String, FieldDetails>();
		details.setDescription("blogDescriptiveField");
		descriptiveFieldEntities.put("blog",details);
		Assertions.assertThat(entityGenerator.findAndSetDescriptiveField(new HashMap<String, FieldDetails>(), relationDetails)).isEqualTo(descriptiveFieldEntities);
	}
	
	@Test
	public void setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap_parametersAreValid_returnMap()
	{
		
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");
		details.setDescription("blogDescriptiveField");
		
		Map<String,FieldDetails> descriptiveFieldEntities= new HashMap<String, FieldDetails>();
		descriptiveFieldEntities.put("blog",details);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.seteName("user");
		relationDetails.setcName("blog");
		relationDetails.setRelation("OneToOne");
		
		RelationDetails relationDetails1= new RelationDetails();
		relationDetails1.seteName("entry");
		relationDetails1.setcName("tag");
		relationDetails1.setRelation("ManyToOne");
		
		Map<String, RelationDetails> relationMap= new HashMap<String, RelationDetails>();
		relationMap.put("user-blog", relationDetails);
		relationMap.put("entry-tag",relationDetails1);
		
		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setIdClass("UserId");
		entityDetails.setEntitiesDescriptiveFieldMap(descriptiveFieldEntities);
		
		Mockito.doReturn(true).when(entityGenerator).identifyOneToOneRelationContainsPrimaryKeys(any(List.class),any(HashMap.class), any(List.class));
		Mockito.doReturn(entityDetails).when(entityGenerator).updateJoinColumnName(any(EntityDetails.class), any(RelationDetails.class));
		Mockito.doReturn(descriptiveFieldEntities).when(entityGenerator).findAndSetDescriptiveField(any(HashMap.class), any(RelationDetails.class));
	
		Assertions.assertThat(entityGenerator.setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(descriptiveFieldEntities, relationMap, new EntityDetails(), "blog")).isEqualTo(entityDetails);
	
	}
	
	@Test
	public void setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap_oneToOneCheckIsNotValid_returnMap()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");
		details.setDescription("blogDescriptiveField");
		
		Map<String,FieldDetails> descriptiveFieldEntities= new HashMap<String, FieldDetails>();
		descriptiveFieldEntities.put("blog",details);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.seteName("user");
		relationDetails.setcName("blog");
		relationDetails.setIsParent(true);
		relationDetails.setRelation("OneToOne");
		
		RelationDetails relationDetails1= new RelationDetails();
		relationDetails1.seteName("entry");
		relationDetails1.setcName("tag");
		relationDetails1.setRelation("ManyToOne");
		
		Map<String, RelationDetails> relationMap= new HashMap<String, RelationDetails>();
		relationMap.put("user-blog", relationDetails);
		relationMap.put("entry-tag",relationDetails1);
		
		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setEntitiesDescriptiveFieldMap(descriptiveFieldEntities);
		
		Mockito.doReturn(true).when(entityGenerator).identifyOneToOneRelationContainsPrimaryKeys(any(List.class),any(HashMap.class), any(List.class));
		Mockito.doReturn(entityDetails).when(entityGenerator).updateJoinColumnName(any(EntityDetails.class), any(RelationDetails.class));
		Mockito.doReturn(descriptiveFieldEntities).when(entityGenerator).findAndSetDescriptiveField(any(HashMap.class), any(RelationDetails.class));
	
		Assertions.assertThat(entityGenerator.setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(descriptiveFieldEntities, relationMap, new EntityDetails(), "blog")).isEqualToIgnoringNullFields(entityDetails);
	}
	
	@Test
	public void setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap_manyTonOneIsNotInList_returnMap()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");
		details.setDescription("blogDescriptiveField");
		
		Map<String,FieldDetails> descriptiveFieldEntities= new HashMap<String, FieldDetails>();
		descriptiveFieldEntities.put("blog",details);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.seteName("user");
		relationDetails.setcName("blog");
		relationDetails.setIsParent(true);
		relationDetails.setRelation("OneToOne");
		
		
		Map<String, RelationDetails> relationMap= new HashMap<String, RelationDetails>();
		relationMap.put("user-blog", relationDetails);
	
		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setEntitiesDescriptiveFieldMap(descriptiveFieldEntities);
		
		Mockito.doReturn(true).when(entityGenerator).identifyOneToOneRelationContainsPrimaryKeys(any(List.class),any(HashMap.class), any(List.class));
		Mockito.doReturn(entityDetails).when(entityGenerator).updateJoinColumnName(any(EntityDetails.class), any(RelationDetails.class));
		Mockito.doReturn(descriptiveFieldEntities).when(entityGenerator).findAndSetDescriptiveField(any(HashMap.class), any(RelationDetails.class));
	
		Assertions.assertThat(entityGenerator.setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(descriptiveFieldEntities, relationMap, new EntityDetails(), "blog")).isEqualToIgnoringNullFields(entityDetails);
	
	}
	
	@Test
	public void identifyOneToOneRelationContainsPrimaryKeys_parametersAreValid_returnTrue()
	{
		List<String> relationEntityPrimaryKeys = new ArrayList<>();
		relationEntityPrimaryKeys.add("userId");
		
		Map<String,String> primaryKeysMap= new HashMap<String, String>();
		primaryKeysMap.put("blogId", "Long");
		primaryKeysMap.put("userId", "Long");
		
		List<JoinDetails> joinDetailsList = new ArrayList<JoinDetails>();
		JoinDetails joinDetails = new JoinDetails();
		joinDetails.setReferenceColumn("userId");
		joinDetailsList.add(joinDetails);
		
		Mockito.doReturn(relationEntityPrimaryKeys).when(mockedEntityGeneratorUtils).getPrimaryKeysFromList(any(List.class));
		Assertions.assertThat(entityGenerator.identifyOneToOneRelationContainsPrimaryKeys(new ArrayList<FieldDetails>(), primaryKeysMap, joinDetailsList)).isEqualTo(true);
	}
	
	@Test
	public void identifyOneToOneRelationContainsPrimaryKeys_entityPrimaryKeysNotContainJoinColumn_returnFalse()
	{
		List<String> relationEntityPrimaryKeys = new ArrayList<>();
		relationEntityPrimaryKeys.add("userId");
		
		Map<String,String> primaryKeysMap= new HashMap<String, String>();
		primaryKeysMap.put("blogId", "Long");
		
		List<JoinDetails> joinDetailsList = new ArrayList<JoinDetails>();
		JoinDetails joinDetails = new JoinDetails();
		joinDetails.setReferenceColumn("userId");
		joinDetailsList.add(joinDetails);
		
		Mockito.doReturn(relationEntityPrimaryKeys).when(mockedEntityGeneratorUtils).getPrimaryKeysFromList(any(List.class));
		Assertions.assertThat(entityGenerator.identifyOneToOneRelationContainsPrimaryKeys(new ArrayList<FieldDetails>(), primaryKeysMap, joinDetailsList)).isEqualTo(false);
	}
	
	@Test
	public void identifyOneToOneRelationContainsPrimaryKeys_listIsEmpty_returnFalse()
	{
		List<String> relationEntityPrimaryKeys = new ArrayList<>();
		relationEntityPrimaryKeys.add("userId");
		
		Map<String,String> primaryKeysMap= new HashMap<String, String>();
		primaryKeysMap.put("blogId", "Long");
		
		List<JoinDetails> joinDetailsList = new ArrayList<JoinDetails>();
		
		Mockito.doReturn(relationEntityPrimaryKeys).when(mockedEntityGeneratorUtils).getPrimaryKeysFromList(any(List.class));
		Assertions.assertThat(entityGenerator.identifyOneToOneRelationContainsPrimaryKeys(new ArrayList<FieldDetails>(), primaryKeysMap, joinDetailsList)).isEqualTo(false);
	}
	
	@Test
	public void updateFieldsListInRelationMap_fieldNameAndJoinColumnAreSame_returnEntityDetails()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");
		
		FieldDetails details1 = new FieldDetails();
		details1.setFieldName("blogId");
		details1.setFieldType("Long");
		
		List<FieldDetails> fDetails = new ArrayList<FieldDetails>();
		fDetails.add(details);
		fDetails.add(details1);
		
		JoinDetails joinDetails = new JoinDetails();
		joinDetails.setReferenceColumn("userId");
		joinDetails.setJoinColumn("blogId");
		
		List<JoinDetails> joinDetailsList = new ArrayList<JoinDetails>();
		joinDetailsList.add(joinDetails);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.setIsParent(true);
		relationDetails.setRelation("OneToOne");
		relationDetails.setfDetails(fDetails);
		relationDetails.setJoinDetails(joinDetailsList);
	
		Map<String, RelationDetails> relationMap= new HashMap<String, RelationDetails>();
		relationMap.put("user-blog", relationDetails);
		
		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setRelationsMap(relationMap);
	    Assertions.assertThat(entityGenerator.updateFieldsListInRelationMap(entityDetails)).isEqualTo(entityDetails);
	}
	
	@Test
	public void updateFieldsListInRelationMap_joinDetailsAreNull_returnEntityDetails()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");
		
		List<FieldDetails> fDetails = new ArrayList<FieldDetails>();
		fDetails.add(details);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.setIsParent(true);
		relationDetails.setRelation("OneToOne");
		relationDetails.setfDetails(fDetails);
		
		Map<String, RelationDetails> relationMap= new HashMap<String, RelationDetails>();
		relationMap.put("user-blog", relationDetails);
		
		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setRelationsMap(relationMap);
	    Assertions.assertThat(entityGenerator.updateFieldsListInRelationMap(entityDetails)).isEqualTo(entityDetails);
	}
	
	@Test
	public void updateJoinColumnName_joinColumnAndReferenceColumnAreNotSame_returnEntityDetails()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogId");
		details.setFieldType("Long");
		details.setDescription("blogDescriptiveField");
		
		Map<String,FieldDetails> fieldDetailsMap= new HashMap<String, FieldDetails>();
		fieldDetailsMap.put("blogId",details);
		

		JoinDetails joinDetails = new JoinDetails();
		joinDetails.setReferenceColumn("userId");
		joinDetails.setJoinColumn("blogId");
		
		List<JoinDetails> joinDetailsList = new ArrayList<JoinDetails>();
		joinDetailsList.add(joinDetails);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.setIsParent(true);
		relationDetails.setRelation("OneToOne");
		relationDetails.setJoinDetails(joinDetailsList);
		
		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setFieldsMap(fieldDetailsMap);
		
		Assertions.assertThat(entityGenerator.updateJoinColumnName(entityDetails, relationDetails)).isEqualTo(entityDetails);
		
	}
	
	@Test
	public void updateJoinColumnName_joinDetailsAreNull_returnEntityDetails()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogId");
		details.setFieldType("Long");
		details.setDescription("blogDescriptiveField");
		
		Map<String,FieldDetails> fieldDetailsMap= new HashMap<String, FieldDetails>();
		fieldDetailsMap.put("blogId",details);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.setIsParent(true);
		relationDetails.setRelation("OneToOne");
		
		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setFieldsMap(fieldDetailsMap);
		
		Assertions.assertThat(entityGenerator.updateJoinColumnName(entityDetails, relationDetails)).isEqualTo(entityDetails);
	}
	
	@Test
	public void validateAuthenticationTable_entityDetailsMapIsNull_returnMap()
	{
		Assertions.assertThat(entityGenerator.validateAuthenticationTable(null, AUTHENTICATION_TABLE)).isEqualTo(null);
	}
	
	@Test
	public void validateAuthenticationTable_entityDetailsMapIsNotNull_returnMap()
	{
		Map<String,EntityDetails> entityDetailsMap= new HashMap<String, EntityDetails>();
		entityDetailsMap.put("user", new EntityDetails());
		Mockito.doReturn(entityDetailsMap).when(entityGenerator).getAuthenticationTableFieldsMapping(any(HashMap.class),anyString());
		Assertions.assertThat(entityGenerator.validateAuthenticationTable(entityDetailsMap, AUTHENTICATION_TABLE)).isEqualTo(entityDetailsMap);
	}
	
	@Test
	public void displayAuthFieldsAndGetMapping_entityDetailsMapIsNotNull_returnMap()
	{
		Map<String,FieldDetails> authFields=new HashMap<String, FieldDetails>();
		authFields.put("UserName", null);
		authFields.put("Password", null);
		
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");
		
		FieldDetails details1 = new FieldDetails();
		details1.setFieldName("blogId");
		details1.setFieldType("Long");
		
		FieldDetails details2 = new FieldDetails();
		details2.setFieldName("pass");
		details2.setFieldType("String");
		
		List<FieldDetails> fDetails = new ArrayList<FieldDetails>();
		fDetails.add(details);
		fDetails.add(details2);
		fDetails.add(details1);
		
		
		Map<String,FieldDetails> updated=new HashMap<String, FieldDetails>();
		updated.put("UserName", details);
		updated.put("Password", details2);
		
		Mockito.doReturn(3,1,1).when(mockedUserInput).getFieldsInput(any(Integer.class));
		Assertions.assertThat(entityGenerator.displayAuthFieldsAndGetMapping(authFields, fDetails)).isEqualTo(updated);
		
	}

	@Test
	public void getFieldsList_fieldsListIsNotEmpty_returnList()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");
		
		FieldDetails details1 = new FieldDetails();
		details1.setFieldName("blogId");
		details1.setFieldType("Long");
	
		Map<String,FieldDetails> fieldDetailsMap= new HashMap<String, FieldDetails>();
		fieldDetailsMap.put("blogId",details1);
		fieldDetailsMap.put("blogName",details);
		
		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setFieldsMap(fieldDetailsMap);
		
		List<FieldDetails> fDetails = new ArrayList<FieldDetails>();
		fDetails.add(details);
		fDetails.add(details1);
		
		Assertions.assertThat(entityGenerator.getFieldsList(entityDetails)).isEqualTo(fDetails);
	}
	
	@Test
	public void getAuthenticationTableFieldsMapping_fieldsListIsNotEmpty_returnList()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");
		
		FieldDetails details1 = new FieldDetails();
		details1.setFieldName("pass");
		details1.setFieldType("String");
		
		List<FieldDetails> fDetails = new ArrayList<FieldDetails>();
		fDetails.add(details);
		fDetails.add(details1);
		
		Map<String,FieldDetails> updated=new HashMap<String, FieldDetails>();
		updated.put("UserName", details);
		updated.put("Password", details1);
		
        Map<String,EntityDetails> entityDetailsMap= new HashMap<String, EntityDetails>();
        EntityDetails entityDetails = new EntityDetails();
        entityDetails.setAuthenticationFieldsMap(updated);
		entityDetailsMap.put("user", entityDetails);
		
		Mockito.doReturn(fDetails).when(entityGenerator).getFieldsList(any(EntityDetails.class));
		Mockito.doReturn(updated).when(entityGenerator).displayAuthFieldsAndGetMapping(any(HashMap.class), any(List.class));
	
		Assertions.assertThat(entityGenerator.getAuthenticationTableFieldsMapping(entityDetailsMap, AUTHENTICATION_TABLE)).isEqualTo(entityDetailsMap);
	}
	
	@Test
	public void generateAutheticationEntities_parametersAreValid_returnNothing()
	{
		String entityName = "entity";
		Map<String, EntityDetails> details = new HashMap<String,EntityDetails>();
		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),SCHEMA_NAME, entityName+"id");
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setEntityTableName(entityName+2);

		details.put(entityName, entityDetails);
		Map<String, Object> root = new HashMap<>();

		root.put("PackageName", PACKAGE_NAME);
		root.put("Cache", true);
		root.put("CommonModulePackage" , PACKAGE_NAME.concat(".commonmodule"));
		root.put("AuthenticationType",AUTHENTICATION_TYPE);
		root.put("SchemaName",SCHEMA_NAME);

		root.put("UserInput","true");
		root.put("AuthenticationTable", entityName);

		root.put("ClassName", entityName);
		root.put("CompositeKeyClasses", entityDetails.getCompositeKeyClasses());
		root.put("Fields", entityDetails.getFieldsMap());
		root.put("AuthenticationFields", entityDetails.getAuthenticationFieldsMap());
		root.put("DescriptiveField", entityDetails.getEntitiesDescriptiveFieldMap());
		root.put("PrimaryKeys", entityDetails.getPrimaryKeys());
		
		Mockito.doReturn(new HashMap<String, Object>()).when(entityGenerator).getAuthenticationEntitiesTemplates(anyString(), anyString(), anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class),  anyString(),  anyString());
		entityGenerator.generateAutheticationEntities(details,SCHEMA_NAME, PACKAGE_NAME, destPath.getAbsolutePath(), AUTHENTICATION_TABLE, AUTHENTICATION_TYPE);
	    Mockito.verify(mockedCodeGeneratorUtils,Mockito.times(1)).generateFiles(any(HashMap.class), any(HashMap.class),  anyString(),  anyString());
	}
	
	@Test
	public void getAuthenticationEntitiesTemplates_autenticationTableIsNotNull_returnTemplatesMap()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/UserpermissionAppService.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/UserroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");
		
		Map<String,Object> expectedList = new HashMap<String,Object>();
		expectedList.put("/PermissionAppService.java.ftl","/PermissionAppService.java");
		expectedList.put("/UserpermissionAppService.java.ftl","/NewUserpermissionAppService.java");
		expectedList.put("/UserroleAppService.java.ftl","/NewUserroleAppService.java");
		
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		
		Assertions.assertThat(entityGenerator.getAuthenticationEntitiesTemplates(destPath.getAbsolutePath(), AUTHENTICATION_TYPE, "NewUser")).isEqualTo(expectedList);
	}
	
	@Test
	public void getAuthenticationEntitiesTemplates_autenticationTableIsNull_returnTemplatesMap()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/UserpermissionAppService.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/UserroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");
		
		Map<String,Object> expectedList = new HashMap<String,Object>();
		expectedList.put("/PermissionAppService.java.ftl","/PermissionAppService.java");
		expectedList.put("/UserpermissionAppService.java.ftl","/UserpermissionAppService.java");
		expectedList.put("/UserAppService.java.ftl","/UserAppService.java");
		expectedList.put("/UserroleAppService.java.ftl","/UserroleAppService.java");
		
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		
		Assertions.assertThat(entityGenerator.getAuthenticationEntitiesTemplates(destPath.getAbsolutePath(), AUTHENTICATION_TYPE, null)).isEqualTo(expectedList);
	}
	
	@Test
	public void buildRootMap_autenticationTableIsNull_returnMap()
	{
		String entityName = "entity1";

		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),SCHEMA_NAME, entityName+"id");
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setEntityTableName(entityName);
		
		Map<String, Object> root = new HashMap<>();

		root.put("EntityClassName", entityName.concat("Entity"));
		root.put("ClassName", entityName);
		root.put("PackageName", PACKAGE_NAME);
		root.put("CommonModulePackage", PACKAGE_NAME.concat(".commonmodule"));
		root.put("CompositeKeyClasses", entityDetails.getCompositeKeyClasses());
		root.put("TableName", entityDetails.getEntityTableName());
		root.put("SchemaName", SCHEMA_NAME);
		root.put("IdClass", entityDetails.getIdClass());
		root.put("AuthenticationType", AUTHENTICATION_TYPE);
		root.put("AuthenticationTable", "User");
		root.put("AuthenticationFields", entityDetails.getAuthenticationFieldsMap());
		
		root.put("Fields", entityDetails.getFieldsMap());
		root.put("Relationship", entityDetails.getRelationsMap());
		root.put("PrimaryKeys", entityDetails.getPrimaryKeys());
		
		Assertions.assertThat(entityGenerator.buildRootMap(entityDetails, entityName, PACKAGE_NAME, SCHEMA_NAME, null, AUTHENTICATION_TYPE)).isEqualTo(root);
	}
	
	@Test
	public void buildRootMap_autenticationTableIsNotNull_returnMap()
	{
		String entityName = "entity1";

		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),SCHEMA_NAME, entityName+"id");
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setEntityTableName(entityName);
		
		Map<String, Object> root = new HashMap<>();

		root.put("EntityClassName", entityName.concat("Entity"));
		root.put("ClassName", entityName);
		root.put("PackageName", PACKAGE_NAME);
		root.put("CommonModulePackage", PACKAGE_NAME.concat(".commonmodule"));
		root.put("CompositeKeyClasses", entityDetails.getCompositeKeyClasses());
		root.put("TableName", entityDetails.getEntityTableName());
		root.put("SchemaName", SCHEMA_NAME);
		root.put("IdClass", entityDetails.getIdClass());
		root.put("AuthenticationType", AUTHENTICATION_TYPE);
		root.put("AuthenticationTable", AUTHENTICATION_TABLE);
		root.put("AuthenticationFields", entityDetails.getAuthenticationFieldsMap());
		
		root.put("Fields", entityDetails.getFieldsMap());
		root.put("Relationship", entityDetails.getRelationsMap());
		root.put("PrimaryKeys", entityDetails.getPrimaryKeys());
		
		Assertions.assertThat(entityGenerator.buildRootMap(entityDetails, entityName, PACKAGE_NAME, SCHEMA_NAME, AUTHENTICATION_TABLE, AUTHENTICATION_TYPE)).isEqualTo(root);
	}
	
	@Test
	public void generateEntityAndIdClass_autenticationTableIsNotNull_returnMap()
	{
		List<String> compositePrimaryKeyEntities= new ArrayList<String>();
		compositePrimaryKeyEntities.add("user");
		
		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),SCHEMA_NAME, "userId");
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setIdClass("userId");
		entityDetails.setCompositeKeyClasses(compositePrimaryKeyEntities);
		
		Map<String, Object> root = new HashMap<>();
		root.put("ClassName", "user");
		Mockito.doNothing().when(entityGenerator).generateEntity(any(HashMap.class), any(String.class));
		Mockito.doNothing().when(entityGenerator).generateIdClass(any(HashMap.class), any(String.class));
	
	    entityGenerator.generateEntityAndIdClass(root, entityDetails, PACKAGE_NAME, destPath.getAbsolutePath(), compositePrimaryKeyEntities);
	    Mockito.verify(entityGenerator,Mockito.times(1)).generateEntity(any(HashMap.class), any(String.class));
	    Mockito.verify(entityGenerator,Mockito.times(1)).generateIdClass(any(HashMap.class), any(String.class));
	}

	@Test
	public void generateEntity_parametersAreValid_returnNothing()
	{
		Map<String, Object> root = new HashMap<>();
		root.put("ClassName", "entity1");
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());
	    entityGenerator.generateEntity(root, destPath.getAbsolutePath());
	    Mockito.verify(mockedCodeGeneratorUtils,Mockito.times(1)).generateFiles(any(HashMap.class), any(HashMap.class),  anyString(), anyString());
	}
	
	@Test
	public void generateIdClass_parametersAreValid_returnNothing()
	{
		Map<String, Object> root = new HashMap<>();
		root.put("ClassName", "entity1");
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());
	    entityGenerator.generateEntity(root, destPath.getAbsolutePath());
	    Mockito.verify(mockedCodeGeneratorUtils,Mockito.times(1)).generateFiles(any(HashMap.class), any(HashMap.class),  anyString(), anyString());
	}

	
}
