# Rookie Onboarding

A short concept primer for anyone shipping a software product for the first time. Helpful if you are a product manager starting a new project, a side-project builder, a domain expert who is learning to ship code, or generally new to the moving parts of a software product.

You do not need to write code to use the constitution skill. You will, however, encounter the concepts below in the files it produces. The point of this page is to give you a working grasp of each one in 15 to 20 minutes, so the rest of the skill reads as a tool rather than as a wall of jargon.

This is not a glossary that hides terminology. It is a short reading list that makes the terminology friendlier.

## Reading Order

Skim the whole page once. Come back to a section when you see the term in one of the governance files.

## 1. Spec, Architecture, Rules, Contracts

These are the four kinds of durable documents the skill helps you produce. They answer four different questions.

- **Spec** answers *what does the product do for the user?*
  Goals, users, non-goals, acceptance criteria. No code in here.
- **Architecture** answers *what are the moving parts inside the product, and how do they fit?*
  Modules, data flow, technology choices, deployment shape. Decisions, not opinions.
- **Rules** answers *what does every change in this codebase need to respect?*
  Coding style that matters, testing expectations, safety rails.
- **Contracts** answers *what are the stable interfaces between parts of the product, or between the product and the outside world?*
  API shapes, database table shapes, event payloads, file formats.

A useful mental picture: Spec is the brochure, Architecture is the floor plan, Rules is the house code (electrical, plumbing), Contracts is the door frames that anything passing through must fit.

## 2. Schema And Migrations

A **schema** is the shape of the data your product stores. For example, a `feedback` table with columns `id`, `source`, `message`, `created_at` is a schema. Schemas are usually held inside a database.

A **migration** is a script that changes a schema. For example, "add a `tags` column to the `feedback` table".

Two things to know:

- Once your product has live users, every schema change touches their data. Adding a column is usually safe. Changing the meaning of a column, removing a column, or renaming a column is often risky.
- Migrations are forward-only in most teams. If you make a mistake, you write another migration to fix it; you do not edit the past.

This is why the skill marks any schema change as "Approval Required". You do not need to write migrations. You do need to notice when one is happening.

## 3. APIs And Contracts

An **API** (application programming interface) is the way one piece of software talks to another. The most common shape is a web API: one program sends an HTTP request, another program returns a response in JSON.

A **contract** describes what an API looks like in enough detail that two teams can build against it separately. A contract usually specifies:

- The URL (where to send the request).
- The shape of the request (which fields, what types, what is required).
- The shape of the response (the success case and the failure cases).
- The error envelope (what an error looks like).

Why this matters when building a product: once any other system relies on your API (your own mobile app, a Zapier integration, a partner), changing the API costs you. Treat the contract file as the source of truth and update it before you change the code.

## 4. Authentication And Authorization

Two different things that are often grouped together.

- **Authentication (authn)** is "who are you?"
  Login flows, sessions, tokens, password resets.
- **Authorization (authz)** is "what are you allowed to do?"
  "Only the team owner can delete a workspace." "Free users can see ten feedback items per month."

Both are subtle and easy to get wrong. The most common failure modes are leaking data across users and accidentally granting too much access. This is why the skill marks any change to authn or authz as "Approval Required". You should treat these areas as places where you slow down, even if the change looks small.

## 5. Bounded Task And Vertical Slice

A **bounded task** is a piece of work small enough that one person (or one AI agent) can finish it in one session and someone else can review it. The skill defines hard limits: roughly five files, three hundred lines of changed code, three verification commands.

A **vertical slice** is a piece of product that goes all the way through the stack: a small UI change plus the API change plus the database change, all delivered together, all working end to end.

Both ideas push against the intuition of "let's just build the whole feature". They are how teams ship without breaking the product. When the skill asks you to write a task file, you are practicing this discipline.

## 6. Environment: Production, Staging, Development

A modern software product usually runs in three places.

- **Development** is your laptop. Things can break freely. No real users.
- **Staging** is a copy of the product that runs in the cloud, looking like production but with fake data. Used to test before showing real users.
- **Production** is the real product. Real users. Real data. Real consequences.

The skill marks any production deployment change as "Approval Required" because the blast radius is large. Most casual mistakes are caught in staging; the ones that reach production are the ones that matter.

You will see these three names in `ARCH.md` and in deployment files. The reason for the separation is purely safety.

## 7. Reversible Vs Irreversible Decisions

Some decisions can be undone for free. Others cost you a lot to undo.

- Reversible: picking a font, naming a button, choosing the loop syntax inside a function.
- Irreversible (or expensive to undo): the shape of your database, the URL of your public API, your authentication model, your payment provider integration, how you handle user deletion, your data retention policy.

The skill's "Approval Required" list is exactly the irreversible category. When you read that list, you are reading "decisions that the AI agent must not make alone".

A useful habit: when an agent is about to make a choice, ask yourself "if this turns out wrong, how bad is it to change later?" If the answer is "easy", let the agent run. If the answer is "painful" or "we would need to migrate users", pause.

## 8. Tests And Verification

A **test** is a small program that proves another piece of code behaves as expected. For example, "if I submit feedback with no message, the API returns a 400 error". Tests are run automatically every time the code changes.

Tests do two jobs:

- They catch regressions: code that used to work but stopped working.
- They are the only honest answer to "is this task done?"

In the skill, every task file has a `## Verification` section with exact commands to run. Those commands include tests. You do not need to write tests yourself, but you should refuse to mark a task as done if its verification step has not been run.

## 9. Review

A **review** is a second person (or a second agent) reading a change before it is merged into the codebase. The reviewer asks four questions:

- Does the change do what the task said it would?
- Does it break anything that was working?
- Did it cross any of the boundaries listed in `ARCH.md` and `RULES.md`?
- Did it touch any of the "Approval Required" surfaces without explicit approval?

When the skill talks about Cursor reviewing diffs or a human reviewer approving merges, this is what is being described. Review is not gatekeeping; it is the cheapest place to catch problems.

## 10. The Promotion Habit

This is the most important habit the skill encourages, and it is not technical.

Whenever you find yourself explaining the same thing twice (to an AI agent, to a teammate, to yourself in chat), write it down in one of the durable files. The general rule:

- Said it twice in code review: promote to `RULES.md`.
- Said it twice about an interface: promote to `docs/CONTRACTS/`.
- Said it twice about how the product should behave: promote to `docs/SPEC.md`.
- Said it twice to an agent: promote to `AGENTS.md`.

The point is not bureaucracy. The point is that anything you have to repeat is something the next person (or agent, or future-you) will not know without being told.

## What Next

After you have read this once:

- Open `references/governance-asset-guide.md` for a longer treatment of the file family.
- Open the worked example at `assets/examples/feedback-inbox/` and skim each file. Do not try to understand everything; just notice the shape of each document.
- When the skill asks you to write a task file, look at `assets/examples/feedback-inbox/docs/TASKS/001-bootstrap-feedback-inbox.md` for what good looks like.

The skill itself will keep referring to these concepts. Come back to this page when a term feels foreign. After a few projects, you will not need it.
