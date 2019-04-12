package com.nfinity.entitycodegen;

import java.util.List;

public class UserInput {
	String packageName;
	String groupArtifactId;
	String generationType;
	String destinationPath;
	String schemaName;
	List<String> tablesList;
	Boolean audit;
	String auditPackage;
	
	
	public String getGroupArtifactId() {
		return groupArtifactId;
	}
	public void setGroupArtifactId(String groupArtifactId) {
		this.groupArtifactId = groupArtifactId;
	}
	public String getGenerationType() {
		return generationType;
	}
	public void setGenerationType(String generationType) {
		this.generationType = generationType;
	}
	
	public String getPackageName() {
		return packageName;
	}
	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}
	public String getDestinationPath() {
		return destinationPath;
	}
	public void setDestinationPath(String destinationPath) {
		this.destinationPath = destinationPath;
	}
	public String getSchemaName() {
		return schemaName;
	}
	public void setSchemaName(String schemaName) {
		this.schemaName = schemaName;
	}
	public Boolean getAudit() {
		return audit;
	}
	public void setAudit(Boolean audit) {
		this.audit = audit;
	}
	public String getAuditPackage() {
		return auditPackage;
	}
	public void setAuditPackage(String auditPackage) {
		this.auditPackage = auditPackage;
	}
	public List<String> getTablesList() {
		return tablesList;
	}
	public void setTablesList(List<String> tablesList) {
		this.tablesList = tablesList;
	}	
	
	
}
