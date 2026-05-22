## Dataset creation

Summarize the quality principles:

- Coverage: Represent the full range of query types, difficulty levels, and policy domains
- Accuracy: Reference outputs must be precise enough to be a reliable benchmark
Size: Start with 20–30 examples, but scale up to match the complexity of your domain

The good news: with synthetic generation, building a dataset that covers all these dimensions becomes much more tractable — you can systematically generate queries across each policy domain without reading every document manually.

So far we've focused on task performance — how accurately the application does its job. But a complete evaluation framework covers two more dimensions.

- Task Performance: How accurately the AI performs its intended function — the extraction quality, answer correctness, faithfulness to source documents
- Cost: Financial resources per operation — for RAG this matters because retrieval + generation can get expensive at scale
- Latency: Response time from input to output — critical if your risk analysts are querying the system interactively

The important trade-off to keep in mind:

_Improving task performance almost always increases cost and latency._

With proper evaluation across all three dimensions, you can make informed trade-offs rather than blind ones — for example: "Our improved retrieval strategy is 12% more accurate, costs 8% more per query, and adds 300ms latency. Is that worth it?"


## AI Application Evaluation

- Evaluation systematically assesses how well AI applications perform against a representative set of inputs with known expected outputs
- Essential because traditional testing fails due to model output variability and the existence of multiple valid responses for the same input
- Comprehensive evaluation examines three dimensions: task performance ( accuracy), cost (financial resources), and latency (response time)
- Evaluation-driven development emphasizes defining success criteria upfront across all dimensions, focusing development efforts on achieving specific, measurable goals before writing a single line of code

## Evaluation Dataset

- Each evaluation example consists of inputs (data provided to the application), reference outputs (expected results), and metadata (for filtering/grouping)
- A complete evaluation dataset is a collection of well-chosen examples that represent the range of scenarios the application will encounter
- Critical foundation of AI development that forces clarity about requirements and helps domain experts communicate expectations effectively
- Quality depends on both coverage (representing the range of inputs) and accuracy (providing clear reference outputs)
- Can be curated through manual creation by domain experts, collection of real-world examples, algorithmic generation, or hybrid approaches

#### Evaluation Methodologies

- Algorithmic Evaluation: Programmatic comparison using custom functions. Use when reference outputs are available and objective criteria can be defined as code. Examples include exact matching, similarity metrics, and domain-specific calculations.
- AI as Judge: Using AI to evaluate AI outputs. Use when variation is allowed, with either reference outputs or clear criteria.
- Human Evaluation: Expert reviewers or crowd-sourced evaluation. Use when variation is allowed with no reference outputs or clear criteria.


## LangSmith

- Purpose-built evaluation platform that integrates with AI development workflows, offering visualization capabilities, metrics dashboards, and efficient dataset management
- Setup requires creating an account, generating an API key, and configuring environment variables for tracing and project identification
- Organizes data hierarchically: Projects (collections of traces), Traces ( sequences of application steps), and Runs (individual steps with detailed metrics)
Supports creating and managing evaluation datasets with version history tracking and collaboration features
- Provides three main experiment views: Experiments Page (comparison charts, key metrics), Experiment Detail (individual examples with performance indicators), and Example Detail (specific inputs, outputs, and reference outputs)