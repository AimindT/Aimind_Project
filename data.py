# In[]:
import pandas as pd
import matplotlib.pyplot as plt
import os
# In[]:

# Step 1: Define the custom path where you want to save the image
save_path = "Graphs/Sastifacion_Dispersion.png" 

# Ensure the directory exists, create it if it doesn't
os.makedirs(os.path.dirname(save_path), exist_ok=True)
# In[]:

# Step 2: Load the CSV file into a DataFrame
df = pd.read_csv('Rating.csv')
# In[]:

# Step 3: Debug - Check the loaded data
print("DataFrame head:", df.head())
print("Columns:", df.columns)
# In[]:

# Step 4: Count the frequency of each emotion
emotion_counts = df['emotion'].value_counts()
# In[]:

# Step 5: Debug - Check the emotion counts
print("Emotion counts:", emotion_counts)
if emotion_counts.empty:
    raise ValueError("No data found in 'emotion' column. Check your CSV file.")
# In[]:

# Step 6: Prepare data for scatter plot
emotions = emotion_counts.index  # Unique emotion labels
frequencies = emotion_counts.values  # Frequencies of each emotion
x_positions = range(len(emotions))  # Numerical positions for each emotion
# In[]:

# Step 7: Debug - Check lengths
print("Length of x_positions:", len(x_positions))
print("Length of frequencies:", len(frequencies))
if len(x_positions) != len(frequencies):
    raise ValueError(f"Length mismatch: x_positions ({len(x_positions)}) != frequencies ({len(frequencies)})")
# In[]:

# Step 8: Create the scatter plot
plt.scatter(x_positions, frequencies, color='blue', s=100, alpha=0.6)
# In[]:

# Step 9: Customize the x-axis to show emotion labels
plt.xticks(ticks=x_positions, labels=emotions, rotation=45)
# In[]:

# Step 10: Add labels and title
plt.xlabel('Sastifación')
plt.ylabel('Frecuencia (número de veces)')
plt.title('Gráfica de dispersión: Sastifación VS Frecuencia')
# In[]:

# Add grid for readability
plt.grid(True)
# In[]:

# Adjust layout to prevent label cutoff
plt.tight_layout()
# In[]:

# Step 11: Save the plot to the specified path
plt.savefig(save_path, dpi=300, bbox_inches='tight')
# In[]:

# Step 12: Display the plot (optional)
plt.show()
# %%
