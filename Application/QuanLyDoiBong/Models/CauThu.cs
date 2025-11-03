namespace QuanLyDoiBong.Models
{
    /// <summary>
    /// Lớp đại diện cho Cầu thủ
    /// </summary>
    public class CauThu
    {
        public string MaCT { get; set; } = string.Empty;
        public string HoTen { get; set; } = string.Empty;
        public string MaDB { get; set; } = string.Empty;

        public CauThu() { }

        public CauThu(string maCT, string hoTen, string maDB)
        {
            MaCT = maCT;
            HoTen = hoTen;
            MaDB = maDB;
        }

        public override string ToString()
        {
            return $"{MaCT} - {HoTen}";
        }
    }
}
