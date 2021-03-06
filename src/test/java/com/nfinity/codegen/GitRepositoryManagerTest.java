package com.nfinity.codegen;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

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

@RunWith(SpringJUnit4ClassRunner.class)
public class GitRepositoryManagerTest {

	@Rule
    public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	GitRepositoryManager gitRepositoryManager;
	
	@Mock
	GitRepositoryManager mockedGitRepositoryManager;
	
	@Mock
	CodeGeneratorUtils mockedUtils;
	
	@Mock
	CommandUtils mockedCommandUtils;
	
    File destPath;
    String testValue = "abc";
	String packageName = "com.nfinity.demo";
	String entityName = "entity1";
	String moduleName = "entity-1";
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(gitRepositoryManager);
		destPath = folder.newFolder("tempFolder");
	
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void isGitInstalled_gitIsInstalled_returnTrue() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "git version 2.23.0.windows.1";
		//String command = "init";
		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		Assertions.assertThat(gitRepositoryManager.isGitInstalled()).isEqualTo(true);
	}
	
	@Test
	public void isGitInstalled_gitIsNotInstalled_returnFalse() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "";
		//String command = "init";
		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		Assertions.assertThat(gitRepositoryManager.isGitInstalled()).isEqualTo(false);
	}
	
	@Test
	public void isGitInitialized_gitIsInstalled_returnTrue() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "true";

		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		Assertions.assertThat(gitRepositoryManager.isGitInstalled()).isEqualTo(true);
	}
	
	@Test
	public void isGitInitialized_gitIsInstalled_returnFalse() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "false";

		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		Assertions.assertThat(gitRepositoryManager.isGitInstalled()).isEqualTo(true);
	}
	
	@Test
	public void initializeGit_gitIsInstalled_returnNothing() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "true";

		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		gitRepositoryManager.initializeGit();
		Mockito.verify(mockedCommandUtils,Mockito.times(3)).runGitProcess(anyString(),anyString());
	}
	
	@Test
	public void hasUncommittedChanges_gitIsInstalled_returnFalse() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "";
		
		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		Assertions.assertThat(gitRepositoryManager.hasUncommittedChanges()).isEqualTo(false);
	}
	
	@Test
	public void hasUncommittedChanges_gitIsInstalled_returnTrue() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "true";
		
		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		Assertions.assertThat(gitRepositoryManager.hasUncommittedChanges()).isEqualTo(true);
	}
	
	@Test
	public void getCurrentBranch_gitIsInstalled_returnString() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "branch";
		
		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		Assertions.assertThat(gitRepositoryManager.getCurrentBranch()).isEqualTo(response);
	}
	
	@Test
	public void createUpgradeBranch_commandResultIsEmpty_returnFalse() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "";
		
		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		Assertions.assertThat(gitRepositoryManager.createUpgradeBranch()).isEqualTo(true);
	}
	
	@Test
	public void createUpgradeBranch_commandResultIsNotEmpty_returnTrue() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "true";
		
		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		Assertions.assertThat(gitRepositoryManager.createUpgradeBranch()).isEqualTo(true);
	}
	
	@Test
	public void addToGitRepository_upgradeFlagIsFalse_returnNothing() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		
		Mockito.doNothing().when(gitRepositoryManager).commitInitialApplication();
		gitRepositoryManager.addToGitRepository(false,"sourceBranch");
		Mockito.verify(gitRepositoryManager, Mockito.times(1)).commitInitialApplication();
	}
	
	@Test
	public void addToGitRepository_upgradeFlagIsTrue_returnNothing() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "";
		
		Mockito.doNothing().when(gitRepositoryManager).commitUpgradeBranch();
		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		Mockito.doReturn(-1).when(gitRepositoryManager).versionCompare(anyString(),anyString());
		gitRepositoryManager.addToGitRepository(true,"sourceBranch");
		Mockito.verify(mockedCommandUtils, Mockito.times(5)).runGitProcess(anyString(), anyString());
	}
	
	@Test
	public void commitInitialApplication_gitIsInstalledAndInitialized_returnNothing() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "";
		
		Mockito.doReturn(true).when(gitRepositoryManager).isGitInstalled();
		Mockito.doReturn(true).when(gitRepositoryManager).isGitInitialized();
		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		gitRepositoryManager.commitInitialApplication();
		Mockito.verify(mockedCommandUtils, Mockito.times(2)).runGitProcess(anyString(), anyString());
		
	}
	
	@Test
	public void commitInitialApplication_gitIsNotInstalled_returnNothing() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		
		Mockito.doReturn(false).when(gitRepositoryManager).isGitInstalled();
		Mockito.doReturn(false).when(gitRepositoryManager).isGitInitialized();
		gitRepositoryManager.commitInitialApplication();
		Mockito.verify(mockedCommandUtils, Mockito.never()).runGitProcess(anyString(), anyString());
	}
	
	@Test
	public void commitUpgradeBranch_gitIsInstalledAndInitialized_returnNothing() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "";
		
		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		gitRepositoryManager.commitUpgradeBranch();
		Mockito.verify(mockedCommandUtils, Mockito.times(2)).runGitProcess(anyString(), anyString());
		
	}
	
	@Test
	public void getGitVersion_gitIsInstalledAndInitialized_returnString() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		String response = "git version 2.23.0.windows.1";
		
		Mockito.doReturn(response).when(mockedCommandUtils).runGitProcess(anyString(),anyString());
		Assertions.assertThat(gitRepositoryManager.getGitVersion()).isEqualTo("2.23.0");
	}
	
	@Test
	public void versionCompare_str1HasLowerVersion_returnString() {
	
		Assertions.assertThat(gitRepositoryManager.versionCompare("2.23.0","2.23.1")).isEqualTo(-1);
	}
	
	@Test
	public void versionCompare_str2HasLowerVersion_returnString() {
	
		Assertions.assertThat(gitRepositoryManager.versionCompare("2.23.1","2.23.0")).isEqualTo(1);
	}
	
	@Test
	public void versionCompare_bothVersionsAreEqual_returnString() {
	
		Assertions.assertThat(gitRepositoryManager.versionCompare("2.23.0","2.23.0")).isEqualTo(0);
	}

	@Test
	public void CopyGitFiles_gitIsInstalled_returnNothing() {
		gitRepositoryManager.setDestinationPath(destPath.getAbsolutePath());
		
		Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
		gitRepositoryManager.CopyGitFiles();
		Mockito.verify(mockedUtils, Mockito.times(1)).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
	}
	
	@Test
	public void getGitTemplates_getGitTemaplates_returnMap() {
		Map<String, Object> gitTemplate = new HashMap<>();
        gitTemplate.put("gitignore.ftl", ".gitignore");
        Assertions.assertThat(gitRepositoryManager.getGitTemplates()).isEqualTo(gitTemplate);
	}

}
