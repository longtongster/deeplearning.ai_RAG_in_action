
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
