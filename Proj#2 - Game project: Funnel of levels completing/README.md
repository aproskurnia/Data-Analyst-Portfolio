
## **Proj#2** - Game Project: Game Funnel Analysis for User Level Completion
### **Table of Contents**
1. [Project Overview](#project-overview)
2. [Tools and Data Sources](#Tools-and-Data-Sources)
3. [Data Manipulation in Python](#Data-Manipulation-in-Python)
4. [Contact Information](#Contact-Information)

#### 1. Project Overview:
In this project, I undertook a comprehensive analysis of the "funnel" that guides a new user through the levels upon installing the game. The primary objective was to enhance the First Time User Experience (FTUE), increase conversion rates, fine-tune game balance, and optimize the difficulty curve. This endeavor represents a critical step toward creating a more engaging and lucrative gaming environment.

Project can be find [here](https://github.com/aproskurnia/Data-Analyst-Portfolio/blob/23f90522e55b421e59f1e5854f6998fcef33b021/Proj%232%20-%20Game%20project%3A%20Funnel%20of%20levels%20completing/Game_project.ipynb)

##### Objectives:
- **FTUE (First Time User Experience):**
Why: Evaluate and enhance the initial user experience to ensure new users have a smooth and engaging introduction to the product. Implement improvements to increase user satisfaction and retention.
How: Analyze user interactions during their first experience with the product, identify pain points by studying conversion drop in the game funnel.

- **Conversion Rate:**
Why: Understand the efficiency of the user journey through different levels and identify potential bottlenecks. Optimize these levels to improve overall conversion and user progression.
How: Analyze the conversion rate at various stages to pinpoint where users drop off. 

- **Game Balance and Difficulty Curve:**
Why: Maintain an engaging and challenging experience for users by ensuring an appropriate balance in game difficulty, and adjust game elements to provide a balanced and enjoyable gameplay experience.
How: Analyze user performance across levels, identify spikes or dips in difficulty.

#### 2. Tools and Data Sources:
Tools: Python (Pandas, Numpy, Matplotlib, Seaborn)

Data Sources: The primary dataset for this analysis is the `plr_smpl_attempts.csv` file, which contains detailed information about the passage of levels by each player.
You can find the data source by this link: [plr_smpl_attempts.csv.zip](https://drive.google.com/file/d/1eU3QhGmRFP2vmtMNhvkKDGexoizaDtsn/view?usp=sharing)

#### 3. Data Manipulation in Python:
1. Setup
   Ensure the necessary libraries and dependencies are imported, and the dataset is loaded into a DataFrame.
3. Data Cleaning
   Conduct data cleaning procedures, addressing any missing values, outliers, or inconsistencies in the dataset.
4. Preparing Data For Analysis
   In this phase, I focused on the analysis of the level progression funnel exclusively for new users. Initially, I extracted User IDs for users whose data is available in this dataset starting from the first level. Subsequently, I created a new DataFrame containing only these IDs. Utilizing a for loop, I calculated the relevant metrics for each specific level essential for my data analysis.
6. Analysing Data
   - Conducted an initial analysis by examining the conversion rate funnel. Generated a histogram and a funnel chart to illustrate the trendline of the conversion rate, identifying any extreme drops deviating from the general trend.
   - Created a top 20 list of levels with the highest drop values in the conversion rate, using the conversion rate difference metric that calculates the percentage difference between the current level and the next level.
   - Constructed a chart displaying the sequential conversion rate by levels, providing insights into level-by-level conversion trends.
   - Investigated the spread in the number of unsuccessful attempts to complete each level, visualized by a chart depicting the total number of failed attempts by levels. Identified the levels with the highest concentrations of failed attempts.
   - Examined the average count of fails per user by levels, creating a list of the top 15 levels with the highest values.
   - Checked the correlation between the number of failed attempts to complete a level and the percentage drop in conversion to assess any relationship between these two metrics, potentially signaling areas of concern for the product team.
4. Summary
   Concluded the analysis with a comprehensive summary, highlighting key findings, trends, and potential areas for improvement. This phase serves as a culmination of insights gained from the data analysis process.

#### 4. Contact Information:
I welcome any inquiries or collaborations related to this project or other data analytics endeavors. Feel free to explore my LinkedIn profile for more details or contact me directly via email, Telegram, or phone:
- LinkedIn - [linkedin.com/in/alinaproskurnia/](https://www.linkedin.com/in/alinaproskurnia/)
- Email - aproskurnya1991@gmail.com
- Telegram - @aproskurnia
- Phone - +38(063)3547787
