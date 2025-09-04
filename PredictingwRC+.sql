WITH TeamCounts AS (
  SELECT 
    Name,
    Year,
    COUNT(DISTINCT Team) AS NumTeams
  FROM Advanced
  GROUP BY Name, Year
), 

JoinedData AS (
  SELECT
    a.Name,
    a.Year,
    a.Team,
    tc.NumTeams,

    -- From Advanced
    a.PA, a.BB_Percent AS BBP, a.K_Percent AS KP, a.BB_K AS BBK,
    a.AVG, a.OBP, a.SLG, a.OPS, a.ISO, a.Sp
d, a.BABIP,
    a.wRC, a.wRAA, a.wOBA, a.wRC_plus AS wRCp,

    -- From BattedBall
    b.GB_FB AS GB_FB, b.LD_Percent AS LDp, b.GB_Percent AS GBp,
    b.FB_Percent AS FBp, b.HR_FB AS HR_FB,
    b.Pull_Percent AS Pullp, b.Cent_Percent AS Centp,
    b.Oppo_Percent AS Oppop, b.Soft_Percent AS Softp,
    b.Med_Percent AS Medp, b.Hard_Percent AS Hardp,

    -- From Statcast
    s.EV, s.EV90, s.maxEV, s.LA, s.Barrel_Percent AS Barrelp,
    s.HardHit_Percent AS HardHitp, s.AVG AS Stat_AVG,
    s.xBA, s.SLG AS Stat_SLG, s.xSLG, s.xwOBA,

    -- From PlateDiscipline
    p.Z_Swing_Percent AS ZSwingp, p.Swing_Percent AS Swingp,
    p.O_Contact_Percent AS OContactp, p.Z_Contact_Percent AS ZContactp,
    p.Contact_Percent AS Contactp, p.Zone_Percent AS Zonep,
    p.F_Strike_Percent AS FStrikep, p.SwStr_Percent AS SwStrp,
    p.CStr_Percent AS CStrp, p.CSW_Percent AS CSWp,

    -- From ParkFactor
    pf.ParkFactor

  FROM Advanced a
  LEFT JOIN BattedBall b
    ON a.Name = b.Name AND a.Year = b.Year
  LEFT JOIN Statcast s
    ON a.Name = s.Name AND a.Year = s.Year
  LEFT JOIN PlateDiscipline p
    ON a.Name = p.Name AND a.Year = p.Year
  LEFT JOIN ParkFactor pf
    ON a.Team = pf.Team AND a.Year = pf.Year
  LEFT JOIN TeamCounts tc
    ON a.Name = tc.Name AND a.Year = tc.Year
)

SELECT
  Name,
  Year,
  Team,
  PA, BBP, KP, BBK, AVG, OBP, SLG, OPS, ISO, Spd, BABIP,
  wRC, wRAA, wOBA, wRCp,
  GB_FB, LDp, GBp, FBp, HR_FB, Pullp, Centp, Oppop, Softp, Medp, Hardp,
  EV, EV90, maxEV, LA, Barrelp, HardHitp, Stat_AVG, xBA, Stat_SLG, xSLG, xwOBA,
  ZSwingp, Swingp, OContactp, ZContactp, Contactp, Zonep, FStrikep, SwStrp, CStrp, CSWp,
  ParkFactor

FROM JoinedData
ORDER BY 
  Year ASC,          -- 2021 → 2024
  Team DESC,         -- Z → A
  NumTeams DESC;     
