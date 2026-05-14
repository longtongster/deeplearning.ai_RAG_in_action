from langchain.chat_models import init_chat_model
from langchain_core.prompts import PromptTemplate
from pydantic import BaseModel, Field
from typing import Optional, Literal
from openai import APIStatusError, APITimeoutError
import datetime

from dotenv import load_dotenv
load_dotenv()

class Finding(BaseModel):
  description: str = Field(description="A concise in very easy and clear language", max_length=2000)
  finding_owner: str = Field(description="The department responsible to solve finding")
  severity: Literal["M1","M2","M3","M4"]= Field(description="the severity of the finding where M1 has the highest and M4 is lowest")
  source: Literal["Soundness", "Documentation", "Governance", "Implementation"] = Field(description="source of the model risk")
  due_date: datetime.date = Field(description="due date for the finding")
  model_id: str = Field(description="Model inventory id of the model", pattern=r"^MI\d{4}")
  
model = init_chat_model("gpt-4o-mini", model_provider="openai")
structured_llm = model.with_structured_output(Finding)

prompt_template_str = """
You are a helpful assistant

Extract the required details from the following text that describes a finding on a model
{input}
"""

prompt_template = PromptTemplate.from_template(prompt_template_str)

def get_response(input):
    prompt = prompt_template.format(input=input)
    try:
      response = structured_llm.invoke(prompt)
      return response
    except APITimeoutError as e:
      print(e)
    except APIStatusError as e:
      if e.status_code == 429:
        print("Rate limit or quota exceeded — try again later")
      elif e.status_code == 503:
        print("Provider overloaded — consider a fallback model")
      elif e.status_code == 400:
          print(f"Bad request — check your input: {e}")
      else:
         print(f"Unexpected API error ({e.status_code}): {e}")        

finding_1 = "The var model with model id MI0001 that is owned by financial markets has a finding related to backtesting. In the current market environment the model generates to many outliers. That can be caused by a more volatile recent period. Therefore the model needs to be recalibrated. This an important finding to be solved but it is not the highest severity which is M1 and M4 is lowest. It needs to be solved before the end of the 2026."
finding_2 = "The var model with model id MI0002 that is owned by financial markets has a finding related to lack of documentation. The model is lacking a description of the key assumptions and their substantiation. For users, validators, peers and validators this is key information.  This is a low priority finding M4. It needs to be solved before next committee meeting 21 october 2026."

print(get_response(finding_2))

