using System.Data;
using System.Data.SqlClient;

namespace QuanLyDoiBong.DataAccess
{
    /// <summary>
    /// Lớp xử lý các truy vấn đặc biệt
    /// </summary>
    public class QueryDAO
    {
        /// <summary>
        /// Query 1: Lấy danh sách cầu thủ theo câu lạc bộ
        /// </summary>
        public DataTable GetCauThuTheoCLB(string clb)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "EXEC sp_GetCauThuTheoCLB @CLB";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@CLB", clb);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);
            }
            return dt;
        }

        /// <summary>
        /// Query 2: Lấy số trận cầu thủ đã tham gia
        /// </summary>
        public DataTable GetSoTranThamGia(string hoTen)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "EXEC sp_GetSoTranThamGia @HoTen";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@HoTen", hoTen);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);
            }
            return dt;
        }

        /// <summary>
        /// Query 3: Đếm số trận hòa tại một sân đấu
        /// </summary>
        public DataTable GetSoTranHoaTaiSan(string sanDau)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "EXEC sp_GetSoTranHoaTaiSan @SanDau";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SanDau", sanDau);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);
            }
            return dt;
        }

        /// <summary>
        /// Query bổ sung: Lấy kết quả trận đấu
        /// </summary>
        public DataTable GetKetQuaTranDau(string maTD)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "EXEC sp_GetKetQuaTranDau @MaTD";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MaTD", maTD);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);
            }
            return dt;
        }

        /// <summary>
        /// Query bổ sung: Top cầu thủ ghi bàn
        /// </summary>
        public DataTable GetTopGhiBan(int top = 10)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "EXEC sp_GetTopGhiBan @Top";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Top", top);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);
            }
            return dt;
        }
    }
}
