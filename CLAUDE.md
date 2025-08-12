# Rails-React Space Booking Project

## Project Overview
This is a learning-focused monorepo implementing a space booking system using Ruby on Rails (backend) and React (frontend), following Clean Architecture principles and Test-Driven Development (TDD).

## Development Principles

### 1. Test-Driven Development (TDD)
- **Red-Green-Refactor Cycle**: Write failing tests first, make them pass, then refactor
- **No code without tests**: Every feature must have tests written before implementation
- **Testing Pyramid**: Unit tests (most) → Integration tests → E2E tests (least)

### 2. Clean Architecture & Domain-Driven Design (DDD)
- **Domain-Centric**: Business logic is independent of frameworks, UI, and external systems
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Separation of Concerns**: Each layer has a single responsibility

### 3. Hexagonal Architecture (Ports & Adapters)
- **Ports**: Interfaces that define how the application interacts with external systems
- **Adapters**: Implementations that connect ports to specific technologies
- **Core isolation**: Domain logic is isolated from external dependencies

## Architecture Layers

### Backend (Rails) - Clean Architecture
```
┌─────────────────────────────────────────┐
│            Controllers (Web)            │  ← Web Adapters
├─────────────────────────────────────────┤
│         Application Services            │  ← Use Cases
├─────────────────────────────────────────┤
│          Domain Services                │  ← Business Logic
├─────────────────────────────────────────┤
│        Domain Models/Entities           │  ← Core Domain
├─────────────────────────────────────────┤
│      Repository Interfaces              │  ← Ports
├─────────────────────────────────────────┤
│   ActiveRecord Models (Persistence)     │  ← Data Adapters
└─────────────────────────────────────────┘
```

### Frontend (React) - Clean Architecture
```
┌─────────────────────────────────────────┐
│         Components (UI Layer)           │  ← Presentation
├─────────────────────────────────────────┤
│       Custom Hooks (Use Cases)         │  ← Application Layer
├─────────────────────────────────────────┤
│        Services (Domain Logic)         │  ← Domain Layer
├─────────────────────────────────────────┤
│    API Clients (External Interfaces)   │  ← Infrastructure
└─────────────────────────────────────────┘
```

## Directory Structure Philosophy

### Backend (Rails)
```
backend/
├── app/
│   ├── controllers/          # Web adapters (HTTP interface)
│   ├── use_cases/            # Application services (business workflows)
│   ├── domain/               # Core domain logic
│   │   ├── models/           # Domain entities and value objects
│   │   ├── services/         # Domain services
│   │   └── repositories/     # Repository interfaces (ports)
│   ├── infrastructure/       # External adapters
│   │   └── persistence/      # ActiveRecord models
│   └── serializers/          # Data transformation
├── spec/                     # RSpec tests
└── config/                   # Rails configuration
```

### Frontend (React)
```
frontend/
├── src/
│   ├── components/          # UI components (dumb & smart)
│   ├── hooks/               # Custom hooks (use cases)
│   ├── services/            # Domain services & API clients
│   ├── types/               # TypeScript type definitions
│   ├── utils/               # Pure utility functions
│   └── __tests__/           # Jest tests
├── public/                  # Static assets
└── package.json             # Dependencies
```

## Testing Strategy

### Backend Testing (RSpec)
- **Unit Tests**: Domain models, services, and use cases
- **Integration Tests**: Controllers and full request cycles
- **Contract Tests**: API endpoint specifications
- **Test Structure**: Arrange-Act-Assert pattern

### Frontend Testing (Jest + React Testing Library)
- **Unit Tests**: Individual components and hooks
- **Integration Tests**: Component interactions
- **E2E Tests**: Critical user flows
- **Testing Philosophy**: Test behavior, not implementation

## Code Quality Standards

### Ruby/Rails Standards
- **RuboCop**: Enforce Ruby style guide
- **Naming**: camelCase for methods/variables, PascalCase for classes
- **SOLID Principles**: Single responsibility, dependency injection
- **Rails Conventions**: RESTful routes, fat models → thin controllers → use cases

### React/JavaScript Standards
- **ESLint + Prettier**: Code formatting and linting
- **TypeScript**: Strong typing for better maintainability
- **Naming**: camelCase for variables/functions, PascalCase for components
- **Hooks Pattern**: Custom hooks for business logic

## Git Workflow & Automation
### Pre-commit Hooks
- Run linters (RuboCop, ESLint)
- Format code (Prettier)
- Run all test suites
- Check for secrets/sensitive data

## Development Commands

### Backend Commands
```bash
# Run tests
bundle exec rspec

# Run linter
bundle exec rubocop

# Run type checker (if using Sorbet)
bundle exec srb tc

# Run Rails server
bundle exec rails server
```

### Frontend Commands
```bash
# Run tests
npm test

# Run linter
npm run lint

# Format code
npm run prettier

# Type check
npm run type-check

# Start development server
npm start
```

### Monorepo Commands
```bash
# Install all dependencies
npm run install:all

# Run all tests
npm run test:all

# Run all linters
npm run lint:all

# Start both servers
npm run dev
```

## Learning Checkpoints

Before each major milestone, we'll review:
1. **Architecture Decisions**: Atleast 2 best options and always thinking on best technical practices.
2. **Technology Explanation**: Explain the framework and technology best practices to apply.

After each major milestone, we'll review:
1. **Architecture Decisions**: Why we chose specific patterns
2. **Testing Strategies**: How our tests validate business requirements
3. **Code Quality**: What makes code maintainable and readable
4. **Trade-offs**: Benefits and costs of our architectural choices