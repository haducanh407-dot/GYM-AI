using System.Security.Claims;
using AiGym.Api.Data;
using AiGym.Api.Dtos;
using AiGym.Api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AiGym.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public sealed class PostsController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public PostsController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<PostResponse>>> GetPosts()
    {
        var posts = await _context.Posts
            .OrderByDescending(post => post.CreatedAt)
            .Select(post => ToResponse(post))
            .ToListAsync();

        return Ok(posts);
    }

    [HttpPost]
    public async Task<ActionResult<PostResponse>> CreatePost(CreatePostRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Content))
        {
            return BadRequest(new { message = "Content is required." });
        }

        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? User.FindFirstValue("userId");
        var authorName = User.FindFirstValue("name")
            ?? User.FindFirstValue(ClaimTypes.Email)
            ?? User.FindFirstValue("email")
            ?? "User";

        var post = new Post
        {
            AuthorId = userId!,
            AuthorName = await ResolveAuthorNameAsync(userId!, authorName),
            Content = request.Content.Trim(),
            ImageAsset = string.IsNullOrWhiteSpace(request.ImageAsset) ? null : request.ImageAsset.Trim(),
            Tag = string.IsNullOrWhiteSpace(request.Tag) ? "Bai viet" : request.Tag.Trim(),
            CreatedAt = DateTime.UtcNow
        };

        _context.Posts.Add(post);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetPosts), new { id = post.Id }, ToResponse(post));
    }

    [HttpPut("{id:int}")]
    public async Task<ActionResult<PostResponse>> UpdatePost(int id, UpdatePostRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Content))
        {
            return BadRequest(new { message = "Content is required." });
        }

        var post = await _context.Posts.FindAsync(id);
        if (post is null)
        {
            return NotFound();
        }

        if (!CanMutate(post))
        {
            return Forbid();
        }

        post.Content = request.Content.Trim();
        await _context.SaveChangesAsync();
        return Ok(ToResponse(post));
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> DeletePost(int id)
    {
        var post = await _context.Posts.FindAsync(id);
        if (post is null)
        {
            return NotFound();
        }

        if (!CanMutate(post))
        {
            return Forbid();
        }

        _context.Posts.Remove(post);
        await _context.SaveChangesAsync();
        return NoContent();
    }

    private bool CanMutate(Post post)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? User.FindFirstValue("userId");
        return User.IsInRole("Admin") || post.AuthorId == userId;
    }

    private async Task<string> ResolveAuthorNameAsync(string userId, string fallback)
    {
        var user = await _context.Users.FindAsync(userId);
        return string.IsNullOrWhiteSpace(user?.FullName) ? fallback : user.FullName;
    }

    private static PostResponse ToResponse(Post post) => new(
        post.Id,
        post.AuthorId,
        post.AuthorName,
        post.Content,
        post.ImageAsset,
        post.Tag,
        post.LikeCount,
        post.Liked,
        post.CreatedAt);
}
