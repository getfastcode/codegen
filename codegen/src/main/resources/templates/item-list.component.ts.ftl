import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import { [=IEntity] } from './[=IEntityFile]';
import { [=ClassName]Service } from './[=ModuleName].service';
import { Router, ActivatedRoute } from '@angular/router';
import {[=ClassName]NewComponent} from './[=ModuleName]-new.component';
import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService, ErrorService } from 'fastCodeCore';


<#if Relationship?has_content>
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "ManyToMany">
<#list CompositeKeyClasses as relationInput>
<#assign parent = relationInput>
<#if parent?keep_before("-") == relationValue.eName>
import { [=relationValue.eName]Service } from '../[=relationValue.eName?lower_case]/[=relationValue.eName?lower_case].service';
</#if>
</#list>
<#elseif relationValue.relation == "ManyToOne">
import { [=relationValue.eName]Service } from '../[=relationValue.eName?lower_case]/[=relationValue.eName?lower_case].service';
</#if>
</#list>
</#if>

@Component({
  selector: 'app-[=ModuleName]-list',
  templateUrl: './[=ModuleName]-list.component.html',
  styleUrls: ['./[=ModuleName]-list.component.scss']
})
export class [=ClassName]ListComponent extends BaseListComponent<[=IEntity]> implements OnInit {

	title:string = "[=ClassName]";
	
	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public dataService: [=ClassName]Service,
		public errorService: ErrorService,
		<#if Relationship?has_content>
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToOne">
		public [=relationValue.eName?uncap_first]Service: [=relationValue.eName]Service,
		</#if>
		</#list>
		</#if>
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, dataService, errorService)
  }

	ngOnInit() {
		<#if Relationship?has_content>
		this.setAssociation();
	    </#if>
		this.setColumns();
		this.primaryKeys = [ <#list PrimaryKeys as key,value>"[=key]", </#list> ]
		super.ngOnInit();
	}
  
  <#if Relationship?has_content> 
	setAssociation(){
  	
		this.associations = [
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToOne">
			{
				column: [
				      <#list relationValue.joinDetails as joinDetails>
                      <#if joinDetails.joinEntityName == relationValue.eName>
                      <#if joinDetails.joinColumn??>
                      {
					  key: '[=joinDetails.joinColumn]',
					  value: undefined,
					  referencedkey: '[=joinDetails.referenceColumn]'
					  },
					  </#if>
                      </#if>
                      </#list>
					  
				],
				isParent: false,
				<#if DescriptiveField[relationValue.eName]??>
				descriptiveField: '[=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first]',
				referencedDescriptiveField: '[=DescriptiveField[relationValue.eName].fieldName]',
				</#if>
				service: this.[=relationValue.eName?uncap_first]Service,
				associatedObj: undefined,
				table: '[=relationValue.eName?lower_case]',
				type: '[=relationValue.relation]'
			},
		</#if>
		</#list>
		];
	}
  </#if>
  
  	setColumns(){
  		this.columns = [
		<#list Fields as key,value>
		<#-- to exclude the duplicate fields(join columns) -->
		<#assign isJoinColumn = false>
		<#if Relationship?has_content>
		<#list Relationship as relationKey, relationValue>
		<#list relationValue.joinDetails as joinDetails>
	    <#if joinDetails.joinEntityName == relationValue.eName>
	    <#if joinDetails.joinColumn??>
	    <#if joinDetails.joinColumn == key>
	    <#assign isJoinColumn = true>
	    </#if>
	    </#if>
		</#if>
		</#list>
		</#list>
		</#if>
		<#if isJoinColumn == false>
		<#if value.fieldType?lower_case == "string">
			{
				column: '[=value.fieldName]',
				label: '[=value.fieldName]',
				sort: true,
				filter: true,
				type: listColumnType.String
			},
		<#elseif value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "long" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "short">
			{
				column: '[=value.fieldName]',
				label: '[=value.fieldName]',
				sort: true,
				filter: true,
				type: listColumnType.Number
			},
		<#elseif value.fieldType?lower_case == "date">
			{
				column: '[=value.fieldName]',
				label: '[=value.fieldName]',
				sort: true,
				filter: true,
				type: listColumnType.Date
			},
		<#elseif value.fieldType?lower_case == "boolean">
			{
				column: '[=value.fieldName]',
				label: '[=value.fieldName]',
				sort: true,
				filter: true,
				type: listColumnType.Boolean
			},
		</#if> 
		</#if>
		</#list>
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToOne">
			<#if DescriptiveField[relationValue.eName]??>
			{
	  			column: '[=relationValue.eName]',
				label: '[=relationValue.eName]',
				sort: false,
				filter: false,
				type: listColumnType.Boolean
	  		},
			</#if>
		</#if>
		</#list>
		  	{
				column: 'actions',
				label: 'Actions',
				sort: false,
				filter: false,
				type: listColumnType.String
			}
		];
		this.selectedColumns = this.columns;
		this.displayedColumns = this.columns.map((obj) => { return obj.column });
  	}
  
	addNew() {
		super.addNew([=ClassName]NewComponent);
	}
  
}
