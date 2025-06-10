<?php

namespace App\Exceptions;

use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Illuminate\Auth\AuthenticationException;
use Throwable;

class Handler extends ExceptionHandler
{
  

    public function register()
    {
        
    }

    protected function unauthenticated($request, AuthenticationException $exception)
    {
        
        if ($request->expectsJson()) {
            return response()->json(['message' => 'No autenticado.'], 401);
        }

        
        abort(401, 'No autenticado.');
    }
}
