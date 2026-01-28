# TechTake UI Specification

This document details the visual design and user interface layout for the **TechTake** application.

## 1. Design Language & Aesthetics
The application follows a **Minimalist Dark Mode** aesthetic, leveraging **Glassmorphism** and high-contrast typography. It uses a premium, developer-centric look inspired by modern IDEs and high-end fintech apps.

- **Primary Font**: 'Inter' (San-serif) for general UI.
- **Monospace Font**: 'JetBrains Mono' for technical labels and loading states.
- **Corner Radius**: Large rounded corners (up to `40px` for cards, `32px` for buttons) for a soft, modern feel.
- **Animations**: Subtle vertical bounces for swipe hints, smooth cross-fades for transitions, and progress bar expansions.

---

## 2. Color Palette

| Element | Color Name | Hex Code | Visual Usage |
| :--- | :--- | :--- | :--- |
| **Background** | Pure Black | `#000000` | Entire app background. |
| **Primary Accent** | Emerald 400 | `#34D399` | Logo, primary buttons, progress bars, active icons. |
| **Glow Accent** | Emerald 500 | `#10B981` | Background decorative blur, button shadows. |
| **Text (Primary)** | Pure White | `#FFFFFF` | Headings, active text, button labels. |
| **Text (Muted)** | White (40%) | `#FFFFFF66` | Descriptions, uppercase labels, secondary info. |
| **Card Surface** | Dark Gradient | `#1A1A1A` → `#0A0A0A` | Main word cards and panels. |
| **Glass Layer** | Glass Black | `rgba(0,0,0,0.7)` | Headers and overlay panels. |
| **Border** | Subtle White | `rgba(255,255,255,0.1)` | Card outlines, dividers, input fields. |

---

## 3. Global Components

### Header
- **Layout**: Fixed at top. Left-aligned logo (`logo provided` icon) and title "TechTake".
- **Notification Bell UI**: 
  - **Icon**: `Bell` (Lucide).
  - **Inactive State**: Background `bg-white/5`, border `1px solid border-white/10`, icon color `text-white/60`.
  - **Hover State**: Icon color shifts to `text-white`.
  - **Active/Tapped State**: When the notification view is active, the button background transforms to Emerald 400 (`#34D399`), the border becomes `border-emerald-400/20`, and the icon color switches to `text-black`.
  - **Indicator**: A solid Emerald dot (`#34D399`) with a `1px` black border appears at the top-right corner (`top-0`, `right-0`) of the button when new XP is earned.
  - *Interaction: Opens the profile view to show user statistics and technical mastery progress.*
- **Visual**: Glass effect (`backdrop-filter: blur(12px)`) with a bottom border (`rgba(255,255,255,0.1)`).

### Bottom Navigation
- **Layout**: Fixed at bottom. Four equally spaced buttons: Home, Path, Find, Saved.
- **Icon Set (Lucide)**:
  - **Home**: `Home`
  - *Interaction: Sets the current view to 'home' and ensures a fresh daily discovery word is visible.*
  - **Path**: `Layers`
  - *Interaction: Sets the current view to 'phases', displaying the hierarchical curriculum roadmap.*
  - **Find**: `Search`
  - *Interaction: Sets the current view to 'find' to access the local SQLite-powered search feature.*
  - **Saved**: `Bookmark`
  - *Interaction: Sets the current view to 'favorites' to view the user's personal Knowledge Bank collection.*
- **Look & Feel**:
  - **Active State**: Icon color `text-emerald-400`. A soft emerald pill background (`bg-emerald-400/10`) surrounds the icon. Label is `text-emerald-400`, `9px`, `font-black`, and uppercase.
  - **Inactive State**: Icon color `text-white/20`. Label is `text-white/20`, `9px`, `font-black`, and uppercase.
- **Visual**: Dark glass effect (`rgba(0,0,0,0.85)`) with a `1px` top border and a bottom shadow (`shadow-[0_-10px_30px_rgba(0,0,0,0.5)]`).

---

## 4. Page-by-Page Breakdown

### Home View 
- **Centered Card**: Displays a "Daily Mix" word card generated from the curriculum with the learning view mentioned below.
- **Interaction**: Words are randomly selected from the predefined curriculum to ensure high-quality, relevant learning.
- **Action Gesture**: A down arrow "Swipe to new word" button with a spinning `Down arrow` icon (`#34D399`). 
- *Interaction: Triggers a fresh randomized lookup from the curriculum and updates the Word Card display.*
- **Background**: Soft emerald blur in the top-right corner.

### Learning View (Word Detail)
The Learning View is contained within a high-fidelity **Word Card** (`68vh` height, `40px` radius) that uses deep layering and precise typography to convey technical depth.

- **Background & Surface**:
  - **Main Surface**: `card-gradient` (`#1A1A1A` to `#0A0A0A`).
  - **Glass Overlay**: `rgba(0,0,0,0.7)` with `12px` backdrop-blur.
  - **Top Edge Accent**: A `4px` top border using `#34D399` at `50%` opacity.
  - **Outer Border**: `1px` solid `rgba(255,255,255,0.1)`.

- **Header Spans & Labels**:
  - **Phase Label**: Top-left position. `8px` font, `900` weight (Black), `0.2em` letter spacing. Color: `rgba(255,255,255,0.4)`. Uppercase.
  - **Chapter Label**: Directly below Phase. `11px` font, `800` weight (Extra Bold). Color: Emerald 400 (`#34D399`). Uppercase.
  - **Word Title**: Large `24px` heading. `900` weight. Pure white (`#FFFFFF`).
  - **Section Headers**: Inside tabs (e.g., "The Definition"). `9px` font, `700` weight. Color: Emerald 400. `0.1em` letter spacing.

- **Content Icons (Lucide Library)**:
  - **"The Take" Icon**: `BookOpen`.
  - **"Usage" Icon**: `Target`.
  - **"Story" Icon**: `Quote`.
  - **"Context" Icon**: `Info`.
  - **"Context Question" Icon**: `MessageSquare` (wrapped in `bg-white/10` circle).
  - **"Expert Answer" Indicator**: Solid Emerald Dot (`#34D399`).

- **Content Tabs (Internal Display Logic)**:
  1.  **"The Take" Tab**:
      - **The Definition**: Large `18px` text, `font-medium`, `leading-snug`, color `white/90`.
      - **Why It Exists**: `14px` text, `leading-relaxed`, color `white/70`.
  2.  **"Usage" Tab**:
      - **How To Use**: `14px` descriptive text, color `white/80`.
      - **Use / Avoid Box**: Rounded `2xl` container (`bg-white/5`). `14px` italic text, color `white/70`.
  3.  **"Story" Tab**:
      - **Analogy Container**: Left-bordered with `2px` Emerald (`#34D3994D`).
      - **Typography**: `16px` font-serif, italic text, `leading-relaxed`, color `white/90`.
  4.  **"Context" Tab**:
      - **Question**: `14px` font-bold, italic text, preceded by the `MessageSquare` icon.
      - **Expert Answer Box**: Rounded `3xl` container (`bg-white/5`). Preceded by an Emerald `1.5px` dot indicator. `14px` text, color `white/80`.

- **Tab Navigation Bar (Bottom of Card)**:
  - **Container**: Flex row with `bg-black/40`, `p-1`, and `2xl` rounding.
  - **Active State**: `bg-white`, `text-black`. Smooth `0.3s` background transition.
  - **Inactive State**: `text-white/40`. Icons sized `14px`.
  - **Labels**: Tiny `8px` font, `extra-bold`, uppercase, tracking-tighter.
  - *Interaction: Updates the visible word content section (Definition, Usage, Story, Context).*

- **Action Buttons (Top Right)**:
  - **Circular Icons**: `p-2` buttons with `bg-white/5` and `full` rounding.
  - **Active Hover**: `bg-white/10`.
  - **Icons**: Volume (TTS) and Bookmark (Save), sized `16px`.
  - *Interaction (Volume): Plays the technical pronunciation of the word using system/default high-fidelity TTS service.*
  - *Interaction (Bookmark): Toggles the current word in the user's favorites collection for later study.*

### Mastery Phases View (Path)
The Mastery Phases View is a high-impact curriculum dashboard utilizing expansive **Phase Cards** (`40px` radius) that visually represent user progression through layered depth.

- **Phase Card Surface**:
  - **Base Layer**: `bg-white/5` with a `1px` solid `border-white/10`.
  - **Atmospheric Glow**: An `absolute` top-right radial gradient (`emerald-400/5` at `128px` width) that blurs into the background.
  - **Interactive State**: `hover:border-emerald-400/50` with a subtle `active:scale-[0.98]` compression.
  - *Interaction: Navigates the user to the Chapters View specifically for the selected technical milestone phase.*

- **Card Header Elements**:
  - **Phase Indicator**: Top-left position. `9px` font, `900` weight. Color: Emerald 400 (`#34D399`). Uppercase, `0.2em` letter spacing. Displays as "PHASE X".
  - **Progress Percent**: Top-right position. `10px` font, `900` weight. Color: `white/20`. Uppercase.

- **Main Body Content**:
  - **Phase Title**: Large `21px` heading. `900` weight. Pure white (`#FFFFFF`). Transition color to Emerald 400 on hover.
  - **Phase Description**: `14px` font, `500` weight (Medium). Color: `white/40`. `leading-relaxed` for readability.

- **Progress Infrastructure**:
  - **Track Container**: Bottom-aligned. Full-width, `4px` height, `bg-white/5` rounding.
  - **Progress Fill**: Dynamic width. `bg-emerald-400`. `700ms` ease-out transition on mount displaying percentage of words learned in that phase.

### Chapters View
The Chapters View organizes specific technical domains into digestible horizontal modules, maintaining the dark-glass aesthetic established in the Path view.

- **Navigation Header**:
  - **Back Button**: Circular `p-2` button with `bg-white/5` rounding. Uses `ChevronLeft` icon.
  - *Interaction: Reverts the view state to the primary Mastery Phases roadmap.*
  - **Typography & Labels**:
    - **View Title**: `24px` font, `900` weight (Black). Pure white.
    - **Phase Context**: `9px` font, `900` weight. Color: Emerald 400 (`#34D399`). Uppercase with `0.2em` letter spacing.

- **Chapter Card Surface**:
  - **Shape**: Wide, horizontal module with a `32px` corner radius.
  - **Layering**: `bg-white/5` base with `1px` solid `border-white/10`.
  - **States**: `hover:border-emerald-400/50` with a subtle `active:scale-[0.98]` compression for tactile feedback.
  - *Interaction: Transitions the user to the Word List View for the specific domain selected.*

- **Internal Content Typography**:
  - **Chapter Title**: `18px` font, `900` weight. Transition to Emerald 400 on hover of the entire card.
  - **Progress Text**: `10px` font, `900` weight. Uppercase with `widest` tracking.
  - **Visual Logic**:
    - **Incomplete State**: Label is `text-white/40`. Action icon is `text-white/10`.
    - **Complete State**: Label is `text-emerald-400`. Action icon container background switches to `bg-emerald-400/10` with `text-emerald-400` icon.

- **Action Indicators**:
  - **Icon**: `ArrowRight` (Lucide) sized `20px`.
  - **Container**: Fully rounded `p-2` element.

### Word List View
The Word List View presents a dense grid of technical vocabulary within the selected chapter, using pill-based navigation.

- **Navigation Header**:
  - **Back Button**: Circular `p-2` button with `bg-white/5`.
  - *Interaction: Returns the user to the Chapters View within the current mastery phase.*
  - **Typography**: Chapter title in `20px` font-black. Subtitle in `10px` font-black, `white/40`, uppercase with `0.2em` letter spacing.

- **Word Pill Configuration**:
  - **Grid**: 2-column layout with `gap-3`.
  - **Shape**: Fully rounded (`rounded-full`) pill buttons.
  - **Typography**: `13px` font, `900` weight (Black). Uppercase. `tracking-tighter`.
  - **Mastered State**: `bg-[#34D3991A]` (10% emerald opacity), `border-emerald-400/30`, `text-emerald-400`.
  - **Unlearned State**: `bg-white/5`, `border-white/10`, `text-white/40`.
  - **Interaction**: `active:scale-95` with `transition-all`.
  - *Interaction: Initiates a hybrid content fetch and navigates to the detailed Learning View card.*

### Find View (Global Search)
The Find View serves as a command-line inspired interface for exploring the entire technical landscape.

- **Search Infrastructure**:
  - **Input Field**: Large `rounded-[32px]` container. `bg-white/5`, `border-white/10`.
  - **Interaction States**: `focus:border-emerald-400` with an outer glow (`ring-emerald-400/20`).
  - **Action Button**: Absolute positioned right-aligned circle. `bg-emerald-400`, `text-black`. `shadow-lg` with emerald tint.
  - *Interaction: Submits the search query to local SQLite storage.*

- **Feedback & Synthesis States**:
  - **Loading Spinner**: 3px width, `border-emerald-400/20` track with `border-t-emerald-400` head. `animate-spin`.
  - **Status Text**: `JetBrains Mono` font, `10px`, `white/40`. `animate-pulse`. Uppercase.
  - **Result Integration**: Displays the generated term as a full **Word Card as described in Learning View** with enter animation (`zoom-in-95`).

### Saved (Bookmark) View
The Saved View is the user's personal "Knowledge Bank", providing organized access to previously bookmarked terms.

- **List Architecture**:
  - **Sectioning**: Groups of terms organized by their `conceptId` (Chapter).
  - **Group Header**: `10px` font-black, `white/30`, uppercase with `0.2em` tracking. Preceded by a `Folder` icon (`emerald-400/50`).

- **Entry Aesthetics**:
  - **Surface**: `bg-white/5` rounded `2xl` containers.
  - **State Transitions**: `hover:border-emerald-400/30`. Title text transitions to `emerald-400`.
  - *Interaction: Opens a high-fidelity full-screen overlay displaying the detailed Word Card for study.*
  - **Actions**: `Trash2` icon for quick removal, colored `white/10` transitioning to `red-400` on hover.
  - *Interaction: Immediately removes the selected term from the Knowledge Bank library.*

- **Overlay Interaction**:
  - **Modal Surface**: `fixed inset-0`, `bg-black/90` with `12px` backdrop-blur.
  - **Transition**: `zoom-in-95` entry animation.
  - **Dismissal**: Absolute positioned `X` (Trash/Close) button in `bg-white/5`.
  - *Interaction: Closes the active Word Card overlay and returns the user to the Knowledge Bank list.*

### Notification View (Accessed via Bell Icon)
- **List View**: Displays notification.


---

## 5. Database

For the native version of TechTake, the application transitions from simple `localStorage` to a robust **SQLite** database to handle hundreds of technical terms, metadata, and user progress efficiently.

### Schema: `words` Table
Stores both pre-authored curriculum terms and AI-generated custom terms.

| Column | Type | Description |
| :--- | :--- | :--- |
| `id` | TEXT (PK) | Unique word identifier (e.g., `word-bit-static`). |
| `word` | TEXT | The technical term (indexed). |
| `theTake` | TEXT | One-sentence punchy definition. |
| `howToUse` | TEXT | Implementation guidance. |
| `story` | TEXT | Analogy/Mental model. |
| `whyItExists` | TEXT | Problem statement. |
| `useAvoid` | TEXT | Trade-offs and recommendations. |
| `category` | TEXT | Phase title (e.g., Phase 1: The Foundation). |
| `conceptId` | TEXT | Chapter title (e.g., DNS). |
| `conversationQ` | TEXT | Stakeholder question from context. |
| `conversationA` | TEXT | Expert answer from context. |

### Schema: `user_stats` Table
Tracks mastery and engagement.

| Column | Type | Description |
| :--- | :--- | :--- |
| `key` | TEXT (PK) | Setting or stat name (e.g., `xp`, `streak`). |
| `value` | INTEGER | Numeric value for the stat. |

### Schema: `mastery` Table
Join table for user-word relationships.

| Column | Type | Description |
| :--- | :--- | :--- |
| `word_id` | TEXT (FK) | Reference to `words.id`. |
| `is_mastered` | BOOLEAN | Whether the user has learned the word. |
| `is_favorite` | BOOLEAN | Whether the word is bookmarked. |
| `last_viewed` | DATETIME | Timestamp for SRS (Spaced Repetition) logic. |

---

## 6. Phases, Chapters and Words

This section outlines the full curriculum available in the application, organized by learning milestones.

### Phase 1: The Foundation
*Hardware, OS, and fundamental computer connectivity.*
- **The Language of Machines**: Bit, Byte, Binary, Latency, Bandwidth, Throughput, Ping, Packet Loss, Buffer, Hardware, CPU, RAM, SSD
- **The Operating System (Kernel)**: Kernel, Process, Thread, Context Switch, Scheduler, Deadlock, System Call, Virtual Memory, Daemon, Bootloader, User Space, Kernel Space
- **The Command Line (Shell & Files)**: CLI, Shell, Bash, Terminal, Root, Permissions (chmod), Path, Standard Output (stdout), Pipe, Script, Sudo, File System
- **How the Internet Connects**: IP Address, DNS, Domain, Protocol, TCP/IP, Router, ISP, VPN, Firewall, Port, Gateway, MAC Address, Subnet
- **Speaking Web (HTTP)**: Client, Server, URL, HTTP/HTTPS, Request, Response, Status Code, Header, Body, Cookies, Cache, Session, TTL
- **Data Formats**: JSON, XML, YAML, CSV, Key-Value, Syntax, Parsing, String, Integer, Boolean, Array, Object, Serialization

### Phase 2: The Logic
*CS fundamentals: organizing data and solving problems.*
- **Data Structures (Containers)**: Linked List, Stack, Queue, Hash Map (Dictionary), Binary Tree, Graph, Node, Pointer, Heap, Vector, Matrix, Set
- **Algorithms (Recipes)**: Sorting, Recursion, Binary Search, Iteration, Brute Force, Divide and Conquer, Dynamic Programming, Greedy, Backtracking, Traversal, Memoization
- **Complexity (Big O)**: Big O Notation, Time Complexity, Space Complexity, Constant Time O(1), Linear Time O(n), Logarithmic O(log n), Exponential, Worst Case, Optimization, Bottleneck, Trade-off

### Phase 3: The Concepts
*High-level theories and engineering philosophies.*
- **Programming Paradigms**: OOP (Object Oriented), Functional Programming, Imperative, Declarative, Class, Object, Inheritance, Polymorphism, Encapsulation, Abstraction, Immutability, Pure Function, Side Effect
- **Code Quality Principles**: SOLID, DRY (Don't Repeat Yourself), KISS (Keep It Simple), YAGNI (You Ain't Gonna Need It), Clean Code, Separation of Concerns, Coupling, Cohesion, Dependency Injection, Refactoring, Technical Debt
- **System Design Fundamentals**: Horizontal Scaling, Vertical Scaling, Load Balancing, Caching, CDN (Content Delivery Network), Proxy, Reverse Proxy, High Availability, Fault Tolerance, Single Point of Failure (SPOF), CAP Theorem, Consistent Hashing
- **Testing & Reliability Strategies**: Unit Test, Integration Test, End-to-End (E2E), TDD (Test Driven Development), Mocking, Stubbing, Code Coverage, Regression Testing, Smoke Test, Flaky Test, Black Box vs. White Box
- **Asynchronous Concepts**: Synchronous, Asynchronous, Blocking, Non-blocking, Callback, Promise, Future, Event Loop, Concurrency, Parallelism, Race Condition, Thread Safety

### Phase 4: The Application
*Applying concepts to build user-facing software.*
- **Frontend: The Glass**: HTML, CSS, JavaScript, DOM, Framework, Library, Responsive, SPA, UI, UX, Accessibility (a11y), Asset
- **Backend: The Engine**: Server-side, Logic, Environment Variables, API, Endpoint, CRUD, Middleware, Authentication, Cron Job, Script, Runtime
- **How Systems Talk (APIs)**: REST, GraphQL, Webhook, Websocket, SOAP, Payload, Integration, Rate Limit, API Key, Documentation, Throttling
- **Patterns: Mono vs. Micro**: Monolith, Microservices, Decoupling, Service Mesh, Granularity, Modular, Distributed Tracing, Event-Driven, Message Queue, Pub/Sub

### Phase 5: The Memory
*Data persistence and storage systems.*
- **Relational DBs (SQL)**: SQL, Table, Schema, Row, Column, Primary Key, Foreign Key, Join, ACID, Query, Normalization, Migration
- **NoSQL & Flexible Data**: NoSQL, Document Store, MongoDB, Key-Value, Redis, Graph Database, In-memory, Eventually Consistent, Unstructured Data
- **Keeping Data in Sync**: Replication, Sharding, Index, Transaction, Backup, Read Replica, Partition, Write-Ahead Log (WAL), Data Integrity, Optimistic Locking

### Phase 6: The Factory
*Infrastructure, deployment, and DevOps.*
- **Cloud Basics**: The Cloud, AWS, GCP, Azure, SaaS, PaaS, IaaS, Serverless, Region, Availability Zone, On-premise, Multi-cloud
- **Shipping Code (CI/CD)**: CI, CD, Pipeline, Build, Artifact, Staging, Production, Git, Branch, Pull Request, Commit
- **Containers (Docker)**: Container, Image, Docker, VM, Hypervisor, Isolation, Dockerfile, Registry, Daemon, Volume
- **Orchestration (K8s)**: Kubernetes, Cluster, Node, Pod, Control Plane, Ingress, Auto-scaling, Helm, StatefulSet, ConfigMap, Secrets
- **Observability**: Uptime, Downtime, SLA/SLO, Logs, Metrics, Tracing, Monitoring, Alerting, Dashboard, Incident, RCA

### Phase 7: The Brain
*Modern data layers and Artificial Intelligence.*
- **Data Science 101**: Big Data, ETL, Data Warehouse, Data Lake, Analytics, Pipeline, Data Cleaning, Visualization, SQL, Business Intelligence
- **Machine Learning**: Model, Algorithm, Training Data, Inference, Supervised, Unsupervised, Neural Network, Bias, Overfitting, Weights, Parameters
- **Generative AI**: LLM, GPT, Token, Hallucination, Prompt, Fine-tuning, RAG, Multimodal, Vector Database, Context Window, Embeddings

### Phase 8: The Shield
*Protecting the stack and identity.*
- **Identity & Access**: AuthN, AuthZ, OAuth, SSO, MFA, JWT, RBAC, Identity Provider, Principal, Scopes
- **Encryption**: Encryption, Decryption, Hashing, Salt, Public Key, Private Key, SSL/TLS, Certificate, Cipher, E2EE
- **The Attack Surface**: DDoS, Phishing, SQL Injection, Zero-Day, Malware, Ransomware, Vulnerability, Pentest, Firewall, Encryption at Rest

### Phase 9: The Process
*Human collaboration and product lifecycles.*
- **Methodology**: Agile, Waterfall, Scrum, Kanban, Sprint, Standup, Backlog, Velocity, Burndown Chart, Retro, Story Points
- **Product Lifecycle**: MVP, Roadmap, Feature Creep, Spec, Stakeholder, QA, Beta, GA
- **Engineering Reality**: Tech Debt, Refactoring, Legacy Code, Bug, Feature, Hotfix, Edge Case, Trade-off, Documentation, Bus Factor