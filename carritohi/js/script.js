

document.addEventListener('DOMContentLoaded', () => {
    const quantityButtons = document.querySelectorAll('.quantity-btn');
    
    quantityButtons.forEach(button => {
        button.addEventListener('click', (event) => {
            const action = event.target.getAttribute('data-action');
            const quantityInput = event.target.parentElement.querySelector('.item-quantity');
            let currentQuantity = parseInt(quantityInput.value);
            
            if (action === 'increase') {
                quantityInput.value = currentQuantity + 1;
            } else if (action === 'decrease') {
                if (currentQuantity > 1) {
                    quantityInput.value = currentQuantity - 1;
                }
            }
            
            
        });
    });
});
