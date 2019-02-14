<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Appointment;
use DB;

class AppointmentsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    { 
        $appointments = Appointment::orderBy('app_id','desc')->paginate(2);
        return view('appointments.index')->with('appointments',$appointments);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('appointments.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $this->validate($request,[
            'app_id' => 'required',
            'patient_id' => 'required',
            'app_date' => 'required',
            'app_time' => 'required',
            'app_location' => 'required',
            'test_instance_id' => 'required'
        ]);
        
        //Create Appointment
        $appointment = new Appointment;
        $appointment->app_id=$request->input('app_id');
        $appointment->patient_id=$request->input('patient_id');
        $appointment->app_date=$request->input('app_date');
        $appointment->app_time=$request->input('app_time');
        $appointment->app_location=$request->input('app_location');
        $appointment->test_instance_id=$request->input('test_instance_id');
        $appointment->save();


        return redirect('/appointments')->with('success','Appointment Created');

    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {   $appointment=Appointment::find($id);
        return view('appointments.show')->with('appointment',$appointment);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $appointment=Appointment::find($id);
        return view('appointments.edit')->with('appointment',$appointment);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $this->validate($request,[
            'app_id' => 'required',
            'patient_id' => 'required',
            'app_date' => 'required',
            'app_time' => 'required',
            'app_location' => 'required',
            'test_instance_id' => 'required'
        ]);
        
        //Create Appointment
        $appointment =  Appointment::find($id);
        $appointment->app_id=$request->input('app_id');
        $appointment->patient_id=$request->input('patient_id');
        $appointment->app_date=$request->input('app_date');
        $appointment->app_time=$request->input('app_time');
        $appointment->app_location=$request->input('app_location');
        $appointment->test_instance_id=$request->input('test_instance_id');
        $appointment->save();


        return redirect('/appointments')->with('success','Appointment Updated');

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $appointment = Appointment::find($id);
        $appointment->delete();
        return redirect('/appointments')->with('success','Appointment Removed');
    }
}
