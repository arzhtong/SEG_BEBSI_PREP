<?php

namespace App\Http\Controllers;

use Google\Cloud\Firestore\FirestoreClient;
use Illuminate\Http\Request;

class FirebaseController extends Controller
{
    /**
     * Initialize Cloud Firestore with default project ID.
     * ```
     * initialize();
     * ```
     */
    function initialize()
    {
        putenv('GOOGLE_APPLICATION_CREDENTIALS=../service_account.json');
        // Create the Cloud Firestore client
        $db = new FirestoreClient();
      
        printf('DB initialized!' . PHP_EOL);
    }
}
