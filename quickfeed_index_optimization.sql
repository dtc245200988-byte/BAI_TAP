-- Kiểm tra kích thước Data và Index của bảng Posts (Trước khi tối ưu)
SELECT 
    table_name AS `Table`, 
    round(((data_length + index_length) / 1024 / 1024), 2) AS `Total Size (MB)`, 
    round((data_length / 1024 / 1024), 2) AS `Data Size (MB)`, 
    round((index_length / 1024 / 1024), 2) AS `Index Size (MB)`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

-- Thực hiện DROP các Index vi phạm Cardinality thấp hoặc tốn dung lượng ổ đĩa
ALTER TABLE Posts DROP INDEX idx_content;
ALTER TABLE Posts DROP INDEX idx_post_type;
ALTER TABLE Posts DROP INDEX idx_is_visible;

-- Kiểm tra lại kích thước Data và Index của bảng Posts (Sau khi tối ưu)
SELECT 
    table_name AS `Table`, 
    round(((data_length + index_length) / 1024 / 1024), 2) AS `Total Size (MB)`, 
    round((data_length / 1024 / 1024), 2) AS `Data Size (MB)`, 
    round((index_length / 1024 / 1024), 2) AS `Index Size (MB)`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';
