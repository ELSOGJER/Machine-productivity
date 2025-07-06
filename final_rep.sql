SELECT 
    td.worderid AS 'امر الشغل',
    td.qty_kg AS 'كمية الامر بالكيلو',
    td.qty_m  AS 'كمية الامر بالمتر',
    SUM(fi.weight) AS 'الوزن النهائى',
    SUM(fi.height) AS 'الطول النهائى',
    COUNT(fi.roll) AS 'عدد التوبات',
    SUM(CASE WHEN fi.fabric_grade = 1 THEN 1 ELSE 0 END) AS 'عدد التوبات درجة 1',
    SUM(CASE WHEN fi.fabric_grade = 2 THEN 1 ELSE 0 END) AS 'عدد التوبات درجة 2',
    SUM(CASE WHEN fi.fabric_grade = 1 THEN fi.weight ELSE 0 END) AS 'وزن درجة 1',
    SUM(CASE WHEN fi.fabric_grade = 2 THEN fi.weight ELSE 0 END) AS 'وزن درجة 2',
	SUM(CASE WHEN fi.fabric_grade = 1 THEN fi.height ELSE 0 END) AS 'طول درجة 1',
    SUM(CASE WHEN fi.fabric_grade = 2 THEN fi.height ELSE 0 END) AS 'طول درجة 2',

    -- نسبة وزن درجة 1
    CASE 
        WHEN LEFT(td.worderid, 1) = 'K' THEN 
            CONCAT(
                FORMAT(
                    CASE 
                        WHEN SUM(fi.weight) > 0 
                        THEN SUM(CASE WHEN fi.fabric_grade = 1 THEN fi.weight ELSE 0 END) * 100.0 / SUM(fi.weight)
                        ELSE 0 
                    END, 
                'N2'), '%'
            )
        ELSE NULL
    END AS 'نسبة وزن درجة 1',

    -- نسبة وزن درجة 2
    CASE 
        WHEN LEFT(td.worderid, 1) = 'K' THEN 
            CONCAT(
                FORMAT(
                    CASE 
                        WHEN SUM(fi.weight) > 0 
                        THEN SUM(CASE WHEN fi.fabric_grade = 2 THEN fi.weight ELSE 0 END) * 100.0 / SUM(fi.weight)
                        ELSE 0 
                    END, 
                'N2'), '%'
            )
        ELSE NULL
    END AS 'نسبة وزن درجة 2',

    -- نسبة طول درجة 1
    CASE 
        WHEN LEFT(td.worderid, 1) = 'W' THEN 
            CONCAT(
                FORMAT(
                    CASE 
                        WHEN SUM(fi.height) > 0 
                        THEN SUM(CASE WHEN fi.fabric_grade = 1 THEN fi.height ELSE 0 END) * 100.0 / SUM(fi.height)
                        ELSE 0 
                    END, 
                'N2'), '%'
            )
        ELSE NULL
    END AS 'نسبة طول درجة 1',

    -- نسبة طول درجة 2
    CASE 
        WHEN LEFT(td.worderid, 1) = 'W' THEN 
            CONCAT(
                FORMAT(
                    CASE 
                        WHEN SUM(fi.height)> 0 
                        THEN SUM(CASE WHEN fi.fabric_grade = 2 THEN fi.height ELSE 0 END) * 100.0 / SUM(fi.height)
                        ELSE 0 
                    END, 
                'N2'), '%'
            )
        ELSE NULL
    END AS 'نسبة طول درجة 2',

    -- الهالك بعد اضافه الدرجة الثانيه
  -- الهالك + الدرجة الثانية مع وحدة القياس
	CASE 
		WHEN LEFT(td.worderid, 1) = 'K' THEN 
			CONCAT(
				FORMAT(
					td.qty_kg - SUM(fi.weight) + SUM(CASE WHEN fi.fabric_grade = 2 THEN fi.weight ELSE 0 END),'N2'), ' kg')
		WHEN LEFT(td.worderid, 1) = 'W' THEN 
			CONCAT(
				FORMAT(
					td.qty_m - SUM(fi.height) + SUM(CASE WHEN fi.fabric_grade = 2 THEN fi.height ELSE 0 END),'N2'), ' M'
			)
		ELSE NULL
	END AS 'وزن/طول الهالك + الدرجة الثانية',

	-- نسبة الهالك + الدرجة الثانية
	     CASE 
        WHEN LEFT(td.worderid, 1) = 'K' AND td.qty_kg > 0 THEN 
            CONCAT(
                FORMAT(
                    (td.qty_kg - SUM(fi.weight) + SUM(CASE WHEN fi.fabric_grade = 2 THEN fi.weight ELSE 0 END)) * 100.0 / td.qty_kg
                , 'N2'), '%')
        WHEN LEFT(td.worderid, 1) = 'W' AND td.qty_m > 0 THEN 
            CONCAT(
                FORMAT(
                    (td.qty_m - SUM(fi.height) + SUM(CASE WHEN fi.fabric_grade = 2 THEN fi.height ELSE 0 END)) * 100.0 / td.qty_m
                , 'N2'), '%')
        ELSE NULL
    END AS 'نسبة الهالك والدرجة الثانية',

      -- الهالك بدون الدرجة الثانية مع وحدة القياس
	CASE 
		WHEN LEFT(td.worderid, 1) = 'K' THEN 
			CONCAT(FORMAT(td.qty_kg - SUM(fi.weight), 'N2'), ' kg')
		WHEN LEFT(td.worderid, 1) = 'W' THEN 
			CONCAT(FORMAT(td.qty_m - SUM(fi.height), 'N2'), ' M')
		ELSE NULL
	END AS 'وزن/طول الهالك بدون الدرجة الثانية',
    -- نسبة الهالك بدون الدرجة الثانية
    CASE 
        WHEN LEFT(td.worderid, 1) = 'K' AND td.qty_kg > 0 THEN 
            CONCAT(FORMAT((td.qty_kg - SUM(fi.weight)) * 100.0 / td.qty_kg, 'N2'), '%')
        WHEN LEFT(td.worderid, 1) = 'W' AND td.qty_m > 0 THEN 
            CONCAT(FORMAT((td.qty_m - SUM(fi.height)) * 100.0 / td.qty_m, 'N2'), '%')
        ELSE NULL
    END AS 'نسبة الهالك بدون الدرجة الثانية',
	min(fi.date) AS 'التاريخ'
	
FROM 
    finish_inspect AS fi 
    LEFT OUTER JOIN techdata AS td ON td.worderid = fi.worder_id 
GROUP BY 
    td.worderid, td.qty_kg, td.qty_m;




