<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

// Add here all GET request routes
Route::get('/', 'PagesController@index');

// Add here all resource routes
Route::resource('staff', 'StaffsController');