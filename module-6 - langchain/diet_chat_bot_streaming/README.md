## Streaming Fundamentals

- Instead of waiting for complete LLM responses, streaming delivers tokens in real-time as they're generated, providing immediate feedback and reducing perceived wait time

- The yield keyword creates generator functions that return a generator object, pausing execution and maintaining state between calls unlike return which exits completely, perfect for streaming data bit by bit without loading everything into memory

- The stream_response method uses model.stream() instead of invoke() to receive chunks from the LLM as they're generated

```python
def stream_response(self, user_message: str) -> Generator[str, None, None]:
    """Stream AI response chunks for a user message."""
    # Check if message is empty
    if not (user_message := user_message.strip()):
        return

    # Add user message to history
    self.history.add_message(HumanMessage(content=user_message))

    # Stream response
    response_content = ""
    for chunk in self.model.stream(
        self.history.get_messages(),
        config={"metadata": {"session_id": self.session_id}},
    ):
        if chunk.text:
            response_content += chunk.text
            yield chunk.text

    # Add final response to history
    self.history.add_message(AIMessage(content=response_content))
    ```

- It accumulates chunks in response_content while yielding each new chunk immediately, then adds the complete response to history after streaming finishes


- The stream_message_handler manages UI updates by creating an empty assistant message placeholder and updating it in real-time as chunks arrive through a for loop that automatically waits for each chunk from the generator

```python
def stream_message_handler(
    self, user_message: str, history: list
) -> Generator[Tuple[str, list], None, None]:
    """Send message to chatbot and stream the response."""
    # Check if message is empty
    if not (user_message := user_message.strip()):
        yield "", history
        return

    # Add user message to UI history
    history.append(gr.ChatMessage(content=user_message, role="user"))
    history.append(gr.ChatMessage(content="", role="assistant"))

    # Yield user message and empty assistant message
    yield "", history

    # Stream response
    full_response = ""
    for chunk in self.chatbot.stream_response(user_message):
        full_response += chunk
        history[-1] = gr.ChatMessage(content=full_response, role="assistant")
        yield "", history

```

- While we do this in Gradio, the same logic can be applied to any web framework or UI library that supports real-time updates