-- Which workout burned the most calories
SELECT "Workout Type", 
       AVG("Calories Burned") AS avg_calories_burned
FROM workout_fitness_tracker_data
GROUP BY "Workout Type"
ORDER BY avg_calories_burned DESC
;

-- What average age burned the most calories by Gender and type of workout
SELECT 
    Age, 
    Gender, 
    "Workout Type", 
    AVG("Calories Burned") AS avg_calories_burned,
    AVG("Workout Duration (mins)") AS avg_workout_duration
FROM workout_fitness_tracker_data
GROUP BY Age, Gender, "Workout Type"
ORDER BY avg_calories_burned DESC
;

-- Fittest age group
SELECT 
    Age, 
    AVG("Calories Burned") AS avg_calories_burned,
    AVG("Steps Taken") AS avg_steps_taken,
    AVG("Water Intake (liters)") AS avg_water_intake,
    AVG("Sleep Hours") AS avg_sleep_hours,
    AVG("VO2 Max") AS avg_vo2_max,
    AVG("Body Fat (%)") AS avg_body_fat,
    -- Fitness score (adjust weights as needed)
    (AVG("Calories Burned") * 0.3 + 
     AVG("Steps Taken") * 0.2 + 
     AVG("Water Intake (liters)") * 0.15 + 
     AVG("Sleep Hours") * 0.1 + 
     AVG("VO2 Max") * 0.1 + 
     (100 - AVG("Body Fat (%)")) * 0.15) AS fitness_score
FROM workout_fitness_tracker_data
GROUP BY Age
ORDER BY fitness_score DESC
;

-- 1.1 Calories Burned Over Time
-- This query calculates the average calories burned per month.
SELECT 
    strftime('%Y-%m', "Workout Date") AS month, 
    AVG("Calories Burned") AS avg_calories_burned
FROM workout_fitness_tracker_data
GROUP BY month
ORDER BY month DESC
;

-- 1.2 Workout Frequency by Month
-- This query calculates how many workouts each user did in each month.
SELECT 
    strftime('%Y-%m', "Workout Date") AS month,  
    COUNT(*) AS workouts_per_month
FROM workout_fitness_tracker_data
GROUP BY month
ORDER BY month DESC
;

-- 1.3 Seasonality of Certain Workouts
-- This query calculates the most common workout types each month.
SELECT 
    strftime('%m', "Workout Date") AS month,  
    "Workout Type",  
    COUNT(*) AS count
FROM workout_fitness_tracker_data
GROUP BY month, "Workout Type"
ORDER BY month, count DESC
;

-- 2.1 Most Active Users
-- This query finds the users who have taken the most steps in total.
SELECT "User ID", 
       SUM("Steps Taken") AS total_steps
FROM workout_fitness_tracker_data
GROUP BY "User ID"
ORDER BY total_steps DESC
LIMIT 5
;

-- 2.2 High Burners
-- This query finds the users who have burned the most calories in total.
SELECT "User ID", 
       SUM("Calories Burned") AS total_calories_burned
FROM workout_fitness_tracker_data
GROUP BY "User ID"
ORDER BY total_calories_burned DESC
LIMIT 5
;

-- 2.3 Most Common Workout by User
-- This query finds the most common workout type for each user.
SELECT "User ID", 
       "Workout Type",  
       COUNT(*) AS workout_count
FROM workout_fitness_tracker_data
GROUP BY "User ID", "Workout Type"
ORDER BY workout_count DESC
;

-- 3.1 Correlation Between Calories Burned and Heart Rate
-- This query calculates the Pearson correlation between calories burned and heart rate.
SELECT 
    (COUNT(*) * SUM("Calories Burned" * "Heart Rate (bpm)") - 
     SUM("Calories Burned") * SUM("Heart Rate (bpm)")) / 
    (SQRT((COUNT(*) * SUM("Calories Burned" * "Calories Burned") - 
     SUM("Calories Burned") * SUM("Calories Burned")) * 
    (COUNT(*) * SUM("Heart Rate (bpm)" * "Heart Rate (bpm)") - 
     SUM("Heart Rate (bpm)") * SUM("Heart Rate (bpm)")))) 
    AS correlation 
FROM workout_fitness_tracker_data
;

-- 3.2 Correlation Between Steps Taken and Calories Burned
-- This query calculates the Pearson correlation between steps taken and calories burned.
SELECT 
    (COUNT(*) * SUM("Steps Taken" * "Calories Burned") - 
     SUM("Steps Taken") * SUM("Calories Burned")) / 
    (SQRT((COUNT(*) * SUM("Steps Taken" * "Steps Taken") - 
     SUM("Steps Taken") * SUM("Steps Taken")) * 
    (COUNT(*) * SUM("Calories Burned" * "Calories Burned") - 
     SUM("Calories Burned") * SUM("Calories Burned")))) 
    AS correlation 
FROM workout_fitness_tracker_data
;

-- 4.1 Segment Users by BMI (Body Mass Index)
-- This query calculates BMI for each user and categorizes them into weight categories.
SELECT "User ID", 
       ("Weight (kg)" / (("Height (cm)" / 100) * ("Height (cm)" / 100))) AS BMI,  
       CASE
           WHEN ("Weight (kg)" / (("Height (cm)" / 100) * ("Height (cm)" / 100))) < 18.5 THEN 'Underweight'  
           WHEN ("Weight (kg)" / (("Height (cm)" / 100) * ("Height (cm)" / 100))) BETWEEN 18.5 AND 24.9 THEN 'Normal'
           WHEN ("Weight (kg)" / (("Height (cm)" / 100) * ("Height (cm)" / 100))) BETWEEN 25 AND 29.9 THEN 'Overweight'
           ELSE 'Obese'
       END AS BMI_category  
FROM workout_fitness_tracker_data
;

-- 4.2 Segment Users by Activity Level
-- This query classifies users into activity levels based on calories burned and steps taken.
SELECT "User ID", 
       SUM("Calories Burned") AS total_calories_burned,  
       SUM("Steps Taken") AS total_steps_taken,  
       CASE 
           WHEN SUM("Calories Burned") > 1000 AND SUM("Steps Taken") > 10000 THEN 'Highly Active'  
           WHEN SUM("Calories Burned") BETWEEN 500 AND 1000 AND SUM("Steps Taken") BETWEEN 5000 AND 10000 THEN 'Moderately Active'
           ELSE 'Inactive'
       END AS activity_level  
FROM workout_fitness_tracker_data
GROUP BY "User ID"
;

-- 5.1 Mood Change by Workout Type
-- This query shows how different workout types affect the mood before and after the workout.
SELECT 
    "Workout Type",  
    COUNT(*) AS count,  
    SUM(CASE WHEN "Mood After Workout" = 'Happy' THEN 1 ELSE 0 END) AS happy_after,  
    SUM(CASE WHEN "Mood Before Workout" = 'Happy' THEN 1 ELSE 0 END) AS happy_before  
FROM workout_fitness_tracker_data
GROUP BY "Workout Type"  
ORDER BY happy_after DESC
;

-- 6.1 Health Score Based on Multiple Metrics
-- This query calculates a custom health score based on various health metrics.
SELECT 
    "User ID", 
    SUM("Calories Burned") * 0.3 +  
    SUM("Steps Taken") * 0.2 +  
    AVG("Sleep Hours") * 0.1 +  
    AVG("VO2 Max") * 0.2 +  
    (100 - AVG("Body Fat (%)")) * 0.2 AS health_score  
FROM workout_fitness_tracker_data
GROUP BY "User ID"  
ORDER BY health_score DESC  
LIMIT 5
;







