--QUESTION 1a.
SELECT npi, SUM (total_claim_count) AS total_drug_claim
FROM prescription
GROUP BY npi 
ORDER BY total_drug_claim DESC 
LIMIT 1 ;
--ANSWER = npi:1881634483, total_drug_claim:99707

--QUESTION 1b.
SELECT prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name, prescriber.specialty_description, 
     SUM(total_claim_count) AS total_drug_claim
FROM prescriber
INNER JOIN prescription
ON prescriber.npi = prescription.npi
GROUP BY prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name, prescriber.specialty_description 
ORDER BY total_drug_claim DESC
LIMIT 1 ;
--ANSWER = nppes_provider_first_name:Bruce, nppes_provider_last_org_name:Pendley, specialty_description:Family practice, total_drug_claim:99707

--QUESTION 2a.
SELECT specialty_description, SUM(total_claim_count) AS total_drug_claim
FROM prescriber
INNER JOIN prescription
ON prescriber.npi = prescription.npi
GROUP BY specialty_description
ORDER BY total_drug_claim DESC
LIMIT 1 ;
--ANSWER = specialty_description:Family practice, total_drug_claim:9752347

--QUESSTION 2b.
SELECT specialty_description, SUM(total_claim_count) AS total_drug_claim
FROM prescriber
INNER JOIN prescription
USING (npi)
INNER JOIN drug
USING (drug_name)
WHERE opioid_drug_flag = 'Y'
GROUP BY specialty_description
ORDER BY total_drug_claim DESC
LIMIT 1 ;
--ANSWER = specialty_description:Nurse Practitioner, total_drug_claim:900845

--QUESTION 3a.
SELECT generic_name, sum (total_drug_cost) AS drug_cost
FROM drug
INNER JOIN prescription
USING (drug_name)
GROUP BY generic_name
ORDER BY drug_cost
LIMIT 1 ;
--ANSWER = generic_name:FLURBIPROFEN SODIUM, drug_cost:80.63

--QUESTION 3b.
SELECT generic_name, ROUND(sum(total_drug_cost)/ sum(total_day_supply),2) AS cost_per_day
FROM drug
INNER JOIN prescription
USING(drug_name)
GROUP BY generic_name
ORDER BY cost_per_day DESC
LIMIT 1 ;
--ANSWER = generic_name:C1 ESTERASE INHIBITOR, cost_per_day:3495.22

--QUESTION 4a.
SELECT drug_name,
 CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
      WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	  WHEN opioid_drug_flag = 'N' AND antibiotic_drug_flag = 'N' THEN 'neither' END AS drug_type
FROM drug
WHERE opioid_drug_flag IS NOT NULL
 AND antibiotic_drug_flag IS NOT NULL ;
 
--QUESTION 4b.
WITH drug_type AS (SELECT drug_name,
					 CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
						  WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
						  WHEN opioid_drug_flag = 'N' AND antibiotic_drug_flag = 'N' THEN 'neither' END AS drug_type
				   FROM drug
				   WHERE opioid_drug_flag IS NOT NULL
					 AND antibiotic_drug_flag IS NOT NULL)
SELECT drug_type, CAST (SUM (total_drug_cost) AS money) AS drug_cost
FROM drug_type
INNER JOIN prescription
USING (drug_name)
GROUP BY drug_type 
ORDER BY drug_cost DESC ;
--ANSWER = drug_type:opioid, drug_cost:$105,080,626.37

--QUESTION 5a.
SELECT fips_county.state, COUNT (cbsa.cbsa)
FROM fips_county
INNER JOIN cbsa
USING (fipscounty)
WHERE state = 'TN'
GROUP BY fips_county.state ;
--ANSWER = state:TN, cbsa:42

--QUESTION 5b.
SELECT cbsaname, SUM(population) AS population
FROM cbsa
INNER JOIN population
USING(fipscounty)
GROUP BY cbsaname
ORDER BY population ;
--ANSWER: largest = cbsaname:Nashville-Davidson--Murfreesboro--Franklin, TN, population:1830410
--ANSWER: smallest = cbsa:MOrristown, TN, population:116352

