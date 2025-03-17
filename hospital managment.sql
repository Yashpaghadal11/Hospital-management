use db5;

/*1*/
select * 
from db5.hospital_metadata_1 h1
join db5.hospital_metadata_2 h2
on h1.Provider_ID = h2.Provider_ID;

/*2*/
select *
from  db5.hospital_metadata_1
where Emergency_Services = 'true'
and Meets_criteria_for_meaningful_use_of_EHRs = 'true';

/*3*/
select Hospital_Type,avg(Hospital_overall_rating) as avg_of_Hospital_overall_rating
from db5.hospital_metadata_1
group by Hospital_Type;

/*4*/
WITH RankedHospitals AS (
    SELECT Provider_ID, Hospital_Name, State, Hospital_overall_rating,
           ROW_NUMBER() OVER (PARTITION BY State ORDER BY Hospital_overall_rating DESC) AS ranka
    FROM db5.Hospital_Metadata_1
)
SELECT * 
FROM RankedHospitals
WHERE Ranka <= 5;

/*5*/
select Hospital_Ownership,count(Hospital_Name) as count_hospital
from db5.hospital_metadata_1
group by Hospital_Ownership;

/*6*/
SELECT db6.Hospital_Name, db6.Mortality_national_comparison
FROM db6.Hospital_Metadata_1 h1
WHERE h1.Mortality_national_comparison < '1.0';

/*7*/
SELECT h1.Hospital_Name, h1.Hospital_Type, h1.Effectiveness_of_care_national_comparison
FROM db5.Hospital_Metadata_1 h1
JOIN db5.Hospital_Metadata_2 h2
ON h1.Provider_ID = h2.Provider_ID
WHERE h1.Effectiveness_of_care_national_comparison > 0.75;
WITH RankedPatientExperience AS (
    SELECT Provider_ID, State, Patient_experience_national_comparison,
           ROW_NUMBER() OVER (PARTITION BY State ORDER BY Patient_experience_national_comparison DESC) AS Ranka
    FROM db5.Hospital_Metadata_1
)
SELECT * 
FROM RankedPatientExperience
WHERE Ranka = 1;

/*8*/
select Hospital_Type, avg(Readmission_national_comparison)  as avg_Readmission_national_comparison
from db5.Hospital_Metadata_1 h1
group by Hospital_Type;

/*9*/
SELECT Hospital_Name, Safety_of_care_national_comparison
FROM db5.Hospital_Metadata_1
WHERE Safety_of_care_national_comparison > 1.0;


/*10*/
SELECT db5.Hospital_Metadata_1.Hospital_Name, db5.Hospital_Metadata_1.State, db5.Hospital_Metadata_1.Efficient_use_of_medical_imaging_national_comparison
FROM db5.Hospital_Metadata_1 h1
JOIN db5.Hospital_Metadata_2 h2
ON h1.Provider_ID = h2.Provider_ID
WHERE h1.Efficient_use_of_medical_imaging_national_comparison = 
      (SELECT MAX(Efficient_use_of_medical_imaging_national_comparison) 
       FROM Hospital_Metadata_1 
       WHERE State = h1.State);

       
/*11*/
SELECT Hospital_Name, Timeliness_of_care_national_comparison
FROM db5.Hospital_Metadata_1
WHERE Timeliness_of_care_national_comparison > 0.90;
      
/*12*/
SELECT County_Name, AVG(Mortality_national_comparison) AS Avg_Mortality, 
       AVG(Safety_of_care_national_comparison) AS Avg_Safety
FROM db5.Hospital_Metadata_1
GROUP BY County_Name;

/*13*/
SELECT db5.Hospital_Metadata_1.Hospital_Name, db5.Hospital_Metadata_1.State, db5.Hospital_Metadata_1.Mortality_national_comparison
FROM db5.Hospital_Metadata_1 h1
JOIN db5.Hospital_Metadata_2 h2
ON h1.Provider_ID = h2.Provider_ID
WHERE h1.Mortality_national_comparison = 
      (SELECT MIN(Mortality_national_comparison) 
       FROM db5.Hospital_Metadata_1);
       
/*14*/
SELECT State, COUNT(*) AS Better_Than_National_Experience
FROM db5.Hospital_Metadata_1
WHERE Patient_experience_national_comparison > 1.0
GROUP BY State;

/*15*/
SELECT State, COUNT(*) AS Low_Readmission_Hospitals
FROM db5.Hospital_Metadata_1
WHERE Readmission_national_comparison < 1.0
GROUP BY State;

/*16*/
SELECT Hospital_Name, State, Emergency_Services
FROM db5.Hospital_Metadata_1
WHERE Meets_criteria_for_meaningful_use_of_EHRs = 'Yes' 
      AND Emergency_Services = 'Yes';
   
/*17*/
WITH RankedHospitals AS (
    SELECT Provider_ID, State, Hospital_Name, Hospital_overall_rating,
           ROW_NUMBER() OVER (PARTITION BY State ORDER BY Hospital_overall_rating DESC) AS Ranka
    FROM db5.Hospital_Metadata_1
)
SELECT *
FROM RankedHospitals
WHERE Ranka <= 3;

/*18*/
SELECT Hospital_Ownership, AVG(Safety_of_care_national_comparison) AS Avg_Safety, 
       AVG(Effectiveness_of_care_national_comparison) AS Avg_Effectiveness
FROM db5.Hospital_Metadata_1
GROUP BY Hospital_Ownership;


/*19*/
SELECT Hospital_Name,Effectiveness_of_care_national_comparison
FROM db5.Hospital_Metadata_1
WHERE Effectiveness_of_care_national_comparison = 
      (SELECT MAX(Effectiveness_of_care_national_comparison) 
       FROM Hospital_Metadata_1);
       
       
/*20*/
SELECT Hospital_Name, Timeliness_of_care_national_comparison
FROM Hospital_Metadata_1
WHERE Timeliness_of_care_national_comparison = 
      (SELECT MIN(Timeliness_of_care_national_comparison) 
       FROM Hospital_Metadata_1);
       
	
SELECT Hospital_Ownership, Emergency_Services, COUNT(*) AS Hospital_Count
FROM Hospital_Metadata_1
GROUP BY Hospital_Ownership, Emergency_Services;

WITH HospitalRanking AS (
    SELECT Hospital_Name, Mortality_national_comparison, Safety_of_care_national_comparison,
           ROW_NUMBER() OVER (ORDER BY Mortality_national_comparison, Safety_of_care_national_comparison DESC) AS Ranka
    FROM db5.Hospital_Metadata_1
)
SELECT * 
FROM HospitalRanking
WHERE Ranka <= 5;



SELECT h1.Hospital_Name, h1.County_Name, h2.Hospital_Name AS Second_Hospital_Name
FROM db5.Hospital_Metadata_1 h1
JOIN db5.Hospital_Metadata_2 h2
ON h1.Provider_ID = h2.Provider_ID
WHERE h1.County_Name = 'YourCounty';