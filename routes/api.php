<?php

use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\ProfileController;
use App\Http\Controllers\Auth\LogoutController;
use App\Http\Controllers\Category\CategoryController;
use App\Http\Controllers\Product\ProductController;

use Illuminate\Support\Facades\Route;

Route::get('/ping', function () {
    return response()->json(['message' => 'pong']);
});
Route::get('/test', function() {
    return response()->json(['message' => 'test ok']);
});

Route::post('/register', [RegisterController::class, 'register']);
Route::post('/login', [LoginController::class, 'login']);
Route::middleware('auth:sanctum')->get('/profile', [ProfileController::class, 'profile']);
Route::middleware('auth:sanctum')->put('/profile', [ProfileController::class, 'update']);

Route::middleware('auth:sanctum')->group(function () {
    // Logout
    Route::post('/logout', [LogoutController::class, 'logout']);

    // Categorías
    Route::get('/categories', [CategoryController::class, 'index']);
    Route::post('/categories', [CategoryController::class, 'store']);
    Route::put('/categories/{id}', [CategoryController::class, 'update']);
    Route::delete('/categories/{id}', [CategoryController::class, 'destroy']);

    // Productos
    Route::get('/products', [ProductController::class, 'index']);
    Route::post('/products', [ProductController::class, 'store']);
    Route::put('/products/{id}', [ProductController::class, 'update']);
    Route::delete('/products/{id}', [ProductController::class, 'destroy']);
});
