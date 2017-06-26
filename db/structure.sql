CREATE TABLE "schema_migrations" ("version" varchar NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
CREATE TABLE "quests" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "upc" varchar NOT NULL, "manufacturer" varchar, "name" varchar, "size" varchar, "is_associated" boolean DEFAULT 'f', "is_searched" boolean DEFAULT 'f', "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "topics" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "question" varchar, "statement" varchar, "qtype" boolean, "test_field" varchar, "sucesses" integer, "failures" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "name" varchar DEFAULT '');
CREATE TABLE "products" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "upc" varchar, "brand_name" varchar, "item_name" varchar, "brand_id" varchar, "item_id" varchar, "item_description" varchar, "nf_ingredient_statement" varchar, "nf_calories" integer, "nf_calories_from_fat" integer, "nf_total_fat" integer, "nf_saturated_fat" integer, "nf_trans_fatty_acid" integer, "nf_polyunsaturated_fat" integer, "nf_monounsaturated_fat" integer, "nf_cholesterol" integer, "nf_sodium" integer, "nf_total_carbohydrate" integer, "nf_dietary_fiber" integer, "nf_sugars" integer, "nf_protein" integer, "nf_vitamin_a_dv" integer, "nf_vitamin_c_dv" integer, "nf_calcium_dv" integer, "nf_iron_dv" integer, "nf_potassium" integer, "nf_servings_per_container" integer, "nf_serving_size_qty" decimal, "nf_serving_size_unit" varchar, "nf_serving_weight_grams" decimal, "metric_qty" decimal, "metric_uom" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "nf_calories_from_fat_pergram" decimal DEFAULT '0', "nf_calories_pergram" decimal DEFAULT '0', "nf_total_fat_pergram" decimal DEFAULT '0', "nf_saturated_fat_pergram" decimal DEFAULT '0', "nf_trans_fatty_acid_pergram" decimal DEFAULT '0', "nf_polyunsaturated_fat_pergram" decimal DEFAULT '0', "nf_monounsaturated_fat_pergram" decimal DEFAULT '0', "nf_cholesterol_pergram" decimal DEFAULT '0', "nf_sodium_pergram" decimal DEFAULT '0', "nf_total_carbohydrate_pergram" decimal DEFAULT '0', "nf_dietary_fiber_pergram" decimal DEFAULT '0', "nf_sugars_pergram" decimal DEFAULT '0', "nf_protein_pergram" decimal DEFAULT '0', "nf_vitamin_a_dv_pergram" decimal DEFAULT '0', "nf_vitamin_c_dv_pergram" decimal DEFAULT '0', "nf_calcium_dv_pergram" decimal DEFAULT '0', "nf_iron_dv_pergram" decimal DEFAULT '0', "nf_potassium_pergram" decimal DEFAULT '0');
CREATE TABLE "players" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar DEFAULT 'no name', "sucesses" varchar DEFAULT '{}', "failures" varchar DEFAULT '{}', "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "password" varchar DEFAULT '', "scores" varchar DEFAULT '{}', "subject" varchar DEFAULT '', "bonuses" varchar DEFAULT '{}');
INSERT INTO schema_migrations (version) VALUES ('20160703042758');

INSERT INTO schema_migrations (version) VALUES ('20160704125115');

INSERT INTO schema_migrations (version) VALUES ('20160706060007');

INSERT INTO schema_migrations (version) VALUES ('20160706061335');

INSERT INTO schema_migrations (version) VALUES ('20160711190000');

INSERT INTO schema_migrations (version) VALUES ('20160714020000');

INSERT INTO schema_migrations (version) VALUES ('20160714153300');

INSERT INTO schema_migrations (version) VALUES ('20160715131200');

INSERT INTO schema_migrations (version) VALUES ('20170611110400');

INSERT INTO schema_migrations (version) VALUES ('20170611120900');

INSERT INTO schema_migrations (version) VALUES ('20170615133800');

INSERT INTO schema_migrations (version) VALUES ('20170615201300');

INSERT INTO schema_migrations (version) VALUES ('20170616094300');

