-- 1. What are the names of the players whose salary is greater than 100,000?

SELECT player_name , salary
FROM players
WHERE salary>100000;


-- 2. What is the team name of the player with player_id = 3?

SELECT p.team_id, t.team_name
FROM players p
JOIN teams t ON p.team_id=t.team_id
WHERE player_id=3;


-- 3. What is the total number of players in each team?

SELECT team_id, COUNT(player_id) AS total_players
FROM players
GROUP BY 1
ORDER BY 1 ASC;


-- 4. What is the team name and captain name of the team with team_id = 2?

SELECT t.team_id,t.team_name,p.player_name
FROM teams t
JOIN players p ON t.team_id=p.team_id
WHERE t.team_id=2 AND p.player_id=2;


-- 5. What are the player names and their roles in the team with team_id = 1?

SELECT player_name, role FROM players
WHERE team_id=1;


-- 6. What are the team names and the number of matches they have won?

SELECT m.winner_id, t.team_name,COUNT(m.winner_id) AS matches_won
FROM matches m JOIN teams t ON m.winner_id=t.team_id
GROUP BY 1,2
ORDER BY 3 DESC;


-- 7. What is the average salary of players in the teams with country 'USA'?

SELECT p.team_id, t.team_name,AVG(p.salary) AS avg_sal
FROM players p
JOIN teams t ON p.team_id=t.team_id
GROUP BY 1,2
ORDER BY 3 ASC;


-- 8. Which team won the most matches?

SELECT m.winner_id, t.team_name,COUNT(m.winner_id) AS matches_won
FROM matches m JOIN teams t ON m.winner_id=t.team_id
GROUP BY 1,2
ORDER BY 3 DESC;


-- 9. What are the team names and the number of players in each team whose salary is greater than 100,000?

SELECT p.team_id,t.team_name, COUNT(p.player_id) AS Total_players
FROM players p
JOIN teams t ON p.team_id=t.team_id
WHERE salary >100000
GROUP BY 1,2
order by 3;


-- 10. What is the date and the score of the match with match_id = 3?

SELECT match_date, score_team1, score_team2
FROM matches
WHERE match_id=3;

