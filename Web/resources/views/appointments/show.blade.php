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
    <a href="/appointments" class="btn btn-primary">Go Back</a>
    <br>
    <br>
    <table class="table table-bordered">
         <tr>
             <th>Appointment_ID</th>
             <th>Patient_ID</th>
             <th>Appointment_DATE</th>
             <th>Appointment_TIME</th>
             <th>Appointment_LOCATION</th>
             <th>TEST_INSTANCE_ID</th>
         </tr>

         <tr>
             <td>{{$appointment->app_id}}</td>
             <td>{{$appointment->patient_id}}</td>
             <td>{{$appointment->app_date}}</td>
             <td>{{$appointment->app_time}}</td>
             <td>{!!$appointment->app_location!!}</td>
             <td>{{$appointment->test_instance_id}}</td>
          </tr>
          
    </table>
     <hr>
     <a href="/appointments/{{$appointment->app_id}}/edit" class="btn btn-primary">Edit</a>
     
     {!!Form::open(['action' => ['AppointmentsController@destroy',$appointment->app_id],'method'=>'POST','class'=> 'float-right'])!!}
        {{Form::hidden('_method','DELETE')}}
        {{Form::submit('Delete',['class'=>'btn btn-danger'])}}
     {!!Form::close()!!}

     @endsection

@else
    <?php header("Location: /login");
    exit();?>
@endif