-- These tables belonged to the initial catalog-based translation design.
-- The current application stores each recognized result in translation.translations
-- and does not read or write this unused, empty catalog.
DROP TABLE IF EXISTS translation.translation_signs;
DROP TABLE IF EXISTS translation.audio_files;
DROP TABLE IF EXISTS translation.signs;
