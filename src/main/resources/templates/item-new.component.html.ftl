<div>
	<mat-toolbar class="action-tool-bar" color="primary">
		<button name="cancel" mat-button (click)="onCancel()">{{'GENERAL.ACTIONS.CANCEL' | translate}}</button>
		<span class="middle">{{title}}</span>
		<button name="save" mat-button (click)="itemNgForm.ngSubmit.emit()" [disabled]="!itemForm.valid || loading <#if AuthenticationType!="none">|| !IsCreatePermission</#if>">{{'GENERAL.ACTIONS.SAVE' | translate}}</button>
	</mat-toolbar>
	<mat-card>
		<h2>{{title}}</h2>
		<form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
		<#list Fields as key,value>
		<#-- to exclude the duplicate fields(join columns) -->
		<#assign isJoinColumn = false>
		<#if Relationship?has_content>
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
		<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
        <#if joinDetails.joinColumn == key>
        <#assign isJoinColumn = true>
        </#if>
        </#if>
		</#if>
		</#list>
		</#if>
		</#list>
		</#if>
		
		<#if AuthenticationType != "none" && ClassName == AuthenticationTable>  
		<#if AuthenticationFields?? && isJoinColumn == false>
		<#if AuthenticationFields.Password.fieldName != value.fieldName>
		<#if value.fieldType?lower_case == "boolean">
			<mat-checkbox formControlName="[=value.fieldName]">[=value.fieldName]</mat-checkbox>
		<#elseif value.fieldType?lower_case == "date">
			<mat-form-field>
				<input formControlName="[=value.fieldName]" matInput [matDatepicker]="[=value.fieldName]Picker" placeholder="Enter [=value.fieldName]">
				<mat-datepicker-toggle matSuffix [for]="[=value.fieldName]Picker"></mat-datepicker-toggle>
				<mat-datepicker #[=value.fieldName]Picker></mat-datepicker>
				<#if value.isNullable == false>
				<mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">[=value.fieldName] is required</mat-error>
				</#if>
			</mat-form-field>
		<#elseif value.fieldType?lower_case == "string">
			<mat-form-field>
				<input formControlName="[=value.fieldName]" matInput placeholder="Enter [=value.fieldName]">
				<#if value.isNullable == false>
				<mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">[=value.fieldName] is required</mat-error>
			    </#if>
			</mat-form-field>
		<#elseif !value.isAutogenerated && (value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "integer" ||  value.fieldType?lower_case == "short" ||  value.fieldType?lower_case == "double")>
			<mat-form-field>
				<input type="number" formControlName="[=value.fieldName]" matInput placeholder="Enter [=value.fieldName]">
				<#if value.isNullable == false>
				<mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">[=value.fieldName] is required</mat-error>
			    </#if>
			</mat-form-field>
		</#if>
		<#else>
			<mat-form-field>
				<input type="password"matInput placeholder="New password" formControlName="[=value.fieldName]" required>
				<mat-error *ngIf="itemForm.hasError('required', 'password')">
					Please enter your new password
				</mat-error>
			</mat-form-field>

			<mat-form-field>
				<input matInput type="password" placeholder="Confirm password" formControlName="confirmPassword"
				pattern="{{ itemForm.get('[=value.fieldName]').value }}">
				<mat-error *ngIf="!itemForm.get('confirmPassword').valid && itemForm.get('confirmPassword').touched">
					Passwords do not match
				</mat-error>
			</mat-form-field>
		</#if>
		</#if>
		<#else>
		<#if isJoinColumn == false>
    	<#if value.fieldType?lower_case == "boolean">    
			<mat-checkbox formControlName="[=value.fieldName]">[=value.fieldName]</mat-checkbox>            
		<#elseif value.fieldType == "Date">
			<mat-form-field>
				<input formControlName="[=value.fieldName]" matInput [matDatepicker]="[=value.fieldName]Picker" placeholder="Enter [=value.fieldName]">
				<mat-datepicker-toggle matSuffix [for]="[=value.fieldName]Picker"></mat-datepicker-toggle>
				<mat-datepicker #[=value.fieldName]Picker></mat-datepicker>
				<#if value.isNullable == false>
				<mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">{{'GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
				</#if>
			</mat-form-field>
		<#elseif value.fieldType?lower_case == "string">
			<mat-form-field>
				<input formControlName="[=value.fieldName]" matInput placeholder="Enter [=value.fieldName]">
				<#if value.isNullable == false>
				<mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">{{'GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
				</#if>
			</mat-form-field>
		<#elseif !value.isAutogenerated && (value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "integer" ||  value.fieldType?lower_case == "short" ||  value.fieldType?lower_case == "double")>
			<mat-form-field>
				<input type="number" formControlName="[=value.fieldName]" matInput placeholder="Enter [=value.fieldName]">
				<#if value.isNullable == false>
			    <mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">{{'GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
				</#if>
			</mat-form-field>
		</#if>
    	</#if>
    	</#if>
    	</#list>
			<mat-form-field *ngFor="let association of parentAssociations">
				<input formControlName="{{association.descriptiveField}}" matInput placeholder="{{association.table}}">
				<mat-icon matSuffix (click)="$event.preventDefault();selectAssociation(association)">list</mat-icon>
			</mat-form-field>       
		</form>
	</mat-card>
</div>
