<?php

namespace App\Http\Controllers\Category;


use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    // Listar todas las categorías
    public function index()
    {
        $categories = Category::all();
        return response()->json($categories);
    }

    // Crear categoría
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|unique:categories,name',
            'slug' => 'required|string|unique:categories,slug',
            'description' => 'nullable|string',
        ]);

        $category = Category::create($request->all());

        return response()->json([
            'message' => 'Categoría creada correctamente',
            'category' => $category
        ], 201);
    }

    // Actualizar categoría
    public function update(Request $request, $id)
    {
        $category = Category::findOrFail($id);

        $request->validate([
            'name' => "string|unique:categories,name,$id",
            'slug' => "string|unique:categories,slug,$id",
            'description' => 'nullable|string',
        ]);

        $category->update($request->all());

        return response()->json([
            'message' => 'Categoría actualizada',
            'category' => $category
        ]);
    }

    // Eliminar categoría
    public function destroy($id)
    {
        $category = Category::findOrFail($id);
        $category->delete();

        return response()->json([
            'message' => 'Categoría eliminada'
        ]);
    }
}
