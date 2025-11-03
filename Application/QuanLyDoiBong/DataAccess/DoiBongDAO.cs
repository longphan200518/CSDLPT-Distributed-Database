using System.Data;
using System.Data.SqlClient;
using QuanLyDoiBong.Models;

namespace QuanLyDoiBong.DataAccess
{
    /// <summary>
    /// Lớp xử lý các thao tác CRUD cho bảng DoiBong
    /// </summary>
    public class DoiBongDAO
    {
        /// <summary>
        /// Lấy tất cả đội bóng
        /// </summary>
        public List<DoiBong> GetAll()
        {
            List<DoiBong> list = new List<DoiBong>();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "SELECT MaDB, TenDB, CLB FROM vw_DoiBong ORDER BY MaDB";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    DoiBong db = new DoiBong
                    {
                        MaDB = reader["MaDB"].ToString() ?? string.Empty,
                        TenDB = reader["TenDB"].ToString() ?? string.Empty,
                        CLB = reader["CLB"].ToString() ?? string.Empty
                    };
                    list.Add(db);
                }
            }
            return list;
        }

        /// <summary>
        /// Lấy đội bóng theo mã
        /// </summary>
        public DoiBong? GetByMa(string maDB)
        {
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "SELECT MaDB, TenDB, CLB FROM vw_DoiBong WHERE MaDB = @MaDB";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MaDB", maDB);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    return new DoiBong
                    {
                        MaDB = reader["MaDB"].ToString() ?? string.Empty,
                        TenDB = reader["TenDB"].ToString() ?? string.Empty,
                        CLB = reader["CLB"].ToString() ?? string.Empty
                    };
                }
            }
            return null;
        }

        /// <summary>
        /// Thêm đội bóng mới
        /// </summary>
        public bool Insert(DoiBong db)
        {
            try
            {
                using (SqlConnection conn = DatabaseConnection.GetConnection())
                {
                    string query = "INSERT INTO vw_DoiBong (MaDB, TenDB, CLB) VALUES (@MaDB, @TenDB, @CLB)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaDB", db.MaDB);
                    cmd.Parameters.AddWithValue("@TenDB", db.TenDB);
                    cmd.Parameters.AddWithValue("@CLB", db.CLB);
                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();
                    return rows > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Cập nhật đội bóng
        /// </summary>
        public bool Update(DoiBong db)
        {
            try
            {
                using (SqlConnection conn = DatabaseConnection.GetConnection())
                {
                    string query = "UPDATE vw_DoiBong SET TenDB = @TenDB, CLB = @CLB WHERE MaDB = @MaDB";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaDB", db.MaDB);
                    cmd.Parameters.AddWithValue("@TenDB", db.TenDB);
                    cmd.Parameters.AddWithValue("@CLB", db.CLB);
                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();
                    return rows > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Xóa đội bóng
        /// </summary>
        public bool Delete(string maDB)
        {
            try
            {
                using (SqlConnection conn = DatabaseConnection.GetConnection())
                {
                    string query = "DELETE FROM vw_DoiBong WHERE MaDB = @MaDB";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaDB", maDB);
                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();
                    return rows > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Lấy danh sách CLB (distinct)
        /// </summary>
        public List<string> GetAllCLB()
        {
            List<string> list = new List<string>();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "SELECT DISTINCT CLB FROM vw_DoiBong ORDER BY CLB";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    list.Add(reader["CLB"].ToString() ?? string.Empty);
                }
            }
            return list;
        }
    }
}
