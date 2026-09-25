const API_URL = "http://127.0.0.1:8000";

// ១. ទាញយក និងបង្ហាញបញ្ជីផលិតផល
async function fetchProducts() {
    try {
        const response = await fetch(`${API_URL}/products/`);
        const products = await response.json();
        const tbody = document.getElementById("productTableBody");
        tbody.innerHTML = "";

        if (products.length === 0) {
            tbody.innerHTML = `<tr><td colspan="5" class="text-center">No products found.</td></tr>`;
            return;
        }

        products.forEach(product => {
            tbody.innerHTML += `
                <tr>
                    <td>#${product.id}</td>
                    <td><strong>${product.title}</strong></td>
                    <td style="color: #16a34a; font-weight: 600;">$${product.price.toFixed(2)}</td>
                    <td><span class="category-badge">${product.category}</span></td>
                    <td style="text-align: center;">
                        <button class="btn-delete" onclick="deleteProduct(${product.id})">Delete</button>
                    </td>
                </tr>
            `;
        });
    } catch (error) {
        console.error("Error fetching products:", error);
    }
}

// ២. បន្ថែមផលិតផលថ្មី
document.getElementById("productForm").addEventListener("submit", async function(e) {
    e.preventDefault();
    
    const newProduct = {
        title: document.getElementById("title").value,
        price: parseFloat(document.getElementById("price").value),
        category: document.getElementById("category").value,
        image_url: document.getElementById("image_url").value || null,
        description: document.getElementById("description").value || null
    };

    try {
        const response = await fetch(`${API_URL}/products/`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(newProduct)
        });

        if (response.ok) {
            alert("Product added successfully!");
            document.getElementById("productForm").reset();
            fetchProducts();
        } else {
            alert("Failed to add product.");
        }
    } catch (error) {
        console.error("Error adding product:", error);
    }
});

// ៣. លុបផលិតផល
async function deleteProduct(id) {
    if (!confirm("Are you sure you want to delete this product?")) return;

    try {
        const response = await fetch(`${API_URL}/products/${id}`, {
            method: "DELETE"
        });
        if (response.ok) {
            alert("Product deleted successfully!");
            fetchProducts();
        } else {
            alert("Failed to delete product.");
        }
    } catch (error) {
        console.error("Error deleting product:", error);
    }
}

// រត់យកទិន្នន័យពេលទំព័រ Load ចប់
fetchProducts();