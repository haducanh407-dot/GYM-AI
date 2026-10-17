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
    public DbSet<WorkoutSession> WorkoutSessions => Set<WorkoutSession>();
    public DbSet<Exercise> Exercises => Set<Exercise>();
    public DbSet<WorkoutPlan> WorkoutPlans => Set<WorkoutPlan>();
    public DbSet<WorkoutPlanExercise> WorkoutPlanExercises => Set<WorkoutPlanExercise>();
    public DbSet<PlanAppointment> PlanAppointments => Set<PlanAppointment>();
    public DbSet<Food> Foods => Set<Food>();
    public DbSet<Meal> Meals => Set<Meal>();
    public DbSet<MealItem> MealItems => Set<MealItem>();
    public DbSet<DailyCalorieTarget> DailyCalorieTargets => Set<DailyCalorieTarget>();
    public DbSet<ConfirmedScanResult> ConfirmedScanResults => Set<ConfirmedScanResult>();
    public DbSet<CoachConversation> CoachConversations => Set<CoachConversation>();
    public DbSet<CoachMessage> CoachMessages => Set<CoachMessage>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        builder.Entity<ApplicationUser>()
            .Property(user => user.FullName)
            .HasMaxLength(120)
            .IsRequired();

        builder.Entity<ApplicationUser>().Property(user => user.Gender).HasMaxLength(30);
        builder.Entity<ApplicationUser>().Property(user => user.Goal).HasMaxLength(120);
        builder.Entity<ApplicationUser>().Property(user => user.TrainingLocation).HasMaxLength(60);
        builder.Entity<ApplicationUser>().Property(user => user.TrainingLevel).HasMaxLength(60);
        builder.Entity<WorkoutSession>(entity =>
        {
            entity.Property(session => session.ExercisesJson).HasDefaultValue("[]");
            entity.Property(session => session.FeedbackCountsJson).HasDefaultValue("{}");
            entity.HasIndex(session => new { session.UserId, session.StartedAt });
            entity.HasOne(session => session.User).WithMany()
                .HasForeignKey(session => session.UserId).OnDelete(DeleteBehavior.Cascade);
        });

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
        builder.Entity<Exercise>(entity =>
        {
            entity.Property(x => x.Name).HasMaxLength(120).IsRequired();
            entity.Property(x => x.Description).HasMaxLength(1000);
            entity.Property(x => x.MuscleGroup).HasMaxLength(80);
            entity.Property(x => x.Difficulty).HasMaxLength(40);
        });
        builder.Entity<WorkoutPlan>(entity =>
        {
            entity.Property(x => x.Name).HasMaxLength(120).IsRequired();
            entity.HasIndex(x => new { x.UserId, x.CreatedAt });
            entity.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
        });
        builder.Entity<WorkoutPlanExercise>(entity =>
        {
            entity.HasIndex(x => new { x.WorkoutPlanId, x.Order });
            entity.HasOne(x => x.WorkoutPlan).WithMany(x => x.Exercises).HasForeignKey(x => x.WorkoutPlanId).OnDelete(DeleteBehavior.Cascade);
            entity.HasOne(x => x.Exercise).WithMany(x => x.PlanExercises).HasForeignKey(x => x.ExerciseId).OnDelete(DeleteBehavior.Restrict);
        });
        builder.Entity<PlanAppointment>(entity =>
        {
            entity.HasIndex(x => new { x.UserId, x.StartsAt });
            entity.Property(x => x.Status).HasMaxLength(30).IsRequired();
            entity.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
            entity.HasOne(x => x.WorkoutPlan).WithMany(x => x.Appointments).HasForeignKey(x => x.WorkoutPlanId).OnDelete(DeleteBehavior.Cascade);
        });
        builder.Entity<Food>(entity =>
        {
            entity.Property(x => x.Name).HasMaxLength(160).IsRequired();
            entity.Property(x => x.Brand).HasMaxLength(120);
            entity.HasIndex(x => x.Name);
        });
        builder.Entity<Meal>(entity =>
        {
            entity.Property(x => x.Name).HasMaxLength(120).IsRequired();
            entity.HasIndex(x => new { x.UserId, x.ConsumedAt });
            entity.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
            entity.Property(x => x.Calories).HasPrecision(10, 2);
            entity.Property(x => x.Protein).HasPrecision(10, 2);
            entity.Property(x => x.Carbs).HasPrecision(10, 2);
            entity.Property(x => x.Fat).HasPrecision(10, 2);
        });
        builder.Entity<MealItem>(entity =>
        {
            entity.HasOne(x => x.Meal).WithMany(x => x.Items).HasForeignKey(x => x.MealId).OnDelete(DeleteBehavior.Cascade);
            entity.HasOne(x => x.Food).WithMany().HasForeignKey(x => x.FoodId).OnDelete(DeleteBehavior.Restrict);
            entity.Property(x => x.Grams).HasPrecision(10, 2);
            entity.Property(x => x.Servings).HasPrecision(10, 2);
        });
        builder.Entity<DailyCalorieTarget>(entity =>
        {
            entity.HasIndex(x => new { x.UserId, x.Date }).IsUnique();
            entity.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
            entity.Property(x => x.Source).HasMaxLength(30);
        });
        builder.Entity<ConfirmedScanResult>(entity =>
        {
            entity.HasIndex(x => new { x.UserId, x.IdempotencyKey }).IsUnique();
            entity.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
            entity.Property(x => x.FoodName).HasMaxLength(160).IsRequired();
        });
        builder.Entity<CoachConversation>(entity =>
        {
            entity.HasIndex(x => new { x.UserId, x.UpdatedAt });
            entity.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
        });
        builder.Entity<CoachMessage>(entity =>
        {
            entity.Property(x => x.Sender).HasMaxLength(20).IsRequired();
            entity.Property(x => x.Status).HasMaxLength(20).IsRequired();
            entity.Property(x => x.Content).HasMaxLength(2000).IsRequired();
            entity.HasIndex(x => new { x.ConversationId, x.CreatedAt });
            entity.HasOne(x => x.Conversation).WithMany(x => x.Messages)
                .HasForeignKey(x => x.ConversationId).OnDelete(DeleteBehavior.Cascade);
        });
    }
}
