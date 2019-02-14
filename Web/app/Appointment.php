<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Appointment extends Model
{ 
    protected $table="appointments";
    public $timestamps = false;
    public $primaryKey="app_id";
}
