const ctx = document.getElementById('stockChart').getContext('2d');

fetch('get_stock_data.php?symbol=TSLA')
  .then(res => res.json())
  .then(data => {
    // 显示价格与涨跌幅
    document.getElementById('price').textContent = `$${data.current.toFixed(2)}`;
    document.getElementById('change').textContent = `${data.changePercent.toFixed(2)}%`;
    document.getElementById('change').classList.add(data.changePercent >= 0 ? 'text-success' : 'text-danger');

    // 显示基本信息
    document.getElementById('marketCap').textContent = data.marketCap;
    document.getElementById('sector').textContent = data.sector;
    document.getElementById('ceo').textContent = data.ceo;
    document.getElementById('peRatio').textContent = data.peRatio;

    // 绘制图表
    new Chart(ctx, {
      type: 'line',
      data: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        datasets: [{
          label: 'TSLA',
          data: data.prices,
          fill: false,
          borderColor: 'red',
          tension: 0.4
        }]
      },
      options: {
        plugins: {
          legend: { display: false }
        },
        responsive: true
      }
    });
  });
