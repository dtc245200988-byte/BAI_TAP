<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>User Management Application</title>
</head>
<body>
<center>
    <h1>User Management</h1>
    <h2>
        <a href="users">List All Users</a>
    </h2>
</center>
<div align="center">
    <form action="users?action=create" method="post">
        <table border="1" cellpadding="5">
            <caption>
                <h2>Add New User</h2>
            </caption>
            <tr>
                <th>User Name: </th>
                <td>
                    <input type="text" name="name" id="name" size="45" required/>
                </td>
            </tr>
            <tr>
                <th>User Email: </th>
                <td>
                    <input type="text" name="email" id="email" size="45" required/>
                </td>
            </tr>
            <tr>
                <th>User Country: </th>
                <td>
                    <input type="text" name="country" id="country" size="15" required/>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div class="form-group" style="padding: 10px;">
                        <label style="font-weight: bold;">Quyền hạn (Permissions):</label>
                        <div style="display: flex; gap: 15px; margin-top: 5px;">
                            <label><input type="checkbox" name="permissions" value="1"> Thêm (Add)</label>
                            <label><input type="checkbox" name="permissions" value="2"> Sửa (Edit)</label>
                            <label><input type="checkbox" name="permissions" value="3"> Xoá (Delete)</label>
                            <label><input type="checkbox" name="permissions" value="4"> Xem (View)</label>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="submit" value="Lưu thông tin" />
                </td>
            </tr>
        </table>
    </form>
</div>
</body>
</html>
