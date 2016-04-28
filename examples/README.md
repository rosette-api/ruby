Ruby Examples
============

These examples are scripts that can be run independently to demonstrate the Rosette API functionality.

You can run your desired `_endpoint_.rb` file to see it in action.

`ruby _endpoint_.rb api_key(required) alternate_url(optional)`

For example, run `ruby categories.js <your_key>` if you want to see the categories
functionality demonstrated.

All files require you to input your Rosette API User Key after `--key` to run.
For example: `ruby ping.js 1234567890`  

To run all of the examples:
`find -maxdepth 1 -name *.rb -exec ruby {} api_key alternate_url`

Each example, when run, prints its output to the console.

| File Name                     | What it does                                          | 
| -------------                 |-------------                                        |
| categories.rb                    | Gets the category of a document at a URL              | 
| entities.rb                      | Gets the entities from a piece of text                | 
| entities_linked.rb               | Gets the linked (to Wikipedia) entities from a piece of text |
| info.rb                          | Gets information about Rosette API                    | 
| language.rb                      | Gets the language of a piece of text                  | 
| name_similarity.rb                  | Gets the similarity score of two names                |
| morphology_complete.rb               | Gets the complete morphological analysis of a piece of text| 
| morphology_compound_components.rb    | Gets the de-compounded words from a piece of text     |
| morphology_han_readings.rb           | Gets the Chinese words from a piece of text           |
| morphology_lemmas.rb                 | Gets the lemmas of words from a piece of text         | 
| morphology_parts_of_speech.rb        | Gets the part-of-speech tags for words in a piece of text |
| ping.rb                          | Pings the Rosette API to check for reachability       | 
| sentences.rb                     | Gets the sentences from a piece of text               |
| sentiment.rb                     | Gets the sentiment of a local file                    | 
| tokens.rb                        | Gets the tokens (words) from a piece of text          | 
| name_translation.rb               | Translates a name from one language to another        |
