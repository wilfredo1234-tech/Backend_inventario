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

    public function update(Request $request)
{
    $user = $request->user();

    $validated = $request->validate([
        'name' => 'string|max:255',
        'email' => 'email|unique:users,email,' . $user->id,
        'password' => 'nullable|min:6|confirmed',
    ]);

    if (isset($validated['password'])) {
        $validated['password'] = bcrypt($validated['password']);
    } else {
        unset($validated['password']);
    }

    $user->update($validated);

    return response()->json([
        'message' => 'Perfil actualizado con éxito',
        'user' => $user
    ]);
}

}
