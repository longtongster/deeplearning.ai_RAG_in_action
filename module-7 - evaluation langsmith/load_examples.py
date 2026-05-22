import pprint
import json

def load_examples():
    evaluation_dataset_path = "evaluation_dataset.json"

    # Load the evaluation dataset
    with open(evaluation_dataset_path, "r", encoding="utf-8") as file:
        examples = json.load(file)

    return examples


examples = load_examples()

pprint.pprint(examples)
