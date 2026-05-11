Pajé(WIP)

A scalable, informative web platform about animals, featuring dynamic taxonomy and habitat-based exploration.

1. Project Overview
Animal Wiki is a structured encyclopedia designed to store and display complex biological data. Built with Go and PostgreSQL, the project focuses on high scalability through a dynamic hierarchical database model, allowing for infinite taxonomic levels (from Kingdom down to Subspecies) without schema changes.

2. Key Features
Dynamic Taxonomy: Self-referencing hierarchical structure for biological classification.

Habitat Management: Dedicated data for ecosystems (Biomes) with descriptions and climate info.

Flexible Attributes: Uses PostgreSQL JSONB to store specific animal characteristics (tags, weight, diet, etc.) without table bloating.

Clean Architecture: Separated into core (domain), coredb (infrastructure), and apiserver (delivery).

3. Database Schema
The project uses a relational model optimized for hierarchical data:

taxonomy: Recursive table for Phylum, Class, Order, etc.

animals: Core data and JSONB attributes.

habitats: Rich information about ecosystems.

animal_habitats: Many-to-Many relationship between species and biomes.

4. Tech Stack
Language: Go (Golang)

Database: PostgreSQL

Driver: pgx (PostgreSQL Driver and Toolkit)

Architecture: Clean Architecture / Ports and Adapters
