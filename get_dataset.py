import pandas as pd

articles = pd.read_csv("articles.csv")

sources = ["The Huffington Post","Daily Beast","Breitbart","New York Post"] 

output_df = pd.DataFrame()

for source in sources: 
    output_df = output_df.append(articles[articles.source==source].sample(200),ignore_index=True) 

output_df = output_df[output_df.columns[1:]]

output_df.to_csv("matlab_dataset.csv",index=False)
