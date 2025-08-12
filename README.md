# 🚀 Space Booking System

Multi-tenant SaaS space booking system for office environments built with **Clean Architecture** principles and **TDD**.

## 🏗️ **Tech Stack**

### Backend
- **Rails 7.1+ API** with multi-tenancy (Apartment gem)
- **MySQL** with Docker
- **RSpec** + **FactoryBot** for testing
- **RuboCop** + **Brakeman** for code quality & security

### Frontend  
- **React 18** with **TypeScript**
- **Biome.js** for linting + formatting (secure ESLint+Prettier alternative)
- **Jest** + **React Testing Library** for testing

## 🔧 **Development Commands**

### Monorepo Commands
```bash
npm run dev                 # Start both backend and frontend
npm run test:all           # Run all tests
npm run lint:all           # Run all linters
```

### Backend Commands
```bash
cd backend
bundle exec rails server  # Start Rails API (port 3001)  
bundle exec rspec         # Run tests
bundle exec rubocop       # Lint and format
```

### Frontend Commands  
```bash
cd frontend
npm start                 # Start React dev server (port 3000)
npm test                  # Run Jest tests
npm run lint:fix          # Auto-fix with Biome
```

## 🛡️ **Quality Assurance**

### Pre-commit Hooks (Automated)
- **🔒 Security**: Gitleaks secrets scanning
- **🏗️ Backend**: RuboCop formatting + RSpec tests + Brakeman security
- **⚛️ Frontend**: Biome linting + TypeScript compilation + Jest tests

### Code Standards
- **Ruby**: Rails Omakase style + performance optimizations
- **TypeScript/React**: Biome.js (97% Prettier compatible, zero vulnerabilities)
- **Testing**: TDD with >90% coverage target

Built with ❤️ following Clean Architecture and TDD principles and the colaboration of claude code ([www.claude.ai](https://www.anthropic.com/claude-code))