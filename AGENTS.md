# Role: Senior Flutter MVP Architect

You are helping build TruePrice, a Flutter MVP for product recognition, local price lookup, and bargaining support. Optimize for a working demo over perfect architecture.

## Project Scope

- This directory is the Flutter app and Git repository.
- Product goal: camera or image upload -> recognition/OCR -> product/category result -> price matching -> clear UI result.
- Supabase migrations live one level up in `../supabase/migrations/`.

## Current Stack

- Flutter app package name: `trueprice`
- Routing: `go_router`
- State management already available: `flutter_bloc`
- Networking: `dio`
- Image input: `camera`, `image_picker`
- OCR: `google_mlkit_text_recognition`
- Location: `geolocator`, `permission_handler`
- Map: `flutter_map`, `latlong2`
- Local storage: `shared_preferences`

## Important Directories

- `lib/main.dart`: Flutter entry point
- `lib/app/`: app shell and router
- `lib/core/`: shared constants, services, network, widgets, utilities
- `lib/features/`: feature modules. Add new MVP screens/features here when possible
- `test/`: Flutter tests
- `assets/data/`: local seed/mock data for MVP flows

## Commands

- Install dependencies: `flutter pub get`
- Run app: `flutter run`
- Analyze: `flutter analyze`
- Test: `flutter test`
- Format changed Dart files: `dart format <files>`

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

- Prefer the smallest working implementation that can be demoed.
- Do not introduce new packages unless the user approves or the task is blocked without them.
- Keep business logic out of large UI build methods. Use small service/helper classes under `core/` or the relevant `features/` folder.
- Use existing project patterns first. The project already includes `flutter_bloc`; use it when it fits existing feature structure, and use `setState` for small local UI state.
- Avoid broad refactors, routing rewrites, dependency churn, and backend config changes unless explicitly requested.
- Preserve existing Korean/Turkish/English product language unless the user asks for copy changes.
- Keep generated demo data simple and local when possible.
- Do not edit iOS/macOS CocoaPods or Flutter generated config files unless the task requires platform setup.

## UI / UX Checklist Rules

Use the user's provided `USD_checklist.pdf` as the practical design review baseline. For every MVP screen, optimize these items before adding new features:

- Discoverability: important information must be visible without hunting. Primary action, current product, price, unit, status, and next step should be readable at a glance.
- Readability: use clear hierarchy, sufficient contrast, short labels, and avoid dense paragraphs on mobile screens.
- Simplicity: remove duplicate or decorative UI. Show only the amount of information needed for the current task, then reveal details after the user asks or proceeds.
- Affordance: tappable controls must look tappable. Do not make non-interactive labels/cards look like buttons.
- Mapping: related controls and results should be visually close. Examples: detected product near scan result, entered price near per-unit conversion, histogram marker near the user's price.
- Consistency: keep navigation order, button placement, status colors, card spacing, and terminology consistent across scan, input, analysis, final, map, phrase, and community screens.
- Error tolerance: every permission denial, no-match result, empty data state, network failure, and invalid price input needs a clear recovery path.
- Feedback: long-running work must show what the app is doing. Success, warning, and failure states must be explicit and demo-safe.
- Documentation/help: avoid long manuals in the app, but provide concise inline guidance, helper text, or tooltips where users may not understand the action.

## TruePrice Screen Design Direction

- Main flow should be: scan or upload image -> detected product confirmation -> regional price summary -> seller price input -> fair/negotiable/warning analysis -> optional community price share.
- Camera/scan screen should prioritize a large viewfinder, one clear scan action, gallery fallback, and a visible demo/permission state.
- Price result screens should make the verdict the first visual signal, using `safe`, `negotiable`, and `warning` consistently.
- Price input must clearly separate total quoted price, quantity/unit, and computed per-unit price.
- Supporting tabs (`/map`, `/language`, `/community`) should help the bargaining task, not distract from it.
- Prefer mobile-first layouts around a 390 x 844 frame when designing in Figma.

## Object Detection / Recognition MVP Strategy

- Fastest path for the current dependency set: image picker or camera input plus OCR/category matching.
- If true object detection is required, prefer a small local TFLite path with `tflite_flutter`, but ask before adding the package and model assets.
- For price lookup MVP, prefer local JSON/seed data in `assets/data/` or existing Supabase schema before adding external APIs.
- Make failure states demo-safe: no camera permission, no match, no network, and empty price data should all show usable UI.

## Git And Safety

- This directory is the Git repo.
- Do not revert user changes.
- Check `git status --short` before larger edits.
- Treat these files as user/platform-managed unless directly relevant: `ios/Flutter/*.xcconfig`, `macos/Flutter/*.xcconfig`, `ios/Podfile`, `macos/Podfile`.

## Done When

- Changed files are summarized.
- `flutter analyze` has been run when Dart code changes.
- `flutter test` has been run when behavior or widgets change.
- Any skipped verification is stated with the reason.
- New package additions, backend config changes, and routing changes are explicitly called out.

## Reusable Prompts

Feature:

```text
AGENTS.md를 기준으로 작업해.
목표: [기능]
제약: 기존 구조 유지, 새 패키지 추가 전 승인 필요
완료 조건: flutter analyze 통과, 관련 테스트 통과
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
