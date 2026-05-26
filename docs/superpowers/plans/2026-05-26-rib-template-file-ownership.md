# RIB Template File Ownership Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make RIB templates generate Splash-style file ownership, add a dynamic component template, and add ergonomic `ComponentizedBuilder` overloads.

**Architecture:** Keep template behavior scoped to `tooling`; move declarations between template files without changing generated runtime behavior. Add source-level builder overloads in `ComponentizedBuilder.swift` and cover them with focused Swift Testing tests.

**Tech Stack:** Swift, Swift Package Manager, Xcode `.xctemplate`, Swift Testing.

---

### Task 1: Builder API Overloads

**Files:**
- Modify: `Sources/RIBsArchitecture/Builder/ComponentizedBuilder.swift`
- Modify: `Sources/RIBsArchitectureTests/Tests/ComponentizedBuilderTests.swift`
- Modify: `Sources/RIBsArchitectureTests/Mocks/ComponentizedBuilderMock.swift`

- [ ] Add short `build` overloads that delegate to the existing long-form componentized builder API.
- [ ] Add mock builders with non-`Void` dependency shapes.
- [ ] Add tests for `build(with:_:)`, `build()`, build-only `build(with:)`, and component-only `build(with:)`.
- [ ] Run `swift test`.

### Task 2: Public Template File Ownership

**Files:**
- Modify: `tooling/RIB (public).xctemplate/ownsView/___FILEBASENAME___Interface.swift`
- Modify: `tooling/RIB (public).xctemplate/ownsView/___FILEBASENAME___Interactor.swift`
- Modify: `tooling/RIB (public).xctemplate/ownsView/___FILEBASENAME___ViewController.swift`
- Modify: `tooling/RIB (public).xctemplate/ownsView/___FILEBASENAME___Router.swift`
- Inspect: `tooling/RIB (public).xctemplate/Default/*.swift`

- [ ] Keep only public external contracts in the view-owning interface template.
- [ ] Move `Interactable` into the router template.
- [ ] Move `PresentableListener` into the view controller template.
- [ ] Preserve the existing user change that marks the view-owning public router initializer as `override`.
- [ ] Leave non-view public template placement unchanged except for consistency fixes discovered during review.

### Task 3: Dynamic Template

**Files:**
- Create: `tooling/RIB (dynamic).xctemplate/TemplateInfo.plist`
- Create: `tooling/RIB (dynamic).xctemplate/Default/*.swift`
- Create: `tooling/RIB (dynamic).xctemplate/ownsView/*.swift`
- Copy: `tooling/RIB (dynamic).xctemplate/TemplateIcon.png`
- Copy: `tooling/RIB (dynamic).xctemplate/TemplateIcon@2x.png`
- Modify: `tooling/README.md`

- [ ] Copy the public template as the baseline.
- [ ] Update builder templates to subclass `ComponentizedBuilder`.
- [ ] Add `ComponentDependency` declarations to interface templates.
- [ ] Add `Dependency` and `Component` declarations to builder templates.
- [ ] Update interface templates to use short `build(with:)`.
- [ ] Set template metadata to `RIB (dynamic)` with a sort order after `RIB (public)`.
- [ ] Document the new template.

### Task 4: Verification

**Files:**
- Inspect generated diff for all modified files.

- [ ] Run `swift test`.
- [ ] Run `plutil -lint tooling/*/TemplateInfo.plist`.
- [ ] Search for misplaced `PresentableListener` in interface templates.
- [ ] Search for the new dynamic template metadata.
