import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { PostService } from './post.service';
import { IPost } from './ipost';
import { PickerDialogService, ErrorService } from 'fastCodeCore';


import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-post-details',
  templateUrl: './post-details.component.html',
  styleUrls: ['./post-details.component.scss']
})
export class PostDetailsComponent extends BaseDetailsComponent<IPost> implements OnInit {
	title:string='Post';
	parentUrl:string='post';
	//roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: PostService,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

	ngOnInit() {
		this.entityName = 'Post';
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			description: [''],
			postid: [''],
			title: [''],
			
	    });
	    if (this.idParam) {
			this.getItem(this.idParam).subscribe(x=>this.onItemFetched(x),error => this.errorMessage = <any>error);
	    }
  }
  
  
	setAssociations(){
  	
		this.associations = [
			{
				column: [
					{
						key: 'pid',
						value: undefined,
						referencedkey: 'postid'
					},
					{
						key: 'title',
						value: undefined,
						referencedkey: 'title'
					},
				],
				isParent: true,
				table: 'postdetails',
				type: 'OneToMany',
			},
		];
		
		this.childAssociations = this.associations.filter(association => {
			return (association.isParent);
		});

		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}

	onItemFetched(item:IPost) {
		this.item = item;
		this.itemForm.patchValue({
			description: item.description,
			postid: item.postid,
			title: item.title,
		});
	}
}