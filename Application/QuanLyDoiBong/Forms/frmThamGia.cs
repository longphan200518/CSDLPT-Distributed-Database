// Form tương tự frmDoiBong nhưng cho ThamGia
using QuanLyDoiBong.DataAccess;
using QuanLyDoiBong.Models;

namespace QuanLyDoiBong.Forms
{
    public partial class frmThamGia : Form
    {
        private ThamGiaDAO dao = new ThamGiaDAO();

        public frmThamGia()
        {
            InitializeComponent();
            this.Text = "Quản Lý Tham Gia";
            this.Size = new Size(900, 600);
            this.StartPosition = FormStartPosition.CenterScreen;
            MessageBox.Show("Form này tương tự frmDoiBong.\nVui lòng xem code mẫu trong frmDoiBong.cs", "Thông báo");
        }

        private void InitializeComponent() { }
    }
}
