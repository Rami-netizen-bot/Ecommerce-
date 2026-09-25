const API_URL = "http://127.0.0.1:8000";

let priceChartInstance = null;

async function loadDashboardData() {
    try {
        const response = await fetch(`${API_URL}/products/`);
        const products = await response.json();

        if (!Array.isArray(products) || products.length === 0) {
            document.getElementById("statTotalProducts").textContent = "0";
            document.getElementById("statInventoryValue").textContent = "$0.00";
            document.getElementById("statCategories").textContent = "0";
            document.getElementById("statAvgPrice").textContent = "$0.00";
            document.getElementById("recentProductsBody").innerHTML = `<tr><td colspan="4" class="text-center">No products found.</td></tr>`;
            document.getElementById("catList").innerHTML = `<p class="text-center">No categories available.</p>`;
            return;
        }

        // ១. គណនា Stat Cards
        const totalProducts = products.length;
        const totalInventoryValue = products.reduce((sum, p) => sum + (p.price || 0), 0);
        
        // រកចំនួន Category មិនស្ទួនគ្នា
        const categories = [...new Set(products.map(p => p.category || "Uncategorized"))];
        const totalCategories = categories.length;
        
        const avgPrice = totalInventoryValue / totalProducts;

        // បង្ហាញតម្លៃនៅលើ Stat Cards
        document.getElementById("statTotalProducts").textContent = totalProducts;
        document.getElementById("statInventoryValue").textContent = "$" + totalInventoryValue.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        document.getElementById("statCategories").textContent = totalCategories;
        document.getElementById("statAvgPrice").textContent = "$" + avgPrice.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });

        // ២. បង្ហាញ Recent Products ក្នុងតារាង (បង្ហាញ ៥ ចុងក្រោយ)
        const recentBody = document.getElementById("recentProductsBody");
        recentBody.innerHTML = "";
        products.slice(0, 5).forEach(p => {
            recentBody.innerHTML += `
                <tr>
                    <td>#${p.id}</td>
                    <td><strong>${p.title}</strong></td>
                    <td style="color: #16a34a; font-weight: 600;">$${p.price.toFixed(2)}</td>
                    <td><span class="category-badge">${p.category}</span></td>
                </tr>
            `;
        });

        // ៣. រៀបចំទិន្នន័យសម្រាប់ Category Breakdown និង Chart.js
        renderCategoryBreakdown(products, categories);

    } catch (error) {
        console.error("Error fetching dashboard data:", error);
    }
}

function renderCategoryBreakdown(products, categories) {
    const catData = {};
    categories.forEach(cat => {
        const catProducts = products.filter(p => (p.category || "Uncategorized") === cat);
        const avgCatPrice = catProducts.reduce((sum, p) => sum + p.price, 0) / catProducts.length;
        catData[cat] = {
            count: catProducts.length,
            avgPrice: avgCatPrice
        };
    });

    // បង្ហាញបញ្ជី Category Breakdown ខាងស្តាំ
    const catListEl = document.getElementById("catList");
    catListEl.innerHTML = "";
    
    const colors = ["#2563eb", "#10b981", "#8b5cf6", "#f59e0b", "#ef4444", "#06b6d4"];
    
    let index = 0;
    for (const [cat, data] of Object.entries(catData)) {
        const percentage = Math.round((data.count / products.length) * 100);
        const color = colors[index % colors.length];

        catListEl.innerHTML += `
            <div>
                <div class="cat-row-top">
                    <div class="cat-dot" style="background: ${color};"></div>
                    <div class="cat-name">${cat}</div>
                    <div class="cat-pct">${percentage}% (${data.count})</div>
                </div>
                <div class="cat-bar-bg">
                    <div class="cat-bar-fill" style="width: ${percentage}%; background: ${color};"></div>
                </div>
            </div>
        `;
        index++;
    }

    // ៤. បង្កើត Chart (Price Distribution by Category) ប្រើ Chart.js
    const ctx = document.getElementById("priceChart").getContext("2d");
    if (priceChartInstance) {
        priceChartInstance.destroy();
    }

    priceChartInstance = new Chart(ctx, {
        type: "bar",
        data: {
            labels: Object.keys(catData),
            datasets: [{
                label: "Avg Price ($)",
                data: Object.values(catData).map(d => d.avgPrice.toFixed(2)),
                backgroundColor: colors.slice(0, categories.length),
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: { 
                    beginAtZero: true, 
                    grid: { color: "#f1f5f9" },
                    ticks: { callback: v => "$" + v, color: "#64748b", font: { size: 11 } } 
                },
                x: { 
                    grid: { display: false },
                    ticks: { color: "#64748b", font: { size: 11 } } 
                }
            }
        }
    });
}

// រត់ដំណើរការមុខងារទាញទិន្នន័យពេល Load ទំព័រចប់
loadDashboardData();