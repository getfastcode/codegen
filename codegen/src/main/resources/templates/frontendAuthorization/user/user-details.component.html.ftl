<div *ngIf="item" class="container">
	<mat-toolbar class="action-tool-bar" color="primary">
		<button mat-flat-button (click)="onBack()">
	    {{'GENERAL.ACTIONS.CANCEL' | translate}} </button>
		<span class="middle">{{title}}</span>
	
		<button mat-flat-button (click)="itemNgForm.ngSubmit.emit()">
	    {{'GENERAL.ACTIONS.SAVE' | translate}} </button>
	</mat-toolbar>
	<mat-card class="card">
		<mat-card-content>
			<form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
				
				<mat-form-field>
					<input formControlName="firstName" matInput placeholder="Enter firstName">
					<mat-error *ngIf="!itemForm.get('firstName').valid && itemForm.get('firstName').touched">firstName is required</mat-error>
				</mat-form-field>

				<mat-form-field>
					<input formControlName="lastName" matInput placeholder="Enter lastName">
					<mat-error *ngIf="!itemForm.get('lastName').valid && itemForm.get('lastName').touched">lastName is required</mat-error>
				</mat-form-field>

				<mat-form-field>
					<input formControlName="userName" matInput placeholder="Enter userName">
					<mat-error *ngIf="!itemForm.get('userName').valid && itemForm.get('userName').touched">userName is required</mat-error>
				</mat-form-field>
				
				<mat-form-field>
					<input formControlName="emailAddress" matInput placeholder="Enter emailAddress">
					<mat-error *ngIf="!itemForm.get('emailAddress').valid && itemForm.get('emailAddress').touched">emailAddress is required</mat-error>
				</mat-form-field>
				
				<mat-form-field>
					<input formControlName="phoneNumber" matInput placeholder="Enter phoneNumber">
				</mat-form-field>
			
				<mat-checkbox formControlName="isActive">isActive</mat-checkbox>            
			
				<mat-checkbox formControlName="isEmailConfirmed">isEmailConfirmed</mat-checkbox>            
			
				<mat-checkbox formControlName="isLockoutEnabled">isLockoutEnabled</mat-checkbox>            
			
				<mat-form-field>
					<input formControlName="isPhoneNumberConfirmed" matInput placeholder="Enter isPhoneNumberConfirmed">
				</mat-form-field>
			
				<mat-form-field>
					<input formControlName="lastLoginTime" matInput [matDatepicker]="lastLoginTimePicker" placeholder="Enter lastLoginTime">
					<mat-datepicker-toggle matSuffix [for]="lastLoginTimePicker"></mat-datepicker-toggle>
					<mat-datepicker #lastLoginTimePicker></mat-datepicker>
				</mat-form-field>
				
				<mat-form-field *ngFor="let association of toOne">
					<input matInput disabled placeholder="{{association.table}}" formControlName="{{association.descriptiveField}}">
					<mat-icon matSuffix (click)="$event.preventDefault();selectAssociation(association)">list</mat-icon>
				</mat-form-field>
				
				<div *ngFor="let association of toMany">
					<a *ngIf="association.type == 'OneToMany'" [routerLink]="['/' + association.table]" [queryParams]="getQueryParams(association)" class="btn btn-link">{{association.table}}</a>
				</div>
			</form>
		</mat-card-content>
	</mat-card>
</div>