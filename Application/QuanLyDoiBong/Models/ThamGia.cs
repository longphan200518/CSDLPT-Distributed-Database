namespace QuanLyDoiBong.Models
{
    /// <summary>
    /// Lớp đại diện cho quan hệ Tham gia (Cầu thủ - Trận đấu)
    /// </summary>
    public class ThamGia
    {
        public string MaTD { get; set; } = string.Empty;
        public string MaCT { get; set; } = string.Empty;
        public int SoTrai { get; set; }

        public ThamGia() { }

        public ThamGia(string maTD, string maCT, int soTrai)
        {
            MaTD = maTD;
            MaCT = maCT;
            SoTrai = soTrai;
        }

        public override string ToString()
        {
            return $"Cầu thủ {MaCT} - Trận {MaTD}: {SoTrai} bàn";
        }
    }
}
