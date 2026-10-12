namespace AiGym.Api.Dtos;

public sealed record CreatePostRequest(string Content, string? ImageAsset = null, string? Tag = null);

public sealed record UpdatePostRequest(string Content);

public sealed record PostResponse(
    int Id,
    string AuthorId,
    string AuthorName,
    string Content,
    string? ImageAsset,
    string Tag,
    int LikeCount,
    bool Liked,
    DateTime CreatedAt);
