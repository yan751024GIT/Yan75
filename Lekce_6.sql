WITH base AS (
	SELECT   
	       EXTRACT(YEAR FROM date)*100 + EXTRACT(month FROM date) AS period,
	 	   confirmed
	  FROM covid19_basic cb
--	  WHERE country = 'Czechia'
)
SELECT   
       period,
	   sum(confirmed) AS confirmed
  FROM base cb
GROUP BY
       period
ORDER BY PERIOD


CREATE TABLE budget_jan (
	kraj text,
	vzdelani_txt text,
	uzemi_txt text,
	hodnota int
)


INSERT INTO budget_jan(kraj, vzdelani_txt, uzemi_txt, hodnota) VALUES('Zlínský kraj','Bez vzdělání','Želechovice nad Dřevnicí',9);
INSERT INTO budget_jan(kraj, vzdelani_txt, uzemi_txt, hodnota) VALUES('Zlínský kraj','Nezjištěno','Želechovice nad Dřevnicí',59);
INSERT INTO budget_jan(kraj, vzdelani_txt, uzemi_txt, hodnota) VALUES('Zlínský kraj','Úplné  střední (s maturitou), vč. nástavbového a pomaturitního','Želechovice nad Dřevnicí',489);
INSERT INTO budget_jan(kraj, vzdelani_txt, uzemi_txt, hodnota) VALUES('Zlínský kraj','Střední vč. vyučení (bez maturity)','Želechovice nad Dřevnicí',540);
INSERT INTO budget_jan(kraj, vzdelani_txt, uzemi_txt, hodnota) VALUES('Zlínský kraj','Vysokoškolské','Želechovice nad Dřevnicí',259);
INSERT INTO budget_jan(kraj, vzdelani_txt, uzemi_txt, hodnota) VALUES('Zlínský kraj','Základní vč. neukončeného','Želechovice nad Dřevnicí',197);
INSERT INTO budget_jan(kraj, vzdelani_txt, uzemi_txt, hodnota) VALUES('Zlínský kraj','Vyšší odborné, konzervatoř','Želechovice nad Dřevnicí',24);
INSERT INTO budget_jan(kraj, vzdelani_txt, uzemi_txt, hodnota) VALUES('Zlínský kraj','Bez vzdělání','Petrov nad Desnou',9);
INSERT INTO budget_jan(kraj, vzdelani_txt, uzemi_txt, hodnota) VALUES('Olomoucký kraj','Nezjištěno','Petrov nad Desnou',34);
INSERT INTO budget_jan(kraj, vzdelani_txt, uzemi_txt, hodnota) VALUES('Olomoucký kraj','Úplné  střední (s maturitou), vč. nástavbového a pomaturitního','Petrov nad Desnou',289);
INSERT INTO budget_jan(kraj, vzdelani_txt, uzemi_txt, hodnota) VALUES('Olomoucký kraj','Střední vč. vyučení (bez maturity)','Petrov nad Desnou',408);

SELECT * FROM budget_jan bj;






 
 