let allProducts = [];

async function loadProducts() {
    const message = document.getElementById("message");
    const tableHead = document.getElementById("table-head");
    const tableBody = document.getElementById("product-table");
    const productCount = document.getElementById("product-count");

    message.textContent = "Loading products...";
    tableHead.innerHTML = "";
    tableBody.innerHTML = "";

    try {
        const response = await fetch("/api/products");
        const products = await response.json();

        if (!response.ok) {
            throw new Error(products.error || "Unable to load products.");
        }

        allProducts = products;
        productCount.textContent = products.length;

        renderProducts(products);

        message.textContent =
            `${products.length} product records loaded successfully.`;

    } catch (error) {
        message.textContent = `Error: ${error.message}`;
        productCount.textContent = "—";
    }
}

function renderProducts(products) {
    const tableHead = document.getElementById("table-head");
    const tableBody = document.getElementById("product-table");

    tableHead.innerHTML = "";
    tableBody.innerHTML = "";

    if (products.length === 0) {
        tableBody.innerHTML =
            '<tr><td colspan="20">No matching products found.</td></tr>';
        return;
    }

    const columns = Object.keys(products[0]);

    tableHead.innerHTML = `
        <tr>
            ${columns.map(column =>
                `<th>${escapeHTML(column)}</th>`
            ).join("")}
            <th>Actions</th>
        </tr>
    `;

    tableBody.innerHTML = products.map(product => `
        <tr>
            ${columns.map(column => `
                <td>${escapeHTML(product[column])}</td>
            `).join("")}

            <td>
                <button type="button"
                    onclick="editProduct(${Number(product.product_id)})">
                    Edit
                </button>

                <button type="button"
                    onclick="deleteProduct(${Number(product.product_id)})">
                    Delete
                </button>
            </td>
        </tr>
    `).join("");
}

function escapeHTML(value) {
    const element = document.createElement("span");
    element.textContent = value == null ? "" : String(value);
    return element.innerHTML;
}

async function openProductForm() {
    
const form = document.getElementById("product-form");
form.reset();
delete form.dataset.editingId;
    const container = document.getElementById("product-form-container");
    const message = document.getElementById("form-message");

    container.hidden = false;
    message.textContent = "Loading categories and brands...";

    try {
        await Promise.all([
            loadCategories(),
            loadBrands()
        ]);

        message.textContent = "";

    } catch (error) {
        message.textContent = `Error: ${error.message}`;
    }
}

function closeProductForm() {
    document.getElementById("product-form-container").hidden = true;
    document.getElementById("product-form").reset();
}

document.getElementById("product-search").addEventListener("input", event => {
    const query = event.target.value.trim().toLowerCase();

    const filtered = allProducts.filter(product =>
        Object.values(product).some(value =>
            String(value ?? "").toLowerCase().includes(query)
        )
    );

    renderProducts(filtered);

    document.getElementById("message").textContent =
        `Showing ${filtered.length} of ${allProducts.length} products.`;
});

document.getElementById("product-form").addEventListener("submit", async event => {
    event.preventDefault();

    const form = event.target;
    const formMessage = document.getElementById("form-message");
    const submitButton = form.querySelector('button[type="submit"]');

    const data = Object.fromEntries(new FormData(form).entries());

    for (const field of [
        "category_id",
        "brand_id",
        "purchase_price",
        "selling_price",
        "stock_quantity",
        "reorder_level"
    ]) {
        data[field] = Number(data[field]);
    }

    submitButton.disabled = true;
    formMessage.textContent = "Saving product...";

    try {
       const editingId = form.dataset.editingId;

const response = await fetch(
    editingId
        ? `/api/products/${editingId}`
        : "/api/products",
    {
        method: editingId ? "PUT" : "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(data)
    }
);

const result = await response.json();

if (!response.ok) {
    throw new Error(result.error || "Could not save product.");
}

formMessage.textContent = result.message;

form.reset();
delete form.dataset.editingId;

await loadProducts();

document.getElementById("product-form-container").hidden = true;

    } catch (error) {
        formMessage.textContent = `Error: ${error.message}`;
    } finally {
        submitButton.disabled = false;
    }
});

document.addEventListener("DOMContentLoaded", loadProducts);

async function loadCategories() {
    const response = await fetch("/api/categories");
    const categories = await response.json();

    if (!response.ok) {
        throw new Error(categories.error || "Unable to load categories.");
    }

    const select = document.getElementById("category-select");

    select.innerHTML = '<option value="">Select Category</option>';

    categories.forEach(category => {
        const option = document.createElement("option");

        option.value = category.category_id;
        option.textContent = category.category_name;

        select.appendChild(option);
    });
}


async function loadBrands() {
    const response = await fetch("/api/brands");
    const brands = await response.json();

    if (!response.ok) {
        throw new Error(brands.error || "Unable to load brands.");
    }

    const select = document.getElementById("brand-select");

    select.innerHTML = '<option value="">Select Brand</option>';

    brands.forEach(brand => {
        const option = document.createElement("option");

        option.value = brand.brand_id;
        option.textContent = brand.brand_name;

        select.appendChild(option);
    });
}

async function editProduct(productId) {
    const product = allProducts.find(
        item => Number(item.product_id) === Number(productId)
    );

    if (!product) {
        alert("Product not found.");
        return;
    }

    const container = document.getElementById("product-form-container");
    const form = document.getElementById("product-form");
    const message = document.getElementById("form-message");

    container.hidden = false;
    message.textContent = "Loading categories and brands...";

    try {
        await Promise.all([loadCategories(), loadBrands()]);

        form.elements["product_code"].value = product.product_code;
        form.elements["product_name"].value = product.product_name;
        form.elements["category_id"].value = product.category_id;
        form.elements["brand_id"].value = product.brand_id;
        form.elements["purchase_price"].value = product.purchase_price;
        form.elements["selling_price"].value = product.selling_price;
        form.elements["stock_quantity"].value = product.stock_quantity;
        form.elements["reorder_level"].value = product.reorder_level;

        message.textContent = `Editing product ID ${productId}`;

        // Store the ID of the product being edited.
        form.dataset.editingId = productId;

        container.scrollIntoView({
            behavior: "smooth",
            block: "start"
        });

    } catch (error) {
        message.textContent = `Error: ${error.message}`;
    }
}


async function deleteProduct(productId) {
    const confirmed = confirm(
        `Are you sure you want to delete product ID ${productId}?`
    );

    if (!confirmed) return;

    try {
        const response = await fetch(`/api/products/${productId}`, {
            method: "DELETE"
        });

        const result = await response.json();

        if (!response.ok) {
            throw new Error(result.error || "Could not delete product.");
        }

        alert(result.message);
        await loadProducts();

    } catch (error) {
        alert(`Error: ${error.message}`);
    }
}

