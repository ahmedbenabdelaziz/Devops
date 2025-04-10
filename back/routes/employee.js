import express from 'express';
import { createEmployee } from '../controllers/employeeController.js';

const router = express.Router();

import { Employee } from '../models/index.js';


// GET - Liste des employés
router.get('/', async (req, res) => {
  try {
    const employees = await Employee.findAll();
    res.json(employees);
  } catch (error) {
    res.status(500).json({ message: 'Erreur de récupération des employés' });
  }
});

// DELETE - Supprimer un employé
router.delete('/:id', async (req, res) => {
  try {
    const employeeId = req.params.id;
    const result = await Employee.destroy({ where: { id: employeeId } });
    if (result) {
      res.status(200).send('Employé supprimé');
    } else {
      res.status(404).send('Employé non trouvé');
    }
  } catch (error) {
    res.status(500).json({ message: 'Erreur de suppression' });
  }
});



// Route pour créer un nouvel employé
router.post('/', createEmployee);

export default router;  // Assurez-vous d'exporter par défaut
