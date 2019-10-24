import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { [=AuthenticationTable]permissionService } from './[=moduleName]permission.service';
import { I[=AuthenticationTable]permission } from './i[=moduleName]permission';
import { PickerDialogService, ErrorService } from 'fastCodeCore';

import { [=AuthenticationTable]Service } from '../[=moduleName]/[=moduleName].service';
import { PermissionService } from '../permission/permission.service';

import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-[=moduleName]permission-details',
  templateUrl: './[=moduleName]permission-details.component.html',
  styleUrls: ['./[=moduleName]permission-details.component.scss']
})
export class [=AuthenticationTable]permissionDetailsComponent extends BaseDetailsComponent<I[=AuthenticationTable]permission> implements OnInit {
  title:string='[=AuthenticationTable]permission';
  parentUrl:string='[=AuthenticationTable?lower_case]permission';
  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: [=AuthenticationTable]permissionService,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
		public [=AuthenticationTable?uncap_first]Service: [=AuthenticationTable]Service,
		public permissionService: PermissionService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

	ngOnInit() {
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			permissionId: ['', Validators.required],
			permissionDescriptiveField : [{ value: '', disabled: true }],
			<#if !UserInput??>
			[=AuthenticationTable?uncap_first]Id: ['', Validators.required],
			[=AuthenticationTable?uncap_first]DescriptiveField : [{ value: '', disabled: true }],
			<#elseif UserInput??>
			<#if PrimaryKeys??>
			<#list PrimaryKeys as key,value>
			<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
			[=AuthenticationTable?uncap_first + value.fieldName?cap_first] : ['', Validators.required],
			</#if> 
			</#list>
			</#if>
			<#if DescriptiveField?? && DescriptiveField[AuthenticationTable]?? && DescriptiveField[AuthenticationTable].description??>
			[=DescriptiveField[AuthenticationTable].description?uncap_first] : [{ value: '', disabled: true }],
			<#else>
			<#if AuthenticationFields??>
  			<#list AuthenticationFields as authKey,authValue>
  			<#if authKey== "UserName">
  			<#if !PrimaryKeys[authValue.fieldName]??>
  			[=AuthenticationTable?uncap_first + authValue.fieldName?cap_first]: [{ value: '', disabled: true }],
  			</#if>
    		</#if>
    		</#list>
    		</#if>
			</#if>
			</#if>
	    });
	    if (this.idParam) {
			this.getItem(this.idParam).subscribe(x=>this.onItemFetched(x),error => this.errorMessage = <any>error);
	    }
  }
  
	setAssociations(){
  	
		this.associations = [
			{
				column: [
					<#if !UserInput??>
					{
						key: '[=AuthenticationTable?uncap_first]Id',
						value: undefined,
						referencedkey: 'id'
					},
					<#elseif UserInput??>
					<#if PrimaryKeys??>
					<#list PrimaryKeys as key,value>
					<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
					{
						key: '[=AuthenticationTable?uncap_first + value.fieldName?cap_first]',
						value: undefined,
						referencedkey: '[=value.fieldName]'
					},
					</#if> 
					</#list>
					</#if>
					</#if>
				],
				isParent: false,
				table: '[=AuthenticationTable?uncap_first]',
				type: 'ManyToOne',
				service: this.[=AuthenticationTable?uncap_first]Service,
				<#if UserInput??>
				<#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??  && DescriptiveField[AuthenticationTable].description??>
				descriptiveField: '[=DescriptiveField[AuthenticationTable].description?uncap_first]',
				referencedDescriptiveField: '[=DescriptiveField[AuthenticationTable].fieldName]',
				<#else>
                <#if AuthenticationFields??>
  				<#list AuthenticationFields as authKey,authValue>
  				<#if authKey== "UserName">
  				<#if !PrimaryKeys[authValue.fieldName]??>
  				descriptiveField: '[=AuthenticationTable?uncap_first + authValue.fieldName?cap_first]',
				referencedDescriptiveField: '[=authValue.fieldName]',
				</#if>
    			</#if>
    			</#list>
    			</#if>
				</#if>
				<#elseif !UserInput??>
				descriptiveField: '[=AuthenticationTable?uncap_first]DescriptiveField',
				referencedDescriptiveField: 'userName',
				</#if>
				
			},
			{
				column: [
					{
						key: 'permissionId',
						value: undefined,
						referencedkey: 'id'
					},
				],
				isParent: false,
				table: 'permission',
				type: 'ManyToOne',
				service: this.permissionService,
				descriptiveField: 'permissionDescriptiveField',
				referencedDescriptiveField: 'name',
			},
		];
		this.childAssociations = this.associations.filter(association => {
			return (association.isParent);
		});

		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}

	onItemFetched(item:I[=AuthenticationTable]permission) {
		this.item = item;
		this.itemForm.patchValue({
			permissionId: item.permissionId,
			permissionDescriptiveField: item.permissionDescriptiveField,
			<#if !UserInput??>
			[=AuthenticationTable?uncap_first]Id: item.[=AuthenticationTable?uncap_first]Id,
			[=AuthenticationTable?uncap_first]DescriptiveField: item.[=AuthenticationTable?uncap_first]DescriptiveField,
			<#elseif UserInput??>
			<#if PrimaryKeys??>
			<#list PrimaryKeys as key,value>
			<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
			[=AuthenticationTable?uncap_first + value.fieldName?cap_first] : item.[=AuthenticationTable?uncap_first + value.fieldName?cap_first],
			</#if> 
			</#list>
			</#if>
			<#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??>
			[=DescriptiveField[AuthenticationTable].description?uncap_first] : item.[=DescriptiveField[AuthenticationTable].description?uncap_first],
			<#else>
			<#if AuthenticationFields??>
  			<#list AuthenticationFields as authKey,authValue>
  			<#if authKey== "UserName">
  			<#if !PrimaryKeys[authValue.fieldName]??>
  			[=AuthenticationTable?uncap_first + authValue.fieldName?cap_first]: item.[=AuthenticationTable?uncap_first + authValue.fieldName?cap_first],
			</#if>
    		</#if>
    		</#list>
    		</#if>
			</#if>
			</#if>
		});
	}
}