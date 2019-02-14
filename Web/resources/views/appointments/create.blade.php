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
     <h1>Create Appointments</h1>

     {!! Form::open(['action' => 'AppointmentsController@store','method'=>'POST']) !!}
         <div class="form-group">
             {{Form::label('app_id','app_id')}}
             {{Form::text('app_id','',['class'=>'form-control','placeholder'=>'id'])}}
         </div>

         <div class="form-group">
             {{Form::label('patient_id','patient_id')}}
             {{Form::text('patient_id','',['class'=>'form-control','placeholder'=>'id'])}}
         </div>

         <div class="form-group">
             {{Form::label('app_date','app_date')}}
             {{Form::text('app_date','',['class'=>'form-control','placeholder'=>'0000-00-00'])}}
         </div>

         <div class="form-group">
             {{Form::label('app_time','app_time')}}
             {{Form::text('app_time','',['class'=>'form-control','placeholder'=>'00:00:00'])}}
         </div>

         <div class="form-group">
             {{Form::label('app_location','app_location')}}
             {{Form::textarea('app_location','',['class'=>'form-control','placeholder'=>'...'])}}
         </div>
        
         <div class="form-group">
             {{Form::label('test_instance_id','test_instance_id')}}
             {{Form::text('test_instance_id','',['class'=>'form-control','placeholder'=>'id'])}}
         </div>
         {{Form::submit('Submit',['class'=>'btn btn-primary'])}}
         <a href="/appointments" class="btn btn-primary" style="float:right;">Cancle</a>
     {!! Form::close() !!}
@endsection

@else
    <?php header("Location: /login");
    exit();?>
@endif