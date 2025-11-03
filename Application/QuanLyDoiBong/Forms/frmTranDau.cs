// Form tương tự frmDoiBong nhưng cho TranDau
using QuanLyDoiBong.DataAccess;
using QuanLyDoiBong.Models;

namespace QuanLyDoiBong.Forms
{
    public partial class frmTranDau : Form
    {
        private TranDauDAO dao = new TranDauDAO();
        private DoiBongDAO doiBongDAO = new DoiBongDAO();

        public frmTranDau()
        {
            InitializeComponent();
            this.Text = "Quản Lý Trận Đấu";
            this.Size = new Size(900, 600);
            this.StartPosition = FormStartPosition.CenterScreen;
            MessageBox.Show("Form này tương tự frmDoiBong.\nVui lòng xem code mẫu trong frmDoiBong.cs", "Thông báo");
        }

        private void InitializeComponent() { }
    }
}
