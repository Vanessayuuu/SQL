-- Keep a log of any SQL queries you execute as you solve the mystery.

-- 1. Get the description of the crime
SELECT description
  FROM crime_scene_reports
 WHERE year = "2021"
   AND month = "7"
   AND day = "28"
   AND street LIKE "Humphrey Street";
-- 2. Get the transcript of interviewees
SELECT transcript
  FROM interviews
 WHERE year = "2021"
   AND month = "7"
   AND day = "28";
-- 3. Get the transaction records of the ATM on Leggett Street on that day
SELECT *
  FROM atm_transactions
 WHERE year = "2021"
   AND month = "7"
   AND day = "28"
   AND atm_location LIKE "Leggett Street";
-- 4. Get the name of people who withdrawed money from the ATM on Leggett Street on that day
SELECT DISTINCT name
  FROM people
       JOIN bank_accounts
       ON people.id = bank_accounts.person_id
       JOIN atm_transactions
       ON bank_accounts.account_number = atm_transactions.account_number
 WHERE bank_accounts.account_number IN
       (SELECT atm_transactions.account_number
          FROM atm_transactions
         WHERE year = "2021"
           AND month = "7"
           AND day = "28"
           AND atm_location LIKE "Leggett Street"
           AND transaction_type = "withdraw");
-- 5. Get the phone call record of which the duration is less than a minute on that day
SELECT *
  FROM phone_calls
 WHERE year = "2021"
   AND month = "7"
   AND day = "28"
   AND duration <= "60";
-- 6. Get the name of people who made a phone call for less than a minute on that day
SELECT DISTINCT name
  FROM people
       JOIN phone_calls
       ON people.phone_number = phone_calls.caller
 WHERE phone_calls.caller IN
       (SELECT caller
          FROM phone_calls
         WHERE year = "2021"
           AND month = "7"
           AND day = "28"
           AND duration <= "60")
         ORDER BY phone_calls.id ASC;
-- 7. Get the name of people who involved in both step 4 and 6
SELECT DISTINCT name
  FROM people
 WHERE name IN
       (SELECT DISTINCT name
          FROM people
               JOIN phone_calls
               ON people.phone_number = phone_calls.caller
         WHERE phone_calls.caller IN
               (SELECT caller
                  FROM phone_calls
                 WHERE year = "2021"
                   AND month = "7"
                   AND day = "28"
                   AND duration <= "60")

             INTERSECT

                SELECT name
                  FROM people
                       JOIN bank_accounts
                       ON people.id = bank_accounts.person_id
                       JOIN atm_transactions
                       ON bank_accounts.account_number = atm_transactions.account_number
                 WHERE bank_accounts.account_number IN
                       (SELECT atm_transactions.account_number
                          FROM atm_transactions
                         WHERE year = "2021"
                           AND month = "7"
                           AND day = "28"
                           AND atm_location LIKE "Leggett Street"
                           AND transaction_type = "withdraw"));
-- 8. Get the name of people who received a phone call for less than a minute on that day
SELECT DISTINCT name
  FROM people
       JOIN phone_calls
       ON people.phone_number = phone_calls.receiver
 WHERE phone_calls.receiver IN
       (SELECT receiver
          FROM phone_calls
         WHERE year = "2021"
           AND month = "7"
           AND day = "28"
           AND duration <= "60");
-- 9. Get the phone call record of the suspected people from step 7 who involved in step 5
SELECT *
  FROM phone_calls
       JOIN people
       ON phone_calls.caller = people.phone_number
 WHERE phone_calls.caller IN
       (SELECT phone_number
          FROM people
         WHERE name IN ("Kenny", "Benista", "Taylor", "Diana", "Bruce"))
   AND phone_calls.id IN ("221", "224", "233", "234", "251", "254", "255", "261", "279", "281");
-- 10. Get the phone call record of the people who received a phone call for less than a minute on that day and involved in step 9
SELECT *
  FROM phone_calls
       JOIN people
       ON phone_calls.receiver = people.phone_number
 WHERE phone_calls.receiver IN
       (SELECT phone_number
          FROM people
         WHERE name IN ("Melissa", "Doris", "Robin", "Jack", "Larry", "Luca", "Philip", "James", "Jacqueline", "Anna"))
   AND phone_calls.id IN ("233", "254", "255", "279", "281");
-- 11. Get the car exit record of the bakery parking lot within 10 minutes of the theft
SELECT *
  FROM bakery_security_logs
 WHERE year = "2021"
   AND month = "7"
   AND day = "28"
   AND hour = "10"
   AND minute <= "25"
   AND activity = "exit";
-- 12. Get the information of people who involved in step 11
SELECT *
  FROM people
 WHERE license_plate IN
       (SELECT license_plate
          FROM bakery_security_logs
         WHERE year = "2021"
           AND month = "7"
           AND day = "28"
           AND hour = "10"
           AND minute <= "25"
           AND activity = "exit");
-- 13. Get the airport information of Fiftyville
SELECT *
  FROM airports
 WHERE city = "Fiftyville";
-- 14. Get the information of earliest flight that leave Fiftyville on 29 July 2021
SELECT *
  FROM flights
 WHERE origin_airport_id = "8"
   AND year = "2021"
   AND month = "7"
   AND day = "29"
 ORDER BY hour ASC, minute ASC
 LIMIT 1;
-- 15. Get the destination of the flight in step 14
SELECT *
  FROM airports
 WHERE id = "4";
-- 16. Get the passengers information who involved in the suspected group in step 7
SELECT *
  FROM passengers
       JOIN people
       ON passengers.passport_number = people.passport_number
 WHERE passengers.passport_number IN
       (SELECT passport_number
          FROM people
         WHERE name IN ("Kenny", "Benista", "Taylor", "Diana", "Bruce"))
   AND passengers.flight_id = "36";
-- Bruce is the person who involved in step 7, 12 and 16
-- Robin is the person who received the phone call from Bruce in step 10
-- New York City is the destination that Bruce escaped to refering to step 15.
