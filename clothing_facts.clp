;; =============================================
;; clothing_facts.clp
;; =============================================

;; =============================================
;; Templates 
;; =============================================

(deftemplate item-prop
   (slot name (type SYMBOL)
              (allowed-symbols Shirt T-shirt Jacket Pants Skirt Shorts 
                               Shoes Sneakers Heels Flats Dress Hats Bags))
   (slot category (type SYMBOL)
                  (allowed-symbols Upperwear Bottomwear Footwear One-piece Accessories))
)

(deftemplate color-prop
   (slot name (type SYMBOL)
              (allowed-symbols black white grey beige navy red yellow orange 
                               pink burgundy blue green olive purple light-blue))
   (slot type (type SYMBOL)
              (allowed-symbols warm cool neutral))
   (slot brightness (type SYMBOL)
                    (allowed-symbols light dark))
)

(deftemplate user-input
   (slot item-type (type SYMBOL)
                   (allowed-symbols Shirt T-shirt Jacket Pants Skirt Shorts 
                                    Shoes Sneakers Heels Flats Dress Hats Bags))
   (slot color (type SYMBOL)
               (allowed-symbols black white grey beige navy red yellow orange 
                                pink burgundy blue green olive purple light-blue))
   (slot weather (type SYMBOL)
                 (allowed-symbols winter autumn summer spring))
   (slot occasion (type SYMBOL)
                  (allowed-symbols formal casual))
   (slot gender (type SYMBOL)
                (allowed-symbols male female))
)

(deftemplate recommendation
   (slot rec-type (type STRING))         
   (slot suggested-item (type SYMBOL))  
   (slot suggested-color (type SYMBOL)) 
   (slot season (type SYMBOL))           
)

(deftemplate color-compatibility
   (slot color1 (type SYMBOL))
   (slot color2 (type SYMBOL))
   (slot compatible (type SYMBOL) (allowed-symbols yes no))
)

;; =============================================
;; Initial Facts
;; =============================================

(deffacts initial-clothing-knowledge
   (item-prop (name Shirt)    (category Upperwear))
   (item-prop (name T-shirt)  (category Upperwear))
   (item-prop (name Jacket)   (category Upperwear))

   (item-prop (name Pants)    (category Bottomwear))
   (item-prop (name Skirt)    (category Bottomwear))
   (item-prop (name Shorts)   (category Bottomwear))

   (item-prop (name Shoes)    (category Footwear))
   (item-prop (name Sneakers) (category Footwear))
   (item-prop (name Heels)    (category Footwear))
   (item-prop (name Flats)    (category Footwear))

   (item-prop (name Dress)    (category One-piece))
   (item-prop (name Hats)     (category Accessories))
   (item-prop (name Bags)     (category Accessories))

   ;; ==================== Color Classification ====================
   (color-prop (name black)     (type neutral) (brightness dark))
   (color-prop (name white)     (type neutral) (brightness light))
   (color-prop (name grey)      (type neutral) (brightness dark))
   (color-prop (name beige)     (type neutral) (brightness light))
   (color-prop (name navy)      (type neutral) (brightness dark))

   (color-prop (name red)       (type warm) (brightness dark))
   (color-prop (name yellow)    (type warm) (brightness light))
   (color-prop (name orange)    (type warm) (brightness light))
   (color-prop (name pink)      (type warm) (brightness light))
   (color-prop (name burgundy)  (type warm) (brightness dark))

   (color-prop (name blue)      (type cool) (brightness dark))
   (color-prop (name green)     (type cool) (brightness dark))
   (color-prop (name olive)     (type cool) (brightness dark))
   (color-prop (name purple)    (type cool) (brightness dark))
   (color-prop (name light-blue)(type cool) (brightness light))

   ;; Black
   (color-compatibility (color1 black) (color2 navy)      (compatible no))

   ;; Navy
   (color-compatibility (color1 navy)  (color2 black)     (compatible no))
   (color-compatibility (color1 navy)  (color2 light-blue)(compatible no))

   ;; Red
   (color-compatibility (color1 red)   (color2 pink)      (compatible no))
   (color-compatibility (color1 red)   (color2 orange)    (compatible no))
   (color-compatibility (color1 red)   (color2 purple)    (compatible no))

   ;; Pink
   (color-compatibility (color1 pink)  (color2 red)       (compatible no))
   (color-compatibility (color1 pink)  (color2 burgundy)  (compatible no))

   ;; Orange
   (color-compatibility (color1 orange)(color2 purple)    (compatible no))
   (color-compatibility (color1 orange)(color2 blue)      (compatible no))

   ;; Yellow
   (color-compatibility (color1 yellow)(color2 light-blue)(compatible no))
   (color-compatibility (color1 yellow)(color2 purple)    (compatible no))

   ;; Green
   (color-compatibility (color1 green) (color2 red)       (compatible no))
   (color-compatibility (color1 green) (color2 purple)    (compatible no))

   ;; Purple
   (color-compatibility (color1 purple)(color2 orange)    (compatible no))
   (color-compatibility (color1 purple)(color2 red)       (compatible no))
   (color-compatibility (color1 purple)(color2 yellow)    (compatible no))

   ;; Burgundy
   (color-compatibility (color1 burgundy)(color2 pink)    (compatible no))
   (color-compatibility (color1 burgundy)(color2 orange)  (compatible no))

   ;; Light-blue
   (color-compatibility (color1 light-blue)(color2 navy)  (compatible no))
   (color-compatibility (color1 light-blue)(color2 yellow)(compatible no))
   (color-compatibility (color1 light-blue)(color2 orange)(compatible no))

   (color-compatibility (color1 black)  (color2 white)    (compatible yes))
   (color-compatibility (color1 black)  (color2 grey)     (compatible yes))
   (color-compatibility (color1 navy)   (color2 white)    (compatible yes))
   (color-compatibility (color1 beige)  (color2 navy)     (compatible yes))
   (color-compatibility (color1 blue)   (color2 grey)     (compatible yes))

   ;; 1. Basic neutral colors(White & Black & Grey)
   (color-compatibility (color1 black)  (color2 white)     (compatible yes))
   (color-compatibility (color1 black)  (color2 grey)      (compatible yes))
   (color-compatibility (color1 black)  (color2 beige)     (compatible yes))
   (color-compatibility (color1 black)  (color2 red)       (compatible yes))
   (color-compatibility (color1 black)  (color2 olive)     (compatible yes))
   (color-compatibility (color1 black)  (color2 burgundy)  (compatible yes))

   (color-compatibility (color1 white)  (color2 navy)      (compatible yes))
   (color-compatibility (color1 white)  (color2 beige)     (compatible yes))
   (color-compatibility (color1 white)  (color2 grey)      (compatible yes))
   (color-compatibility (color1 white)  (color2 red)       (compatible yes))
   (color-compatibility (color1 white)  (color2 blue)      (compatible yes))
   (color-compatibility (color1 white)  (color2 green)     (compatible yes))
   (color-compatibility (color1 white)  (color2 burgundy)  (compatible yes))
   (color-compatibility (color1 white)  (color2 pink)      (compatible yes))
   (color-compatibility (color1 white)  (color2 olive)     (compatible yes))

   (color-compatibility (color1 grey)   (color2 navy)      (compatible yes))
   (color-compatibility (color1 grey)   (color2 burgundy)  (compatible yes))
   (color-compatibility (color1 grey)   (color2 pink)      (compatible yes))
   (color-compatibility (color1 grey)   (color2 blue)      (compatible yes))
   (color-compatibility (color1 grey)   (color2 yellow)    (compatible yes))

   ;; 2. Earthy and calm colors(Beige & Olive)
   (color-compatibility (color1 beige)  (color2 navy)      (compatible yes))
   (color-compatibility (color1 beige)  (color2 olive)     (compatible yes))
   (color-compatibility (color1 beige)  (color2 burgundy)  (compatible yes))
   (color-compatibility (color1 beige)  (color2 green)     (compatible yes))
   (color-compatibility (color1 beige)  (color2 light-blue)(compatible yes))

   (color-compatibility (color1 olive)  (color2 navy)      (compatible yes))
   (color-compatibility (color1 olive)  (color2 yellow)    (compatible yes))
   (color-compatibility (color1 olive)  (color2 orange)    (compatible yes))

   ;; 3. Classic formats for cold colors (Navy & Blue & Light-blue)
   (color-compatibility (color1 navy)   (color2 burgundy)  (compatible yes))
   (color-compatibility (color1 navy)   (color2 yellow)    (compatible yes))
   (color-compatibility (color1 navy)   (color2 pink)      (compatible yes))
   (color-compatibility (color1 navy)   (color2 green)     (compatible yes))

   (color-compatibility (color1 blue)   (color2 yellow)    (compatible yes))
   (color-compatibility (color1 blue)   (color2 pink)      (compatible yes))
   (color-compatibility (color1 blue)   (color2 beige)     (compatible yes))

   (color-compatibility (color1 light-blue) (color2 grey)  (compatible yes))
   (color-compatibility (color1 light-blue) (color2 pink)  (compatible yes))
   (color-compatibility (color1 light-blue) (color2 beige) (compatible yes))

   ;; 4. worm formats (Red, Burgundy, Yellow, Orange, Pink)
   (color-compatibility (color1 burgundy) (color2 yellow)  (compatible yes))
   (color-compatibility (color1 burgundy) (color2 green)   (compatible yes))

   (color-compatibility (color1 yellow) (color2 grey)      (compatible yes))
   (color-compatibility (color1 yellow) (color2 green)     (compatible yes))

   (color-compatibility (color1 pink)   (color2 green)     (compatible yes))
   
   (color-compatibility (color1 orange) (color2 olive)     (compatible yes))
   (color-compatibility (color1 orange) (color2 navy)      (compatible yes))

   ;; 5. (Analogous & Complementary)
   (color-compatibility (color1 purple) (color2 grey)      (compatible yes))
   (color-compatibility (color1 purple) (color2 white)     (compatible yes))
   (color-compatibility (color1 purple) (color2 black)     (compatible yes))
   (color-compatibility (color1 purple) (color2 beige)     (compatible yes))
)