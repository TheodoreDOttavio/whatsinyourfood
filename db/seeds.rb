puts "--  Adding Topics to quiz on"
Topic.create!(question: "Which product has the most calories?",
                 statement: "The most calories:",
                 test_field: "nf_calories",
                 qtype: true )
Topic.create!(question: "Which product has the most calories from fat?",
                 statement: "The most calories from fat:",
                 test_field: "nf_calories_from_fat",
                 qtype: true )
Topic.create!(question: "Which product has the highest total fat content?",
                 statement: "The highest total fat content:",
                 test_field: "nf_total_fat",
                 qtype: true)
Topic.create!(question: "Which product has the most saturated fat?",
                 statement: "The most saturated fat:",
                 test_field: "nf_saturated_fat",
                 qtype: true)
Topic.create!(question: "Which product has the highest amount of cholesterol?",
                 statement: "The highest amount of cholesterol:",
                 test_field: "nf_cholesterol",
                 qtype: true)
Topic.create!(question: "Which product has the most salt?",
                 statement: "The most salt:",
                 test_field: "nf_sodium",
                 qtype: true)
Topic.create!(question: "Which product has the most protein?",
                 statement: "The most protein:",
                 test_field: "nf_protein",
                 qtype: true)
Topic.create!(question: "Which product has the most vitamin A?",
                 statement: "The most vitamin A:",
                 test_field: "nf_vitamin_a_dv",
                 qtype: true)
Topic.create!(question: "Which product has the most calcium?",
                 statement: "The most calcium:",
                 test_field: "nf_calcium_dv",
                 qtype: true)
Topic.create!(question: "Which product has the most iron?",
                 statement: "The most iron:",
                 test_field: "nf_iron_dv",
                 qtype: true)
Topic.create!(question: "Which product has the most total carbohydrates?",
                 statement: "The most total carbohydrates:",
                 test_field: "nf_total_carbohydrate",
                 qtype: true)
Topic.create!(question: "Which product has the most vitamin C?",
                 statement: "The most vitamin C:",
                 test_field: "nf_vitamin_c_dv",
                 qtype: true)

Topic.create!(question: "Which product has the least calories?",
                 statement: "The least calories:",
                 test_field: "nf_calories",
                 qtype: false)
Topic.create!(question: "Which product has the least calories from fat?",
                 statement: "The least calories from fat:",
                 test_field: "nf_calories_from_fat",
                 qtype: false)
Topic.create!(question: "Which product has the lowest total fat content?",
                 statement: "The lowest total fat content:",
                 test_field: "nf_total_fat",
                 qtype: false)
Topic.create!(question: "Which product has the least saturated fat?",
                 statement: "The least saturated fat:",
                 test_field: "nf_saturated_fat",
                 qtype: false)
Topic.create!(question: "Which product has the lowest amount of cholesterol?",
                 statement: "The lowest amount of cholesterol:",
                 test_field: "nf_cholesterol",
                 qtype: false)
Topic.create!(question: "Which product has the least salt?",
                 statement: "The least salt:",
                 test_field: "nf_sodium",
                 qtype: false)
Topic.create!(question: "Which product has the least protein?",
                 statement: "The least protein:",
                 test_field: "nf_protein",
                 qtype: false)
Topic.create!(question: "Which product has the least vitamin A?",
                 statement: "The least vitamin A:",
                 test_field: "nf_vitamin_a_dv",
                 qtype: false)
Topic.create!(question: "Which product has the least calcium?",
                 statement: "The least calcium:",
                 test_field: "nf_calcium_dv",
                 qtype: false)
Topic.create!(question: "Which product has the least iron?",
                 statement: "The least iron:",
                 test_field: "nf_iron_dv",
                 qtype: false)
Topic.create!(question: "Which product has the least total carbohydrates?",
                 statement: "The least total carbohydrates:",
                 test_field: "nf_total_carbohydrate",
                 qtype: false)
Topic.create!(question: "Which product has the least vitamin C?",
                 statement: "The least vitamin C:",
                 test_field: "nf_vitamin_c_dv",
                 qtype: false)