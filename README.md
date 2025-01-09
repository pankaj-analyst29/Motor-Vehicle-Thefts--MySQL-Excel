# Motor Vehicle Thefts Analysis

## Overview
This project analyzes patterns and trends in motor vehicle thefts using SQL. It focuses on understanding when and where vehicles are most likely to be stolen, along with other key factors like vehicle make and daily trends. The insights aim to support law enforcement, urban planners, and insurance companies in mitigating theft risks.

## Objectives
1. Identify when vehicles are likely to be stolen.
2. Identify which vehicles are likely to be stolen.
3. Identify where vehicles are likely to be stolen
4. Provide actionable insights for risk assessment and prevention.

## Dataset
The analysis uses the following tables:
- **`stolen_vehicles`**: Contains records of stolen vehicles with attributes like `date_stolen`, `vehicle_id`, and `location_id`.
- **`locations`**: Maps `location_id` to geographic details (e.g., city, state).
- **`make_details`**: Provides details about the vehicle make and model.

### Sample Schema
```sql
CREATE TABLE stolen_vehicles (
    vehicle_id INT PRIMARY KEY,
    vehicle_type VARCHAR(50),
    make_id INT,
    model_year INT,
    vehicle_desc VARCHAR(50),
    color VARCHAR(50),
    date_stolen DATE,
    location_id INT
);

CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    region VARCHAR(50),
    country VARCHAR(50),
    population INT,
    density INT
);

CREATE TABLE make_details (
    make_id INT PRIMARY KEY,
    make_name VARCHAR(50),
    make_type VARCHAR(50)
);
