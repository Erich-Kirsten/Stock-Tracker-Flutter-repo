<?php
header('Content-Type: application/json');

// 模拟返回（你也可以改为用 Finnhub API）
echo json_encode([
  'symbol' => 'TSLA',
  'current' => 201.00,
  'changePercent' => -0.28,
  'marketCap' => '$800B',
  'sector' => 'Automotive / Tech',
  'ceo' => 'Elon Musk',
  'peRatio' => 48.23,
  'prices' => [190, 192, 188, 193, 197, 200, 201]
]);
