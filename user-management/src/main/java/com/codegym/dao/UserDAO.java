package com.codegym.dao;

import com.codegym.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO implements IUserDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/demo";
    private String jdbcUsername = "root";
    private String jdbcPassword = "password"; // update accordingly

    public UserDAO() {}

    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    @Override
    public void insertUser(User user) throws SQLException {
        // Old implementation
    }

    @Override
    public User selectUser(int id) {
        // Old implementation
        return null;
    }

    @Override
    public List<User> selectAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("select * from users");) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String country = rs.getString("country");
                users.add(new User(id, name, email, country));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public boolean deleteUser(int id) throws SQLException {
        return false;
    }

    @Override
    public boolean updateUser(User user) throws SQLException {
        return false;
    }

    // Triển khai hàm gọi Stored Procedure: get_user_by_id
    @Override
    public User getUserById(int id) {
        User user = null;
        String query = "{CALL get_user_by_id(?)}";
        try (Connection connection = getConnection();
             CallableStatement callableStatement = connection.prepareCall(query)) {
            callableStatement.setInt(1, id);
            ResultSet rs = callableStatement.executeQuery();
            while (rs.next()) {
                String name = rs.getString("name");
                String email = rs.getString("email");
                String country = rs.getString("country");
                user = new User(id, name, email, country);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    // Triển khai hàm gọi Stored Procedure: insert_user
    @Override
    public void insertUserStore(User user) throws SQLException {
        String query = "{CALL insert_user(?, ?, ?)}";
        try (Connection connection = getConnection();
             CallableStatement callableStatement = connection.prepareCall(query)) {
            callableStatement.setString(1, user.getName());
            callableStatement.setString(2, user.getEmail());
            callableStatement.setString(3, user.getCountry());
            System.out.println(callableStatement);
            callableStatement.executeUpdate();
        }
    }

    // Triển khai hàm thêm User bằng Transaction
    @Override
    public void addUserTransaction(User user, int[] permissionIds) throws SQLException {
        Connection connection = null;
        PreparedStatement pstmtUser = null;
        PreparedStatement pstmtAssignment = null;
        ResultSet rs = null;

        try {
            connection = getConnection();
            // 1. Tắt auto-commit để bắt đầu một Transaction
            connection.setAutoCommit(false);
            
            // 2. Chèn dữ liệu vào bảng users và cấu hình lấy lại ID vừa tạo
            String insertUserSql = "INSERT INTO users (name, email, country) VALUES (?, ?, ?)";
            pstmtUser = connection.prepareStatement(insertUserSql, Statement.RETURN_GENERATED_KEYS);
            pstmtUser.setString(1, user.getName());
            pstmtUser.setString(2, user.getEmail());
            pstmtUser.setString(3, user.getCountry());
            pstmtUser.executeUpdate();

            // 3. Lấy ID của user vừa được chèn
            rs = pstmtUser.getGeneratedKeys();
            int userId = 0;
            if (rs.next()) {
                userId = rs.getInt(1);
            }

            // 4. Chèn dữ liệu vào bảng user_permission
            if (permissionIds != null && permissionIds.length > 0) {
                String insertPermissionSql = "INSERT INTO user_permission (user_id, permission_id) VALUES (?, ?)";
                pstmtAssignment = connection.prepareStatement(insertPermissionSql);
                for (int permissionId : permissionIds) {
                    pstmtAssignment.setInt(1, userId);
                    pstmtAssignment.setInt(2, permissionId);
                    pstmtAssignment.executeUpdate();
                }
            }
            
            // 5. Nếu mọi thứ thành công, tiến hành Commit
            connection.commit();
            System.out.println("Transaction đã được commit thành công!");

        } catch (SQLException e) {
            // 6. Nếu có lỗi xảy ra ở bất kỳ đâu, Rollback lại toàn bộ dữ liệu
            try {
                if (connection != null) {
                    connection.rollback();
                    System.out.println("Có lỗi xảy ra! Transaction đã bị rollback.");
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            // 7. Dọn dẹp tài nguyên và bật lại auto-commit
            if (rs != null) rs.close();
            if (pstmtUser != null) pstmtUser.close();
            if (pstmtAssignment != null) pstmtAssignment.close();
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
    }
}
