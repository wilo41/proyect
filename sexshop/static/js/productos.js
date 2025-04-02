// Lista de productos con detalles
const products = [
    { id: 1, name: "Vibrador Inalámbrico A", price: 100000, image: "img/default-image.jpg", details: "Este es un vibrador inalámbrico con control remoto USB. Ideal para quienes buscan comodidad y discreción.", rating: 4.3 },
    { id: 2, name: "Vibrador Inalámbrico B", price: 80000, image: "img/descarga (1).jpg", details: "Este vibrador inalámbrico cuenta con un diseño ergonómico y fácil de usar.", rating: 4.0 },
    { id: 3, name: "Vibrador Inalámbrico B", price: 60000, image: "img/descarga.jpg", details: "Este vibrador inalámbrico cuenta con un diseño ergonómico y fácil de usar.", rating: 4.0 },
    { id: 4, name: "GAto", price: 30000, image: "img/gatocomuneuropeo-97.jpg", details: "Gato iluminador de mundos.", rating: 4.0 },
    { id: 5, name: "Vibrador Inalámbrico B", price: 10000, image: "img/images (5).jpg", details: "Este vibrador inalámbrico cuenta con un diseño ergonómico y fácil de usar.", rating: 4.0 },
];

// Función para cargar los productos en el catálogo
function loadProducts() {
    const productList = document.getElementById("productList");
    productList.innerHTML = "";  // Limpiar el contenido previo

    products.forEach((product) => {
        const productCard = `
            <div class="col-md-3">
                <div class="card" data-id="${product.id}">
                    <img src="${product.image}" class="card-img-top" alt="${product.name}">
                    <div class="card-body">
                        <h5 class="card-title">${product.name}</h5>
                        <p class="card-text">Precio: $${product.price.toLocaleString()}</p>
                        <div class="rating">
                            <!-- Estrellas de producto que tú tenías antes -->
                            <input value="5" name="rate${product.id}" id="star${product.id}1" type="radio" ${product.rating >= 5 ? 'checked' : ''}>
                            <label for="star${product.id}1"></label>
                            <input value="4" name="rate${product.id}" id="star${product.id}2" type="radio" ${product.rating >= 4 ? 'checked' : ''}>
                            <label for="star${product.id}2"></label>
                            <input value="3" name="rate${product.id}" id="star${product.id}3" type="radio" ${product.rating >= 3 ? 'checked' : ''}>
                            <label for="star${product.id}3"></label>
                            <input value="2" name="rate${product.id}" id="star${product.id}4" type="radio" ${product.rating >= 2 ? 'checked' : ''}>
                            <label for="star${product.id}4"></label>
                            <input value="1" name="rate${product.id}" id="star${product.id}5" type="radio" ${product.rating >= 1 ? 'checked' : ''}>
                            <label for="star${product.id}5"></label>
                        </div>
                        <button class="btn btn-danger add-to-cart-btn" data-id="${product.id}">
                            <i class="fas fa-shopping-cart"></i> Añadir al carrito
                        </button>
                    </div>
                </div>
            </div>
        `;
        productList.insertAdjacentHTML("beforeend", productCard);  // Insertar el producto en el catálogo
    });

    // Agregar evento para abrir el modal al hacer clic en el producto, pero no en las estrellas
    const productCards = document.querySelectorAll('.card');
    productCards.forEach(card => {
        card.addEventListener('click', function (event) {
            // Prevenir la acción de clic en el botón "Añadir al carrito" o las estrellas
            if (event.target.closest('.add-to-cart-btn') || event.target.closest('.rating')) {
                return;
            }

            const productId = parseInt(card.getAttribute('data-id'));
            showProductDetails(productId);
            $('#productModal').modal('show');  // Mostrar el modal
        });
    });

    // Agregar funcionalidad al botón "Añadir al carrito" en las tarjetas
    const addToCartButtons = document.querySelectorAll(".add-to-cart-btn");
    addToCartButtons.forEach(button => {
        button.addEventListener("click", function (e) {
            e.stopPropagation(); // Prevenir que se dispare el evento click en el card
            const productId = parseInt(this.getAttribute("data-id"));
            addToCart(productId);
        });
    });
}

// Función para generar las estrellas dinámicamente según la calificación
function getStarsHTML(rating) {
    let starsHTML = '';
    for (let i = 1; i <= 5; i++) {
        if (i <= rating) {
            starsHTML += `<span class="star active" data-value="${i}">&#9733;</span>`;  // Estrella activa
        } else {
            starsHTML += `<span class="star" data-value="${i}">&#9733;</span>`;  // Estrella inactiva
        }
    }
    return starsHTML;
}

// Función para mostrar los detalles del producto en el modal
function showProductDetails(productId) {
    const product = products.find(p => p.id === productId);

    if (!product) {
        document.getElementById("productDetails").innerHTML = "<h2>Producto no encontrado.</h2>";
        return;
    }

    const ratingStars = getStarsHTML(product.rating);  // Obtener las estrellas en formato HTML

    // Mostrar los detalles del producto en el modal
    document.getElementById("productDetails").innerHTML = `
        <div class="image-container">
            <img src="${product.image}" alt="${product.name}">
        </div>
        <div class="product-details">
            <h3 class="product-title">${product.name}</h3>
            <div class="d-flex align-items-center mb-2">
                <div class="stars">${ratingStars}</div>
                <span class="ml-2 rating-text">(${product.rating})</span>
                <span class="ml-2 text-muted">(13 reviews)</span>
            </div>
            <h4 class="price">$${product.price.toLocaleString()}</h4>
            <p>${product.details}</p>
            <p class="text-success">Envío gratis a todo el país</p>
            <div class="d-flex align-items-center mb-3">
                <button class="btn btn-outline-secondary" id="decreaseQuantity">-</button>
                <input type="number" id="productQuantity" value="1" min="1" class="mx-2" style="width: 60px; text-align: center;">
                <button class="btn btn-outline-secondary" id="increaseQuantity">+</button>
            </div>
            <p>Cantidad disponible: <span id="stockQuantity">10</span></p>
        </div>
    `;

    // Estrellas interactivas en el modal
    const stars = document.querySelectorAll('.modal .star');
    const ratingText = document.querySelector('.modal .rating-text');

    stars.forEach(star => {
        star.addEventListener('click', () => {
            const rating = star.getAttribute('data-value');
            ratingText.textContent = `(${rating}.0)`; 

            stars.forEach(s => s.classList.remove('active'));
            for (let i = 0; i < rating; i++) {
                stars[i].classList.add('active');
            }
        });
    });

    // Funcionalidad para aumentar y disminuir la cantidad
    const increaseBtn = document.getElementById("increaseQuantity");
    const decreaseBtn = document.getElementById("decreaseQuantity");
    const quantityInput = document.getElementById("productQuantity");

    increaseBtn.addEventListener("click", () => {
        quantityInput.value = parseInt(quantityInput.value) + 1;
    });

    decreaseBtn.addEventListener("click", () => {
        if (quantityInput.value > 1) {
            quantityInput.value = parseInt(quantityInput.value) - 1;
        }
    });

    // Agregar el producto al carrito desde el modal
    document.getElementById('add-to-cart-modal').addEventListener('click', function() {
        addToCart(productId, quantityInput.value);  // Usamos la cantidad actualizada desde el modal
    });
}

// Función para añadir productos al carrito
function addToCart(productId, quantity = 1) {
    let cart = JSON.parse(localStorage.getItem("cart")) || [];
    const product = products.find((p) => p.id === productId);

    if (!product) {
        console.error("Producto no encontrado");
        return;
    }

    const existingProduct = cart.find(p => p.id === productId);

    if (existingProduct) {
        existingProduct.quantity += parseInt(quantity); // Si ya está en el carrito, incrementa la cantidad
    } else {
        cart.push({ ...product, quantity: parseInt(quantity) }); // Si no está, lo agrega con la cantidad proporcionada
    }

    localStorage.setItem("cart", JSON.stringify(cart)); // Guarda el carrito en localStorage
    updateCartCount(); // Actualiza el contador del carrito

    // Mostrar mensaje de agregado al carrito y cerrar el modal
    alert(`${product.name} ha sido añadido al carrito.`);
    $('#productModal').modal('hide'); // Cierra el modal

    
}

// Actualizar el contador del carrito
function updateCartCount() {
    const cart = JSON.parse(localStorage.getItem("cart")) || [];
    const count = cart.reduce((total, item) => total + item.quantity, 0);
    document.getElementById("cart-count").textContent = count; // Actualiza el número en el carrito
}

// Ejecutar cuando la página esté completamente cargada
document.addEventListener("DOMContentLoaded", () => {
    loadProducts();  // Cargar los productos en el catálogo
    updateCartCount();  // Actualizar el contador del carrito
});
