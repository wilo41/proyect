// Recuperar carrito del localStorage o inicializar vacío
let cart = JSON.parse(localStorage.getItem('cart')) || [];

// Mostrar productos en el carrito
function showCart() {
    const cartContainer = document.getElementById('cart-container');
    const totalAmount = document.getElementById('total-amount');
    cartContainer.innerHTML = '';
    let subtotal = 0;

    if (cart.length === 0) {
        cartContainer.innerHTML = "<p>No hay productos en el carrito.</p>";
        totalAmount.textContent = "$0.00";
        return;
    }

    cart.forEach((product, index) => {
        const productTotal = (product.price * product.quantity).toFixed(2);
        subtotal += parseFloat(productTotal);
        const cartItem = `
            <div class="cart-item">
                <img src="${product.image}" alt="${product.name}" class="product-image">
                <div class="product-details">
                    <h5>${product.name}</h5>
                    <p>${product.details}</p>
                    <h3 class="price">Precio: $${product.price}</h3>
                </div>
                <div class="product-actions">
                    <p class="subtotal">Subtotal: $${productTotal}</p>
                    <div class="quantity">
                        <button class="btn-quantity" onclick="decrementQuantity(${index})">-</button>
                        <input type="number" id="cantidad-${index}" min="1" value="${product.quantity}" 
                               onchange="updateQuantity(${index}, this.value)">
                        <button class="btn-quantity" onclick="incrementQuantity(${index})">+</button>
                    </div>
                    <button class="btn-icon" onclick="removeFromCart(${index})" title="Eliminar">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                </div>
            </div>
        `;
        cartContainer.innerHTML += cartItem;
    });

    const total = subtotal.toFixed(2);
    totalAmount.textContent = `$${total}`;
}

// Incrementar cantidad
function incrementQuantity(index) {
    cart[index].quantity += 1;
    localStorage.setItem('cart', JSON.stringify(cart));
    showCart();
}

// Decrementar cantidad
function decrementQuantity(index) {
    if (cart[index].quantity > 1) {
        cart[index].quantity -= 1;
        localStorage.setItem('cart', JSON.stringify(cart));
        showCart();
    } else {
        removeFromCart(index);
    }
}

// Actualizar cantidad de un producto
function updateQuantity(index, quantity) {
    if (quantity < 1) {
        removeFromCart(index);
        return;
    }
    cart[index].quantity = parseInt(quantity);
    localStorage.setItem('cart', JSON.stringify(cart));
    showCart();
}

// Eliminar un producto del carrito
function removeFromCart(index) {
    cart.splice(index, 1);
    localStorage.setItem('cart', JSON.stringify(cart));
    showCart();
}

// Vaciar el carrito
function clearCart() {
    cart = [];
    localStorage.setItem('cart', JSON.stringify(cart));
    showCart();
}

// Proceder al pago
function checkout() {
    if (cart.length === 0) {
        alert("Tu carrito está vacío.");
        return;
    }
    alert("Redirigiendo a la página de pago...");
}

// Inicializar la vista del carrito
document.addEventListener("DOMContentLoaded", showCart);
