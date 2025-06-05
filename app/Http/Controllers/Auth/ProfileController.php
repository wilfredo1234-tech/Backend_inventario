<?php


namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function profile(Request $request)
    {
        return response()->json([
            'message' => 'Datos del perfil',
            'user' => $request->user()
        ]);
    }
}
