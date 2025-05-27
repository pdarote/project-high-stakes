# Next.js

Next.js Coding Standard

## 0. Project Root

All Next.js related code must be contained within the `/nextjs` folder at the project root:

```
digital_name_card/
├─ nextjs/          # All Next.js project files
│  ├─ app/
│  ├─ components/
│  ├─ lib/
│  ├─ package.json  # Project dependencies
│  └─ ...
└─ flutter/        # Flutter project files
```

## 1. Dependency Management

1. **Package Installation Requirements**

   - Always specify when new packages need to be installed
   - Include the exact installation command
   - Mention any peer dependencies
     Example format:

   ```
   Required packages:
   npm install package-name@version
   # or
   yarn add package-name@version
   ```

2. **Version Management**

   - Specify exact versions for critical dependencies
   - Document any specific version requirements
   - Note any potential version conflicts

3. **Development Dependencies**
   - Clearly distinguish between dependencies and devDependencies
   - Installation format:
   ```
   npm install -D package-name@version
   # or
   yarn add -D package-name@version
   ```

## 2. Project Structure

1. **App Router Structure**

   - Use the new `/app` directory for Next.js 13+ applications
   - Organize routes using folder-based file system structure

   ```
   digital_name_card/
   └─nextjs/
      └─app/
         ├─ components/
         │  ├─ ui/
         │  └─ shared/
         ├─ lib/
         │  ├─ utils/
         │  └─ hooks/
         ├─ services/
         ├─ types/
         ├─ (auth)/
         │  ├─ login/
         │  └─ register/
         ├─ (dashboard)/
         │  ├─ layout.tsx
         │  └─ page.tsx
         └─ layout.tsx
   ```

2. **Component Organization**

   - **UI Components**: Reusable UI elements in `/components/ui`
   - **Shared Components**: Business logic components in `/components/shared`
   - **Page Components**: Route-specific components in their respective route folders

3. **Additional Directories**
   - **/lib**: Utility functions, custom hooks, and helpers
   - **/services**: API calls and external service integrations
   - **/types**: TypeScript type definitions
   - **/public**: Static assets

## 3. Naming Conventions

1. **Files and Folders**

   - Use **kebab-case** for folders and files (e.g., `user-profile`)
   - Special Next.js files use their exact names (e.g., `page.tsx`, `layout.tsx`, `loading.tsx`)

2. **Components**

   - Use **PascalCase** for component files and names (e.g., `UserProfile.tsx`)
   - Suffix test files with `.test` or `.spec` (e.g., `UserProfile.test.tsx`)

3. **Functions and Variables**

   - Use **camelCase** for functions, variables, and hooks
   - Prefix custom hooks with "use" (e.g., `useAuth`, `useUser`)

4. **Types and Interfaces**
   - Use **PascalCase** with descriptive names
   - Suffix interfaces with props when used for components (e.g., `UserProfileProps`)

## 4. Coding Style

1. **TypeScript Usage**

   - Enforce strict TypeScript checks
   - Avoid `any` type - use proper typing
   - Use interface for objects and type for unions/intersections

2. **Component Structure**

   ```typescript
   // Import order
   import { external } from 'library';
   import { internal } from '@/components';
   import { styles } from './styles';

   // Types at the top
   interface ComponentProps {
     // props definition
   }

   // Component definition
   export function Component({ prop1, prop2 }: ComponentProps) {
     // hooks at the top
     // business logic
     // render
   }
   ```

3. **State Management**
   - Use React's built-in hooks for simple state
   - Consider Zustand or Jotai for complex state
   - Implement context sparingly and only when needed

## 5. Data Fetching

1. **Server Components**

   - Default to Server Components
   - Use async components for direct data fetching

   ```typescript
   async function ProductList() {
     const products = await fetchProducts();
     return <div>{/* render products */}</div>;
   }
   ```

2. **Client Components**

   - Mark with 'use client' directive
   - Use SWR or TanStack Query for client-side data fetching

   ```typescript
   'use client';

   import { useQuery } from '@tanstack/react-query';
   ```

3. **API Routes**
   - Organize under `app/api` directory
   - Use proper HTTP methods and status codes
   - Implement proper error handling and validation

## 6. Performance Optimization

1. **Image Optimization**

   - Use Next.js Image component
   - Implement proper loading strategies

   ```typescript
   import Image from 'next/image';

   <Image src={src} alt={alt} width={width} height={height} loading="lazy" />;
   ```

2. **Code Splitting**
   - Use dynamic imports for large components
   - Implement proper loading states
   ```typescript
   const DynamicComponent = dynamic(() => import('./Heavy'), {
     loading: () => <Loading />,
   });
   ```

## 7. Testing Practices

1. **Test File Structure**
   - Place tests next to the component they test
   - Use `.test.tsx` or `.spec.tsx` suffix
   ```
   components/
   ├─ Button/
   │  ├─ Button.tsx
   │  ├─ Button.test.tsx
   │  └─ __snapshots__/
   │     └─ Button.test.tsx.snap
   ```

2. **Component Testing Workflow**
   - Every new component must include:
     - Unit tests
     - Snapshot tests
     - Integration tests (when applicable)
   - Minimum test coverage requirement: 80%

3. **Snapshot Testing**
   - Use Jest snapshot testing for UI regression
   ```typescript
   import { render } from '@testing-library/react'
   import Button from './Button'

   describe('Button', () => {
     it('should match snapshot', () => {
       const { container } = render(<Button>Click me</Button>)
       expect(container).toMatchSnapshot()
     })

     it('should match snapshot in different states', () => {
       const { container } = render(<Button disabled>Click me</Button>)
       expect(container).toMatchSnapshot()
     })
   })
   ```

4. **Unit Testing**
   - Test component logic and behavior
   - Use React Testing Library's best practices
   ```typescript
   import { render, screen, fireEvent } from '@testing-library/react'
   import Button from './Button'

   describe('Button', () => {
     it('should call onClick when clicked', () => {
       const handleClick = jest.fn()
       render(<Button onClick={handleClick}>Click me</Button>)
       
       fireEvent.click(screen.getByText('Click me'))
       expect(handleClick).toHaveBeenCalledTimes(1)
     })

     it('should not call onClick when disabled', () => {
       const handleClick = jest.fn()
       render(<Button disabled onClick={handleClick}>Click me</Button>)
       
       fireEvent.click(screen.getByText('Click me'))
       expect(handleClick).not.toHaveBeenCalled()
     })
   })
   ```

5. **Test Commands**
   ```bash
   # Run all tests
   npm test

   # Update snapshots
   npm test -- -u

   # Run tests with coverage
   npm test -- --coverage

   # Run tests in watch mode
   npm test -- --watch
   ```

6. **Testing Best Practices**
   - Test component behavior, not implementation
   - Use semantic queries (getByRole, getByLabelText) over getByTestId
   - Test accessibility when applicable
   - Mock external dependencies and API calls
   - Use test fixtures for complex data structures
   ```typescript
   // fixtures/user.ts
   export const mockUser = {
     id: '1',
     name: 'John Doe',
     email: 'john@example.com'
   }

   // UserProfile.test.tsx
   import { mockUser } from '../fixtures/user'
   
   it('should render user information', () => {
     render(<UserProfile user={mockUser} />)
     expect(screen.getByText(mockUser.name)).toBeInTheDocument()
   })
   ```

## 8. Error Handling

1. **Error Boundaries**

   - Implement custom error boundaries
   - Use error.tsx files for route error handling
   - Provide meaningful error messages

2. **API Error Handling**
   - Use proper HTTP status codes
   - Implement consistent error response format
   - Handle errors gracefully on the client side

## 9. Security

1. **Authentication**

   - Use Next-Auth or similar for authentication
   - Implement proper session management
   - Use secure cookies and HTTP-only flags

2. **Data Protection**
   - Validate all input data
   - Implement proper CORS policies
   - Use environment variables for sensitive data

## 10. Deployment

1. **Environment Configuration**

   - Use `.env` files properly
   - Keep sensitive data in environment variables
   - Document required environment variables

2. **Build Process**
   - Optimize builds for production
   - Implement proper CI/CD pipelines
   - Use caching strategies effectively

## 11. Theme Implementation

1. **Theme Structure**

   - Use shared design tokens from `/design-tokens` directory as single source of truth
   - Implement theme using the following structure:

   ```
   digital_name_card/nextjs/
   └─theme/
      ├─ theme.ts        # Main theme configuration
      ├─ colors.ts      # Color definitions from design tokens
      ├─ typography.ts  # Typography styles
      └─ components/    # Component-specific theme settings
   ```

2. **Theme Configuration**

   - Use TypeScript types and interfaces for type-safe theme values
   - Support both light and dark themes using design token values
   - Example theme configuration:

   ```typescript
   interface AppTheme {
     colors: {
       primary: string;
       secondary: string;
       background: string;
       text: string;
       // ... other colors from design tokens
     };
     typography: {
       h1: TextStyle;
       body: TextStyle;
       // ... other typography from design tokens
     };
   }

   export const lightTheme: AppTheme = {
     colors: {
       primary: designTokens.colors.primary[500],
       secondary: designTokens.colors.secondary[500],
       // ... other color mappings
     },
     // ... other theme values
   };
   ```

3. **Theme Usage**

   - Use styled-components or emotion for consistent theme access
   - Access theme values directly through theme object
   - Never use hardcoded values - always reference theme tokens
   - Example usage with styled-components:

   ```typescript
   import styled from 'styled-components';

   const StyledButton = styled.button`
     background-color: ${({ theme }) => theme.colors.primary};
     font-size: ${({ theme }) => theme.typography.body.fontSize}px;
     font-weight: ${({ theme }) => theme.typography.body.fontWeight};
   `;
   ```

4. **Theme Provider Setup**

   - Wrap application with ThemeProvider
   - Implement theme switching functionality using context

   ```typescript
   import { ThemeProvider } from 'styled-components';
   import { useThemeContext } from '@/theme/ThemeContext';

   export function RootLayout({ children }) {
     const { theme } = useThemeContext();
     return <ThemeProvider theme={theme}>{children}</ThemeProvider>;
   }
   ```
