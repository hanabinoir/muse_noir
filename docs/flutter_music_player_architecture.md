# Flutter Android Music Player Architecture

## 1. Architecture Overview

**Pattern:** Layered Architecture + Feature-first, powered by Riverpod

Key goals: - Clear separation of concerns - Audio engine isolated from
UI - MediaStore access abstracted - Playlist persistence independent of
Android APIs - Scalable for future features (lyrics, EQ, streaming)

------------------------------------------------------------------------

## 2. Top-Level Folder Structure

    lib/
    ├── main.dart
    ├── app.dart
    ├── core/
    ├── features/
    ├── data/
    ├── domain/
    └── services/

------------------------------------------------------------------------

## 3. Core Layer

    core/
    ├── constants/
    ├── theme/
    ├── utils/
    ├── errors/
    └── extensions/

------------------------------------------------------------------------

## 4. Features Layer

### Player

    features/player/
    ├── presentation/
    ├── controller/
    └── state/

### Library

    features/library/
    ├── presentation/
    ├── controller/
    └── state/

### Playlist

    features/playlist/
    ├── presentation/
    ├── controller/
    └── state/

### Settings

    features/settings/
    ├── presentation/
    ├── controller/
    └── state/

------------------------------------------------------------------------

## 5. Domain Layer

    domain/
    ├── entities/
    ├── repositories/
    └── usecases/

------------------------------------------------------------------------

## 6. Data Layer

    data/
    ├── models/
    ├── datasources/
    └── repositories/

------------------------------------------------------------------------

## 7. Services Layer

    services/
    ├── audio/
    ├── media/
    └── storage/

------------------------------------------------------------------------

## 8. Data Flow Example

    UI
    ↓
    Controller
    ↓
    UseCase
    ↓
    Repository
    ↓
    Datasource
    ↓
    Platform API

------------------------------------------------------------------------

This document captures the recommended production-ready architecture for
a Flutter-based Android local music player.
