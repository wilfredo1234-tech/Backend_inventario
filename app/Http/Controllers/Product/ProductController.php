<?php

namespace App\Http\Controllers\Product;



use App\Http\Controllers\Controller; 
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    // Listar productos con categoría cargada
    public function index()
    {
        $products = Product::with('category')->get();
        return response()->json($products);
    }

    // Crear producto
    public function store(Request $request)
    {
        $request->validate([
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string',
            'sku' => 'nullable|string|unique:products,sku',
            'description' => 'nullable|string',
            'price' => 'required|numeric',
            'stock' => 'required|integer',
            'status' => 'required|boolean',
        ]);

        $product = Product::create($request->all());

        return response()->json([
            'message' => 'Producto creado correctamente',
            'product' => $product
        ], 201);
    }

    // Actualizar producto
    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);

        $request->validate([
            'category_id' => 'exists:categories,id',
            'name' => 'string',
            'sku' => "string|unique:products,sku,$id",
            'description' => 'nullable|string',
            'price' => 'numeric',
            'stock' => 'integer',
            'status' => 'boolean',
        ]);

        $product->update($request->all());

        return response()->json([
            'message' => 'Producto actualizado',
            'product' => $product
        ]);
    }

    // Eliminar producto
    public function destroy($id)
    {
        $product = Product::findOrFail($id);
        $product->delete();

        return response()->json([
            'message' => 'Producto eliminado'
        ]);
    }
}
