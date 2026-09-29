-- 1. Xóa bỏ Fat Index cũ gây tắc nghẽn quá trình GHI (INSERT)
ALTER TABLE SensorLogs DROP INDEX idx_fat_covering;

-- 2. Tạo Lean Index mới tinh gọn (Chỉ chứa cột dùng trong mệnh đề WHERE)
CREATE INDEX idx_lean_search ON SensorLogs(sensor_id, recorded_at);

-- 3. Chạy lệnh EXPLAIN để kiểm tra 
-- (Kết quả mong đợi: type = range hoặc ref, Extra KHÔNG còn chữ "Using index" - vì hệ thống sẽ Lookup table)
EXPLAIN SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20';
