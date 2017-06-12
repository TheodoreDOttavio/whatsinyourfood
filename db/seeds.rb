puts "--  Adding Topics to quiz on"

Topic.destroy_all

Topic.create!(question: "Which product has the most calories?",
                 statement: "The most calories:",
                 test_field: "nf_calories_pergram",
                 name: "Calories",
                 qtype: true )
Topic.create!(question: "Which product has the most calories from fat?",
                 statement: "The most calories from fat:",
                 test_field: "nf_calories_from_fat_pergram",
                 name: "Calories",
                 qtype: true )
Topic.create!(question: "Which product has the highest total fat content?",
                 statement: "The highest total fat content:",
                 test_field: "nf_total_fat_pergram",
                 name: "Fat",
                 qtype: true)
Topic.create!(question: "Which product has the most saturated fat?",
                 statement: "The most saturated fat:",
                 test_field: "nf_saturated_fat_pergram",
                 name: "Fat",
                 qtype: true)
Topic.create!(question: "Which product has the highest amount of cholesterol?",
                 statement: "The highest amount of cholesterol:",
                 test_field: "nf_cholesterol_pergram",
                 name: "Cholesterol",
                 qtype: true)
Topic.create!(question: "Which product has the most salt?",
                 statement: "The most salt:",
                 test_field: "nf_sodium_pergram",
                 name: "Salt",
                 qtype: true)
Topic.create!(question: "Which product has the most protein?",
                 statement: "The most protein:",
                 test_field: "nf_protein_pergram",
                 name: "Protein",
                 qtype: true)
Topic.create!(question: "Which product has the most vitamin A?",
                 statement: "The most vitamin A:",
                 test_field: "nf_vitamin_a_dv_pergram",
                 name: "Vitamin A",
                 qtype: true)
Topic.create!(question: "Which product has the most calcium?",
                 statement: "The most calcium:",
                 test_field: "nf_calcium_dv_pergram",
                 name: "Calcium",
                 qtype: true)
Topic.create!(question: "Which product has the most iron?",
                 statement: "The most iron:",
                 test_field: "nf_iron_dv_pergram",
                 name: "Iron",
                 qtype: true)
Topic.create!(question: "Which product has the most total carbohydrates?",
                 statement: "The most total carbohydrates:",
                 test_field: "nf_total_carbohydrate_pergram",
                 name: "Carbohydrates",
                 qtype: true)
Topic.create!(question: "Which product has the most vitamin C?",
                 statement: "The most vitamin C:",
                 test_field: "nf_vitamin_c_dv_pergram",
                 name: "Vitamin C",
                 qtype: true)

Topic.create!(question: "Which product has the least calories?",
                 statement: "The least calories:",
                 test_field: "nf_calories_pergram",
                 name: "Calories",
                 qtype: false)
Topic.create!(question: "Which product has the least calories from fat?",
                 statement: "The least calories from fat:",
                 test_field: "nf_calories_from_fat_pergram",
                 name: "Calories",
                 qtype: false)
Topic.create!(question: "Which product has the lowest total fat content?",
                 statement: "The lowest total fat content:",
                 test_field: "nf_total_fat_pergram",
                 name: "Fat",
                 qtype: false)
Topic.create!(question: "Which product has the least saturated fat?",
                 statement: "The least saturated fat:",
                 test_field: "nf_saturated_fat_pergram",
                 name: "Fat",
                 qtype: false)
Topic.create!(question: "Which product has the lowest amount of cholesterol?",
                 statement: "The lowest amount of cholesterol:",
                 test_field: "nf_cholesterol_pergram",
                 name: "Cholesterol",
                 qtype: false)
Topic.create!(question: "Which product has the least salt?",
                 statement: "The least salt:",
                 test_field: "nf_sodium_pergram",
                 name: "Salt",
                 qtype: false)
Topic.create!(question: "Which product has the least protein?",
                 statement: "The least protein:",
                 test_field: "nf_protein_pergram",
                 name: "Protein",
                 qtype: false)
Topic.create!(question: "Which product has the least vitamin A?",
                 statement: "The least vitamin A:",
                 test_field: "nf_vitamin_a_dv_pergram",
                 name: "Vitamin A",
                 qtype: false)
Topic.create!(question: "Which product has the least calcium?",
                 statement: "The least calcium:",
                 test_field: "nf_calcium_dv_pergram",
                 name: "Calcium",
                 qtype: false)
Topic.create!(question: "Which product has the least iron?",
                 statement: "The least iron:",
                 test_field: "nf_iron_dv_pergram",
                 name: "Iron",
                 qtype: false)
Topic.create!(question: "Which product has the least total carbohydrates?",
                 statement: "The least total carbohydrates:",
                 test_field: "nf_total_carbohydrate_pergram",
                 name: "Carbohydrates",
                 qtype: false)
Topic.create!(question: "Which product has the least vitamin C?",
                 statement: "The least vitamin C:",
                 test_field: "nf_vitamin_c_dv_pergram",
                 name: "Vitamin C",
                 qtype: false)
