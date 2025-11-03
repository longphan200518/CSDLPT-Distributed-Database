using QuanLyDoiBong.Forms;
using QuanLyDoiBong.DataAccess;

namespace QuanLyDoiBong;

public partial class Form1 : Form
{
    public Form1()
    {
        InitializeComponent();
        this.Text = "Hệ Thống Quản Lý Đội Bóng - CSDL Phân Tán";
        this.Size = new Size(1000, 700);
        this.StartPosition = FormStartPosition.CenterScreen;
        InitializeMenu();
        CheckDatabaseConnection();
    }

    private void InitializeMenu()
    {
        MenuStrip menuStrip = new MenuStrip();

        // Menu Quản lý
        ToolStripMenuItem menuQuanLy = new ToolStripMenuItem("&Quản Lý");
        menuQuanLy.DropDownItems.Add("Đội Bóng", null, (s, e) => OpenForm(new frmDoiBong()));
        menuQuanLy.DropDownItems.Add("Cầu Thủ", null, (s, e) => OpenForm(new frmCauThu()));
        menuQuanLy.DropDownItems.Add("Trận Đấu", null, (s, e) => OpenForm(new frmTranDau()));
        menuQuanLy.DropDownItems.Add("Tham Gia", null, (s, e) => OpenForm(new frmThamGia()));

        // Menu Truy vấn
        ToolStripMenuItem menuTruyVan = new ToolStripMenuItem("&Truy Vấn");
        menuTruyVan.DropDownItems.Add("Cầu thủ theo CLB", null, (s, e) => OpenForm(new frmQuery1()));
        menuTruyVan.DropDownItems.Add("Số trận tham gia", null, (s, e) => OpenForm(new frmQuery2()));
        menuTruyVan.DropDownItems.Add("Số trận hòa", null, (s, e) => OpenForm(new frmQuery3()));

        // Menu Hệ thống
        ToolStripMenuItem menuHeThong = new ToolStripMenuItem("&Hệ Thống");
        menuHeThong.DropDownItems.Add("Kiểm tra kết nối", null, (s, e) => CheckDatabaseConnection());
        menuHeThong.DropDownItems.Add(new ToolStripSeparator());
        menuHeThong.DropDownItems.Add("Thoát", null, (s, e) => Application.Exit());

        menuStrip.Items.Add(menuQuanLy);
        menuStrip.Items.Add(menuTruyVan);
        menuStrip.Items.Add(menuHeThong);

        this.MainMenuStrip = menuStrip;
        this.Controls.Add(menuStrip);
    }

    private void OpenForm(Form form)
    {
        form.ShowDialog();
    }

    private void CheckDatabaseConnection()
    {
        if (DatabaseConnection.TestConnection())
        {
            MessageBox.Show("Kết nối database thành công!", "Thông báo", 
                MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        else
        {
            MessageBox.Show("Không thể kết nối database!\nVui lòng kiểm tra:\n" +
                "1. SQL Server đã được khởi động\n" +
                "2. Database GlobalDB đã được tạo\n" +
                "3. Connection string trong DatabaseConnection.cs",
                "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }
}
