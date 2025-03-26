CREATE TABLE IF NOT EXISTS employe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    poste VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS heures_sup (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employe_id INT NOT NULL,
    date DATE NOT NULL,
    nb_heures FLOAT NOT NULL,
    FOREIGN KEY (employe_id) REFERENCES employe(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS tarif (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_jour ENUM('weekend', 'jour ordinaire') NOT NULL,
    tarif FLOAT NOT NULL
);
INSERT INTO employe (nom, prenom, poste) VALUES 
('Doe', 'John', 'Développeur'),
('Smith', 'Alice', 'Designer');
INSERT INTO tarif (type_jour, tarif) VALUES 
('weekend', 20.0),
('jour ordinaire', 10.0);
