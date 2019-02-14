@extends('layouts.app')

@if(!Auth::guest())
    @section('content')
    <div class="card-body">
        @if (session('status'))
            <div class="alert alert-success" role="alert">
                {{ session('status') }}
            </div>
        @endif

@section('content')
    <br>
     <h1>Edit Appointments</h1>

     {!! Form::open(['action' => ['AppointmentsController@update',$appointment->app_id],'method'=>'Post']) !!}
         <div class="form-group">
             {{Form::label('app_id','app_id')}}
             {{Form::text('app_id',$appointment->app_id,['class'=>'form-control','placeholder'=>'id'])}}
         </div>

         <div class="form-group">
             {{Form::label('patient_id','patient_id')}}
             {{Form::text('patient_id',$appointment->patient_id,['class'=>'form-control','placeholder'=>'id'])}}
         </div>

         <div class="form-group">
             {{Form::label('app_date','app_date')}}
             {{Form::text('app_date',$appointment->app_date,['class'=>'form-control','placeholder'=>'0000-00-00'])}}
         </div>

         <div class="form-group">
             {{Form::label('app_time','app_time')}}
             {{Form::text('app_time',$appointment->app_time,['class'=>'form-control','placeholder'=>'00:00:00'])}}
         </div>

         <div class="form-group">
             {{Form::label('app_location','app_location')}}
             {{Form::textarea('app_location',$appointment->app_location,['class'=>'form-control','placeholder'=>'...'])}}
         </div>
        
         <div class="form-group">
             {{Form::label('test_instance_id','test_instance_id')}}
             {{Form::text('test_instance_id',$appointment->test_instance_id,['class'=>'form-control','placeholder'=>'id'])}}
         </div>
         {{Form::hidden('_method','PUT')}}
         {{Form::submit('Submit',['class'=>'btn btn-primary'])}}
         <a href="/appointments" class="btn btn-primary" style="float:right;">Cancle</a>
     {!! Form::close() !!}
@endsection

@else
    <?php header("Location: /login");
    exit();?>
@endif