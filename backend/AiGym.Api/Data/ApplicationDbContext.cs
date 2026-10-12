using AiGym.Api.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace AiGym.Api.Data;

public sealed class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<Post> Posts => Set<Post>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        builder.Entity<ApplicationUser>()
            .Property(user => user.FullName)
            .HasMaxLength(120)
            .IsRequired();

        builder.Entity<Post>(entity =>
        {
            entity.Property(post => post.AuthorName).HasMaxLength(120).IsRequired();
            entity.Property(post => post.Content).HasMaxLength(1000).IsRequired();
            entity.Property(post => post.ImageAsset).HasMaxLength(255);
            entity.Property(post => post.Tag).HasMaxLength(50).IsRequired();
            entity.HasOne(post => post.Author)
                .WithMany()
                .HasForeignKey(post => post.AuthorId)
                .OnDelete(DeleteBehavior.Cascade);
        });
    }
}
