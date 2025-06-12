<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class RegisterRequest extends FormRequest
{

     
    public function authorize(): bool
    {
        return true;
    }

    
     
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:100', 'regex:/^[a-zA-Z\s]+$/'],
            'email' => ['required', 'email', 'unique:users,email'],
            'password' => [
                'required',
                'string',
                'min:6',
                'confirmed',
                'regex:/[A-Z]/',      
                'regex:/[a-z]/',       
                'regex:/[0-9]/',       
                'regex:/[@$!%*?&]/'    
            ],
            'password_confirmation' => ['required']
        ];
    }

    
    public function messages(): array
    {
        return [
            'name.required' => 'El nombre es obligatorio.',
            'name.regex' => 'El nombre solo puede contener letras y espacios.',
            'email.required' => 'El correo es obligatorio.',
            'email.email' => 'El correo no es válido.',
            'email.unique' => 'Este correo ya está registrado.',
            'password.required' => 'La contraseña es obligatoria.',
            'password.min' => 'La contraseña debe tener al menos 6 caracteres.',
            'password.confirmed' => 'La confirmación de contraseña no coincide.',
            'password.regex' => 'La contraseña debe tener al menos una mayúscula, una minúscula, un número y un carácter especial.',
            'password_confirmation.required' => 'Debes confirmar la contraseña.'
        ];
    }
}
