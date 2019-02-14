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
     <h1>Appointments</h1>
     {{$appointments->links()}}
     @if(count($appointments)>0)
         @foreach($appointments as $appointment)
             <div class="jumbotron">
                 <h3><a href="/appointments/{{$appointment->app_id}}">Appointment ID : {{$appointment->app_id}}</h3>
             </div>
         @endforeach   
     @else
         <p>No Appointments Found</p>
     @endif
     <a href="/appointments/create" class="btn btn-primary">Add Appointments</a>
@endsection

@else
    <?php header("Location: /login");
    exit();?>
@endif