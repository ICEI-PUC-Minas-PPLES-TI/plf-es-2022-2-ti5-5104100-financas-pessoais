using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WeBudgetWebAPI.Migrations
{
    public partial class chageBudget : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<double>(
                name: "BudgetValueUsed",
                table: "Budget",
                type: "double precision",
                nullable: false,
                defaultValue: 0.0);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "BudgetValueUsed",
                table: "Budget");
        }
    }
}
