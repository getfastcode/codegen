@import './node_modules/@angular/material/_theming.scss'; //for testing purpose
@import 'light-purple-teal.scss';

//colors
$fc-primary-color: mat-color($fc-theme-primary);
$fc-primary-color-light: mat-color($fc-theme-primary,300);
$fc-accent-color: mat-color($fc-theme-accent);

.details-content{
    overflow: auto;
    height: calc(100% - 116px);
}

.details-container{
    height: 100%;
    display: flex;
    padding: 5px;
}

@media (max-width: 1024px) {
    .details-container{
        display: block;
        padding: 5px;
    }
}

.details-container a{
    color: $fc-accent-color;
    cursor: pointer;
}

.details-section {
    margin: 10px !important;
}

.details-section mat-card-title span {
    float: right;
    cursor: pointer;
    color: $fc-primary-color;
}

.details-section .user-details{
    display: inline-flex;
    align-items: center;
    width: 100%;
}

.col {
    flex: 1;
}

.full-width {
    width: 100%;
}

.generic-list {
    list-style: none inside;
    padding: 0;
    margin: 5px 0;
}

.generic-list.pack {
    max-height: 250px;
    overflow: auto;
}

.generic-list li {
    padding: 6px;
    position: relative;
}

.generic-list li > .icon {
    padding-right: 5px;
}

.generic-list li:hover {
    background-color:  #f8f8f9;
}

.generic-list li.nothing-to-see:hover {
    background-color:  transparent;
}

.generic-list li.active {
    background-color:  #eeeeee;
}

.generic-list li .actions {
    position: absolute;
    top: 3px;
    right: 5px;
    font-size: 20px;
    padding: 0 0 0 4px;
}

.generic-list li .actions a {
     padding: 4px 4px 0 4px;
 }

.generic-list li .actions a:hover {
    background-color: #ffffff;
}

.generic-list.grid li {
    border-bottom: 1px solid #eeeeee;
}

.generic-list.grid li:first-child {
    border-top: 1px solid #eeeeee;
}

.generic-list li .subtle {
    color: #999999;
    font-size: 13px;
}

.generic-list .loading {
    position: absolute;
    left: 50%;
    margin-left: -15px;
    line-height: 30px;
    top: 8px;
    z-index: 1030;
}

.generic-list .icon-image, .related-content .icon-image {
    color: #484b84;
}

.generic-list .icon-pdf, .related-content .icon-pdf {
    color: #ac2020;
}

.generic-list .icon-powerpoint, .related-content .icon-powerpoint {
    color: #dc5b31;
}

.generic-list .icon-excel, .related-content .icon-excel {
    color: #13743d;
}

.generic-list .icon-word, .related-content .icon-word {
    color: #2974b8;
}

.generic-list .icon-content, .related-content .icon-content {
    color: #666666;
}

.generic-list .user-picture {
    float: left;
    font-size: 12px;
    width: 24px;
    height: 24px;
    line-height: 24px;
    background-size: 24px 24px;
    margin-right: 6px;
    border: none;
}

.task-content-list.simple-list li {
    float: left;
    padding: 5px 10px;
    margin-bottom: 10px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.task-content-list.simple-list li .subtle {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.task-content-list.simple-list li:hover {
    background-color: #fafafb;
}

.task-content-list.simple-list li .actions {
    padding: 5px 4px 0 4px;
    display: inline-block;
    right: 0px;
}

.task-content-list.simple-list .subtle {
    font-size: 12px;
}

.task-content-list.simple-list .nothing-to-see {
    border: 1px solid #999999;
    box-shadow: 1px 1px 2px #dddddd;
    background-color: #ffffff;
    width: 130px;
    height: 155px;
    padding: 50px 0 0 0;
    text-align: center;
}

.task-content-list.simple-list .nothing-to-see .loading {
    display: inline-block;
    position: relative;
    margin: 3px;
    left: 0;
}

.sub-task-list li.more {
    padding: 10px 15px;
    background-color: #ffffff;
    color: #666666;
}

.sub-task-list li.more i.icon {
    font-size: 70%;
}

.sub-task-list {
    list-style: none;
    padding: 0;
    margin-bottom: 0;
}

.sub-task-list li {
    position: relative;
    display: block;
    border-bottom: 1px solid #f5f5f5;
    cursor: pointer;
    padding: 2px 0px 2px 0px;
}

.sub-task-list li .badge, .generic-list li .badge{
    font-size: 12px;
    line-height: 12px;
    padding-right: 0;
    background-color: #e8edf1;
    color: $fc-accent-color;
    background-color: transparent;
    font-weight: normal;

}

.sub-task-list li.active {
    background-color: #fafafb;
}

.sub-task-list li:hover {
    background-color: #fafafb;
}

.sub-task-list li > div:hover {
    border-color: #d8dde1;
}

.sub-task-list li > div {
    margin: 0 6px 0 4px;
    border-left: 4px solid #e8edf1;
    min-height: 50px;
    padding: 5px 5px 5px 5px;
}

.sub-task-list li.active > div {
    border-left-color: #2980b9;
}

.sub-task-list li .title {
    font-size: 16px;
    margin: 0 0 0 5px;

    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.sub-task-list li .summary {
    clear: both;
    margin: 3px 5px 0px 5px;
    font-size: 13px;
    color: #1a1a1a;
    white-space: nowrap;
    width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
}

.sub-task-list li .detail {
    margin: 0 5px;
    font-size: 12px;
    color: #999999;
    white-space: nowrap;
    width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
}

.cursor-pointer{
    cursor: pointer;
}

.help-container {
    display: table;
    height: 100%;
    padding: 0 30px;
    margin: 0px auto;
}

.help-container.fixed {
    padding-top: 40px;
}

.help-container > div {
    display: table-cell;
    vertical-align: middle;
    position: relative;
}

.help-text {
    margin-top: 10px;
    color: #636363;
    background: #eee;
    padding: 20px;
    -webkit-border-radius: 10px;
    -moz-border-radius: 10px;
    border-radius: 10px;
    max-width: 450px;
    font-size: 14px;
    position: relative;
}

.help-text.wide {
    max-width: 550px;
}

.help-text .description {
    margin-bottom: 25px;
}

.help-text .description:last-child {
    margin-bottom: 0px;
}

.task-help-entry {
    margin: 5px 0 5px 10px;
    cursor: pointer;
    padding: 5px;
    display: inline-flex;
    vertical-align: middle;
    align-items: center;
}

.task-help-entry:hover, .task-help-entry.active {
    background-color: #f6f6f7;
}

.task-help-entry.active {
    padding: 10px;
}

.task-help-entry > span {
    margin-left: 3px;
}

.task-help-entry:hover > span, .task-help-entry:hover > mat-icon {
    color: $fc-accent-color;
}

.task-help-entry.active:hover > span {
    color: #636363;
}

.task-help-entry .pull-right > .btn {
    border: none;
}

.task-help-entry:hover .note {
    color: #999999;
    text-decoration: none;
}