select * 
from ecom_d_uk
where description in ("?","*Boombox Ipod Classic", 
"*USB Office Mirror Ball",
"? sold as sets?",
"?sold as sets?",
"?lost",
"?display?",
"?missing",
"??",
"20713",
"???lost",
"?? missing",
"????missing",
"???missing",
"???",
"????damages????")
;

SELECT count(*)
FROM ecom_d_uk;

SELECT COUNT(DISTINCT Description) AS unique_descriptions
FROM ecom_d_uk; -- 4206

SELECT *
FROM ecom_d_uk
WHERE Description IS NULL OR TRIM(Description) = ''; -- nothing 

SELECT Description, COUNT(*) AS frequency
FROM ecom_d_uk
GROUP BY Description
ORDER BY frequency DESC
LIMIT 10; -- many frequency of the same descriptions

SELECT DISTINCT Description
FROM ecom_d_uk
WHERE Description REGEXP '[^a-zA-Z0-9 ,.-]'; -- symbols, accents, etc. (theres about 400 in total

SELECT COUNT(*) AS gift_related
FROM ecom_d_uk
WHERE LOWER(Description) LIKE '%gift%'; -- theres about 5293 as gift related

SELECT Description, SUM(Quantity) AS total_quantity_sold
FROM ecom_d_uk
GROUP BY Description
ORDER BY total_quantity_sold DESC
LIMIT 10; -- 
-- investigating whether there are more than one stockcode for each top sold items
SELECT Description, StockCode, COUNT(*) AS occurrences
FROM ecom_d_uk
WHERE Description = 'WHITE HANGING HEART T-LIGHT HOLDER'
GROUP BY Description, StockCode
ORDER BY occurrences DESC;

SELECT Description, StockCode, COUNT(*) AS occurrences
FROM ecom_d_uk
WHERE Description = 'REGENCY CAKESTAND 3 TIER'
GROUP BY Description, StockCode
ORDER BY occurrences DESC;

SELECT Description, StockCode, COUNT(*) AS occurrences
FROM ecom_d_uk
WHERE Description IN (
    'WHITE HANGING HEART T-LIGHT HOLDER',
    'REGENCY CAKESTAND 3 TIER',
    'JUMBO BAG RED RETROSPOT',
    'PARTY BUNTING',
    'LUNCH BAG RED RETROSPOT',
    'ASSORTED COLOUR BIRD ORNAMENT',
    'SET OF 3 CAKE TINS PANTRY DESIGN',
    'PACK OF 72 RETROSPOT CAKE CASES',
    'LUNCH BAG  BLACK SKULL.',
    'NATURAL SLATE HEART CHALKBOARD'
)
GROUP BY Description, StockCode
ORDER BY Description, occurrences DESC; -- no double or more than one stockcode providing one description

SELECT Description, COUNT(DISTINCT StockCode) AS distinct_stockcodes
FROM ecom_d_uk
GROUP BY Description
HAVING COUNT(DISTINCT StockCode) > 1
ORDER BY distinct_stockcodes DESC;

select * 
from ecom_d_uk
where description = "discount";

select * 
from ecom_d_uk
where description = "damages";

select * 
from ecom_d_uk
where description = "carriage"; -- samething as stockcode "c2"

select * 
from ecom_d_uk
where description = "Manual";

select * 
from ecom_d_uk
where description = "PADS TO MATCH ALL CUSHIONS";

select * 
from ecom_d_uk
where description = "ADJUST BAD DEBT";

select * 
from ecom_d_uk
where stockcode = "b";

select * 
from ecom_d_uk
where description = "?";

-- PART 1: Build the Flag — is_real_product
-- 🧠 Strategy:
-- We'll use:
-- Direct string matches
-- Wildcard/substring matches (e.g. anything with ???, damaged, missing)
-- Regex-style filtering for flexible patterns
-- 🧾 SQL Snippet (simplified example):

SELECT *,
  CASE
    WHEN Description IS NULL OR TRIM(Description) = '' THEN 0
    WHEN LOWER(Description) REGEXP
         'check|damaged|damages|found|sold as|adjustment|amazon|thrown away|unsaleable|dotcom|had been put aside|ebay|wet|missing|smashed|incorrect|mailout|crushed|metal sign|wet pallet|wax|dotcom sales|mixed up|printing|returned|reverse|rusty|samples|stock check|test|water|counted|discount|carriage|manual|pads to match|bad debt|commission|b$|^\?|^\*|^\d{5,}|^\?+|lost|display' THEN 0
    ELSE 1
  END AS is_real_product
FROM ecom_d_uk;

-- Catches nulls, blanks, numeric-only codes, random punctuation (???, ??, etc.)
-- Flags all your provided examples
-- Leaves clean, sellable products as 1
-- Let me know if you want to make this into a temporary view or a filtered table.


-- This will help you:
-- Spot edge cases your list didn't catch
-- Keep your product base squeaky clean
-- Improve classification accuracy later
select * from ecom_d_uk
where description regexp 'incorrect';


SELECT 
    COUNT(DISTINCT description)
FROM
    ecom_d_uk2;
    
select description
from ecom_d_uk2;

-- '|||||cyan|magenta|||||||||salmon|skyblue|navy|coral||indigo|maroon||beige||violet|plum|crimson|orchid|||slateblue|forestgreen|lightblue|darkorange|darkred|darkgreen|darkblue|lightgrey|khaki'


WITH color_filtered AS (
    SELECT * 
    FROM ecom_d_uk2
    WHERE description REGEXP 'blue|red|green|orange|purple|yellow|lime|pink|brown|grey|black|white|gold|teal|turquoise|olive|chocolate|tomato'
)
, color_count AS (
    SELECT 
        CASE 
            WHEN description REGEXP 'blue' THEN 'blue'
            WHEN description REGEXP 'red' THEN 'red'
            WHEN description REGEXP 'green' THEN 'green'
            WHEN description REGEXP 'orange' THEN 'orange'
            WHEN description REGEXP 'purple' THEN 'purple'
            WHEN description REGEXP 'yellow' THEN 'yellow'
            WHEN description REGEXP 'lime' THEN 'lime'
            WHEN description REGEXP 'pink' THEN 'pink'
            WHEN description REGEXP 'brown' THEN 'brown'
            WHEN description REGEXP 'grey' THEN 'grey'
            WHEN description REGEXP 'black' THEN 'black'
            WHEN description REGEXP 'white' THEN 'white'
            WHEN description REGEXP 'gold' THEN 'gold'
            WHEN description REGEXP 'teal' THEN 'teal'
            WHEN description REGEXP 'turquoise' THEN 'turquoise'
            WHEN description REGEXP 'olive' THEN 'olive'
            WHEN description REGEXP 'chocolate' THEN 'chocolate'
            WHEN description REGEXP 'tomato' THEN 'tomato'
            ELSE 'other' 
        END AS color,
        COUNT(*) AS color_count
    FROM color_filtered
    GROUP BY color
)
SELECT color, color_count
FROM color_count
ORDER BY color_count DESC;

-- '|||||cyan|magenta|||||||||salmon|skyblue|navy|coral||indigo|maroon||beige||violet|plum|crimson|orchid|||slateblue|forestgreen|lightblue|darkorange|darkred|darkgreen|darkblue|lightgrey|khaki'

-- red, pink, blue, white, green, black, chocolate, yellow, purple, gold, orange, brown, turquoise, teal, grey, tomato, lime, olive 

WITH word_filtered AS (
    SELECT * 
    FROM ecom_d_uk2
    WHERE description REGEXP 'shirt|pants|dress|jacket|shoes|socks|phone|laptop|camera|tablet|headphones|charger|doll|puzzle|game|toy car|blocks|chair|table|bed|lamp|rug|pillow|lipstick|shampoo|lotion|perfume|skincare|bag|watch|bracelet|ring|sunglasses|ball|racket|gloves|jersey|shoes|discount|sale|offer|promotion|coupon|clearance|delivery|shipping|courier|express|tracking|dispatch|payment|credit|debit|invoice|transaction|checkout|support|service|customer|feedback|return|exchange|size|small|medium|large|color|red|blue|black|white'
)
, word_count AS (
    SELECT 
        CASE 
            WHEN description REGEXP 'shirt' THEN 'shirt'
            WHEN description REGEXP 'pants' THEN 'pants'
            WHEN description REGEXP 'dress' THEN 'dress'
            WHEN description REGEXP 'jacket' THEN 'jacket'
            WHEN description REGEXP 'shoes' THEN 'shoes'
            WHEN description REGEXP 'socks' THEN 'socks'
            WHEN description REGEXP 'phone' THEN 'phone'
            WHEN description REGEXP 'laptop' THEN 'laptop'
            WHEN description REGEXP 'camera' THEN 'camera'
            WHEN description REGEXP 'tablet' THEN 'tablet'
            WHEN description REGEXP 'headphones' THEN 'headphones'
            WHEN description REGEXP 'charger' THEN 'charger'
            WHEN description REGEXP 'doll' THEN 'doll'
            WHEN description REGEXP 'puzzle' THEN 'puzzle'
            WHEN description REGEXP 'game' THEN 'game'
            WHEN description REGEXP 'toy car' THEN 'toy car'
            WHEN description REGEXP 'blocks' THEN 'blocks'
            WHEN description REGEXP 'chair' THEN 'chair'
            WHEN description REGEXP 'table' THEN 'table'
            WHEN description REGEXP 'bed' THEN 'bed'
            WHEN description REGEXP 'lamp' THEN 'lamp'
            WHEN description REGEXP 'rug' THEN 'rug'
            WHEN description REGEXP 'pillow' THEN 'pillow'
            WHEN description REGEXP 'lipstick' THEN 'lipstick'
            WHEN description REGEXP 'shampoo' THEN 'shampoo'
            WHEN description REGEXP 'lotion' THEN 'lotion'
            WHEN description REGEXP 'perfume' THEN 'perfume'
            WHEN description REGEXP 'skincare' THEN 'skincare'
            WHEN description REGEXP 'bag' THEN 'bag'
            WHEN description REGEXP 'watch' THEN 'watch'
            WHEN description REGEXP 'bracelet' THEN 'bracelet'
            WHEN description REGEXP 'ring' THEN 'ring'
            WHEN description REGEXP 'sunglasses' THEN 'sunglasses'
            WHEN description REGEXP 'ball' THEN 'ball'
            WHEN description REGEXP 'racket' THEN 'racket'
            WHEN description REGEXP 'gloves' THEN 'gloves'
            WHEN description REGEXP 'jersey' THEN 'jersey'
            WHEN description REGEXP 'discount' THEN 'discount'
            WHEN description REGEXP 'sale' THEN 'sale'
            WHEN description REGEXP 'offer' THEN 'offer'
            WHEN description REGEXP 'promotion' THEN 'promotion'
            WHEN description REGEXP 'coupon' THEN 'coupon'
            WHEN description REGEXP 'clearance' THEN 'clearance'
            WHEN description REGEXP 'delivery' THEN 'delivery'
            WHEN description REGEXP 'shipping' THEN 'shipping'
            WHEN description REGEXP 'courier' THEN 'courier'
            WHEN description REGEXP 'express' THEN 'express'
            WHEN description REGEXP 'tracking' THEN 'tracking'
            WHEN description REGEXP 'dispatch' THEN 'dispatch'
            WHEN description REGEXP 'payment' THEN 'payment'
            WHEN description REGEXP 'credit' THEN 'credit'
            WHEN description REGEXP 'debit' THEN 'debit'
            WHEN description REGEXP 'invoice' THEN 'invoice'
            WHEN description REGEXP 'transaction' THEN 'transaction'
            WHEN description REGEXP 'checkout' THEN 'checkout'
            WHEN description REGEXP 'support' THEN 'support'
            WHEN description REGEXP 'service' THEN 'service'
            WHEN description REGEXP 'customer' THEN 'customer'
            WHEN description REGEXP 'feedback' THEN 'feedback'
            WHEN description REGEXP 'return' THEN 'return'
            WHEN description REGEXP 'exchange' THEN 'exchange'
            WHEN description REGEXP 'size' THEN 'size'
            WHEN description REGEXP 'small' THEN 'small'
            WHEN description REGEXP 'medium' THEN 'medium'
            WHEN description REGEXP 'large' THEN 'large'
            WHEN description REGEXP 'color' THEN 'color'
            WHEN description REGEXP 'red' THEN 'red'
            WHEN description REGEXP 'blue' THEN 'blue'
            WHEN description REGEXP 'black' THEN 'black'
            WHEN description REGEXP 'white' THEN 'white'
            ELSE 'other' 
        END AS product_type,
        COUNT(*) AS product_count
    FROM word_filtered
    GROUP BY product_type
)
SELECT product_type, product_count
FROM word_count
ORDER BY product_count DESC;

-- size
WITH word_filtered AS (
    SELECT * 
    FROM ecom_d_uk2
    WHERE description REGEXP 'size|small|medium|large|short|long|big|little'
)
, word_count AS (
    SELECT 
        CASE 
            WHEN description REGEXP 'size' THEN 'size'
            WHEN description REGEXP 'small' THEN 'small'
            WHEN description REGEXP 'medium' THEN 'medium'
            WHEN description REGEXP 'large' THEN 'large'
            WHEN description REGEXP 'short' THEN 'short'
            WHEN description REGEXP 'long' THEN 'long'
            WHEN description REGEXP 'big' THEN 'big'
            ELSE 'other' 
        END AS product_type,
        COUNT(*) AS product_count
    FROM word_filtered
    GROUP BY product_type
)
SELECT product_type, product_count
FROM word_count
ORDER BY product_count DESC;

-- light
WITH word_filtered AS (
    SELECT * 
    FROM ecom_d_uk2
    WHERE description REGEXP 'light'
)
, word_count AS (
    SELECT 
        CASE 
            WHEN description REGEXP 'light' THEN 'light'
            ELSE 'other' 
        END AS product_type,
        COUNT(*) AS product_count
    FROM word_filtered
    GROUP BY product_type
)
SELECT product_type, product_count
FROM word_count
ORDER BY product_count DESC;

-- kitchen appliance

WITH word_filtered AS (
    SELECT * 
    FROM ecom_d_uk2
    WHERE description REGEXP 'Refrigerator|Oven|Microwave|Dishwasher|machine|Blender|Toaster|Fryer|Grill|Cooker|Crockpot|Pressure|Dispenser|Juicer|Maker|Waffle|Grinder|pan|stove'
)
, word_count AS (
    SELECT 
        CASE 
            WHEN description REGEXP ' Oven ' THEN ' Oven '
            WHEN description REGEXP ' Microwave ' THEN ' Microwave '
            WHEN description REGEXP ' Dishwasher ' THEN ' Dishwasher '
            WHEN description REGEXP ' Cooker ' THEN ' Cooker '
            WHEN description REGEXP ' Dispenser ' THEN ' Dispenser '
            WHEN description REGEXP ' Maker ' THEN ' Maker '
            WHEN description REGEXP ' Grinder ' THEN ' Grinder '
            WHEN description REGEXP ' pan ' THEN ' pan '
            ELSE 'other' 
        END AS product_type,
        COUNT(*) AS product_count
    FROM word_filtered
    GROUP BY product_type
)
SELECT product_type, product_count
FROM word_count
ORDER BY product_count DESC;

-- only sells the list of kitchen appliance below:
-- pan '12385'
-- Oven '1906'
-- Dispenser '378'
-- Microwave '264'
-- Maker '246'
-- Grinder '38'

select * from ecom_d_uk2
where description like '%cooker%';

-- ------------------------------------------------------------------

-- see if the description collumn has these list
-- Washing Machines (front-load, top-load, portable)
-- Dryers (ventless, condenser, tumble dryers)
-- Ironing Boards
-- Irons (steam irons, steam generators)
-- Garment Steamers
-- Clothes Drying Racks (manual or electric)
-- Washer/Dryer Combos

WITH word_filtered AS (
    SELECT * 
    FROM ecom_d_uk2
    WHERE description REGEXP 'Washing|Ironing'
)
, word_count AS (
    SELECT 
        CASE 
            WHEN description REGEXP 'Washing' THEN 'Washing'
            WHEN description REGEXP 'Ironing' THEN 'Ironing'
            ELSE 'other' 
        END AS product_type,
        COUNT(*) AS product_count
    FROM word_filtered
    GROUP BY product_type
)
SELECT product_type, product_count
FROM word_count
ORDER BY product_count DESC;


-- only sells laundry appliance below
-- Washing 1081
-- Ironing 107

select distinct description from ecom_d_uk2
where description like '%Washing%';

-- ----------------------------------------------------

-- Heating & Cooling Appliances
-- Air Conditioners (window units, portable, central A/C)
-- Fans (tower, box, pedestal, ceiling fans)
-- Space Heaters (electric, oil-filled radiators, infrared)
-- Dehumidifiers
-- Humidifiers
-- Heaters (ceramic, convection, fan-forced)
-- Coolers (evaporative air coolers, portable AC units)
-- Thermostats (smart thermostats, programmable thermostats)

WITH word_filtered AS (
    SELECT * 
    FROM ecom_d_uk2
    WHERE description REGEXP 'Fan'
)
, word_count AS (
    SELECT 
        CASE 
            WHEN description REGEXP ' Fan ' THEN ' Fan '
            ELSE 'other' 
        END AS product_type,
        COUNT(*) AS product_count
    FROM word_filtered
    GROUP BY product_type
)
SELECT product_type, product_count
FROM word_count
ORDER BY product_count DESC;

select distinct description from ecom_d_uk2
where description like '% fan %'; -- fan only exists when placed with a space in the end spelling issues

-- result of heating cooling appliances
-- Fan '142'

-- --------------------------------------------------------

-- doll

select distinct description from ecom_d_uk2
where description like '% doll%'
and description like '%dolly%';

-- -----------------------------------------------------

-- see how much distinct description in total
select distinct description from ecom_d_uk2; -- 3969

-- see how much has a space at the end

select distinct description from ecom_d_uk2
where description like '% '; -- theres 725
-- 'POPPY''S PLAYHOUSE BEDROOM '

-- see how much has a space in the beginning

select distinct description from ecom_d_uk2
where description like ' %'; -- theres 12

select * from ecom_d_uk2
where description like 'breakages';

select * from ecom_d_uk2
where description like 'hook%';