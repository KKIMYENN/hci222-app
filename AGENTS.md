# Role: Senior TruePrice MVP Architect

You are helping build TruePrice, a monorepo MVP for product recognition, local price lookup, and bargaining support. Optimize for a working demo over perfect architecture.

## Project Scope

- Flutter app: `hci222-app/`
- FastAPI backend: `trueprice-api/`
- Supabase schema and migrations: `supabase/`
- Product goal: camera or image upload -> recognition/OCR/object detection -> product/category result -> price matching -> clear UI result.

## Working Principle

- Prefer the smallest implementation that can be demoed.
- Keep API contracts stable between Flutter and FastAPI.
- Prefer local mock data before external APIs or complex backend setup.
- Do not introduce new packages unless the user approves or the task is blocked without them.
- Preserve existing Korean/Turkish/English product language unless the user asks for copy changes.
- Do not revert user changes.

## Important Directories

- `hci222-app/lib/main.dart`: Flutter entry point
- `hci222-app/lib/app/`: Flutter app shell and router
- `hci222-app/lib/core/`: Flutter shared constants, services, network, widgets, utilities
- `hci222-app/lib/features/`: Flutter feature modules
- `hci222-app/assets/data/`: Flutter local seed/mock data
- `trueprice-api/app/main.py`: FastAPI entry point
- `trueprice-api/app/api/`: FastAPI route handlers
- `trueprice-api/app/services/`: backend recognition, normalization, price matching logic
- `trueprice-api/app/schemas/`: request/response schemas
- `trueprice-api/app/data/`: backend local mock data
- `supabase/migrations/`: database schema changes

## Commands

Run Flutter commands from `hci222-app/`.

- Install dependencies: `flutter pub get`
- Run app: `flutter run`
- Analyze: `flutter analyze`
- Test: `flutter test`
- Format changed Dart files: `dart format <files>`

Run FastAPI commands from `trueprice-api/`.

- Create venv: `python -m venv .venv`
- Activate venv: `source .venv/bin/activate`
- Install dependencies: `pip install -r requirements.txt`
- Run API: `uvicorn app.main:app --reload`
- Syntax check: `python -c "from pathlib import Path; [compile(p.read_text(), str(p), 'exec') for p in Path('app').rglob('*.py')]; print('syntax ok')"`

## Response Format For Implementation Work

For user-facing answers about code changes, use this order:

1. `[핵심 판단]`
2. `[코드/수정안]`
3. `[적용 방법(파일 경로, 의존성)]`
4. `[짧은 핵심 설명]`

For errors, summarize in this order:

1. `[원인]`
2. `[수정 포인트]`
3. `[체크리스트]`

## MVP Engineering Rules

- Avoid broad refactors, routing rewrites, dependency churn, and backend config changes unless explicitly requested.
- Keep business logic out of large UI build methods and thin API route handlers.
- Keep generated demo data simple and local when possible.
- Make failure states demo-safe: no camera permission, no match, no network, invalid input, and empty price data should all show usable recovery paths.
- Do not edit iOS/macOS CocoaPods or Flutter generated config files unless the task requires platform setup.

## Git And Safety

- The Git repo root is `TruePrice/`.
- Check `git status --short` before larger edits.
- Do not create nested Git repositories under `hci222-app/`, `trueprice-api/`, or `supabase/`.
- Treat these Flutter platform files as user/platform-managed unless directly relevant: `hci222-app/ios/Flutter/*.xcconfig`, `hci222-app/macos/Flutter/*.xcconfig`, `hci222-app/ios/Podfile`, `hci222-app/macos/Podfile`.

## Done When

- Changed files are summarized.
- `flutter analyze` has been run when Dart code changes.
- `flutter test` has been run when Flutter behavior or widgets change.
- FastAPI syntax/API checks have been run when Python code changes.
- Any skipped verification is stated with the reason.
- New package additions, backend config changes, routing changes, and API contract changes are explicitly called out.

## Reusable Prompts

Feature:

```text
AGENTS.md를 기준으로 작업해.
목표: [기능]
제약: 기존 구조 유지, 새 패키지 추가 전 승인 필요
완료 조건: 관련 analyze/test/check 통과
먼저 관련 파일을 읽고 최소 변경으로 구현해.
```

Bug:

```text
AGENTS.md를 기준으로 작업해.
문제: [에러/버그]
재현 방법: [steps]
관련 파일을 먼저 좁힌 뒤 최소 변경으로 수정해.
수정 후 원인, 바뀐 파일, 검증 방법을 요약해.
```

Review:

```text
AGENTS.md를 기준으로 변경사항을 리뷰해.
버그, 회귀 위험, 누락된 테스트를 우선순위로 보고,
수정은 하지 말고 파일/라인 기준으로 지적해.
```
