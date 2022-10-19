using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WeBudgetWebAPI.Migrations
{
    public partial class transactionsChanges : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "PaymentType",
                table: "Transaction",
                type: "text",
                nullable: false,
                oldClrType: typeof(double),
                oldType: "double precision");

            migrationBuilder.AddColumn<double>(
                name: "PaymentValue",
                table: "Transaction",
                type: "double precision",
                nullable: false,
                defaultValue: 0.0);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PaymentValue",
                table: "Transaction");

            migrationBuilder.AlterColumn<double>(
                name: "PaymentType",
                table: "Transaction",
                type: "double precision",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");
        }
    }
}
