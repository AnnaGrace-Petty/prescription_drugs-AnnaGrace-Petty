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
SELECT specialty_description, total_claim_count
FROM prescriber
INNER JOIN prescription
USING (npi)
WHERE drug_name LIKE 'opioids'
GROUP BY specialty_description, total_claim_count
ORDER BY total_claim_count DESC ;