# AI GYM Backend

Backend ASP.NET Core Web API cho app AI GYM, gom Identity, JWT, role va API bai viet.

## Chay API

Yeu cau .NET SDK 9 tro len va SQL Server LocalDB hoac SQL Server.

```powershell
dotnet restore backend/AiGym.Backend.slnx
dotnet run --project backend/AiGym.Api
```

Mac dinh API chay theo `Properties/launchSettings.json`. Khi dung Conveyor, lay URL public/noi bo cua Conveyor va gan vao Flutter `.env`, vi du:

```env
API_BASE_URL=https://your-conveyor-url
```

## Cau hinh

File `backend/AiGym.Api/appsettings.json` co:

- `ConnectionStrings:DefaultConnection`: SQL Server database `AIGymDb`.
- `Jwt:Issuer`, `Jwt:Audience`, `Jwt:Key`, `Jwt:ExpiresInMinutes`.
- `LMStudio:BaseUrl`, `LMStudio:Model`: dia chi va model LMStudio dung cho tro ly AI.

Khi dua len may that, doi `Jwt:Key` sang secret rieng va khong commit secret san xuat.

LMStudio can chay tai `http://127.0.0.1:1234`, da nap model `qwen/qwen3.5-9b`,
sau do khoi dong lai backend de ap dung cau hinh.

## Tai khoan va role seed san

- Admin: `admin123@gmail.com`
- Mat khau: `123123123Az!`
- Roles: `Admin`, `User`

User dang ky qua API mac dinh duoc gan role `User`.

## Endpoint

### Auth

`POST /api/auth/register`

```json
{
  "fullName": "Nguyen Van A",
  "email": "user@example.com",
  "password": "123123123Az!"
}
```

`POST /api/auth/login`

```json
{
  "email": "admin123@gmail.com",
  "password": "123123123Az!"
}
```

`GET /api/auth/me`

Can header:

```http
Authorization: Bearer <token>
```

Token JWT co claim `userId`, `email`, `role`, `exp` de Flutter doc bang `jwt_decode`.

### Posts

`GET /api/posts` public.

`POST /api/posts` can login:

```json
{
  "content": "Tap nguc voi AI Gym",
  "tag": "Bai viet"
}
```

`PUT /api/posts/{id}` can chu bai viet hoac `Admin`.

`DELETE /api/posts/{id}` can chu bai viet hoac `Admin`.

### AI

`POST /api/ai/chat` can dang nhap va chuyen yeu cau den LMStudio:

```json
{
  "message": "Goi y cho toi mot bai tap nguc cho nguoi moi."
}
```

## Kiem tra

```powershell
dotnet test backend/AiGym.Backend.slnx
dotnet build backend/AiGym.Backend.slnx
```
