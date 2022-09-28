--QUESTION 1a
SELECT npi, SUM(total_claim_count ) AS total_drug_claim
FROM prescription
GROUP BY npi ;

--QUESTION 1b
SELECT prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name, prescriber.specialty_description, 
     SUM(total_claim_count) AS total_drug_claim
FROM prescriber
INNER JOIN prescription
ON prescriber.npi = prescription.npi 
GROUP BY prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name, prescriber.specialty_description ;

--QUESTION 2a
SELECT specialty_description, SUM(total_claim_count) AS total_drug_claim
FROM prescriber
INNER JOIN prescription
ON prescriber.npi = prescription.npi
GROUP BY specialty_description
ORDER BY total_drug_claim DESC ;

--QUESTION 2b
SELECT specialty_description, SUM(total_claim_count) AS total_drug_claim
FROM prescriber
INNER JOIN prescription
USING (npi)
INNER JOIN drug
USING (drug_name)
WHERE opioid_drug_flag = 'Y'
GROUP BY specialty_description, total_claim_count
ORDER BY total_drug_claim DESC
LIMIT 1 ;

--QUESTION 3a
SELECT generic_name, sum (total_drug_cost) AS drug_cost
FROM drug
INNER JOIN prescription
USING (drug_name)
GROUP BY generic_name
ORDER BY drug_cost
LIMIT 1 ;

--QUESTION 3b
SELECT generic_name, ROUND(sum(total_drug_cost)/ sum(total_day_supply),2) AS cost_per_day
FROM drug
INNER JOIN prescription
USING(drug_name)
GROUP BY generic_name
ORDER BY cost_per_day
LIMIT 1 ;

--QUESTION 4a
SELECT drug_name,
 CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
      WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	  WHEN opioid_drug_flag = 'N' AND antibiotic_drug_flag = 'N' THEN 'neither' END AS drug_type
FROM drug
WHERE opioid_drug_flag IS NOT NULL
 AND antibiotic_drug_flag IS NOT NULL ;
 
--QUESTION 4b

 






