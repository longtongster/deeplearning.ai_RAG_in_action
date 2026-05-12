
# RAG Improvements

Here we keep a list of items the final RAG architecture should include.


#### Searches

There are three types of searches: `keyword`, `semantic`, and `metadata` search. You can improve your system by combining `keyword` and `semantic` searches—this is called `hybrid` search.

`Metadata` filtering is not used to actually retrieve documents, but rather to narrow down the search space. There is no way to rank the remaining subset using metadata alone. On the filtered subset, `keyword`, `semantic`, or `hybrid` search is then applied.

Several metrics can be used to evaluate retrieval, such as precision@k, recall@k, MAP, and MRR. Some of these are more theoretical than practical in certain cases.

Semantic embedding of documents or queries requires a distance measure (e.g., Euclidean distance or cosine similarity). The embedding of a query is used to find the closest or most similar documents. Variants of ANN (Approximate Nearest Neighbors) are used to quickly calculate the top-k nearest neighbors to a query. Most commonly, Hierarchical Navigable Small World (HNSW) is used.

#### Chunking

When documents are too long, they need to be split into smaller chunks—this is called chunking. Chunking is necessary because extracting meaning from an entire long document can be difficult, and it may be hard to find specific content. The size of the chunks can be determined by the model’s maximum token length. For example, if the model can handle 512 tokens, you might want to chunk your documents into 512 tokens or less. Since documents might be split at sensible places, there is usually some overlap between the chunks.

Chunking also helps improve the context provided to the LLM. Smaller but relevant chunks help the LLM in your RAG generate more meaningful and precise responses.

There are different chunking strategies, such as character-based or token-based chunking. A more advanced (and expensive) approach is semantic chunking, where a chunk continues as long as the semantic meaning remains consistent. You can also use a large language model to chunk a document into semantically similar parts. This seems to result in high-quality chunks.

#### Query Parsing

Instead of feeding a prompt directly to the knowledge base, an LLM can be used to parse the prompt for its intent, edit, rewrite, or transform it for better retrieval.

_Remark_: This was done in the `langchain-academy` course for LangGraph, where a research assistant was created. An LLM was used to adjust the human query before it was used to search the internet.

NER – One can also use GLINER to perform NER (Named Entity Recognition) on a query and use the result to filter data.

HyDE – Hypothetical Document Embedding – an LLM writes a document based on your query that answers the query. Then this document is embedded and used to search the knowledge base.

#### Embeddings

- bi-encoders - is the default. Create embedding vectors for docs (can be preprocessed). When query comes only query needs to be embedded and than a search can be performed.
- cross encoders - encode the query with each doc. Can only be done at search time. Does not scale. (gives best performance)
- ColBert - encode each token of the query, encode each token of doc (requires more vectors per doc). similary score matrix is calculated. Approximate cross encoders performance but scales better.

#### Reranking 

Reranking is all about improving the quality of your retrieval after a collection of documents or chunks has already been retrieved but before the are sent to the LLM.

Since reranking is only applied to a small subset of all the documents it can be performed by expensive techniques like cross encoders or via LLM scoring.

When a reranker is used you usually overfetch documents in the first step of the retrieval (e.g. 20). Then only after reranking you return a shorter list (e.g.10)

#### Prompt engineering

Module 4 has a nice video in what to include in your prompt and how to structure. It takes as example an Antrophic prompt and gives some additional ideas that a system prompt for RAG could include.

There are also things like in context learning where you provide examples in your prompt. (high quality question and answer pairs). You also can have the LLM reason step by step (CoT)  

#### Hallucinations
Hallucinations are a common problem in RAG systems. They occur when the LLM generates information that is not supported by the retrieved documents. This can happen when the retrieved documents are not relevant, or when the LLM is not able to properly understand the retrieved information.

One way to limit hallucinations is to have the llm generate several responses and to compare the responses for consistency. This migh be costly and inconsistent. For a RAG system the best place is to only allow the llm to respond based on the provided context and ask it to cite sources. 

#### Monitoring and evaluation

- langsmith
- langfuse
- Arize Phoenix


# LLM appication tips (ToDo)

(see datacamp for nice suggestions)

#### Structured output

- Define data models using Python type annotations to specify expected structure
- Use BaseModel for both input validation and output parsing
- Add validation rules via Field() to enforce data quality
- Create nested models to represent complex hierarchical data

```python
from pydantic import BaseModel, Field
from typing import Optional


class SubItem(BaseModel):
    name: str = Field(description="Item name")
    score: float = Field(gt=0, le=10, description="Rating score")
    note: Optional[str] = Field(default=None, description="Optional note")


class Result(BaseModel):
    id: str = Field(pattern=r"^[A-Z]\d{4}$", description="Unique ID")
    summary: str = Field(description="Brief summary")
    tags: list[str] = Field(description="Relevant tags")
    items: list[SubItem] = Field(description="Detailed sub-items")
```

- Common field types and constraints -use the `Field` to provide a description to the llm model via the `description` argument. Use other argument to validate the data such as `pattern` for regex, `le` for less than equal, `format` for datetime formats etc.


```python
# Common field types and constraints
required_string = str  # Required by default
optional_string: Optional[str] = None  # Using Optional from typing
optional_with_default: str = "default value"
int_with_range = Field(gt=0, lt=100)  # Greater than 0, less than 100
validated_string = Field(
    pattern=r"^[A-Z]\d{3}$")  # Regex pattern validation
validated_date = Field(format="YYYY-MM-DD")  # Date format validation
string_with_length = Field(min_length=1,
                           max_length=1000)  # Length constraints
list_field: list[str]  # List of strings
nested_model: list[SubModel]  # List of nested models
```

```python
# Configure the LLM
llm = init_chat_model(
    model="gpt-4.1-nano",
    timeout=0.1,  # 100ms timeout
    max_retries=3,  # 3 retries
)
```

- calling the model

```python
from pydantic import BaseModel


class YourModel(BaseModel):
    field_one: str
    field_two: int
    # ... other fields


structured_llm = llm.with_structured_output(YourModel)
result = structured_llm.invoke(prompt)  # Returns validated Pydantic object
```

#### Input Handling

- The process of preparing, validating, and formatting user inputs before sending to an LLM
- Prevents hallucinations, preserves data integrity, and optimizes token usage
- Use Pydantic models to validate structured inputs before processing

```python
from pydantic import BaseModel, Field, ValidationError


class InputModel(BaseModel):
    text: str = Field(min_length=1, max_length=5000)
    category: str
    rating: int = Field(gt=0, le=5)


try:
    validated = InputModel.model_validate_json(raw_input)
except ValidationError as e:
    print(e)
```

#### Data Modeling for LLM Applications

- Design data structures that represent your application's needs, independent of storage
- Properly modeled data ensures consistent outputs that fit application requirements
- Good models make code more robust, maintainable, and less error-prone
- Models serve as documentation of your app's data requirements

#### API errors

Error Handling

- Code-level errors (429, 504, 400): Handle with retries, timeouts, and validation
- Account-level errors (401, 403, 429): Address with key rotation and quota management
- Provider-level errors (503, 529): Implement graceful degradation and fallbacks
- Use try/except blocks with specific exception handling for each error type

```python
from openai import APITimeoutError, RateLimitError, APIStatusError

try:
    response = llm.invoke(prompt)
except APITimeoutError:
    # Retry or simplify request
    response = fallback_response
except RateLimitError:
    # Back off and retry
    time.sleep(5)
    response = llm.invoke(prompt)
except APIStatusError as e:
    # Covers 400, 429, 503 etc. — check e.status_code
    if e.status_code == 503:
        response = fallback_llm.invoke(prompt)
    else:
        raise
except Exception as e:
    # Final safety net
    response = "Service unavailable, please try again later."
```

You can give the `init_chat_model` arguments such as `timeout` to limit response times and `max_retries` for retry a request a few times. 

Use a backup model in production environment with a try/except block. 