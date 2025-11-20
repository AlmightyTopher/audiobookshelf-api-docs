# OpenAPI & Schema Validation Guide

**Purpose:** Automate API documentation validation to keep docs in sync with backend changes
**Goal:** Eliminate documentation drift and ensure accuracy
**Benefit:** Catch API changes before they break integrations

---

## Table of Contents

1. [Why Automated Validation?](#why-automated-validation)
2. [OpenAPI Specification](#openapi-specification)
3. [Implementation Roadmap](#implementation-roadmap)
4. [Schema Validation Tools](#schema-validation-tools)
5. [CI/CD Integration](#cicd-integration)
6. [Testing Strategy](#testing-strategy)
7. [Migration Plan](#migration-plan)

---

## Why Automated Validation?

### Current Challenges

**Manual Documentation:**
- ❌ Docs can become outdated when API changes
- ❌ New endpoints may not be documented
- ❌ Response schemas can drift from reality
- ❌ No automated verification of examples
- ❌ Time-consuming to keep in sync

**With Automated Validation:**
- ✅ Documentation auto-generated from code
- ✅ CI/CD catches documentation drift
- ✅ Response schemas validated against reality
- ✅ Examples automatically tested
- ✅ Always up-to-date documentation

---

## OpenAPI Specification

### What is OpenAPI?

[OpenAPI](https://swagger.io/specification/) (formerly Swagger) is an industry-standard specification for describing REST APIs. It provides:

- **Machine-readable** API definitions
- **Auto-generated** documentation
- **Interactive** API explorers
- **Client SDK** generation
- **Contract testing** capabilities

### OpenAPI Structure

```yaml
openapi: 3.1.0
info:
  title: Audiobookshelf API
  version: 2.0.0
  description: Complete API for audiobook and podcast management

servers:
  - url: https://abs.example.com
    description: Production server

paths:
  /api/libraries:
    get:
      summary: Get All Libraries
      tags: [Libraries]
      security:
        - bearerAuth: []
      responses:
        '200':
          description: List of libraries
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/LibrariesResponse'

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  schemas:
    LibrariesResponse:
      type: object
      properties:
        libraries:
          type: array
          items:
            $ref: '#/components/schemas/Library'
```

---

## Implementation Roadmap

### Phase 1: Initial Setup (Week 1-2)

**Goal:** Generate basic OpenAPI specification

**Tasks:**
1. ✅ Audit existing API endpoints (done - see ENDPOINT_MATRIX.md)
2. ⏳ Choose OpenAPI generation approach
3. ⏳ Set up OpenAPI tooling
4. ⏳ Generate initial specification

**Recommended Tools:**
- **For Express.js:** [swagger-jsdoc](https://github.com/Surnet/swagger-jsdoc)
- **For Manual Creation:** [Stoplight Studio](https://stoplight.io/studio)
- **For Validation:** [swagger-cli](https://github.com/APIDevTools/swagger-cli)

**Example: Adding JSDoc Comments to Routes**

```javascript
/**
 * @openapi
 * /api/libraries:
 *   get:
 *     summary: Get All Libraries
 *     tags:
 *       - Libraries
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Successfully retrieved libraries
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 libraries:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Library'
 */
router.get('/api/libraries', authenticateUser, async (req, res) => {
  // ... implementation
});
```

---

### Phase 2: Schema Definitions (Week 3-4)

**Goal:** Define complete data schemas

**Tasks:**
1. ⏳ Convert existing schemas to OpenAPI format
2. ⏳ Add request body schemas
3. ⏳ Add response schemas
4. ⏳ Define reusable components

**Schema Example:**

```yaml
components:
  schemas:
    Library:
      type: object
      required:
        - id
        - name
        - mediaType
      properties:
        id:
          type: string
          example: "lib_123"
          description: Library identifier
        name:
          type: string
          example: "Audiobooks"
          description: Library name
        mediaType:
          type: string
          enum: [book, podcast]
          description: Type of media in library
        folders:
          type: array
          items:
            $ref: '#/components/schemas/Folder'
        icon:
          type: string
          nullable: true
          example: "database"
        displayOrder:
          type: integer
          example: 1
        settings:
          $ref: '#/components/schemas/LibrarySettings'
```

**Benefits:**
- Type safety
- Validation
- Auto-completion in IDEs
- Client SDK generation

---

### Phase 3: Response Validation (Week 5-6)

**Goal:** Validate actual API responses against schemas

**Tasks:**
1. ⏳ Set up response validation middleware
2. ⏳ Add validation to test suite
3. ⏳ Fix schema mismatches
4. ⏳ Add CI/CD validation

**Validation Middleware Example:**

```javascript
const OpenAPIResponseValidator = require('openapi-response-validator');
const spec = require('./openapi.json');

// Create validator
const validator = new OpenAPIResponseValidator({
  responses: spec.paths['/api/libraries'].get.responses,
  components: spec.components
});

// Middleware to validate responses in development
function validateResponse(req, res, next) {
  if (process.env.NODE_ENV !== 'development') return next();

  const originalJson = res.json.bind(res);
  res.json = function(data) {
    const validation = validator.validateResponse(200, data);
    if (validation && validation.errors) {
      console.error('Response validation failed:', validation.errors);
      // In development, log but don't fail
      // In CI, this should fail the test
    }
    return originalJson(data);
  };
  next();
}

router.get('/api/libraries',
  authenticateUser,
  validateResponse,
  async (req, res) => {
    // ... implementation
  }
);
```

---

### Phase 4: Documentation Generation (Week 7-8)

**Goal:** Auto-generate API documentation from OpenAPI spec

**Tasks:**
1. ⏳ Choose documentation generator
2. ⏳ Set up build pipeline
3. ⏳ Integrate with existing Slate docs
4. ⏳ Deploy to production

**Recommended Generators:**
- **[Swagger UI](https://swagger.io/tools/swagger-ui/)** - Interactive API explorer
- **[ReDoc](https://redocly.github.io/redoc/)** - Beautiful API documentation
- **[Stoplight Elements](https://stoplight.io/open-source/elements)** - Modern API docs
- **[RapiDoc](https://mrin9.github.io/RapiPdf/)** - Minimal, fast docs

**Example Build Command:**

```bash
# Generate OpenAPI spec from code
npx swagger-jsdoc -d swaggerDef.js routes/**/*.js -o openapi.json

# Generate HTML documentation
npx redoc-cli bundle openapi.json -o docs/api-reference.html

# Validate specification
npx swagger-cli validate openapi.json
```

---

## Schema Validation Tools

### 1. OpenAPI Validator

**Purpose:** Validate OpenAPI specification files

```bash
npm install -g swagger-cli

# Validate OpenAPI spec
swagger-cli validate openapi.yaml

# Bundle multiple spec files
swagger-cli bundle openapi.yaml --outfile dist/openapi.json
```

---

### 2. Jest OpenAPI Validator

**Purpose:** Test API responses in Jest tests

```javascript
const request = require('supertest');
const jestOpenAPI = require('jest-openapi');
const spec = require('./openapi.json');

jestOpenAPI(spec);

describe('GET /api/libraries', () => {
  it('should return valid response', async () => {
    const response = await request(app)
      .get('/api/libraries')
      .set('Authorization', `Bearer ${token}`);

    expect(response.status).toBe(200);
    expect(response).toSatisfyApiSpec();
  });
});
```

---

### 3. Express OpenAPI Validator

**Purpose:** Runtime request/response validation

```javascript
const OpenApiValidator = require('express-openapi-validator');

app.use(
  OpenApiValidator.middleware({
    apiSpec: './openapi.yaml',
    validateRequests: true,
    validateResponses: true,
    ignorePaths: /^(?!\/api).*/ // Only validate /api/* paths
  })
);

// Validation errors automatically handled
app.use((err, req, res, next) => {
  res.status(err.status || 500).json({
    message: err.message,
    errors: err.errors
  });
});
```

---

### 4. Prism Mock Server

**Purpose:** Test against mock API before implementation

```bash
npm install -g @stoplight/prism-cli

# Start mock server from OpenAPI spec
prism mock openapi.yaml

# Server running at http://127.0.0.1:4010
# Returns example responses from spec
```

**Use case:** Frontend development before backend is ready

---

### 5. OpenAPI Diff

**Purpose:** Detect breaking changes between API versions

```bash
npm install -g openapi-diff

# Compare two versions
openapi-diff openapi-v1.yaml openapi-v2.yaml

# Output shows:
# - Breaking changes (require major version bump)
# - Non-breaking changes (minor version)
# - Documentation changes (patch version)
```

---

## CI/CD Integration

### GitHub Actions Workflow

Create `.github/workflows/api-validation.yml`:

```yaml
name: API Documentation Validation

on:
  pull_request:
    paths:
      - 'server/**'
      - 'openapi.yaml'
  push:
    branches: [main, develop]

jobs:
  validate-openapi:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Generate OpenAPI spec from code
        run: npm run generate-openapi

      - name: Validate OpenAPI specification
        run: npx swagger-cli validate openapi.yaml

      - name: Check for breaking changes
        if: github.event_name == 'pull_request'
        run: |
          git fetch origin main
          git show origin/main:openapi.yaml > openapi-main.yaml
          npx openapi-diff openapi-main.yaml openapi.yaml --fail-on-breaking

      - name: Run API response validation tests
        run: npm test -- --coverage
        env:
          VALIDATE_RESPONSES: true

      - name: Generate documentation
        run: npm run generate-docs

      - name: Upload OpenAPI artifact
        uses: actions/upload-artifact@v3
        with:
          name: openapi-spec
          path: openapi.yaml

  test-against-mock:
    runs-on: ubuntu-latest
    needs: validate-openapi

    steps:
      - uses: actions/checkout@v3

      - name: Start Prism mock server
        run: |
          npm install -g @stoplight/prism-cli
          prism mock openapi.yaml &

      - name: Run integration tests against mock
        run: npm run test:integration
```

---

### Pre-commit Hook

Validate changes before committing:

`.git/hooks/pre-commit`:

```bash
#!/bin/bash

echo "Validating OpenAPI specification..."

# Generate OpenAPI spec from code
npm run generate-openapi

# Validate specification
npx swagger-cli validate openapi.yaml

if [ $? -ne 0 ]; then
  echo "❌ OpenAPI validation failed. Please fix errors before committing."
  exit 1
fi

echo "✅ OpenAPI validation passed"
exit 0
```

---

## Testing Strategy

### 1. Unit Tests with Schema Validation

```javascript
const { validateSchema } = require('./test-utils');

describe('Library Model', () => {
  it('should match OpenAPI schema', () => {
    const library = new Library({
      id: 'lib_123',
      name: 'Audiobooks',
      mediaType: 'book'
    });

    expect(validateSchema('Library', library.toJSON())).toBe(true);
  });
});
```

---

### 2. Integration Tests with Spec Compliance

```javascript
const request = require('supertest');
const jestOpenAPI = require('jest-openapi');

jestOpenAPI('./openapi.yaml');

describe('Libraries API', () => {
  describe('GET /api/libraries', () => {
    it('should satisfy OpenAPI spec', async () => {
      const response = await request(app)
        .get('/api/libraries')
        .set('Authorization', `Bearer ${validToken}`);

      expect(response).toSatisfyApiSpec();
      expect(response.status).toBe(200);
    });

    it('should return 401 without auth', async () => {
      const response = await request(app)
        .get('/api/libraries');

      expect(response).toSatisfyApiSpec();
      expect(response.status).toBe(401);
    });
  });

  describe('POST /api/libraries', () => {
    it('should validate request body', async () => {
      const response = await request(app)
        .post('/api/libraries')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          name: 'New Library',
          folders: ['/audiobooks'],
          mediaType: 'book'
        });

      expect(response).toSatisfyApiSpec();
      expect(response.status).toBe(200);
    });

    it('should reject invalid request', async () => {
      const response = await request(app)
        .post('/api/libraries')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          name: 'New Library'
          // Missing required fields
        });

      expect(response.status).toBe(400);
      expect(response.body.errors).toBeDefined();
    });
  });
});
```

---

### 3. Contract Testing with Pact

For microservices or external integrations:

```javascript
const { Pact } = require('@pact-foundation/pact');

describe('Audiobookshelf Consumer', () => {
  const provider = new Pact({
    consumer: 'MyApp',
    provider: 'Audiobookshelf',
    port: 1234
  });

  beforeAll(() => provider.setup());
  afterAll(() => provider.finalize());

  describe('GET /api/libraries', () => {
    beforeEach(() => {
      return provider.addInteraction({
        state: 'libraries exist',
        uponReceiving: 'a request for libraries',
        withRequest: {
          method: 'GET',
          path: '/api/libraries',
          headers: {
            Authorization: 'Bearer valid_token'
          }
        },
        willRespondWith: {
          status: 200,
          headers: {
            'Content-Type': 'application/json'
          },
          body: {
            libraries: Pact.eachLike({
              id: 'lib_123',
              name: 'Audiobooks',
              mediaType: 'book'
            })
          }
        }
      });
    });

    it('should fetch libraries', async () => {
      const response = await client.getLibraries();
      expect(response.libraries).toHaveLength(1);
    });
  });
});
```

---

## Migration Plan

### Option A: Gradual Migration (Recommended)

**Pros:** Lower risk, incremental improvements, continuous delivery
**Timeline:** 2-3 months

**Steps:**

1. **Week 1-2: Foundation**
   - ✅ Create initial OpenAPI structure
   - ✅ Document authentication
   - ✅ Set up tooling

2. **Week 3-6: Core Endpoints**
   - Document most-used endpoints (Libraries, Items, Users)
   - Add schema definitions
   - Implement validation tests

3. **Week 7-10: Remaining Endpoints**
   - Document less common endpoints
   - Add comprehensive examples
   - Validate all responses

4. **Week 11-12: Polish & Deploy**
   - Generate interactive docs
   - Set up CI/CD
   - Deploy to production

---

### Option B: Big Bang Migration

**Pros:** Complete immediately, consistent approach
**Cons:** Higher risk, longer development time
**Timeline:** 1-2 months focused effort

**Steps:**

1. **Week 1-2: Complete Spec**
   - Document all 135 endpoints at once
   - Define all schemas
   - Add all examples

2. **Week 3-4: Validation**
   - Implement validation middleware
   - Write comprehensive tests
   - Fix all schema mismatches

3. **Week 5-6: Documentation & Deployment**
   - Generate documentation
   - Set up CI/CD
   - Deploy to production

---

## Recommended Tools & Packages

### Documentation Generation

| Tool | Purpose | License |
|------|---------|---------|
| [Swagger UI](https://swagger.io/tools/swagger-ui/) | Interactive API explorer | Apache 2.0 |
| [ReDoc](https://github.com/Redocly/redoc) | Beautiful API docs | MIT |
| [Stoplight Elements](https://github.com/stoplightio/elements) | Modern API docs | Apache 2.0 |
| [RapiDoc](https://github.com/rapi-doc/RapiDoc) | Fast, customizable docs | MIT |

### Specification Tools

| Tool | Purpose | License |
|------|---------|---------|
| [swagger-jsdoc](https://github.com/Surnet/swagger-jsdoc) | Generate spec from JSDoc | MIT |
| [swagger-cli](https://github.com/APIDevTools/swagger-cli) | Validate & bundle specs | MIT |
| [openapi-diff](https://github.com/OpenAPITools/openapi-diff) | Detect breaking changes | Apache 2.0 |
| [Stoplight Studio](https://stoplight.io/studio) | Visual spec editor | Free |

### Validation Tools

| Tool | Purpose | License |
|------|---------|---------|
| [express-openapi-validator](https://github.com/cdimascio/express-openapi-validator) | Runtime validation | MIT |
| [jest-openapi](https://github.com/openapi-library/OpenAPIValidators/tree/master/packages/jest-openapi) | Test validation | MIT |
| [prism](https://github.com/stoplightio/prism) | Mock server | Apache 2.0 |
| [dredd](https://github.com/apiaryio/dredd) | API testing | MIT |

---

## Implementation Examples

### Full OpenAPI Spec Template

```yaml
openapi: 3.1.0

info:
  title: Audiobookshelf API
  version: 2.0.0
  description: |
    Complete REST API for the Audiobookshelf audiobook and podcast server.

    ## Authentication

    Use Bearer token authentication with your API token or user token.

    ## Rate Limiting

    Currently no rate limits enforced.

    ## Pagination

    List endpoints support `?limit=` and `?page=` query parameters.

  contact:
    name: Audiobookshelf Support
    url: https://github.com/advplyr/audiobookshelf
  license:
    name: GPL-3.0
    url: https://github.com/advplyr/audiobookshelf/blob/master/LICENSE

servers:
  - url: https://abs.example.com
    description: Production server
  - url: http://localhost:13378
    description: Development server

tags:
  - name: Authentication
    description: Login, logout, and token management
  - name: Libraries
    description: Library management and browsing
  - name: Items
    description: Library item operations
  - name: Users
    description: User account management
  - name: Share
    description: Media sharing capabilities
  - name: Emails
    description: Email and eReader integration

paths:
  /login:
    post:
      summary: Login
      description: Authenticate and receive an API token
      tags: [Authentication]
      operationId: login
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - username
                - password
              properties:
                username:
                  type: string
                  example: "admin"
                password:
                  type: string
                  format: password
                  example: "password123"
      responses:
        '200':
          description: Successfully authenticated
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/LoginResponse'
        '401':
          description: Invalid credentials
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /api/libraries:
    get:
      summary: Get All Libraries
      description: Retrieve list of all libraries accessible to the user
      tags: [Libraries]
      operationId: getLibraries
      security:
        - bearerAuth: []
      responses:
        '200':
          description: List of libraries
          content:
            application/json:
              schema:
                type: object
                properties:
                  libraries:
                    type: array
                    items:
                      $ref: '#/components/schemas/Library'
        '401':
          $ref: '#/components/responses/Unauthorized'

    post:
      summary: Create a Library
      description: Create a new library (admin only)
      tags: [Libraries]
      operationId: createLibrary
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateLibraryRequest'
      responses:
        '200':
          description: Library created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Library'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      description: User token or API key

  schemas:
    LoginResponse:
      type: object
      properties:
        user:
          $ref: '#/components/schemas/User'
        userDefaultLibraryId:
          type: string
          nullable: true
        serverSettings:
          $ref: '#/components/schemas/ServerSettings'
        ereaderDevices:
          type: array
          items:
            $ref: '#/components/schemas/EReaderDevice'

    User:
      type: object
      required:
        - id
        - username
        - type
        - token
      properties:
        id:
          type: string
          example: "user_123"
        username:
          type: string
          example: "admin"
        type:
          type: string
          enum: [root, admin, user, guest]
          example: "admin"
        token:
          type: string
          description: API authentication token
          example: "eyJhbGci..."
        email:
          type: string
          format: email
          nullable: true
        isActive:
          type: boolean
          default: true
        isLocked:
          type: boolean
          default: false
        librariesAccessible:
          type: array
          items:
            type: string
          description: List of library IDs the user can access
        permissions:
          $ref: '#/components/schemas/Permissions'

    Library:
      type: object
      required:
        - id
        - name
        - folders
        - displayOrder
        - icon
        - mediaType
      properties:
        id:
          type: string
          example: "lib_123"
        name:
          type: string
          example: "Audiobooks"
        folders:
          type: array
          items:
            $ref: '#/components/schemas/Folder'
        displayOrder:
          type: integer
          minimum: 1
          example: 1
        icon:
          type: string
          example: "database"
        mediaType:
          type: string
          enum: [book, podcast]
        provider:
          type: string
          example: "google"
        settings:
          $ref: '#/components/schemas/LibrarySettings'
        createdAt:
          type: integer
          format: int64
          description: Unix timestamp in milliseconds
        lastUpdate:
          type: integer
          format: int64

    Error:
      type: object
      required:
        - message
      properties:
        message:
          type: string
          example: "Invalid credentials"
        error:
          type: string
        errors:
          type: array
          items:
            type: object

  responses:
    Unauthorized:
      description: Authentication required
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            message: "Unauthorized"

    Forbidden:
      description: Insufficient permissions
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            message: "Forbidden - Admin access required"

    BadRequest:
      description: Invalid request
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            message: "Validation failed"
            errors: ["Name is required", "Folders must not be empty"]
```

---

## Next Steps

1. **Decision:** Choose migration approach (gradual vs big bang)
2. **Setup:** Install OpenAPI tools
3. **Start:** Begin with high-traffic endpoints
4. **Test:** Implement validation in CI/CD
5. **Deploy:** Generate and publish documentation

---

## Resources

- **OpenAPI Specification:** https://spec.openapis.org/oas/latest.html
- **Swagger Tools:** https://swagger.io/tools/
- **OpenAPI Generator:** https://openapi-generator.tech/
- **API Testing Guide:** https://www.postman.com/api-testing/
- **Contract Testing:** https://pact.io/

---

**Ready to modernize your API documentation? Start with Phase 1 today!**
