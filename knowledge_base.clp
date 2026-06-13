;; =============================================
;; knowledge_base.clp
;; =============================================

;; Rule 1: Suggest compatible pairs explicitly defined
(defrule MAIN::suggest-compatible-pairs
   (user-input (item-type ?user-item) (color ?user-color) (weather ?weather) (occasion ?occasion) (gender ?gender)) 
   (item-prop (name ?user-item) (category ?u-cat))
   
   (item-prop (name ?target-item&~?user-item) (category ?t-cat))
   (color-prop (name ?target-color))
   
   (or (color-compatibility (color1 ?user-color) (color2 ?target-color) (compatible yes))
       (color-compatibility (color1 ?target-color) (color2 ?user-color) (compatible yes)))
       
   ;; --- Physical, Weather, Occasion & Gender Logic Filter ---
   (test 
      (and
        ;; 1. Prevent same category unless one is a Jacket
        (or (neq ?u-cat ?t-cat)
            (and (eq ?u-cat Upperwear) (eq ?t-cat Upperwear) 
                 (or (eq ?user-item Jacket) (eq ?target-item Jacket))))
        
        ;; 2. Prevent bottom/upper if user item is One-piece (except Jacket)
        (not (and (eq ?u-cat One-piece)
                  (or (eq ?t-cat Bottomwear)
                      (and (eq ?t-cat Upperwear) (neq ?target-item Jacket)))))
                      
        ;; 3. Prevent One-piece if user picked bottom/upper
        (not (and (eq ?t-cat One-piece)
                  (or (eq ?u-cat Bottomwear) (eq ?u-cat Upperwear))))
                  
        ;; 4. Weather Logic
        (not (and (eq ?weather winter) (eq ?target-item Shorts)))
        (not (and (eq ?weather summer) (eq ?target-item Jacket)))
        (not (and (or (eq ?weather winter) (eq ?weather autumn)) (eq ?target-item T-shirt)))
        
        ;; 5. Occasion Logic
        (not (and (eq ?occasion formal) (eq ?target-item Sneakers)))

        ;; 6. Gender Logic
        (not (and (eq ?gender male) 
                  (or (eq ?target-item Skirt) (eq ?target-item Dress) (eq ?target-item Heels))))
      )
   )
=>
   (assert (recommendation 
              (rec-type "perfect")
              (suggested-item ?target-item)
              (suggested-color ?target-color)
              (season ?weather))) 
)

;; =============================================

;; Rule 2: Suggest by color properties (type/brightness)
(defrule MAIN::suggest-by-properties
   (user-input (item-type ?user-item) (color ?user-color) (weather ?weather) (occasion ?occasion) (gender ?gender)) 
   (item-prop (name ?user-item) (category ?u-cat))

   (color-prop (name ?user-color) (type ?u-type) (brightness ?u-bright))
   
   (item-prop (name ?target-item&~?user-item) (category ?t-cat))
   (color-prop (name ?target-color&~?user-color) (type ?t-type) (brightness ?t-bright))
   
   (test (or (eq ?u-bright ?t-bright) (eq ?u-type ?t-type)))
   (not (color-compatibility (color1 ?user-color) (color2 ?target-color) (compatible no)))
   (not (color-compatibility (color1 ?target-color) (color2 ?user-color) (compatible no)))

   ;; --- Physical, Weather, Occasion & Gender Logic Filter ---
   (test 
      (and
        (or (neq ?u-cat ?t-cat)
            (and (eq ?u-cat Upperwear) (eq ?t-cat Upperwear) 
                 (or (eq ?user-item Jacket) (eq ?target-item Jacket))))
        
        (not (and (eq ?u-cat One-piece)
                  (or (eq ?t-cat Bottomwear)
                      (and (eq ?t-cat Upperwear) (neq ?target-item Jacket)))))
                       
        (not (and (eq ?t-cat One-piece)
                  (or (eq ?u-cat Bottomwear) (eq ?u-cat Upperwear))))
                  
        (not (and (eq ?weather winter) (eq ?target-item Shorts)))
        (not (and (eq ?weather summer) (eq ?target-item Jacket)))
        (not (and (or (eq ?weather winter) (eq ?weather autumn)) (eq ?target-item T-shirt)))
        
        (not (and (eq ?occasion formal) (eq ?target-item Sneakers)))

        (not (and (eq ?gender male) 
                  (or (eq ?target-item Skirt) (eq ?target-item Dress) (eq ?target-item Heels))))
      )
   )
=>
   (assert (recommendation 
              (rec-type "good")
              (suggested-item ?target-item)
              (suggested-color ?target-color)
              (season ?weather))) 
)

;; =============================================

;; Rule 3: Avoid clashing pairs
(defrule MAIN::avoid-clashing-pairs
   (user-input (item-type ?user-item) (color ?user-color) (weather ?weather) (occasion ?occasion) (gender ?gender)) 
   (item-prop (name ?user-item) (category ?u-cat))
   
   (item-prop (name ?target-item&~?user-item) (category ?t-cat))
   (color-prop (name ?target-color))
   
   (or (color-compatibility (color1 ?user-color) (color2 ?target-color) (compatible no))
       (color-compatibility (color1 ?target-color) (color2 ?user-color) (compatible no)))

   ;; --- Physical, Weather, Occasion & Gender Logic Filter ---
   (test 
      (and
        (or (neq ?u-cat ?t-cat)
            (and (eq ?u-cat Upperwear) (eq ?t-cat Upperwear) 
                 (or (eq ?user-item Jacket) (eq ?target-item Jacket))))
        
        (not (and (eq ?u-cat One-piece)
                  (or (eq ?t-cat Bottomwear)
                      (and (eq ?t-cat Upperwear) (neq ?target-item Jacket)))))
                      
        (not (and (eq ?t-cat One-piece)
                  (or (eq ?u-cat Bottomwear) (eq ?u-cat Upperwear))))
                  
        (not (and (eq ?weather winter) (eq ?target-item Shorts)))
        (not (and (eq ?weather summer) (eq ?target-item Jacket)))
        (not (and (or (eq ?weather winter) (eq ?weather autumn)) (eq ?target-item T-shirt)))
        
        (not (and (eq ?occasion formal) (eq ?target-item Sneakers)))

        (not (and (eq ?gender male) 
                  (or (eq ?target-item Skirt) (eq ?target-item Dress) (eq ?target-item Heels))))
      )
   )
=>
   (assert (recommendation 
              (rec-type "avoid")
              (suggested-item ?target-item)
              (suggested-color ?target-color)
              (season ?weather))) 
)