-- +goose Up
CREATE TABLE taxonomy {
    id SERIAL PRIMARY KEY
    name VARCHAR(100) NOT NULL,
    rank VARCHAR(100) NOT NULL,
    parent_id INT REFERENCES taxonomy(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

};

CREATE TABLE habitats (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    common_name VARCHAR(150) NOT NULL,
    scientific_name VARCHAR(150) UNIQUE NOT NULL,
    taxonomy_id INT REFERENCES taxonomy(id) ON DELETE SET NULL,
    image_url TEXT,
    characteristics JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE animal_habitats (
    animal_id INT REFERENCES animals(id) ON DELETE CASCADE,
    habitat_id INT REFERENCES habitats(id) ON DELETE CASCADE,
    PRIMARY KEY (animal_id, habitat_id)
);

-- +goose Down
DROP TABLE animal_habitats;
DROP TABLE animals;
DROP TABLE habitats;
DROP TABLE taxonomy;
