using System.Data;
using System.Data.SqlClient;
using QuanLyDoiBong.Models;

namespace QuanLyDoiBong.DataAccess
{
    /// <summary>
    /// Lớp xử lý các thao tác CRUD cho bảng TranDau
    /// </summary>
    public class TranDauDAO
    {
        /// <summary>
        /// Lấy tất cả trận đấu
        /// </summary>
        public List<TranDau> GetAll()
        {
            List<TranDau> list = new List<TranDau>();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "SELECT MaTD, MaDB1, MaDB2, TrongTai, SanDau FROM vw_TranDau ORDER BY MaTD";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    TranDau td = new TranDau
                    {
                        MaTD = reader["MaTD"].ToString() ?? string.Empty,
                        MaDB1 = reader["MaDB1"].ToString() ?? string.Empty,
                        MaDB2 = reader["MaDB2"].ToString() ?? string.Empty,
                        TrongTai = reader["TrongTai"].ToString() ?? string.Empty,
                        SanDau = reader["SanDau"].ToString() ?? string.Empty
                    };
                    list.Add(td);
                }
            }
            return list;
        }

        /// <summary>
        /// Lấy trận đấu theo mã
        /// </summary>
        public TranDau? GetByMa(string maTD)
        {
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "SELECT MaTD, MaDB1, MaDB2, TrongTai, SanDau FROM vw_TranDau WHERE MaTD = @MaTD";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MaTD", maTD);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    return new TranDau
                    {
                        MaTD = reader["MaTD"].ToString() ?? string.Empty,
                        MaDB1 = reader["MaDB1"].ToString() ?? string.Empty,
                        MaDB2 = reader["MaDB2"].ToString() ?? string.Empty,
                        TrongTai = reader["TrongTai"].ToString() ?? string.Empty,
                        SanDau = reader["SanDau"].ToString() ?? string.Empty
                    };
                }
            }
            return null;
        }

        /// <summary>
        /// Thêm trận đấu mới
        /// </summary>
        public bool Insert(TranDau td)
        {
            try
            {
                using (SqlConnection conn = DatabaseConnection.GetConnection())
                {
                    string query = "INSERT INTO vw_TranDau (MaTD, MaDB1, MaDB2, TrongTai, SanDau) " +
                                   "VALUES (@MaTD, @MaDB1, @MaDB2, @TrongTai, @SanDau)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaTD", td.MaTD);
                    cmd.Parameters.AddWithValue("@MaDB1", td.MaDB1);
                    cmd.Parameters.AddWithValue("@MaDB2", td.MaDB2);
                    cmd.Parameters.AddWithValue("@TrongTai", td.TrongTai);
                    cmd.Parameters.AddWithValue("@SanDau", td.SanDau);
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
        /// Cập nhật trận đấu
        /// </summary>
        public bool Update(TranDau td)
        {
            try
            {
                using (SqlConnection conn = DatabaseConnection.GetConnection())
                {
                    string query = "UPDATE vw_TranDau SET MaDB1 = @MaDB1, MaDB2 = @MaDB2, " +
                                   "TrongTai = @TrongTai, SanDau = @SanDau WHERE MaTD = @MaTD";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaTD", td.MaTD);
                    cmd.Parameters.AddWithValue("@MaDB1", td.MaDB1);
                    cmd.Parameters.AddWithValue("@MaDB2", td.MaDB2);
                    cmd.Parameters.AddWithValue("@TrongTai", td.TrongTai);
                    cmd.Parameters.AddWithValue("@SanDau", td.SanDau);
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
        /// Xóa trận đấu
        /// </summary>
        public bool Delete(string maTD)
        {
            try
            {
                using (SqlConnection conn = DatabaseConnection.GetConnection())
                {
                    string query = "DELETE FROM vw_TranDau WHERE MaTD = @MaTD";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaTD", maTD);
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
        /// Lấy danh sách sân đấu (distinct)
        /// </summary>
        public List<string> GetAllSanDau()
        {
            List<string> list = new List<string>();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "SELECT DISTINCT SanDau FROM vw_TranDau ORDER BY SanDau";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    list.Add(reader["SanDau"].ToString() ?? string.Empty);
                }
            }
            return list;
        }
    }
}
